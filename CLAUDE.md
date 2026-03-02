# CLAUDE.md — Oakridge Reignited Website

This file is auto-read by Claude Code at session start. Follow everything here precisely.

---

## Security

- The GitHub PAT is in the env var `GH_PAT_OAKRIDGE`. Use it only for authentication (git remote URL). Never write it to any file or print it unredacted.
- Never modify `docs/index.html` directly. That is the live production page and is a human-only step.

---

## Session Start Checklist

Run these steps at the top of every session:

1. Verify the repo is cloned at `/home/user/oakridge` (or clone it):
   ```
   git clone "https://x-access-token:${GH_PAT_OAKRIDGE}@github.com/communityml/oakridge.git" /home/user/oakridge
   ```
2. Set the authenticated remote (if already cloned):
   ```
   git -C /home/user/oakridge remote set-url origin "https://x-access-token:${GH_PAT_OAKRIDGE}@github.com/communityml/oakridge.git"
   ```
3. Find the current working version: list `docs/index_*.html` and take the highest number.
4. Confirm the task with the user before making any changes.

---

## Versioning Workflow

| File | Role |
|---|---|
| `docs/index.html` | **Live production page** — humans only, never Claude |
| `docs/index_NNN.html` | Numbered snapshots — Claude works here |

**To create a new version:**
1. `cp docs/index_NNN.html docs/index_MMM.html` (MMM = NNN + 1)
2. Edit `docs/index_MMM.html` with the requested changes
3. Commit and push to `main`
4. Share preview URL: `https://communityml.github.io/oakridge/index_MMM.html`

**Current version:** 061

---

## Design Principles (never violate these)

- **Phone-first** — mobile layout and font sizes come first; desktop is secondary
- **Elderly-friendly** — large fonts, high contrast, simple navigation; no tiny text or confusing UI
- **Information over aesthetics** — clear, navigable content beats decorative whitespace
- **Self-contained** — single HTML file with inline CSS and JS; no external build step
- **Section comments** — every major HTML section has a `<!-- ── NAME ── -->` comment for navigation

---

## HTML Section Map (for docs/index_NNN.html)

```
<!-- ── HERO ── -->
<!-- ── HERO SLIDESHOW ── -->
<!-- ── OUR MISSION ── -->
<!-- ── A FRESH START ── -->
<!-- ── ROADMAP ── -->
<!-- ── WHAT HAS BEEN ACCOMPLISHED ── -->
<!-- ── EVENTS ── -->
<!-- ── CONTACT ── -->
<!-- ── DONATIONS ── -->
<!-- ── CREDIBILITY BAND ── -->
<!-- ── STORY / FOUNDING TEXT ── -->
<!-- ── SIX PILLARS IMAGE ── -->
<!-- ── FOOTER ── -->
```

---

## Events — Auto-hide Logic

Events use `<details class="eventCard" data-event-date="YYYY-MM-DD">`. The inline JS hides any event where the current date is more than 1 week after `data-event-date`. If all events are hidden, "No upcoming events" is shown automatically. Always set `data-event-date` to the **last day** of the event.

---

## Deployment (human step only)

Once a preview version is approved by the human:
1. Copy approved `docs/index_NNN.html` content into `docs/index.html`, push to `main`
2. Upload `docs/index.html` to the AWS S3 bucket
3. Create a CloudFront invalidation for `/index.html`
