# Deployment (my-wiki)

This project is a static site built with MkDocs Material.

## Option A: Local preview (developer)

```powershell
cd d:\code_info\my-wiki
pip install -r requirements.txt
python -m mkdocs serve
```

Open `http://127.0.0.1:8000/`.

## Option B: Build static files (production artifact)

```powershell
cd d:\code_info\my-wiki
pip install -r requirements.txt
python -m mkdocs build --clean
```

The output is in `site\`.

Quick smoke test:

```powershell
cd d:\code_info\my-wiki\site
python -m http.server 8080
```

Open `http://127.0.0.1:8080/`.

## Option C: Run with Docker (Nginx serving `site/`)

Build image (builds MkDocs first, then serves via Nginx):

```powershell
cd d:\code_info\my-wiki
docker build -t my-wiki:latest .
docker run --rm -p 8080:80 my-wiki:latest
```

Open `http://127.0.0.1:8080/`.

Or via compose:

```powershell
cd d:\code_info\my-wiki
docker compose up --build
```

## Option D: GitHub Pages

This repo already supports `mkdocs gh-deploy` (publishes to the `gh-pages` branch):

```powershell
cd d:\code_info\my-wiki
pip install -r requirements.txt
python -m mkdocs gh-deploy
```
