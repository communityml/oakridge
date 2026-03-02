# Oakridge Reignited — Community Website

A community-led website for the Oakridge effort. Designed for phones first, and friendly to everyone — including parents and grandparents who just want to see what's happening and how to help.

---

## What's in this repo

```
docs/
  index.html          ← the live page (what the public sees)
  index_NNN.html      ← numbered working versions / history
  img/                ← images
  favicon.ico / favicon-32.png
CLAUDE.md             ← instructions for Claude Code (auto-read at session start)
```

---

## Making changes to the site

Changes go through numbered preview versions before going live. The process:

1. **Start a Claude Code session** — Claude reads `CLAUDE.md` automatically and knows the workflow
2. **Tell Claude what you want changed** — describe it in plain language
3. **Claude creates the next numbered version** (e.g. `index_062.html`) and pushes it
4. **Preview it** at `https://communityml.github.io/oakridge/index_NNN.html` (takes ~30–60 seconds to build)
5. **Give feedback** and iterate until it looks right
6. **Publish it** — see the Deployment section below

**One rule:** Claude never touches `index.html` directly. That's a human step.

---

## Setting up Claude Code

1. Get a GitHub Personal Access Token (PAT) with **Contents → Read and Write** on this repo
2. Set it as an environment variable named `GH_PAT_OAKRIDGE`
3. Start a session. Claude reads `CLAUDE.md` automatically — no extra prompting needed

---

## Deployment (publishing to production)

Once a preview version is approved:

1. **Update `docs/index.html`** — replace its contents with the approved `index_NNN.html`, push to `main`
2. **Upload to S3** — upload that same `index.html` to the AWS S3 bucket
3. **Invalidate CloudFront** — create an invalidation for `/index.html` so the CDN serves the new version right away

---

## Design principles

- **Phone-first** — layout and font sizes are optimized for mobile screens
- **Elderly-friendly** — large fonts, high contrast, simple navigation
- **Content over decoration** — clear information beats whitespace and flourishes
- **Self-contained** — single HTML file with inline CSS and JS; no build step needed
