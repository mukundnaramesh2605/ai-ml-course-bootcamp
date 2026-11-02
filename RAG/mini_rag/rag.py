"""
Mini RAG: document Q&A with neural embeddings, a vector store, and an LLM.

Pipeline (see README for the diagram this mirrors):
    load docs -> chunk -> embed (sentence-transformers) -> store (Chroma)
    question -> embed -> retrieve top-k -> build prompt -> LLM answer + sources

First run downloads a small embedding model (~90 MB) once, then caches it.
The LLM step uses Anthropic if ANTHROPIC_API_KEY is set; otherwise it prints
the assembled prompt so you can still see retrieval working end to end.

Usage:
    python rag.py index                       # build the vector store
    python rag.py ask "how do I reset my password"
"""

import os
import sys
import glob

import chromadb
from sentence_transformers import SentenceTransformer

EMBED_MODEL = "all-MiniLM-L6-v2"   # small, fast, 384-dim, good default
DB_DIR = ".chroma"
COLLECTION = "nimbus_kb"
TOP_K = 3

_model = None
def embedder():
    """Load the embedding model once and reuse it."""
    global _model
    if _model is None:
        _model = SentenceTransformer(EMBED_MODEL)
    return _model


def chunk(text, size=500, overlap=80):
    """Recursive-ish split: prefer paragraph breaks, fall back to a window.
    Keeps chunks focused while an overlap protects boundary ideas."""
    paras = [p.strip() for p in text.split("\n\n") if p.strip()]
    chunks, buf = [], ""
    for p in paras:
        if len(buf) + len(p) <= size:
            buf = f"{buf}\n\n{p}".strip()
        else:
            if buf:
                chunks.append(buf)
            # carry the tail of the last chunk forward as overlap
            buf = (buf[-overlap:] + "\n\n" + p).strip() if buf else p
    if buf:
        chunks.append(buf)
    return chunks


def get_collection(reset=False):
    client = chromadb.PersistentClient(path=DB_DIR)
    if reset:
        try:
            client.delete_collection(COLLECTION)
        except Exception:
            pass
    return client.get_or_create_collection(COLLECTION)


def do_index(folder="docs"):
    """Indexing phase: build vectors for every chunk and store them."""
    col = get_collection(reset=True)
    model = embedder()

    ids, texts, metas = [], [], []
    for path in sorted(glob.glob(f"{folder}/*.md")):
        with open(path, encoding="utf-8") as f:
            for j, c in enumerate(chunk(f.read())):
                ids.append(f"{os.path.basename(path)}::{j}")
                texts.append(c)
                metas.append({"source": path})

    # embed all chunks in one batch, then store vectors + text + metadata
    vectors = model.encode(texts, normalize_embeddings=True).tolist()
    col.add(ids=ids, documents=texts, embeddings=vectors, metadatas=metas)
    print(f"Indexed {len(texts)} chunks from {folder}/ into '{COLLECTION}'.")


def retrieve(question, k=TOP_K):
    """Query phase step 1: embed the question, pull the nearest chunks."""
    col = get_collection()
    qvec = embedder().encode([question], normalize_embeddings=True).tolist()
    res = col.query(query_embeddings=qvec, n_results=k)
    docs = res["documents"][0]
    srcs = [m["source"] for m in res["metadatas"][0]]
    dists = res["distances"][0]            # smaller distance = closer
    return list(zip(docs, srcs, dists))


def build_prompt(question, hits):
    context = "\n\n".join(f"[source {i+1}: {s}]\n{d}" for i, (d, s, _) in enumerate(hits))
    return (
        "You are a Nimbus support assistant. Answer the question using ONLY the "
        "context below. If the answer is not in the context, say you don't know. "
        "Cite the source number you used.\n\n"
        f"Context:\n{context}\n\nQuestion: {question}\nAnswer:"
    )


def generate(prompt):
    """Query phase step 2: hand the prompt to an LLM. Falls back to printing
    the prompt if no API key is set, so the demo always runs."""
    key = os.environ.get("ANTHROPIC_API_KEY")
    if not key:
        return ("[no ANTHROPIC_API_KEY set, showing the prompt instead]\n\n" + prompt)
    import anthropic
    client = anthropic.Anthropic(api_key=key)
    msg = client.messages.create(
        model="claude-3-5-haiku-latest",
        max_tokens=400,
        messages=[{"role": "user", "content": prompt}],
    )
    return msg.content[0].text


def do_ask(question):
    hits = retrieve(question)
    print(f'Question: "{question}"\nRetrieved:')
    for i, (doc, src, dist) in enumerate(hits, 1):
        print(f"  {i}. {src}  (distance {dist:.3f})  {doc[:70].strip()}...")
    print("\nAnswer:\n" + generate(build_prompt(question, hits)))


def main():
    if len(sys.argv) >= 2 and sys.argv[1] == "index":
        do_index()
    elif len(sys.argv) >= 3 and sys.argv[1] == "ask":
        do_ask(sys.argv[2])
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
