# Mini RAG: document Q&A

A small, complete Retrieval-Augmented Generation system over a folder of
Markdown docs. Two files, each teaching a different layer:

| File | What it shows | Dependencies |
|---|---|---|
| `rag_from_scratch.py` | The mechanics, printed stage by stage. TF-IDF vectors, cosine similarity, top-k. | scikit-learn, numpy |
| `rag.py` | The real shape. Neural embeddings, a Chroma vector store, a pluggable LLM. | sentence-transformers, chromadb |

## Setup

```bash
cd mini_rag
python -m venv .venv && source .venv/bin/activate   # or use your aiml_venv
pip install -r requirements.txt
```

## Run the transparent version first

No downloads, runs instantly. Read the printed stages.

```bash
python rag_from_scratch.py "how do I get my money back"
```

You will see 3 docs become 8 chunks, the top-k chunks ranked by cosine
similarity, and the exact prompt that would go to an LLM. Try a question
whose words do not appear in the docs (for example "unsubscribe") and watch
TF-IDF struggle. That weakness is why the real version uses neural embeddings.

## Run the real version

First run downloads a ~90 MB embedding model once, then caches it.

```bash
python rag.py index                              # build the vector store
python rag.py ask "how do I reset my password"
python rag.py ask "what are your support hours"
```

Without an API key it prints the assembled prompt so you still see retrieval
working. For real generated answers, set a key first:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
python rag.py ask "how do I reset my password"
```

## Make it yours

- Drop your own `.md` files into `docs/` and re-run `python rag.py index`.
- Tune `chunk(size, overlap)` and `TOP_K` in `rag.py` and watch the answers shift.

## Where to take it next (the upgrades from the tutorial)

1. Add citations to the output (the source is already tracked per chunk).
2. Add hybrid search: run a BM25 keyword pass with `rank_bm25` and merge scores.
3. Add reranking: re-score the top-20 with a cross-encoder (`cross-encoder/ms-marco-MiniLM-L-6-v2`), keep the best 3.
4. Add query rewriting: ask the LLM to expand the question before you embed it.
5. Add evaluation: build 10 question/answer pairs and measure faithfulness and context recall with RAGAS.
