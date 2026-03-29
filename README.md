# Personal knowledge graph (Quartz)

One guide for **notes**, **git**, **local builds**, **UI changes**, and **upkeep**. Framework details beyond this file: [Quartz documentation](https://quartz.jzhao.xyz/).

## Contents

1. [What you are building](#what-you-are-building)
2. [Repository & Git](#repository--git)
3. [Content layout & note habits](#content-layout--note-habits)
4. [Frontmatter, links, tags, hubs](#frontmatter-links-tags-hubs)
5. [Private notes & drafts](#private-notes--drafts)
6. [Run, preview, and scheduled builds](#run-preview-and-scheduled-builds)
7. [Customizing the site UI](#customizing-the-site-ui)
8. [Publishing](#publishing)
9. [Maintenance cadence](#maintenance-cadence)
10. [New-note checklist](#new-note-checklist)
11. [Quartz upstream](#quartz-upstream)

---

## What you are building

- **Notes** — Markdown under `content/`.
- **Graph** — From **wikilinks** (`[[note-name]]`) and crawlable Markdown links ([CrawlLinks](https://quartz.jzhao.xyz/plugins/CrawlLinks)); resolution is **shortest** in `quartz.config.ts`.
- **Tags** — Frontmatter tags → tag pages; use them to separate unrelated domains over time.
- **Hubs** — Index notes that link clusters together so the graph stays navigable.

Repeatable rules matter more than planning every topic in advance.

---

## Repository & Git

| Item | This repo |
|------|-----------|
| **Default branch** | `main` |
| **Remote `origin`** | [github.com/adityanagachandra/personal-KG](https://github.com/adityanagachandra/personal-KG) |
| **Branches** | Do day-to-day work on `main`; spin **topical branches** (`feature/…`, `notes/…`) when you want isolation, then merge to `main`. |

Typical session:

```bash
cd /path/to/quartz   # repo root
git status
git add content/     # or git add -A when you changed quartz.config, styles, etc.
git commit -m "Short, specific message"
git push origin main
```

There is **no** required upstream remote to Jacky’s Quartz. To pull official Quartz updates later, add a remote when needed, for example:

`git remote add quartz https://github.com/jackyzha0/quartz.git`  
then fetch/merge or cherry-pick on a branch, separate from content commits.

**Dates on the site** use frontmatter, then **git**, then the filesystem — commit notes when you care about accurate “modified” times.

---

## Content layout & note habits

**Published** material lives under `content/`. **Ignored** by the build (`quartz.config.ts` → `ignorePatterns`):

| Path | Use |
|------|-----|
| `content/private/` | Never published; still in repo unless you exclude it. |
| `content/templates/` | Note templates. |
| `content/.obsidian/` | Obsidian settings. |

Suggested folders (all optional):

```text
content/
  index.md           # Entry; link to hubs
  private/
  templates/
  areas/             # Ongoing areas (work, health, …)
  projects/          # Time-bound work
  resources/         # Books, courses, references
```

- **Filenames:** `kebab-case.md`; one main idea per file; split if a note mixes reference, narrative, and tasks.

---

## Frontmatter, links, tags, hubs

**Frontmatter** (every note):

```yaml
---
title: "Readable title"
description: "Optional; good for previews/SEO"
tags:
  - area/work
  - project/example
draft: false
---
```

- **`draft: true`** — Not published (`RemoveDrafts()` in config).
- **Tags** — Prefer small namespaces, e.g. `area/*`, `project/*`, `type/*`, optional `status/*`. Prune duplicates monthly.

**Links:** prefer wikilinks for the graph (`[[other-note]]`, `[[note|label]]`). Add at least one inbound and one outbound link for new notes; link new concepts from a **hub** the same session.

**Hubs:** one hub per major domain — short scope paragraph, list of `[[key notes]]`, link up to `index.md` or a parent hub. Keep `index.md` thin: pointers to hubs, not every note.

**Stubs** (title + few bullets + links) are fine; **orphans** are not. **Archive** with `status/archived` and “Superseded by [[…]]” instead of deleting history.

---

## Private notes & drafts

- **`content/private/`** — Excluded from the site; not for secrets if the folder is committed.
- **`draft: true`** — Excluded from build but can still be in git; not for secrets.
- **Real secrets** — Password manager or material outside this repo.

---

## Run, preview, and scheduled builds

From the **repository root**:

```bash
npx quartz build -d content                    # static output → public/
npx quartz build --serve -d content            # http://localhost:8080 + hot reload
```

**Nightly static build (macOS):** a LaunchAgent runs **`quartz build`** (not `--serve`) every day at **11:59 PM local time**.

| Piece | Path / command |
|-------|----------------|
| Script | `scripts/daily-build.sh` |
| Install / refresh agent | `./scripts/install-launchd-daily-build.sh` |
| Plist (after install) | `~/Library/LaunchAgents/com.adityanagachandra.quartz.daily-build.plist` |
| Logs | `scripts/logs/daily-build.log` and `daily-build.err.log` (gitignored) |

**Uninstall:**  
`launchctl bootout "gui/$(id -u)/com.adityanagachandra.quartz.daily-build"`  
then remove that plist. If the Mac is asleep at 11:59, the run may slip; use CI (e.g. GitHub Actions) if you need a guaranteed cloud build.

---

## Customizing the site UI

Work in the **repo root** `quartz/` tree. After edits, rebuild or let `--serve` reload.

| Goal | Where |
|------|--------|
| Site title, fonts, light/dark colors | `quartz.config.ts` → `configuration.pageTitle`, `theme.typography`, `theme.colors` |
| Sidebar, footer, which blocks appear (graph, TOC, search, …) | `quartz.layout.ts` → `sharedPageComponents`, `defaultContentPageLayout`, `defaultListPageLayout` |
| Behavior/markup of a widget | `quartz/components/*.tsx` (e.g. `Footer.tsx`, `Graph.tsx`, `Explorer.tsx`, `PageTitle.tsx`) |
| Your CSS overrides | `quartz/styles/custom.scss` |
| Global variables (spacing, radii, …) | `quartz/styles/variables.scss` |
| Styles for one component | `quartz/components/styles/*.scss` (e.g. `graph.scss`, `explorer.scss`) |

Practical order: **`quartz.config.ts`** → **`quartz.layout.ts`** (including footer links) → **`custom.scss`** → individual **`.tsx` / `.scss`** only when necessary.

---

## Publishing

### GitHub Pages (this repo)

The site is deployed with **GitHub Actions** when you push to **`main`**.

1. On GitHub: **Settings → Pages** (under “Code and automation”).
2. Under **Build and deployment**, set **Source** to **GitHub Actions** (not “Deploy from a branch”).
3. Push this repo (including `.github/workflows/deploy.yml`). The **Deploy Quartz site to GitHub Pages** workflow builds with `npx quartz build -d content` and publishes the `public/` folder.
4. After the first successful run, open your site at  
   **https://adityanagachandra.github.io/personal-KG/**  
   (GitHub may take a minute to propagate.)

**`baseUrl`** in `quartz.config.ts` is set to `adityanagachandra.github.io/personal-KG` so RSS, sitemap, and absolute URLs match that address. If you rename the repo or use a **custom domain**, update `baseUrl` to match (see [Quartz configuration](https://quartz.jzhao.xyz/configuration)).

If a workflow run fails with an environment protection error, open **Settings → Environments**, remove any stale **`github-pages`** environment, and re-run the workflow so GitHub can recreate it.

### Other hosts

Any static host that serves the contents of **`public/`** after `npx quartz build -d content` works (e.g. Cloudflare Pages). Keep **`baseUrl`** aligned with the public URL.

---

## Maintenance cadence

| When | What |
|------|------|
| Each session | New note: wikilinks in + out; tag with `area/*` or `project/*`. |
| Weekly | Global graph: reduce islands; tighten hubs. |
| Monthly | Tag cleanup; archive finished projects; refresh `index.md` if priorities shifted. |
| Quarterly | Merge/rename redundant notes; realign hub scopes. |

---

## New-note checklist

- [ ] `kebab-case` filename, one main idea  
- [ ] Frontmatter: `title`, `tags`, `draft` intentional  
- [ ] At least one `[[wikilink]]` in and one out  
- [ ] Linked from a hub or parent project  
- [ ] Committed when dates on the site should reflect reality  

---

## Quartz upstream

Powered by [Quartz v4](https://github.com/jackyzha0/quartz). Docs, Discord, and advanced plugins: [quartz.jzhao.xyz](https://quartz.jzhao.xyz/).
