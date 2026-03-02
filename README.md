# Oakridge Reignited — Community Website

A mostly self-contained single-page website for the Oakridge community effort. Designed phone-first and friendly to elderly users (parents, grandparents) who want to see what's going on and find ways to help.

## Design Principles

- **Phone-first** — layout and type sizes are optimized for mobile screens first
- **Elderly-friendly** — large fonts, high contrast, simple navigation; no tiny print or confusing UI
- **Information over aesthetics** — clear, easy-to-navigate content is more important than decorative whitespace
- **Self-contained** — keep everything in a single HTML file where possible (inline CSS and JS, no external build step)

---

## Working with Claude Code

### Environment Setup

1. Obtain a GitHub Personal Access Token (PAT) with **Contents → Read and Write** access to this repo
2. Store the PAT in an environment variable (e.g. `GH_PAT_OAKRIDGE`)
3. Start a Claude Code session and tell it:

   > "I gave you a GitHub PAT in `GH_PAT_OAKRIDGE`. Use it to access the repo at https://github.com/communityml/oakridge and read the README for the workflow."

### Versioning Workflow

Versions of the page are stored as numbered snapshots in `docs/`:

| File | Role |
|---|---|
| `docs/index.html` | The **live** page (what the public sees) |
| `docs/index_NNN.html` | Numbered snapshots — the working history |

**To start a new version:**

1. Find the highest-numbered `index_NNN.html` in `docs/` — that is the latest good starting point
2. Copy it to the next number (e.g. `index_061.html`)
3. Edit the new file with the desired changes
4. Push to `main`

### Previewing

GitHub Pages serves the `docs/` folder automatically from `main`. After any push, the new file is live at:

```
https://communityml.github.io/oakridge/index_NNN.html
```

Share that URL with collaborators to collect feedback, then iterate.

### Iteration Loop

1. Make edits to `docs/index_NNN.html`
2. Push to `main`
3. Wait ~30–60 seconds for GitHub Pages to rebuild
4. Share the preview URL for review
5. Apply feedback and repeat until the version looks great

---

## Deployment (Publishing to Production)

Once a preview version is approved:

1. **Update `index.html`** — replace the contents of `docs/index.html` with the contents of the approved `index_NNN.html`, then push to `main`
2. **Push to S3** — take that same `index.html` file verbatim and upload it to the AWS S3 bucket for the site
3. **Invalidate CloudFront cache** — create a CloudFront invalidation for the path `/index.html` so the CDN serves the new version immediately

---

## Repo Structure

```
docs/
  index.html          ← live production page
  index_000.html      ┐
  index_001.html      │ numbered snapshots / version history
  ...                 │
  index_NNN.html      ┘
  img/                ← all images used by the page
  favicon.ico
  favicon-32.png
```
