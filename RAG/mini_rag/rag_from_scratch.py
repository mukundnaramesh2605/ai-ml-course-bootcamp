"""
RAG from scratch, no black boxes.

This version uses TF-IDF vectors instead of a neural embedding model so it runs
instantly with no downloads. The retrieval math (cosine similarity, top-k) is
identical to a real system. It prints every stage so you can see what RAG does
internally. Run it, read the output, then move on to rag.py for the real thing.

    python rag_from_scratch.py "how do I get my money back"
"""

import sys
import glob
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer


# ---------- stage 1: load ----------
def load_docs(folder="docs"):
    docs = []
    for path in sorted(glob.glob(f"{folder}/*.md")):
        with open(path, encoding="utf-8") as f:
            docs.append((path, f.read()))
    return docs


# ---------- stage 2: chunk ----------
def chunk(text, size=400, overlap=60):
    """Split text into overlapping windows of roughly `size` characters.
    Overlap keeps ideas that fall on a boundary intact."""
    chunks = []
    start = 0
    while start < len(text):
        end = start + size
        chunks.append(text[start:end].strip())
        start += size - overlap          # step forward, but leave an overlap
    return [c for c in chunks if c]


# ---------- stage 3: embed (here: TF-IDF) ----------
def build_index(chunks):
    """Turn every chunk into a vector. In rag.py this is a neural model;
    here it is TF-IDF so there is nothing to download."""
    vectorizer = TfidfVectorizer(stop_words="english")
    matrix = vectorizer.fit_transform(chunks)   # shape: (n_chunks, vocab)
    return vectorizer, matrix


# ---------- stage 4: retrieve ----------
def cosine_top_k(query_vec, matrix, k):
    """Cosine similarity between the query and every chunk, then the top k.
    TF-IDF rows are already L2-normalised, so a dot product IS the cosine."""
    sims = (matrix @ query_vec.T).toarray().ravel()
    order = np.argsort(sims)[::-1][:k]
    return [(int(i), float(sims[i])) for i in order]


# ---------- stage 5: augment + "generate" ----------
def build_prompt(question, retrieved):
    context = "\n\n".join(f"[source {i+1}] {txt}" for i, (txt, _) in enumerate(retrieved))
    return (
        "Answer using ONLY the context. If it is not there, say you don't know.\n\n"
        f"Context:\n{context}\n\nQuestion: {question}\nAnswer:"
    )


def main():
    question = sys.argv[1] if len(sys.argv) > 1 else "how do I reset my password"
    k = 3

    docs = load_docs()
    chunks, sources = [], []
    for path, text in docs:
        for c in chunk(text):
            chunks.append(c)
            sources.append(path)
    print(f"Loaded {len(docs)} docs, split into {len(chunks)} chunks.\n")

    vectorizer, matrix = build_index(chunks)
    query_vec = vectorizer.transform([question])      # same transform as the chunks

    hits = cosine_top_k(query_vec, matrix, k)
    print(f'Question: "{question}"')
    print(f"Top {k} retrieved chunks (by cosine similarity):\n")
    retrieved = []
    for rank, (idx, score) in enumerate(hits, 1):
        preview = " ".join(chunks[idx].split())[:90]
        print(f"  {rank}. score={score:.3f}  {sources[idx]}")
        print(f"     {preview}...\n")
        retrieved.append((chunks[idx], score))

    print("-" * 60)
    print("Prompt that would be sent to the LLM:\n")
    print(build_prompt(question, retrieved))
    print("\n(In rag.py this prompt goes to a real LLM, which writes the final answer.)")


if __name__ == "__main__":
    main()
