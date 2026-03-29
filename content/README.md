# Personal knowledge graph (Quartz)

This repository is a **Quartz 4** site: Markdown notes in `content/` are built into a static site with search, backlinks, tags, and an interactive **global graph**. The graph is only as useful as the **links and structure** you maintain—this document is the contract you use when topics and goals shift over the next several months.

For framework-specific options (plugins, hosting, CI), see the [official Quartz documentation](https://quartz.jzhao.xyz/).

---

## What you are building

- **Notes** are plain `.md` files under `content/`.
- **The graph** is derived from **wikilinks** (`[[note-name]]`) and regular Markdown links that Quartz can crawl (see [CrawlLinks](https://quartz.jzhao.xyz/plugins/CrawlLinks)).
- **Tags** in frontmatter create tag pages and help **filter** when you have many unrelated domains (work, health, learning, projects).
- **Hub notes** (maps of content, indexes) are how you keep **diverse topics** navigable without one giant folder per idea.

Your job is not to predict every topic upfront. It is to use **repeatable rules** so that when you add something new, it still connects cleanly six months later.

---

## Directory layout (recommended)

Everything published must live under `content/`. The following paths are **ignored by the build** (see `quartz.config.ts` → `ignorePatterns`):

| Path | Purpose |
|------|--------|
| `content/private/` | Notes you edit locally but **never** publish (same repo, excluded from site). |
| `content/templates/` | Boilerplate for new notes (Obsidian templates, copy-paste starters). |
| `content/.obsidian/` | Obsidian workspace settings (already ignored). |

**Suggested shape inside `content/`** (adapt as you go):

```text
content/
  index.md                 # Main entry; link to your top-level hubs
  private/                 # local-only (not built)
  templates/
  areas/                   # Ongoing responsibilities (work, health, finance)
  projects/                # Time-bound efforts with an end state
  resources/               # Book/article/course notes, stable reference
  people/                  # Optional: people + context (only if useful)
```

Folders are optional: Quartz emits **folder pages** if you use them, which helps browsing. If you prefer a flat `content/` with strong hubs and tags, that is valid too—pick one primary strategy and stick to it.

---

## File naming

- Use **kebab-case** filenames: `machine-learning-basics.md`, not `Machine Learning Basics.md`.  
  Wikilinks resolve to files; predictable names reduce broken links.
- One **main concept or project** per file. Split when a note tries to do three jobs (reference + diary + checklist).

---

## Frontmatter (required habits)

Every note should start with YAML frontmatter. Quartz reads this for titles, dates, tags, and drafts.

```yaml
---
title: "Readable title for the page"
description: "One line for SEO / previews (optional but good for sharing)"
tags:
  - area/work
  - topic/ml
draft: false
---
```

### Fields that matter for *your* workflow

- **`title`** — Shown in the UI; can differ from the filename. Prefer setting it explicitly on important pages.
- **`tags`** — Use a **small, consistent vocabulary**. See [Tags](#tags-across-diverse-topics) below.
- **`draft: true`** — **Unpublished.** The site uses `RemoveDrafts()`; drafts never appear in the build. Use this for half-finished or sensitive-in-progress notes that still live under `content/` (not in `private/`).
- **Dates** — `CreatedModifiedDate` uses frontmatter first, then **git**, then filesystem. **Commit notes to git** if you care about accurate “modified” times on the site.

Optional fields you may add over time: `aliases` (for Obsidian and redirects), `permalink`, etc.—see [Quartz Frontmatter](https://quartz.jzhao.xyz/plugins/Frontmatter).

---

## Linking: wikilinks vs Markdown links

This project uses **Obsidian-style wikilinks** and **CrawlLinks** with `markdownLinkResolution: "shortest"`.

**Prefer wikilinks** for graph-native connections:

```markdown
See [[project-alpha]] for the earlier experiment.
[[shared-ideas|different link text]]
```

**Use Markdown links** for external URLs and when you explicitly want a full path.

**Rules of thumb**

1. When you introduce a **new concept** that will matter again, create a note (even a stub) and **link it at creation time**. Stubs beat orphan titles.
2. **Link out from hubs**: each major hub note should mention its children; children should link back to at least one hub or parent project.
3. After a writing session, ask: *“If I opened the graph, would this note look like an island?”* If yes, add one inbound and one outbound link.

---

## Tags across diverse topics

Tags are your **coarse filter** when topics have little to do with each other. Avoid hundreds of one-off tags.

**Suggested pattern: namespace + optional subtopic**

```yaml
tags:
  - area/work
  - area/personal
  - project/kg-site
  - type/book
  - type/meeting
```

- **`area/*`** — Ongoing life/work buckets.  
- **`project/*`** — Things with an end date or deliverable.  
- **`type/*`** — Note *shape* (book, course, meeting, howto).  
- **`status/*`** — Only if you need it (`status/active`, `status/archived`).

**Maintenance:** Once a month, open the tag list on the built site (or Obsidian tag pane) and **merge or delete** tags that duplicated the same idea (`ml` vs `machine-learning`).

---

## Hub notes (maps of content)

For each major domain you care about, maintain **one hub note** that:

1. States the **scope** in one paragraph (what belongs here vs elsewhere).  
2. Lists **key notes** with wikilinks (grouped by subtopic if needed).  
3. Links **up** to `index.md` or a parent area hub.

**`index.md`** should stay lightweight: point to hubs, not to every note.

When you start a new objective for the month, either:

- add a subsection to an existing hub, or  
- create **`projects/YYYY-MM-short-name.md`** and link it from `index.md` and the relevant `area/*` hub.

---

## Stubs, depth, and when to split

- **Stub** = title + 2–4 bullets + links to sources or parent notes. Stubs are allowed; **orphans** are not.  
- **Split** when a note exceeds ~400–600 words *and* mixes **reference** with **narrative** or **tasks**—give each its own file and cross-link.  
- **Archive** by adding `tags: [status/archived]` and a short “Superseded by [[new-note]]” line at the top—not by deleting history unless it was wrong.

---

## Private and sensitive material

- **`content/private/`** — Ignored by Quartz; good for keys, health details, or anything that must not ship. Still in git unless you use a local-only branch or exclude via `.gitignore` (your choice).  
- **`draft: true`** — Excluded from the **build** but still in the repo if committed; fine for “not ready for the website” but not for secrets.  
- **Secrets** do not belong in this repo at all—use a password manager or an untracked path.

---

## Local workflow: write, preview, ship

From the repository root:

```bash
# One-off build → output in public/
npx quartz build -d content

# Local site + hot reload (default http://localhost:8080)
npx quartz build --serve -d content
```

Edit files in `content/` with Obsidian, VS Code, or any editor. If you use Obsidian, keep vault root at the repo root or at `content/` consistently so paths in wikilinks match.

**Before you rely on dates on the site:** commit changes so git-based dates are meaningful.

---

## Git and your remote

Push to your GitHub repository when you want a backup or to connect hosting (e.g. GitHub Pages). Typical flow:

```bash
git add content/
git status
git commit -m "Describe what changed for your future self"
git push
```

If you track upstream Quartz for updates, pull or merge from that remote separately from your content commits so you can reason about “framework changes” vs “note changes.”

---

## Publishing (when you go beyond localhost)

In `quartz.config.ts`, update **`baseUrl`** to your real domain when you deploy; otherwise links and feeds may point at the wrong host. Analytics and other options are documented on [quartz.jzhao.xyz](https://quartz.jzhao.xyz/configuration).

---

## Maintenance cadence (realistic for six months)

| When | What |
|------|------|
| **Each session** | New note gets at least one wikilink in and one out; tag with `area/*` or `project/*`. |
| **Weekly** | Open **global graph**; fix obvious islands; add one hub link if a cluster grew. |
| **Monthly** | Tag cleanup; archive finished projects; refresh `index.md` if priorities shifted. |
| **Quarterly** | Rename or merge redundant notes; update hub scopes so they still match reality. |

---

## Quick checklist (new note)

- [ ] Filename: kebab-case, one main idea  
- [ ] Frontmatter: `title`, `tags`, `draft` set intentionally  
- [ ] At least one `[[wikilink]]` to an existing or new stub  
- [ ] Linked from a **hub** or **parent project** note  
- [ ] Committed to git when the note is “real” enough to show dates  

---

## Quartz upstream

This project is powered by [Quartz v4](https://github.com/jackyzha0/quartz). Framework docs, Discord, and sponsorship links live in the upstream README and on [quartz.jzhao.xyz](https://quartz.jzhao.xyz/).
