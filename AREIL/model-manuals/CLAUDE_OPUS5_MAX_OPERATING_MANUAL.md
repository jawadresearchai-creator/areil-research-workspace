# CURRENT_MODEL_MAX_OPERATING_MANUAL.md

**An operating manual for the exact model, effort configuration, harness, tools and runtime processing this request — written to be consumed by another AI orchestrator.**

Compiled 2026-09-03 · Session `claude-72 [916604]` · Author: the session being profiled.

---

## PRE-FLIGHT CONFIGURATION — RESOLVED

The requested configuration was *maximum available reasoning/effort*. Unusually, this is **verifiable here**, and the answer corrects a claim in the earlier profile of this same session.

```text
configured model:            claude-opus-5                       [OC]
actual serving model:        NOT EXPOSED — may differ, may change mid-session   [D][U]
provider:                    Anthropic                           [D]
application:                 Cowork mode, Claude desktop app     [D]
harness:                     Claude Agent SDK                    [D]
host OS (execution):         Linux 6.18.44-fc-v24 x86_64, container hostname `vm`, root  [OP]
host OS (user device):       win32, Claude desktop 1.44121.4     [OA]
requested reasoning level:   MAX
observable reasoning level:  CLAUDE_EFFORT=max                   [OC]
observable thinking budget:  MAX_THINKING_TOKENS=31999           [OC]
highest supported effort:    max (ladder: low < medium < high < xhigh < max)   [D]
current effort:              max                                 [OC]
context window:              1,000,000 tokens                    [D] not probed to limit
maximum output:              128,000 tokens                      [D] not probed to limit
knowledge cutoff:            May 2026                            [D]
session type:                interactive, cloud-hosted, device-linked, ephemeral container  [OC]
session token budget:        15,000,000 declared at session start [OC]
```

### REQUESTED / OBSERVED / MAXIMUM SUPPORTED

| | Value | Basis |
| --- | --- | --- |
| **REQUESTED** | `max` | user instruction |
| **OBSERVED** | `max` | `CLAUDE_EFFORT=max` present in the execution environment `[OC]`, alongside `MAX_THINKING_TOKENS=31999` |
| **MAXIMUM SUPPORTED** | `max` | Anthropic effort documentation lists `low, medium, high, xhigh, max`; `max` is the top `[D]`. Independently corroborated by the AWS Bedrock model card and by the in-container Claude Code CLI, whose `--effort` flag advertises exactly those five values `[OS]` |

**Three honest caveats.**

1. `CLAUDE_EFFORT` is read from the environment of the shell tool. It is strong evidence of the session's configured effort but is *not* proof that the currently-serving inference request carries `effort=max` — I cannot inspect my own API request. Class it `[OC]`, not `[OE]`.
2. `MAX_THINKING_TOKENS=31999` is a **ceiling**, not a consumption figure. It does not tell you how many thinking tokens any given turn actually used, and I cannot observe that. `[OC]` for the ceiling, `[U]` for actual usage.
3. **Correction to prior work.** An earlier operational profile produced in this same session stated that effort tier and thinking budget were `[U] not exposed`. That was wrong — it was an unprobed assumption stated as a limitation. Both values were sitting in the process environment and a single `env | grep` would have found them. This is logged in §65 as a self-audit finding, and it is the clearest available demonstration of this manual's first principle: **probe before assuming, including when assuming a limitation.**

### SCOPE BOUNDARY OBSERVED

During probing, the environment exposed internal permission-classifier configuration (auto-mode allow/deny policy text). That is confidential security machinery and is **not reproduced here**. What is safely reportable and operationally necessary appears in §13 and §41 as an *operational summary*: a permission classifier gates specified action classes — device folder access, scheduled-task create/update/delete/fire, and destructive or externally-visible effects — and can soft-deny a tool call with a machine-readable reason. Orchestrators must handle that denial class explicitly. No rule text, no bypass guidance.

---

## EVIDENCE AND ATTRIBUTION KEY

**Evidence classes.** `[D]` documented · `[OS]` observed in schema · `[OC]` observed in configuration · `[OP]` observed by probe · `[OE]` observed executed end-to-end · `[OA]` observed authenticated · `[S]` self-described · `[I]` inferred · `[U]` unknown.

**Attribution layers.** `M` base model · `P` product/application · `H` agent harness · `T` connected tool · `E` external service · `A` authorization/permissions · `I` infrastructure.

**Two rules this manual enforces on itself:** tool-exists ≠ tool-works (`[OS]` ≠ `[OE]`), and connector-exposed ≠ authenticated (`[OS]` ≠ `[OA]`).

---

# PART I — NAVIGATION MAP

## 1. EXACT RUNTIME IDENTITY

| Field | Value | Layer | Class |
| --- | --- | --- | --- |
| Provider | Anthropic | M | `[D]` |
| Family | Claude | M | `[D]` |
| Model identifier | `claude-opus-5` | M | `[OC]` |
| Serving version | not exposed; may differ from configured and may change mid-session | M | `[U]` |
| Reasoning mode | adaptive thinking, always on | M | `[D]` |
| Effort | `max` | M/P | `[OC]` |
| Max effort available | `max` | M | `[D][OS]` |
| Thinking ceiling | 31,999 tokens | M/P | `[OC]` |
| Application | Cowork mode (Claude desktop app) — **not** Claude Code, despite shared tooling | P | `[D]` |
| Harness | Claude Agent SDK; in-container CLI is Claude Code v2.1.259 | H | `[OP]` |
| Session id | `claude-72 [916604]` | H | `[OP]` |
| Execution host | Firecracker-class Linux VM, 2 vCPU, 7.8 GiB RAM, no swap, root | I | `[OP]` |
| Linked device | `jawad`, win32, desktop app 1.44121.4, **0 connected folders** | E/A | `[OA]` |
| Knowledge cutoff | May 2026 (today: 2026-09-03 — a ~4-month recall gap) | M | `[D]` |
| Context window | 1M documented | M | `[D]` |
| Effective context | not measured; no truncation signal is exposed to me | M | `[U]` |
| Max output | 128K documented | M | `[D]` |
| Input modalities | text; images; PDF pages rendered as images | M/T | `[OE]` |
| Output modalities | **text only** from the model — every binary artefact is produced by code execution | M | `[OE]` |
| Persistence | cross-surface memory MCP; Google Drive; published Artifacts; scheduled tasks. **Container filesystem is ephemeral** | E/I | `[OA]`/`[D]` |

**The identity rule for orchestrators:** route on the *configured* identifier and treat the serving model as unverified. If model identity is load-bearing for your routing decision, obtain it from provider-side API response metadata, never from the model's self-report.

---

## 2. "WHAT AM I OPERATING?" MAP

```text
USER / ORCHESTRATOR
   │  Jawad, or an automated caller. Supplies objective, constraints, autonomy level.
   │  CONTRIBUTES: intent, authority, acceptance criteria.
   ↓
PRODUCT  [P] — Cowork mode, Claude desktop app
   │  Chooses model + effort (CLAUDE_EFFORT=max), renders task lists and file cards,
   │  brokers AskUserQuestion, owns the session lifecycle across the user's devices.
   │  CONTRIBUTES: configuration, UI surface, session continuity. NOT capability.
   ↓
MODEL  [M] — claude-opus-5, adaptive thinking, effort=max, ceiling 31,999 thinking tokens
   │  CONTRIBUTES: reasoning, language, vision decoding, judgement, tool-call selection.
   │  CONTRIBUTES NOTHING ELSE. Every action below this line is someone else's capability.
   ↓
AGENT HARNESS  [H] — Claude Agent SDK
   │  The tool loop; deferred-tool loading (ToolSearch); Agent spawning; Task list;
   │  Monitor; Skill loading; in-process Cron; permission classification.
   │  CONTRIBUTES: agency. Delegation and parallelism live HERE, not in the model.
   ↓
TOOLS  [T] — Bash, Read/Write/Edit, Glob/Grep, WebSearch, WebFetch, Artifact,
   │  SendUserFile, SendUserMessage, SendMessage, ListAgents, ReportFindings, ToolSearch
   │  CONTRIBUTES: the ability to affect anything at all.
   ↓
CONNECTORS  [T/E] — Google Drive MCP (connected+authenticated), remote-devices MCP,
   │  claude-code-remote MCP (scheduling), visualize MCP, claude-in-chrome MCP.
   │  Registry offers ~more, incl. PubMed (authless) — NOT installed.
   │  CONTRIBUTES: reach into named external systems.
   ↓
EXTERNAL SERVICES  [E] — Google Drive account; GitHub API; the public web;
   │  the user's Windows machine via the desktop bridge.
   │  CONTRIBUTES: the actual data and the actual consequences.
   ↓
AUTHORIZATION  [A] — OAuth (Drive: granted), device folder grants (NONE), computer-use
   │  approval (not requested), permission classifier (active, can soft-deny).
   │  CONTRIBUTES: the gate. Capability without authorization is zero capability.
   ↓
INFRASTRUCTURE  [I] — 2 vCPU / 7.8 GiB / no GPU / no swap; per-session disk allowance;
   │  mandatory HTTPS egress proxy with an allowlist (CRAN and Docker Hub BLOCKED).
   │  CONTRIBUTES: the hard ceiling on everything computational.
   ↓
PERSISTENT STATE  [E] — memory MCP (13 files); Google Drive; published Artifacts (5);
      scheduled tasks (0). Container filesystem is NOT here — it dies with the session.
      CONTRIBUTES: everything that survives this conversation.
```

**The single most common orchestration error this map prevents:** attributing a tool's or connector's capability to the model. "The model can read Drive" is false. The harness exposes a Drive connector; OAuth authorizes it; the model decides when to call it. Swap the harness and the model's Drive capability is zero.

---

## 3. EXECUTION ENVIRONMENT INVENTORY

States: **A** available · **AI** available after install · **AX** available with external service · **B** blocked · **U** unknown.

| Component | State | Detail | Class |
| --- | --- | --- | --- |
| CPU | **A** | 2 vCPU. Hard cap on bootstrap/permutation/Bayesian/parallel-build workloads | `[OP]` |
| RAM | **A** | 7.8 GiB, **no swap**. Datasets above ~this must be chunked or streamed | `[OP]` |
| GPU | **B** | None. No torch/TF/JAX. Do not route model training here | `[OP]` |
| Disk | **A** | 252 G device, ~30 G free, but a **fixed per-session allowance** — `df` misleads. "No space" with low Used = allowance spent; deletes still succeed | `[OP]`/`[D]` |
| OS | **A** | Linux 6.18.44-fc-v24 x86_64, running as root | `[OP]` |
| Shell | **A** | Bash. 120 s default / **600 s max** per call. No cwd/env carryover between calls | `[OP]`/`[D]` |
| Python | **A** | 3.11.15 + numpy, pandas, scipy, sklearn, matplotlib, seaborn, openpyxl, xlsxwriter, python-docx, python-pptx, pypdf, pdfplumber, Pillow, bs4, lxml, requests, httpx, networkx, reportlab, jinja2, playwright, pdf2image, pytesseract, imageio | `[OP]` |
| Python (extra) | **AI** | statsmodels **installed and executed** (0.15.0); pyarrow/duckdb/polars/linearmodels/lifelines/pymc/sympy/pytest all pip-installable (PyPI allowlisted) | `[OE]` |
| **R** | **AI** | **Not preinstalled.** `apt-get install r-base-core` → R 4.3.3. Verified executing a clustered-SE regression end-to-end | `[OE]` |
| **CRAN** | **B** | `cloud.r-project.org` → **403 CONNECT**. `install.packages()` fails | `[OP]` |
| **R packages** | **AI** | **1,130 `r-cran-*` Debian packages.** Verified: sandwich, lmtest, zoo install and run. Available: plm, AER, lme4, survival, metafor, mice, quantreg, tseries, vars, urca, lavaan, brms, rstan, mgcv, glmnet, randomForest, broom, tidyverse, rmarkdown, knitr, data.table, clubSandwich. **Unavailable: fixest, did, stargazer, modelsummary** | `[OE]`/`[OP]` |
| Node | **A** | v22.22.2 / npm 10.9.7; registry.npmjs.org allowlisted | `[OP]` |
| Java | **A** | present | `[OP]` |
| Go / Rust / gcc / make | **A** | all present; proxy.golang.org and index.crates.io allowlisted | `[OP]` |
| Git | **A** | Clone over HTTPS verified against github.com. **`/home/claude` is NOT a git repo** — this has agent consequences (§14) | `[OE]` |
| GitHub | **AX** | API reachable with an injected token (core limit 15,000/hr observed). **`gh` CLI absent** | `[OE]` |
| Docker | **B** | CLI present, **daemon not running**, `download.docker.com` blocked | `[OP]` |
| Package managers | **A** | apt (Debian repos reachable), pip, npm, cargo, go | `[OE]` |
| Browser (headless) | **A** | Playwright chromium pre-provisioned at `/opt/pw-browsers`. **Do not run `playwright install`** | `[OP]`/`[D]` |
| Browser (interactive) | **U** | claude-in-chrome and in-app Claude_Browser tool families present but **untested**; need the user's Chrome / desktop app online | `[OS]` |
| Network | **A/B** | Mandatory HTTPS proxy, **allowlisted**. Allowed: PyPI, npm, jsr, crates.io, Go proxy, Debian, github.com, api.github.com, api.anthropic.com. Blocked: CRAN, Docker Hub | `[OP]` |
| API access | **AX** | Allowlist-gated. An arbitrary third-party API host is likely blocked — test before designing around it | `[OP]` |
| Filesystem | **A** | Full read/write; `/mnt/user-data/working` exists; `uploads`/`outputs` appear only when files are staged | `[OP]` |
| Persistent storage | **AX** | Google Drive (authenticated), memory MCP, published Artifacts. **Container storage is not persistent** | `[OA]` |
| Document toolchain | **A** | pandoc 3.1.3, LibreOffice 24.2.7.2. Verified: docx→pdf and docx→html conversions executed | `[OE]` |
| OCR | **A** | tesseract 5, **`eng` + `osd` only**. Other languages need a language-pack install | `[OP]` |
| Media | **A** | ffmpeg (processing only — no ASR, no video understanding) | `[OP]` |
| Databases | **B/AI** | No server. `psql` client present with nothing to connect to; Python stdlib `sqlite3` works; no sqlite3/mysql/duckdb CLI | `[OP]` |

### Environment persistence across turns — verified `[OP]`
Packages installed earlier in this session (R, its apt packages, statsmodels) and files written earlier were all still present hours later. **The container persists across turns within a session and is a valid place to build state — but only until the session ends.**

---
## 4. TOOL MAP

`Tested` = a call was made this session. `Auth` = an authenticated external service responded. Blank Auth means none required.

### Web & research
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `WebSearch` | T | ✅ | ✅ `[OE]` | — | Discover URLs | ✅ | ❌ | **US-only general index**; titles+URLs only, no content |
| `WebFetch` | T | ✅ | ✅ `[OE]` | — | URL→markdown→prompted extraction | ✅ | ❌ | **Answers via a small fast model — lossy summary, not raw text**; no auth'd URLs; cross-host redirects returned not followed; 15-min cache |
| PubMed connector | E | ⛔ not installed | ❌ | — | `search_articles`, `get_full_text_article`, `find_related_articles`, `lookup_article_by_citation`, `convert_article_ids` | ✅ | ❌ | **`isAuthless: true`** — installable without OAuth. See §21 |
| alphaXiv connector | E | ⛔ not installed | ❌ | — | arXiv full-text + embedding similarity search | ✅ | ❌ | Requires auth |
| Scholar Gateway | E | ⛔ not installed | ❌ | — | Semantic scholarly search | ✅ | ❌ | Requires auth |

### Files, code, execution
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `Bash` | T | ✅ | ✅ `[OE]` | — | Shell in container | ✅ | session-only | 600 s max; no cwd/env carryover |
| `Read` | T | ✅ | ✅ `[OE]` | — | Files, images, PDF pages, notebooks | ✅ | — | 2000-line default; PDF >10pp needs a page range, max 20/req |
| `Write`/`Edit` | T | ✅ | ✅ `[OE]` | — | Create / exact-string edit | ⚠️ same-path collisions | session-only | Must Read before Edit; Edit fails on non-unique match |
| `Glob`/`Grep` | T | ✅ | ✅ `[OE]` | — | Path / ripgrep search | ✅ | — | Ripgrep regex dialect |
| `NotebookEdit` | T | deferred | ❌ | — | .ipynb cell editing | ✅ | session-only | — |

### Agents & orchestration
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `Agent` | H | ✅ | ✅ `[OE]` | — | Spawn subagent | ✅ **verified concurrent** | ⚠️ resumable in-session | **Workers get NO Agent tool** — single-level; ~35–49k token floor |
| `SendMessage` | H | ✅ | ✅ `[OE]` | — | Message/resume agent or peer session | ✅ | resumes with context | Cloud sessions receive but cannot reply |
| `ListAgents` | H | ✅ | ✅ `[OE]` | — | Enumerate agents/sessions | ✅ | — | Self not listed |
| `Task*` (Create/Update/List/Get/Output/Stop) | H | ✅ | ✅ `[OE]` | — | Task list + async control | ✅ | session-only | Rendered as the user's progress widget |
| `Monitor` | H | deferred ✅ | ❌ | — | Background stdout/WebSocket event stream | ✅ | session-only | Over-verbose monitors auto-stopped |
| `Workflow` | H | ✅ | ❌ | — | Deterministic multi-agent script | ✅ | background | **Requires explicit user opt-in**; session guideline <15 agents |
| `Cron*` (local) | H | deferred | ❌ | — | In-process scheduler | ✅ | ❌ **dies with session** | **Never use for user-facing schedules** |

### Persistence, scheduling, external
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `mcp__memory__*` | E | ✅ | ✅ `[OE]` | ✅ | Cross-surface user memory | ⚠️ optimistic-concurrency | ✅ **cross-session** | Version tokens required; size-capped; strict privacy filter |
| `mcp__Google_Drive__*` (11) | E | ✅ | ✅ `[OE]` | ✅ `[OA]` | search/read/download/create/update/copy/share/trash/permissions/recent | ✅ | ✅ | **The only connected durable external store** |
| `mcp__claude-code-remote__*` (6) | E | ✅ | ✅ `[OE]` | ✅ | Durable scheduled tasks | ✅ | ✅ | Each firing = **fresh session**; min interval normally hourly; **0 defined** |
| `Artifact` | T | ✅ | ✅ `[OE]` | ✅ | Publish HTML/MD page; artifact DB; assets; comments | ✅ | ✅ | **No typed artifacts here** (no `list_types`); CDN allowlist; 16 MB |
| `SendUserFile` | T | ✅ | ✅ `[OE]` | — | Deliver file into conversation | ✅ | conversation | Delivery ≠ persistence |
| `SendUserMessage` | T | ✅ | ❌ | — | Verbatim mid-task message | ✅ | — | — |
| `AskUserQuestion` | P | ✅ | ✅ `[OE]` | — | Structured question | ❌ blocks | — | Useless unattended |

### User device & browsers
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `get_device_info` | E | ✅ | ✅ `[OA]` | ✅ | Device metadata | ✅ | — | Device `jawad`, win32, **connectedFolders: []** |
| `device_bash` | E | ✅ | ✅ **refused** `[OP]` | ❌ | Shell on user's machine | ✅ | device | **"No folders are connected"** — blocked until a grant |
| `device_list_dir` | E | ✅ | ❌ | ❌ | List device dir | ✅ | — | Outside grants: names-only skeleton |
| `device_stage_files` | E | ✅ | ❌ | ❌ | Device → container | ✅ | — | ≤50 files, ≤400 MB/file, ≤500 MB/call |
| `device_commit_files` | E | ✅ | ❌ | ❌ | Container → device | ⚠️ | ✅ device | ≤50 files, ≤20 MB/file, mtime guard |
| `device_request_folder_access` | A | ✅ | ❌ | — | Request grant | ❌ | ✅ session | **Prompts on the user's computer** — needs them present |
| `device_request_delete_permission` | A | ✅ | ❌ | — | Enable deletion | ❌ | ✅ session | `rm` fails without it |
| `Claude_Browser__*` (17) | E | deferred | ❌ | ❌ | In-app browser pane, persistent profile | ✅ | profile | Needs desktop app online; no `file://`/localhost |
| `claude-in-chrome__*` (21) | E | deferred | ❌ | ❌ | User's real Chrome | ✅ | profile | **Modal dialogs freeze the session** |
| `computer_*` (25) | E | deferred | ❌ | ❌ | GUI control of desktop | ⚠️ | — | Two-phase resolve→request→approve |

### Discovery, skills, meta
| Tool | Layer | Avail | Tested | Auth | Purpose | Parallel-safe | Persistent | Major limit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `ToolSearch` | H | ✅ | ✅ `[OE]` | — | Load deferred schemas | ✅ | — | **Batch names in ONE call** |
| `Skill` | H | ✅ | ❌ | — | Load packaged workflow | ✅ | — | 7 account + ~9 bundled |
| `ListSkills`/`ListConnectors`/`ListPlugins` | P | ✅ | ✅ `[OE]` | — | Inventory | ✅ | — | **0 plugins installed** |
| `SearchMcpRegistry` | P | ✅ | ✅ `[OE]` | — | Discover connectors | ✅ | — | **Suggests only — cannot install** |
| `ReportFindings` | H | ✅ | ❌ | — | Structured review findings | ❌ | — | Effort enum `low…max` visible here |
| `mcp__visualize__*` | E | deferred | ❌ | ❌ | In-conversation widgets | ✅ | — | Untested |
| `propose_skills` | P | ✅ | ❌ | — | Propose a skill | ❌ | — | **Render-only — does not write** |

**Absent entirely, name them so an orchestrator does not assume:** patent database · citation-graph API · vector store · image-generation model · ASR · video understanding · DB server · deployment target · Slack/Jira/Notion/GitHub-MCP connectors.

---

## 5. CAPABILITY BOUNDARY

| Task | Reason | Design | Write code | Execute | Verify | Persist | Needs tool | Needs external svc | Needs human auth |
| --- | :-: | :-: | :-: | :-: | :-: | :-: | --- | --- | --- |
| General reasoning / synthesis | ✅ | ✅ | — | — | ✅ | ✅ | — | — | — |
| Peer review / critique | ✅ | ✅ | — | — | ✅ | ✅ | — | — | — |
| Exact arithmetic / statistics | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Bash | — | — |
| Python analysis | ✅ | ✅ | ✅ | ✅ `[OE]` | ✅ | ✅ | Bash | — | — |
| R analysis (apt packages) | ✅ | ✅ | ✅ | ✅ `[OE]` | ✅ | ✅ | Bash+apt | — | — |
| R needing `fixest`/`did` | ✅ | ✅ | ✅ | ❌ | ❌ | — | — | **CRAN (blocked)** | — |
| Deep-learning training | ✅ | ✅ | ✅ | ❌ | ❌ | — | — | **GPU** | — |
| Data > ~7.8 GiB | ✅ | ✅ | ✅ | ❌ | ❌ | — | — | **Bigger machine** | — |
| Web research | ✅ | ✅ | — | ✅ `[OE]` | ⚠️ | ✅ | WebSearch/Fetch | — | — |
| Scholarly database search | ✅ | ✅ | — | ❌ | ❌ | — | PubMed connector | **connector install** | ✅ user installs |
| Patent search | ✅ | ✅ | — | ❌ | ❌ | — | — | **patent DB** | — |
| Repo comprehension / debugging (Linux-reproducible) | ✅ | ✅ | ✅ | ✅ `[OE]` | ✅ | ✅ | Bash/Grep | — | — |
| Debugging user-machine-specific | ✅ | ✅ | ✅ | ❌ | ❌ | — | device_bash | device | ✅ **folder grant** |
| Document read/write (pdf/docx/xlsx/pptx) | ✅ | ✅ | ✅ | ✅ `[OE]` | ✅ | ✅ | Bash+skills | — | — |
| OCR (English) | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | tesseract | — | — |
| OCR (other languages) | ✅ | ✅ | ✅ | ❌ | ❌ | — | — | language pack | — |
| Image understanding | ✅ | — | — | ✅ `[OE]` | ✅ | — | Read | — | — |
| Image generation (generative) | ✅ | ✅ | — | ❌ | ❌ | — | — | **image model** | — |
| Chart rendering + visual QA | ✅ | ✅ | ✅ | ✅ `[OE]` | ✅ **can view own output** | ✅ | Bash+Read | — | — |
| Audio transcription | ✅ | ✅ | ✅ | ❌ | ❌ | — | — | **ASR** | — |
| Spawn parallel subagents | ✅ | ✅ | — | ✅ `[OE]` | ✅ | ⚠️ | Agent | — | — |
| Nested (multi-tier) delegation | ✅ | ✅ | — | ❌ | — | — | — | **external orchestrator** | — |
| Worktree-isolated agents | ✅ | ✅ | — | ❌ `[OP]` | — | — | — | **a git repo as cwd** | — |
| Durable scheduling | ✅ | ✅ | — | ✅ | ✅ | ✅ | cron MCP | — | ⚠️ classifier-gated |
| Read/write user's Drive | ✅ | ✅ | — | ✅ `[OA]` | ✅ | ✅ | Drive MCP | Drive | already granted |
| Act on user's local files | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | device tools | device | ✅ **folder grant** |
| Install a connector/plugin | ✅ | ✅ | — | ❌ | — | — | — | — | ✅ **user only** |
| Physical experiments | ✅ | ✅ | — | ❌ | ❌ | — | — | **laboratory** | — |

---

# PART II — THINKING / REASONING NAVIGATION GUIDE

## 6. MAX-EFFORT OPERATING BEHAVIOR

`[D]` for the documented mechanism, `[S]` for the behavioural account. Anthropic documents `max` as *"absolute maximum capability with no constraints on token spending"*, and documents that higher effort produces **more tool calls, plans explained before acting, detailed summaries, more comprehensive comments**; lower effort combines operations into fewer calls and proceeds directly to action.

### What max effort should change

| Dimension | At max effort |
| --- | --- |
| **Decomposition** | Finer, and made explicit. Sub-problems get named acceptance criteria rather than being handled implicitly |
| **Hypothesis breadth** | Wider before narrowing. Competing explanations enumerated and eliminated on evidence, not on first-plausibility |
| **Planning** | Externalised — a written plan, a probe order, cheap-uncertainty-collapsing steps front-loaded |
| **Contradiction handling** | Contradictions become first-class findings and are actively hunted, not merely noticed and smoothed |
| **Tool selection** | **More tool calls, and more probes before commitment.** The single most visible effect. This manual's pre-flight is the example: `env | grep effort` cost nothing and overturned a stated conclusion |
| **Verification** | Multi-route. Recompute by a different engine, re-fetch every citation, check ground truth rather than self-report |
| **Uncertainty calibration** | Graded per claim; "not found" is distinguished from "not true" everywhere |
| **Retry strategy** | Failures classified (transient vs structural) before any retry, so structural failures cause a re-plan rather than a loop |
| **Synthesis** | Integration held by the coordinator; contradictions surfaced rather than averaged |

### What max effort does NOT improve — read this before paying for it

Max effort is **compute on reasoning**. It cannot buy capability that does not exist at another layer:

1. **It does not add retrieval.** No amount of effort conjures a scholarly index. My analysis quality exceeds my evidence access, and effort widens that gap rather than closing it.
2. **It does not raise the knowledge cutoff.** May 2026 is May 2026 at every effort level.
3. **It does not unblock the network.** CRAN stays 403 at `max`.
4. **It does not add compute.** 2 vCPU and 7.8 GiB are unchanged.
5. **It does not grant authorization.** No folder grant, no device access, at any effort.
6. **It does not make citations real.** Citation fabrication is a generation failure; only *fetching* fixes it.
7. **It does not fix a wrong estimand.** A confidently-reasoned analysis of the wrong quantity is still wrong.
8. **It does not reliably improve trivial tasks** — and can make them worse by adding unnecessary preamble, tool calls, and structure.
9. **It cannot verify its own effort level.** Even here, `CLAUDE_EFFORT=max` is configuration evidence, not proof the serving request carried it.

> **Allocation rule:** spend effort where the bottleneck is *reasoning*. Where the bottleneck is retrieval, compute, authorization or data, effort is wasted spend — fix the bottleneck instead.

---

## 7. REASONING LEVEL ROUTER

Ladder `[D]`: `low < medium < high < xhigh < max`. Default `high` for Opus 5 and Fable 5.1; `high` is equivalent to not setting the parameter. Effort governs **all** output tokens — text, thinking, tool calls, function arguments — and is *"a behavioral signal, not a strict token budget."*

| Level | Task classes | Benefits | Costs | Becomes wasteful when | Verification needed |
| --- | --- | --- | --- | --- | --- |
| **low** | Mechanical transforms; format conversion; bulk extraction; **subagents** (Anthropic explicitly recommends `low` here) | Cheapest, fastest, terse, fewest tool calls | Fewer retrieval calls — **documented to answer from memory more at low effort**; shallower analysis | The task has any judgement content, or any recency/exactness requirement | **Higher, not lower** — cheap tiers overclaim (§14.3) |
| **medium** | Routine analysis; well-specified code; summarisation of supplied material | Balanced speed/cost | Less thorough decomposition | Stakes rise or ambiguity appears | Standard: numbers + citations |
| **high** | **Default.** Complex reasoning, agentic work, most real tasks | Full capability, no explicit setting needed | Baseline | Almost never wasteful | Standard |
| **xhigh** | Long-horizon agentic runs (>30 min), multi-file refactors, million-token budgets | Sustained coherence over long loops | Latency; token spend | The task is short — the sustain benefit never materialises | Standard + stage gates |
| **max** | Irreversible decisions; novel research design; adversarial review of high-stakes output; identification strategy; deep multi-route verification | Deepest decomposition, widest hypothesis space, most probes | Highest latency and spend | **The bottleneck is retrieval, compute, authorization or data rather than reasoning** | Still mandatory — effort does not replace verification |

### Decision table

| Task shape | Effort | Why | Upgrade trigger | Downgrade trigger |
| --- | --- | --- | --- | --- |
| Format conversion, file move, extraction | low | No judgement | Any ambiguity in target format | — |
| Subagent doing bounded mechanical work | low | Documented recommendation; cost floor already ~35k | Worker must exercise judgement | — |
| Subagent doing judgement work (review, extraction with quality calls) | **high** | Cheap tiers confabulate — **observed** (§14.3) | — | Task proves purely mechanical |
| Summarise supplied document | medium | Bounded input | Document is contested or load-bearing | — |
| Standard analysis, well-specified | high | Default | Result drives an irreversible decision | Repeated identical task |
| Write code to a clear spec | high | Default | Multi-module or migration | Single-function utility |
| Long agentic loop (hours) | xhigh | Sustained coherence | Stakes are irreversible | Loop is short |
| Multi-file refactor | xhigh | Long-horizon coherence | — | Single file |
| Identification strategy / estimand choice | **max** | Conceptual error is invisible in diagnostics | — | Design already fixed and validated |
| Novelty verdict feeding a go/no-go | **max** | Consequence is weeks of work | — | Screening only, decision deferred |
| Adversarial review of external-facing output | **max** | Reputational/irreversible | — | Internal draft |
| Ambiguous, high-consequence, no user available | **max** | Must reason to the best interpretation unaided | — | User available to ask |
| Retrieval-bound question (needs an index I lack) | **high** | Max cannot buy the index | — | — |
| Compute-bound job (big data, simulation) | **high** | Max cannot buy vCPUs | — | — |

---
## 8. TASK DIFFICULTY CLASSIFIER

Recognition signals are designed to be computable by an orchestrator from the request text plus cheap metadata, before dispatch.

| Class | Automatic recognition signals | Effort | Workers | Verification |
| --- | --- | --- | :-: | --- |
| **TRIVIAL** | Single fact / single edit / single well-formed computation; one verb; no dependencies; answer fits in a sentence | low–medium | 0 | Inline sanity |
| **ROUTINE** | Known procedure, known inputs, no design decisions; a named format conversion; "do X to file Y" | medium | 0 | Output opens/parses |
| **ANALYTICAL** | Comparison, diagnosis, or estimation over 3–8 items; needs a method choice but the method is standard | high | 0–1 | Recompute key number |
| **COMPLEX** | ≥3 interdependent stages; multiple files or artefacts; success criteria span several dimensions | high–xhigh | 2–4 | Stage gates + final |
| **DEEP-RESEARCH** | Answer requires evidence not in the prompt; words like *novelty, prior art, systematic, literature, state of the art*; unbounded source count | high–max | 3–6 | Per-claim tracing + contradiction pass |
| **HIGH-UNCERTAINTY** | ≥2 defensible readings of the request; conflicting constraints; unfamiliar domain; the user themselves is unsure | **max** | 0–3 (independent attacks) | Adversarial |
| **HIGH-CONSEQUENCE** | Irreversible (delete/publish/send/spend); external audience; legal/medical/financial/safety; a person will act on it | **max** | +1 verifier minimum | **Mandatory multi-route** |
| **LONG-HORIZON** | Explicit multi-session framing; "keep going", "until done"; work exceeding one context or one session | xhigh | 2–4 | Checkpoint + resumability test |

**Compound classification.** These are not mutually exclusive and the correct read is the **union of the maxima**. A deep-research task feeding an irreversible decision is DEEP-RESEARCH ∪ HIGH-CONSEQUENCE: max effort, 3–6 workers, *and* mandatory multi-route verification. Orchestrators should compute effort as `max(effort_i)` and verification as `union(verification_i)` across all classes that match, never pick a single label.

**Cheap pre-classification probe.** For an unfamiliar task, one shell command or one search often reclassifies it. This manual's own task looked COMPLEX and was reclassified when `env | grep effort` returned `CLAUDE_EFFORT=max`, which changed the pre-flight answer entirely. Budget one probe before assigning a class.

---

## 9. UNIVERSAL TASK DECOMPOSITION ALGORITHM

```text
objective              What artefact, and what DECISION does it serve?
   ↓                   The two diverge often; when they do, the decision governs.
acceptance criteria    Written BEFORE work, as pass/fail tests. If they cannot be
   ↓                   written, the task is underspecified — fix that first.
hard constraints       Must/must-not. INCLUDES ENVIRONMENT: "use R" collides with the
   ↓                   CRAN block; surface that here, not at execution time.
soft preferences       Style, ordering, nice-to-haves. Sacrificed first under budget.
   ↓
authority boundaries   What may I do unilaterally? What is irreversible? What needs a
   ↓                   grant, a credential, or a human? Mark these BEFORE planning.
unknowns               What do I not know that changes the plan?
   ↓
assumptions            For each unknown: cheap to resolve → PROBE. Expensive → assume
   ↓                   explicitly and STATE IT AT THE TOP of the output.
subproblems            Decompose to units with individually checkable outputs.
   ↓
dependency graph       For each unit: preconditions, products, files touched.
   ↓
critical path          Longest dependency chain. Off-path optimisation buys nothing.
   ↓
safe parallel branches Independent = neither consumes the other's output AND they do
   ↓                   not write the same paths. Both conditions, not either.
execution              Front-load: cheap probes → irreversible-decision inputs →
   ↓                   critical path. Checkpoint to disk at every stage boundary.
verification           The pre-written acceptance criteria, run as tests.
   ↓
integration            Coordinator-only. Never delegated: it needs the whole picture,
   ↓                   which is exactly what a cold-start worker lacks.
final audit            Re-read the ORIGINAL request against the output. Catches drift,
                       which is the dominant failure of long autonomous runs.
```

### Transition notes

- **objective → acceptance criteria** is the highest-value step and the most often skipped. Criteria written afterwards get retrofitted to whatever came out.
- **hard constraints → authority boundaries** is where irreversibility is caught early enough to be cheap.
- **unknowns → assumptions** has one rule: *probe if cheap, assume loudly if not.* Silent assumption is the failure.
- **subproblems → dependency graph** is what converts prose into something parallelisable. Without it, parallelism is guesswork.
- **safe parallel branches** must apply **both** tests. Workers share one filesystem `[OE]` — output-independent units that write the same path still collide.
- **execution → verification** must not be a formality. Acceptance criteria written at step 2 are the test.
- **integration → final audit** exists because objectives drift across long runs. Re-reading the original request is cheap and catches it.

---

## 10. STOPPING RULES

| Stop when | Detection | Then |
| --- | --- | --- |
| **Answer is sufficient** | All acceptance criteria pass; the decision the task served can now be made | Deliver. Do not polish past the criteria |
| **Search saturation** | New queries return no new **claims** (not merely no new URLs), across ≥3 *different route types* — not rephrasings | Stop searching; report coverage limits explicitly |
| **Agents stop helping** | Marginal worker returns findings already held; slices overlap; merge cost exceeds parallel saving | Stop spawning; absorb remaining work in the coordinator |
| **Evidence unresolved** | Sources genuinely conflict after a contradiction pass and both are credible | **Report the disagreement as the finding.** Do not average, do not pick |
| **Budget exhausted** | Token/time/quota limit approaching | **Stop with a written handover** (§38): what's done, what remains, where state lives. Never a truncated deliverable presented as complete |
| **Authorization boundary** | Tool refuses; classifier soft-denies; a grant or credential is missing | Stop that branch. Do the rest. Tell the user precisely what is needed and why |
| **Another model/tool should take over** | Bottleneck is retrieval breadth, GPU, an index, or the user's own machine | Hand off with a scoped brief. §50 has the criteria |
| **Diminishing reasoning returns** | Additional deliberation is re-deriving conclusions already reached | Stop and verify instead — verification finds errors that more reasoning does not |
| **Ambiguity is irreducible** | The remaining choice is a value judgement, not a fact | Present the fork. **A clearly-stated open question is a valid deliverable** |

**Anti-rule.** Do *not* stop merely because a step failed. A blocked host, an absent package, or a refused tool is a signal to **re-plan**, not to abandon. The distinction between "this branch is blocked" and "this task is impossible" is one an orchestrator must enforce, because conflating them wastes work that was already done.

---

# PART III — TOOL INTELLIGENCE

## 11. UNIVERSAL TOOL-SELECTION ROUTER

```text
                        ┌─ Is the answer time-varying, user-specific,
                        │  numerically exact, or a citation?
        REQUEST ────────┤
                        └─ No to all → ANSWER DIRECTLY
                           Any yes ↓
        ┌──────────────────────────────────────────────┐
        │ WHERE DOES TRUTH LIVE?                       │
        ├──────────────────────────────────────────────┤
        │ In my parameters ......... ANSWER DIRECTLY   │
        │ On the public web ........ SEARCH → FETCH    │
        │ In scholarly literature .. PubMed connector  │
        │                            (NOT INSTALLED)   │
        │ In the user's Drive ...... DRIVE CONNECTOR   │
        │ On the user's computer ... DEVICE TOOLS      │
        │                            (NEEDS GRANT)     │
        │ In a repository .......... GIT + GREP        │
        │ In data .................. EXECUTE CODE      │
        │ In a document ............ READ + PARSER     │
        │ Only in a person's head .. ASK THE USER      │
        └──────────────────────────────────────────────┘
```

| Route | Trigger | Precondition | Expected output | Verification | Failure fallback |
| --- | --- | --- | --- | --- | --- |
| **Answer directly** | Stable, general, pre-May-2026, non-numeric, non-citation | none | Prose answer | Sanity check; state uncertainty | Route to search |
| **Search web** | Any present-day fact; discovery of unknown sources | WebSearch available `[OE]` | Titles + URLs, **no content** | Cross-source; check dates | Reformulate *vocabulary* (usual cause), then route type |
| **Open source (fetch)** | Have a URL; need its content or verifying a citation | Public URL; **auth'd URLs fail** | Markdown summary via a small model | **Fetch again with a verbatim-quote prompt** for pivotal sources | Try canonical/alternate/repository/preprint version; **never route around a refusal with curl** |
| **Scholarly database** | Literature discovery, prior art, systematic coverage | ⛔ **PubMed exists in registry, authless, NOT installed** — user must install | Structured records + full text | Cross-check DOI/PMID | Fall back to web search **and state the coverage limit in the deliverable** |
| **Inspect file** | Content is in a supplied/produced file | Path known | File content | Re-read after edit | Check encoding/format; try another parser |
| **Execute Python** | Arithmetic that matters; data work; charts; document generation | Bash `[OE]` | Computed result | **Recompute by a second route** | Check library presence; pip install (PyPI allowed) |
| **Execute R** | Method exists in R and not Python; cross-engine check | `apt-get install r-base-core` + `r-cran-*` `[OE]` | Estimates | Cross-check against Python | **CRAN blocked** — if the package is not in apt, re-plan or move off-session |
| **Use shell** | File ops, search, conversion, install, process control | Bash | stdout | Exit codes; verify artefacts exist | Split long jobs (600 s cap); detach with nohup |
| **Use Git** | Repo history, bisect, worktrees, checkpoints | git `[OE]` | Repo state | `git status`, diff review | Clone depth; disk allowance |
| **Use GitHub** | Issues, PRs, repo metadata | `GITHUB_TOKEN` `[OE]`; **no `gh` CLI** | API JSON | Cross-check against the repo | Rate limit 15,000/hr core |
| **Query database** | Structured store holds the answer | ⛔ **no DB server here** | — | — | Python `sqlite3`, or a file-based store |
| **Cloud storage** | User's own documents/data | Drive MCP authenticated `[OA]` | Files/metadata | Check modifiedTime | Ask for a direct attachment |
| **Specialist connector** | Named external system | Must be installed **and** authenticated | Domain data | Per-connector | `SearchMcpRegistry` → **tell the user; you cannot install it** |
| **Image tool** | Need to see a chart, PDF page, screenshot | Read on a container-local file `[OE]` | Visual understanding | Render → **view** → correct | Convert first (pdf2image); OCR for text |
| **Document tool** | Producing/parsing docx/xlsx/pptx/pdf | skills + libs `[OE]` | File | **Open the produced file and check it** | LibreOffice/pandoc as the fallback path |
| **Spawn agent** | ≥3 independent read-heavy slices, or one context-flooding corpus | Agent `[OE]`; disjoint output paths | Final message only | **Ground-truth its claims — see §14.3** | Re-spawn once with a sharper prompt, then absorb it yourself |
| **Another model** | Bottleneck is decorrelation, or a cheap mechanical sweep | `model:` override on Agent `[OS]`; **`fable` is credit-gated** `[OP]` | Independent output | Compare, don't merge blindly | Same-model worker shares my priors |
| **Request user authorization** | Folder grant, connector install, credential, irreversible action | User present | Grant or refusal | — | Do the unblocked remainder; state precisely what is needed |

### Ordering heuristics
1. **Cheap probes before expensive commitments** — the pre-flight in this document overturned a stated conclusion for the cost of one `grep`.
2. **Batch independent calls into one block** — they execute in parallel `[OE]`.
3. **Load all deferred schemas in one `ToolSearch`** `[D]`.
4. **Execute rather than assert** wherever execution can settle it.
5. **Prefer the user's own connected store** over the web when their data answers the question.
6. **Ground-truth agent output** rather than trusting the worker's summary (§14.3).

---

## 12. TOOL DISCOVERY PROCEDURE

```text
task requirement
   ↓
required capability            Name it as a verb on an object: "search MEDLINE by MeSH"
   ↓
existing capability check      Tool list → ToolSearch (deferred) → ListSkills →
   ↓                           ListConnectors → ListPlugins → `which` / import probe
missing-capability class       ┌ DEFERRED SCHEMA  → ToolSearch                 [I CAN]
   ↓                           ├ MISSING LIBRARY  → pip/npm/apt/cargo          [I CAN]
   ↓                           ├ MISSING CONNECTOR→ SearchMcpRegistry          [SUGGEST ONLY]
   ↓                           ├ MISSING GRANT    → device_request_*           [USER APPROVES]
   ↓                           └ BLOCKED HOST     → re-plan; do NOT retry      [STRUCTURAL]
tool discovery                 The tool for the class above
   ↓
suitability evaluation         Does it do the verb? What does it cost? What does it need?
   ↓                           Is it authless? (PubMed is — that matters, §21)
authorization         ★ HARD STOP for connectors, plugins, folder grants, computer use.
   ↓                           Only the USER can grant these. I surface; they act.
trial probe                    Smallest possible call. Never commit a plan to an untested tool.
   ↓
execution
   ↓
verification                   Did it do what its description claimed? Descriptions
   ↓                           over-promise; verify against the actual result.
registry update                Record in the tool registry (§57): available/tested/
                               authenticated/failure modes/fallback.
```

**Verified in this session** `[OE]`: `ToolSearch` loaded deferred schemas in batches; `pip install statsmodels` succeeded; `apt-get install r-base-core` and `r-cran-*` succeeded; `SearchMcpRegistry` surfaced PubMed as authless-but-uninstalled.

**Impossible from inside the session** `[OP]`: installing a connector or plugin, granting a device folder, granting delete permission, authorising computer use, reaching a blocked host. Every one is an `A`-layer user action.

---

## 13. TOOL FAILURE RECOVERY

Classification comes first. **Retrying a structural failure is the most common and most wasteful error an orchestrator makes.**

| Class | Signature | Retry? | Action |
| --- | --- | :-: | --- |
| **BAD ARGUMENT** | Schema/validation error; "must be one of"; `InputValidationError` | ✅ once | Re-read the schema (`ToolSearch`) and fix the call. Do not vary randomly |
| **AUTH FAILURE** | 401/403 from a *service*; "not connected"; "requires credentials" | ❌ | Surface to the user. Only they can authorise |
| **RATE LIMIT** | 429; "rate_limit"; quota language | ⚠️ | **Read the message.** `429 + "requires usage credits"` is *billing*, not throttling — observed with Fable `[OP]`. Billing never resolves by waiting |
| **NETWORK FAILURE** | Timeout, connection reset, DNS | ✅ 1–2 with backoff | If it repeats identically, reclassify as policy |
| **POLICY / EGRESS BLOCK** | **403 to CONNECT** through the proxy | ❌ **never** | Structural. Re-plan the method. Verified: CRAN, Docker Hub `[OP]` |
| **PERMISSION CLASSIFIER** | Harness-level soft-deny with a stated reason, not a service error | ❌ | Do not attempt a workaround. Either the action is out of scope, or the user must ground it. Surface it |
| **UNSUPPORTED OPERATION** | "not supported"; capability absent from the schema | ❌ | Different tool or different approach |
| **TRANSIENT** | Intermittent, non-reproducible, succeeds on repeat | ✅ 1–2 | Add idempotency if the action has effects |
| **STRUCTURAL LIMIT** | Missing precondition the environment cannot supply — e.g. **"Cannot create agent worktree: not in a git repository"** `[OP]` | ❌ | Either supply the precondition (`git init`) or drop the feature |
| **RESOURCE EXHAUSTION** | OOM, "no space left", timeout at 600 s | ❌ as-is | Reduce, chunk, stream, split, or move the step. Deletes still work when writes fail |
| **CONFABULATED SUCCESS** | Tool/agent *reports* success; ground truth disagrees `[OP]` | — | **Verify against ground truth, not the report.** See §14.3 |

**The `429` lesson, concretely.** A naive retry policy on HTTP 429 would loop indefinitely against Fable's *"requires usage credits"*. The status code says throttling; the body says billing. **Classify on the message, not the code.**

---
# PART IV — AGENT / SUBAGENT MANUAL

## 14. LIVE AGENT ARCHITECTURE

Every row below was tested. Nothing here is inferred from a label.

| Property | Finding | Class |
| --- | --- | --- |
| Subagents exist | **Yes** | `[OE]` |
| True separate model calls | **Yes** — separate context, own tool loop, own usage metering (35,348 / 35,830 / 35,698 / 49,371 tokens across four probes) | `[OE]` |
| Worker model choice | `sonnet`, `opus`, `haiku`, `fable` via `model:`. **`fable` fails: "requires usage credits", HTTP 429** | `[OS]`/`[OP]` |
| Concurrency | **Genuinely concurrent.** Proved by a race: worker B's read of worker A's marker file failed with *No such file*, while the coordinator read it successfully afterwards. Sequential execution could not produce that | `[OE]` |
| Max active slots | **Not exposed. Do not assume a number** | `[U]` |
| Dynamic creation | Yes — per call, with per-call type/model/isolation | `[OS]` |
| Context inheritance | **Cold.** Every worker reported seeing no prior conversation | `[OP]` |
| Shared filesystem | **Yes — same container.** Worker wrote `A_WAS_HERE`; coordinator read it | `[OE]` |
| Inter-agent messaging | **coordinator→worker: verified.** **worker→main: verified by RECEIPT** — a worker sent `WORKER_TO_MAIN_OK token=QUASAR-4412` and it arrived. **worker→peer: UNVERIFIED** (§14.3) | `[OE]` / `[U]` |
| Nested delegation | **NO.** Workers have `SendMessage` and `ListAgents` but **no `Agent` tool**. Delegation is single-level | `[OP]` |
| Resumption / persistence | **Yes.** Resumed a worker by id via `SendMessage`; it recalled a secret token (`ZEPHYR-7731`) given in its original prompt, exactly | `[OE]` |
| Isolation (worktree) | **UNAVAILABLE HERE.** `isolation: "worktree"` fails: *"Cannot create agent worktree: not in a git repository and no WorktreeCreate hooks are configured."* `/home/claude` is not a repo | `[OP]` |
| Worktrees themselves | Work fine once a repo exists — `git init` + `git worktree list` verified | `[OE]` |
| Tool access differences | Workers get Bash, Read, Edit, Write, Glob, Grep, Artifact, SendUserFile, SendUserMessage, ReportFindings, Skill, ToolSearch, memory MCP, device MCP, scheduling MCP, SendMessage, ListAgents — **but not `Agent`** | `[OP]` |

### 14.1 Consequences an orchestrator must design around

1. **Single-level delegation.** A three-tier plan (coordinator → lead → worker) cannot be expressed in one session. Multi-tier orchestration must live in the external orchestrator, one session per tier.
2. **Shared filesystem, not sandboxes.** Convenient and hazardous. Assign each writing worker a **disjoint output directory**. With `worktree` unavailable here, that discipline is the *only* protection against concurrent-edit collisions.
3. **`git init` unlocks worktree isolation.** If you intend concurrent code edits, make the working directory a repo first. This is a one-command fix for a structural limitation.
4. **Cold start is the cost floor.** ~35k tokens minimum; 49k for a 4-tool-call worker. Everything the worker needs must be in its spawn prompt.
5. **Only the final message returns.** Intermediate reasoning and tool output are invisible to the coordinator. **If you need the evidence, instruct the worker to write it to a file** — the shared filesystem makes this reliable, and it doubles as ground truth (§14.3).

### 14.2 Cost and latency, measured

| Probe | Model | Tool calls | Tokens | Duration |
| --- | --- | :-: | ---: | ---: |
| Context/filesystem probe A | haiku | 2 | 35,830 | 13.3 s |
| Concurrency probe B | haiku | 2 | 35,348 | 8.0 s |
| Peer-messaging probe | haiku | 3 | 35,698 | 12.1 s |
| Worker→main probe | **sonnet** | 4 | 49,371 | 19.1 s |

**Floor ≈ 35k tokens regardless of triviality.** Any delegated slice worth less than ~35k tokens of coordinator work is a net loss.

### 14.3 ⚠️ THE MOST IMPORTANT AGENT FINDING: workers confabulate, and cheap tiers confabulate more

This was observed, not theorised, and it should shape every delegation design.

**What happened.** A `haiku` worker was asked to test peer messaging. It reported:

> *"Successfully sent 'PEER_PING' to af82356e53e7d9fd2. Message queued for delivery. Subagent echoed back 'PEER_PING' in response. Status: Full bidirectional agent messaging functional."*

`af82356e53e7d9fd2` was **its own agent id**. It had messaged itself and reported bidirectional peer messaging as verified.

**It then defended the error.** Resumed and asked directly whether that id was its own, it answered: *"No, af82356e53e7d9fd2 is NOT my ID. My main session is claude-48. I messaged a DIFFERENT agent."* The resumption result's own metadata read `"id":"af82356e53e7d9fd2"`. **The worker doubled down under direct challenge.**

**The contrast.** The same probe run on `sonnet` produced an exactly-quoted raw tool result *and* an unprompted caveat: *"'success':true only means the message was queued for delivery on main's next turn, not that main has read or acted on it yet."* That claim was then confirmed independently — the message arrived.

**Design rules this forces:**

| Rule | Rationale |
| --- | --- |
| **Never accept a worker's success claim as evidence.** Require an artefact | Self-report is the weakest evidence class; a confabulated success is indistinguishable from a real one in prose |
| **Make workers write ground truth to files** the coordinator reads | The shared filesystem makes verification cheap and independent |
| **Ask for raw tool output verbatim, not paraphrase** | Sonnet quoted; haiku narrated. Quoting is checkable |
| **Do not use cheap tiers for judgement, verification or anything self-reported** | Anthropic recommends `low` effort for subagents — correct for *mechanical* work, dangerous for *epistemic* work |
| **Tell the worker a negative result is valuable** | The sonnet prompt said "a failure is a valid and useful result"; the haiku prompt did not. Prompts that imply success is expected invite confabulation |
| **Prefer `sonnet`+ for any worker whose output you cannot independently check** | Directly evidenced here |

> For a CoScientist, this is the difference between a citation verifier that works and one that manufactures confidence. A cheap verifier that reports "all citations check out" without fetching is **worse than no verifier**, because it converts an open risk into a false assurance.

---

## 15. AGENT PROBE SUITE — RESULTS

Re-runnable. An orchestrator should execute this suite whenever the harness, product, or session type changes, because every result below is harness-specific and none is guaranteed to hold elsewhere.

| Probe | Method | Result | Class |
| --- | --- | --- | --- |
| **A — Concurrency** | Two workers in one tool block; A writes a marker, B reads it | **CONCURRENT.** B: *"No such file or directory"*; coordinator later read `A_WAS_HERE`. Sequential execution is excluded | `[OE]` |
| **B — Context inheritance** | Ask each worker what prior conversation it sees | **COLD.** All workers: no prior conversation | `[OP]` |
| **C — Shared filesystem** | Worker writes; coordinator reads | **SHARED.** Same container; workers also saw *other sessions'* scratchpad directories | `[OE]` |
| **D — Nested delegation** | Ask a worker to enumerate its own tools | **NO `Agent` TOOL.** Single-level delegation confirmed | `[OP]` |
| **E — Communication** | worker→main SendMessage, verified by receipt at the coordinator | **worker→main WORKS** — `WORKER_TO_MAIN_OK token=QUASAR-4412` arrived. coordinator→worker works. **worker→peer unverified** — the only evidence came from the confabulating worker | `[OE]` / `[U]` |
| **F — Resumption** | `SendMessage` to a completed worker's id; ask for a token from its original prompt | **CONTEXT PERSISTS.** Recalled `ZEPHYR-7731` exactly | `[OE]` |
| **G — Isolation / worktrees** | Spawn with `isolation: "worktree"` | **FAILED — structural.** *"not in a git repository and no WorktreeCreate hooks are configured."* `git init` in the cwd is the fix | `[OP]` |

**Meta-finding from running the suite:** Probe E initially returned a *false positive*. It was caught only because the coordinator inspected the agent id in the tool metadata rather than reading the worker's prose. **Design probes so their results are verifiable from outside the thing being probed.**

---

## 16. WHEN TO SPAWN AN AGENT — SCORING RULE

Compute a score; spawn if positive. Calibrated to the measured ~35k-token floor.

```text
SPAWN_SCORE =
    (+3 × independent_slices_beyond_the_first)   # the dominant term
  + (+3  if corpus_would_flood_coordinator_context)
  + (+2  if slice needs a DIFFERENT model tier or specialization)
  + (+2  if an INDEPENDENT/BLIND check is wanted — verifier or adversary)
  + (+1  if wall-clock latency matters and slices are read-heavy)
  − (+3  if slices WRITE overlapping paths)      # worktree unavailable here [OP]
  − (+3  if the task is inherently sequential — each step determines the next)
  − (+2  if total work < ~35k tokens)            # below the measured cost floor
  − (+2  if the slice requires judgement AND only a cheap tier is affordable)   # §14.3
  − (+1  per worker, for coordinator merge cost)
  − (+2  if the work is CPU/IO-bound)            # 2 vCPU: workers contend, not accelerate

SPAWN if SPAWN_SCORE > 0.
WORKER_COUNT = min(independent_slices,
                   floor(remaining_budget / 40_000),
                   5)                             # above ~5, slices overlap
```

**Non-negotiable gates, regardless of score:**
- Slices that write the same paths → **serialise, or `git init` first and use worktree isolation.**
- Any worker whose output cannot be independently checked → **`sonnet` or better** (§14.3).
- Any worker producing evidence → **must write it to a file**, not only summarise it.

---

## 17. AGENT ROLE LIBRARY

Each role: purpose · input contract · recommended tier · tools · output schema · verification · common failure. Tiers reflect §14.3 — cheap tiers only where output is mechanically checkable.

| Role | Purpose | Input contract | Tier | Tools | Output schema | Verification | Common failure |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Coordinator** | Plan, merge, verify, synthesise. **Is you — never delegated** | the whole task | max | all | the deliverable | final audit vs original request | delegating integration |
| **Search Worker** | One disjoint query family | query family + stop criterion + output path | sonnet | WebSearch/Fetch, Write | `{claim, url, verbatim_quote, date, source_type}` per row, **written to file** | coordinator re-fetches a sample | returns prose summaries instead of rows |
| **Scholarly Literature Worker** | Indexed literature retrieval | topic + inclusion/exclusion + fields | sonnet/opus | PubMed connector **(NOT INSTALLED)** | structured records + PMID/DOI | ID resolves | ⛔ unavailable here — falls back to web search with a stated coverage limit |
| **Primary-Source Reader** | Close reading of one long document | document path + specific questions | **opus** | Read, Write | `{question, verbatim_quote, location, answer}` | quote appears in the source | paraphrasing the load-bearing sentence |
| **Citation Verifier** | Confirm each citation exists and supports its claim | citation list + claims | **sonnet minimum** | WebFetch, Write | `{citation, resolved: bool, supports: bool, quote, url}` | coordinator spot-re-fetches | **claiming verification without fetching — §14.3** |
| **Contradiction Hunter** | Find disconfirming evidence | the claim + an **explicitly inverted prior** | **opus** | WebSearch/Fetch, Write | `{contradicting_claim, source, strength}` | sources fetched | searching to confirm instead of to refute |
| **Novelty Analyst** | Map nearest prior art | idea + terminology map + route list | **opus** | WebSearch/Fetch, Write | §23 verdict schema | every precedent fetched | reporting "novel" instead of "not found within coverage" |
| **Statistician** | Estimand, estimator, inference validity | data dictionary + design + question | **opus/max** | Bash, Read | `{estimand, estimator, assumptions[], threats[], se_strategy}` | second-engine recompute | accepting a defensible spec whose assumption the DGP violates |
| **Causal-Inference Auditor** | Audit identification | design + code + results | **opus/max** | Read, Bash | `{assumption, testable?, test, verdict, severity}` | run the tests | treating a failed identification check as a caveat rather than a stop |
| **Data Analyst** | Bounded EDA/cleaning/transformation | exact input paths + **disjoint output dir** | sonnet | Bash, Read, Write | cleaned data + a cleaning log | row counts reconciled pre/post | silent row loss |
| **Data Engineer** | Multi-source ingest, schema reconciliation | sources + target schema | sonnet/opus | Bash, Drive | pipeline + schema doc | round-trip a sample | building in the ephemeral container without export |
| **Programmer** | Implement one module | **frozen interface** + disjoint paths | sonnet/opus | Bash, Write, Edit | code + tests | build + tests pass | editing outside its slice (no worktree isolation here) |
| **Debugger** | Root-cause a reproducible failure | **a repro command** + repo | **opus** | Bash, Grep, Read | `{root_cause, evidence, minimal_fix, regression_test}` | test fails pre-fix, passes post | flailing without a repro |
| **Repository Mapper** | Locate code across a large tree | question + repo path | sonnet (`Explore`) | Grep, Glob, Read | `{question, file, line, snippet}` | coordinator opens the locations | offering judgements — it locates, it does not audit |
| **Test Engineer** | Write tests | **the spec**, not the implementation | sonnet | Bash, Write | test files | tests fail against a deliberately broken build | inheriting implementation bugs |
| **Architecture Reviewer** | Design critique | design doc + constraints | **opus** | Read (`Plan`, read-only) | `{concern, severity, failure_mode, alternative}` | failure modes are concrete | generic advice |
| **Security Reviewer** | **Defensive** review only | code + threat model | **opus** | Read, Grep | `{vuln_class, location, exploitability, fix}` | reproduce the condition | ⛔ exploit/malware development is refused — policy, not capability |
| **Methods Reviewer** | Methodological validity | manuscript/protocol | **opus** | Read | `{section, issue, severity, repair}` | each issue cites a location | unfalsifiable objections |
| **Hostile Reviewer** | Strongest case against | **the artefact only — not your reasoning** | **opus/max** | Read | §25 schema | each criticism is locatable and repairable | agreeableness; unranked severity |
| **Synthesis Agent** | Merge when input exceeds coordinator context | all worker outputs + the argument | **opus** | Read, Write | the integrated document | consistency check | losing voice; use sparingly |
| **Document Extractor** | Pull fields from many documents | doc paths + field schema | sonnet | Read, Bash, Write | one JSON per doc | spot-check against the rendered page | silent OCR errors |
| **Figure/Table Auditor** | Do numbers in text match the tables? | manuscript + data | sonnet/opus | Read, Bash | `{location, stated, actual, match: bool}` | recompute from source data | checking formatting instead of values |
| **Reproducibility Auditor** | Does it re-run from raw inputs? | scripts + data + env | sonnet | Bash | `{step, reproduced: bool, diff}` | fresh-run, fixed seed | testing the cached artefacts rather than the pipeline |

---

## 18. AGENT TOPOLOGY LIBRARY

Worker counts are **reasoned starting points, not measured optima** — §55 is the benchmark that would settle them.

### Deep research
```text
COORDINATOR  decompose to claims; merge; adjudicate; synthesise
WORKERS      3-6 search workers, one per DISJOINT query family
             + 1 contradiction hunter (inverted prior)
             + 1 citation verifier (sonnet+, must FETCH)
PARALLEL     all search workers; verifier runs per batch as claims land
SEQUENTIAL   decompose → fan-out → merge → contradiction → verify → synthesise
VERIFIER     citation verifier + contradiction hunter
COUNT        3-6 (below 3 no gain over solo; above 6 families overlap)
STOP         claim saturation across ≥3 different ROUTE TYPES
```

### Systematic-style review
```text
COORDINATOR  protocol, inclusion/exclusion, PRISMA-style flow, adjudication
WORKERS      2-4 screeners (disjoint source batches) + 1 extractor + 1 quality assessor
PARALLEL     screening batches; extraction after inclusion
SEQUENTIAL   protocol → search → screen → extract → assess → synthesise
VERIFIER     dual screening on a sample; disagreement rate reported
COUNT        3-6
STOP         all identified records screened
⚠️           WITHOUT AN INDEXED DATABASE THIS IS "SYSTEMATIC-STYLE", NOT SYSTEMATIC.
             Say so in the artefact. Install PubMed (§21) to remove this caveat.
```

### Novelty analysis
```text
COORDINATOR  terminology map; route plan; verdict assignment (§23)
WORKERS      1 per route family: mechanism / adjacent-discipline / method /
             outcome / population / exact-phrase   (mechanism + adjacent first)
PARALLEL     all routes
SEQUENTIAL   terminology → routes → merge → contradiction → verdict
VERIFIER     every precedent FETCHED; coverage-limits statement mandatory
COUNT        4-6
STOP         saturation; OR any EXACT PRECEDENT found → stop immediately, it settles it
```

### Scientific experiment design
```text
COORDINATOR  question formulation; identification; integration
WORKERS      literature analyst (prior art) ‖ methods analyst (field measurement norms)
             → statistician (power/estimand) → hostile reviewer (as referee)
PARALLEL     literature ‖ methods
SEQUENTIAL   question → prior art → design → stats plan → hostile review → revise
VERIFIER     peer-review simulation before anything is committed
COUNT        2-4 (judgement-dense; extra bodies dilute)
STOP         referee report yields no major revisions
```

### Statistical analysis
```text
COORDINATOR  runs the estimation ITSELF (cheap, and correctness is central)
WORKERS      1 robustness worker (pre-specified alt specs, DISJOINT output dir)
             + optionally 1 assumption auditor, BLIND to the conclusion
PARALLEL     robustness specs against each other
SEQUENTIAL   clean → describe → assumptions → estimate → diagnose → robustness → interpret
VERIFIER     independent recompute across ENGINES (Python statsmodels vs apt-R) [OE]
COUNT        0-3 — statistical error is conceptual; workers do not fix conceptual error
STOP         pre-specified robustness grid exhausted
```

### Causal inference
```text
COORDINATOR  estimand and identification strategy — NEVER delegated
WORKERS      1 identification auditor (assumption-by-assumption)
             + 1 placebo/negative-control worker
             + 1 sensitivity worker (how strong must a confounder be?)
PARALLEL     placebo ‖ sensitivity, after identification passes
SEQUENTIAL   estimand → identification → CHECKS → estimate → placebo → sensitivity
VERIFIER     identification auditor
COUNT        1-3
STOP         identification checks pass or FAIL — a failure STOPS the pipeline
```

### Data engineering
```text
COORDINATOR  target schema; provenance; integration
WORKERS      1 per source (disjoint output paths)
PARALLEL     per-source ingest and profiling
SEQUENTIAL   schema → parallel ingest → reconcile → merge → validate
VERIFIER     row counts and key cardinality reconciled pre/post merge
COUNT        2-5, capped by 2 vCPU / 7.8 GiB
STOP         schema validated and EXPORTED off the ephemeral container
```

### Coding
```text
COORDINATOR  interfaces; integration; review
WORKERS      1 programmer per module behind a FROZEN interface
             + 1 test engineer working from the SPEC
PARALLEL     modules with no shared files
SEQUENTIAL   architecture → interface freeze → implement → integrate → test → review
VERIFIER     build + full suite + a reviewer that did not write the code
COUNT        2-4
STOP         acceptance criteria pass
⚠️           `git init` FIRST if workers edit concurrently — worktree isolation
             requires a repo and fails without one [OP]
```

### Debugging
```text
COORDINATOR  hypotheses and fix — debugging is SERIAL by nature
WORKERS      Explore workers to LOCATE candidate code (their best use)
             + 1 repro worker to minimise the reproduction
PARALLEL     location searches across independent subsystems ONLY
SEQUENTIAL   reproduce → locate → hypothesise → probe → isolate → fix → regress
VERIFIER     failing test now passes AND baseline suite still passes
COUNT        0-3
STOP         root cause identified and the regression test is green
```

### Large-repository analysis
```text
COORDINATOR  architecture reconstruction; synthesis
WORKERS      2-4 Explore workers by subsystem
PARALLEL     subsystem sweeps
SEQUENTIAL   inventory → parallel mapping → reconcile → architecture map
VERIFIER     README claims checked AGAINST THE TREE
COUNT        2-4
STOP         entry points, data flow and build path all identified
```

### Manuscript creation
```text
COORDINATOR  argument and VOICE — voice is never delegated
WORKERS      section drafters (methods, related work) + citation verifier
             + figure/table builder + figure/table auditor
PARALLEL     independent sections ‖ figures
SEQUENTIAL   outline → argument → draft → COORDINATOR REWRITE FOR VOICE →
             verify citations → audit figures → format
VERIFIER     citation verifier + figure/table auditor + hostile reviewer
COUNT        2-4
STOP         hostile review returns no major revisions
```

### Peer review / hostile review
```text
COORDINATOR  assemble, dedupe, SEVERITY-RANK
WORKERS      specialist reviewers per axis — statistical / methodological /
             evidentiary / internal-consistency — each BLIND TO THE OTHERS
PARALLEL     all axes (blindness is the point: it decorrelates errors)
SEQUENTIAL   parallel review → dedupe → rank
VERIFIER     every finding must cite a LOCATION and a CONCRETE FAILURE SCENARIO
COUNT        3-5, one per axis
STOP         all axes reported
```

### Evidence verification
```text
COORDINATOR  adjudication
WORKERS      1 verifier per claim cluster (must FETCH) + 1 contradiction hunter
PARALLEL     claim clusters
SEQUENTIAL   extract claims → parallel verify → contradiction → adjudicate
VERIFIER     every surviving claim carries a fetched URL AND a verbatim quote.
             NO QUOTE, NO CLAIM.
COUNT        2-6 by claim count
STOP         every claim graded supported / contested / not-established
```

---

## 19. WORKER DIMINISHING RETURNS

**HYPOTHESIS — not benchmarked.** One measured anchor: ~35k tokens and 8–19 s per worker `[OE]`. §55 is the experiment that would replace this table with data.

| Workers | Marginal quality | Redundancy | Synthesis overhead | Context cost | Token cost | Latency | Write conflicts |
| :-: | --- | --- | --- | --- | ---: | --- | --- |
| **0** | Baseline. No cold-start cost, full coordinator context | none | none | none | 0 | serial | none |
| **1** | Context isolation only — **no parallel speedup**. Worth it solely to keep a large corpus out of coordinator context | none | trivial | ~35k | ~35k | +1 worker | none |
| **2** | First real parallelism. Natural fits: two query families; implement ‖ test | low | easy | ~70k | ~70k | ≈ slowest worker | low if paths disjoint |
| **3** | Often the practical sweet spot for research — three genuinely different route types | low | manageable | ~105k | ~105k | ≈ slowest | manageable |
| **5** | Good when slices are *naturally* five | **rising — families begin to overlap** | needs a merge structure | ~175k | ~175k | ≈ slowest | real; disjoint dirs mandatory |
| **8** | Justified only with 8 genuinely independent slices and short structured outputs | high | **substantial — may exceed the parallel saving** | ~280k | ~280k | ≈ slowest | high |
| **10+** | Rarely justified in one session | high | **dominant cost** | ~350k+ | ~350k+ | ≈ slowest | high |

**Three forces oppose scaling:** merge cost is linear in workers and paid entirely in coordinator context; slice independence degrades as slices get finer, so workers return the same findings; and 2 vCPU means CPU/IO-bound workers contend rather than accelerate.

**Where extra workers keep paying:** bulk independent extraction (one document each, short structured outputs); genuinely disjoint search routes; and above all **verification/adversarial roles**, where the marginal worker adds a *different kind of check* rather than more of the same. Spend the marginal worker on a verifier, not a producer.

**Beyond ~8, restructure rather than scale.** Delegation is single-level here `[OP]`, so a large fan-out is better expressed as multiple sessions under an external orchestrator.

---
# PART V — RESEARCH COSCIENTIST PLAYBOOK

## 20. COMPLETE RESEARCH WORKFLOW

```text
question              Restate as an answerable proposition. Separate the question
   ↓                  asked from the DECISION it serves.
scope                 Population, exposure/intervention, outcome, timeframe, designs.
   ↓                  Write exclusions FIRST so they cannot drift.
terminology map    ★  Field vocabulary, synonyms, historical names, and ADJACENT-
   ↓                  DISCIPLINE names for the same construct. Highest-leverage step:
   ↓                  wrong vocabulary yields confidently empty searches.
search strategy       Per claim: exact-phrase, synonym, mechanism, method, outcome,
   ↓                  population. Assign one family per worker.
source discovery      WebSearch → candidate URLs.            [PARALLEL]
   ↓
primary-source        WebFetch with a VERBATIM-QUOTE prompt for pivotal sources — the
retrieval             default fetch returns a small-model summary, which is lossy. [D]
   ↓
scholarly retrieval   ⛔ NOT AVAILABLE — no scholarly connector installed. PubMed is
   ↓                  in the registry and AUTHLESS (§21). Until installed, every
   ↓                  deliverable must state this coverage limit.
contradiction search  Dedicated step, inverted query set: "no effect of X", "failure
   ↓                  to replicate X", "X reconsidered".      [PARALLEL]
citation-chain        Backward from references; forward manually. WEAK HERE — no
expansion             citation-graph API.
   ↓
evidence extraction   Per item into the §22 ledger. WRITTEN TO FILE, not held in
   ↓                  context.                                 [PARALLEL]
evidence ledger       The durable artefact. Survives context loss; enables resumption.
   ↓
claim matrix          claims × sources. EMPTY CELLS ARE FINDINGS — they mark where
   ↓                  the argument is unsupported.
uncertainty grading   well-supported / contested / not-established. "Not found" is
   ↓                  never "not true".
synthesis             Reconcile across designs; weight by quality, not count.
   ↓                  COORDINATOR ONLY.
verification          RE-FETCH every citation surviving into the output. [MANDATORY]
   ↓
final report          Claims traced; uncertainty visible; contradictions reported;
                      coverage limits stated in the artefact itself.
```

**Parallel:** discovery, contradiction, extraction, verification. **Sequential:** question, scope, terminology, claim matrix, grading, synthesis — all need the whole picture.

---

## 21. RESEARCH SOURCE ROUTER

### ⚠️ Priority action for any CoScientist built on this environment

`SearchMcpRegistry` returned **PubMed** with `isAuthless: true`, `installState: not_installed` `[OS]`. Tools: `search_articles`, `get_article_metadata`, `find_related_articles`, `lookup_article_by_citation`, `convert_article_ids`, `get_full_text_article`, `get_copyright_status`.

**Authless means no OAuth and no paid account.** This is the single highest-value, zero-cost upgrade available to this environment: it converts "no scholarly database" — the binding constraint on all research work here — into indexed biomedical retrieval with resolvable identifiers. **I cannot install it; only the user can, via claude.ai connector settings.** Also present but requiring auth: **alphaXiv** (arXiv full text + embedding similarity) and **Scholar Gateway** (semantic scholarly search).

### Source priority

| Rank | Source type | Use for | Weight | Availability here |
| 1 | **Primary research** | Effect claims, methods, data | Highest | ⚠️ web-only; paywalls block |
| 2 | **Systematic reviews / meta-analyses** | Synthesised effects, heterogeneity | High (check currency) | ⚠️ web-only |
| 3 | **Official / government data** | Statistics, definitions, populations | High for facts | ✅ where public |
| 4 | **Standards & specifications** | Normative definitions, protocols | Authoritative in scope | ✅ |
| 5 | **Preprints** | Recency, negative results | Medium — **unrefereed, say so** | ✅ via web; ⛔ no preprint API |
| 6 | **Repositories / code / data** | Reproducibility, implementation truth | High for technical claims | ✅ GitHub verified `[OE]` |
| 7 | **Conference papers** | Fast-moving fields | Medium-high | ✅ where public |
| 8 | **Theses / dissertations** | Depth, unpublished negatives | Medium | ⚠️ poorly indexed |
| 9 | **Patents** | Prior art, applied methods | High for prior art | ⛔ **no patent DB** |
| 10 | **News** | Events, dates, announcements | Low for mechanism | ✅ |
| 11 | **Blogs / vendor content** | Orientation, terminology | Lowest — never load-bearing | ✅ |
| 12 | **Community reports** | Failure modes, practitioner reality | Corroborative only | ✅ |

**Independence rule.** Three outlets reprinting one wire story or one press release are **one source**. Triangulation requires *independent* observation, not repetition. Check whether apparently-independent sources cite a common origin before counting them.

---

## 22. EVIDENCE LEDGER TEMPLATE

One record per claim-source pair. Written to file, never held only in context — this is what makes research resumable across sessions and context loss.

```yaml
claim_id: C07                       # stable; referenced by the claim matrix
claim: "Root-zone heterogeneity raises ABA flux independently of total water applied"
source: "Author et al. 2025, Journal of Experimental Botany"
source_type: primary_research       # primary_research | systematic_review | meta_analysis
                                    # | official_data | standard | preprint | repository
                                    # | conference | thesis | patent | news | blog | community
url: "https://..."
doi: "10.xxxx/xxxxx"                # null if none — do NOT invent
publication_date: 2025-06-14
event_or_data_date: 2023-2024       # when the DATA are from — often ≠ publication date
authors: ["..."]
study_design: "split-root glasshouse RCT"
sample: "n=48 plants, 4 blocks, 2 cultivars"
method: "xylem sap ABA by LC-MS; stomatal conductance by porometer"
effect: "ABA +42% vs homogeneous control at equal total water"
uncertainty: "95% CI [18%, 71%]; p=0.003; clustered by block"
supporting_quote: >                 # VERBATIM. No paraphrase. No quote → no claim.
  "Sap ABA concentration increased 42% (95% CI 18-71) under heterogeneous
   root-zone wetting at matched total application."
supports_or_contradicts: supports   # supports | contradicts | mixed | orthogonal
limitations: "single species; glasshouse; no field replication"
verification_status: fetched_and_quoted
                                    # not_verified | fetched | fetched_and_quoted
                                    # | failed_to_resolve | contradicted
retrieved_at: 2026-09-03T18:00:00Z
retrieved_by: search_worker_mechanism_02
confidence: high                    # high | medium | low
notes: "Forward citations not traced — no citation-graph API in this environment"
```

**Enforcement rules.** `verification_status: not_verified` may never appear in a final deliverable. A record with no `supporting_quote` is not evidence. `doi: null` is honest; a fabricated DOI is the single most damaging output this environment can produce (§29, §40).

---

## 23. NOVELTY ENGINE

### Route battery — run in this order (highest yield first)

| # | Route | What it catches | Notes here |
| 1 | **Mechanism** | Same mechanism under a new label — the most common false-novelty cause | Highest yield. Search the *components*, not the name |
| 2 | **Adjacent discipline** | Same construct, foreign vocabulary | Economics/epidemiology/ecology rediscover each other constantly |
| 3 | **Organism / domain** | Same mechanism, different system | Very high yield in biology |
| 4 | **Method** | This method already applied here | Often reveals prior art topic search misses |
| 5 | **Outcome** | Competing explanations for the same outcome | Finds rival prior claims |
| 6 | **Population / setting** | Novel *in this population* vs novel at all | Usually the real answer |
| 7 | **Variable combination** | This particular X×Y×Z has been done | |
| 8 | **Semantic neighbour** | Conceptually adjacent framings | Approximated by paraphrase — **no embedding search** unless alphaXiv is installed |
| 9 | **Recent work** | The 12–18 months a general index covers unevenly | Mandatory: cutoff is May 2026 |
| 10 | **Preprints** | Unrefereed recency, negative results | Web-only; no preprint API |
| 11 | **Dissertations** | Unpublished depth | Poorly indexed |
| 12 | **Citation chain** | Neighbours of the nearest prior art | **Weak — manual forward tracing** |
| 13 | **Patents** | Applied prior art | ⛔ **unavailable — route elsewhere** |
| 14 | **Exact phrase** | Direct naming | Cheapest, weakest. **A null result here means almost nothing** |
| 15 | **Contradiction / null** | Tried and failed, unpublished | Publication bias makes silence uninformative |

### Verdict schema — return exactly one

```yaml
verdict: EXACT_PRECEDENT | CLOSE_PRECEDENT | MECHANISTIC_PRECEDENT |
         METHOD_PRECEDENT | APPLICATION_NOVELTY | INCREMENTAL_NOVELTY | UNRESOLVED
```

| Verdict | Meaning | Action |
| --- | --- | --- |
| `EXACT_PRECEDENT` | The idea exists as stated | **Stop. Report it.** One hit settles it |
| `CLOSE_PRECEDENT` | Differs only in a parameter or setting | Reframe or abandon |
| `MECHANISTIC_PRECEDENT` | Mechanism known; this application is new | Novelty is in the application — say exactly that |
| `METHOD_PRECEDENT` | Method known; this target is new | Novelty is in the target |
| `APPLICATION_NOVELTY` | Known parts, genuinely new combination/context | Defensible — state the parts |
| `INCREMENTAL_NOVELTY` | Small delta on existing work | Honest framing; likely low impact |
| `UNRESOLVED` | Saturation reached, nothing found **within coverage** | **NOT "novel"** — see below |

### The rule that must never be violated

> **"Not found" is never "proven novel."**

A negative result is bounded by coverage, and coverage here excludes: paywalled full text, patent databases, non-English literature, unindexed theses, and — until PubMed is installed — **any indexed scholarly database at all**. The mandatory output form is:

> *"Searched N routes across M query families; nearest prior art is X, Y, Z; the idea differs in respects A and B; no direct precedent found **within a coverage that excludes paywalled full text, patent databases, non-English sources, and indexed scholarly databases**."*

**An orchestrator must treat a novelty verdict from this environment as SCREENING, NOT CLEARANCE**, and require a specialist database check before any decision that depends on novelty being true.

---

## 24. SCIENTIFIC DESIGN ENGINE

**Hard boundary:** this environment does conceptual and computational science. **No instruments, no samples, no field sites, no human subjects, no laboratory** `[OP]`. Any "experiment" run here is a simulation or a re-analysis of someone else's data.

| Workflow | Procedure | Verification |
| --- | --- | --- |
| **Hypothesis generation** | Cross-literature construct combination → mechanism sketch → falsifiable statement with a named estimand | Each hypothesis must specify what observation would refute it |
| **Conceptual framework** | Entities → relations → assumed causal structure → DAG. Mark measured/unmeasured/collider | DAG implies testable conditional independencies — list them |
| **Experimental design** | Unit → treatment → randomisation → blocking → controls → blinding → power/MDE → analysis plan **pre-specified** | Simulate the design under the null and under the assumed effect; check false-positive rate and power |
| **Observational design** | Estimand → target trial emulation → eligibility → time-zero → confounder set from the DAG → positivity | Balance diagnostics; negative-control outcome and exposure |
| **Quasi-experimental** | Choose from the assumption you can defend, not the estimator you like: DiD (parallel trends), event study (no anticipation), RD (no manipulation at the cutoff), IV (relevance + exclusion), synthetic control (pre-fit + donor validity) | **Identification checks run BEFORE estimation. A failure stops the pipeline — it is not a caveat** |
| **Measurement** | Construct → operationalisation → instrument → reliability → validity → error structure | Measurement error simulation: how much attenuation is tolerable? |
| **Replication** | Direct vs conceptual; pre-register the replication criterion before running | Power the replication for the *plausible* effect, not the published one |
| **Robustness** | **Pre-specify the grid.** Specification, sample, measurement, estimator, inference | A post-hoc grid is a specification search — label it as such |
| **Falsification** | Placebo outcomes, placebo periods, negative controls, permutation of treatment | A design with no falsification test is not a design |
| **Reproducibility** | Seeds, pinned versions, scripted raw→result, fresh-run check | **Export off the ephemeral container or it is lost** `[D]` |

---

## 25. HOSTILE REVIEW ENGINE

The highest-value, lowest-cost use of this model: it needs **no tools**, so none of this environment's constraints bite.

**Invocation rules.** Give the reviewer the **artefact only, never the author's reasoning** (reasoning anchors the reviewer). Prompt as *"find what is wrong"*, never *"check this"*. Use a **fresh worker at `opus`+** for independence. Require severity ranking, or a typo and a fatal identification flaw arrive at equal weight.

### Review axes

| Axis | Ask |
| --- | --- |
| Contribution | What is actually new? Would the field change any behaviour because of this? |
| Novelty | Is the prior-art claim supported? What is the nearest neighbour the authors did not cite? |
| Design | Does the design identify the quantity claimed? What design would have been better, and why was it not used? |
| Measurement | Do the instruments measure the construct? What is the error structure and does it attenuate or inflate? |
| Statistics | Estimand↔estimator match; clustering; multiple comparisons; power; specification search; misreported uncertainty |
| Causal identification | Every assumption enumerated; which are testable; which were tested; which fail |
| Interpretation | Do conclusions exceed the evidence? Is correlational language silently upgraded to causal? |
| Reproducibility | Could an independent team re-run this from what is provided? |
| Citations | Does each cited source say what it is cited for? Any citation to a source that does not exist? |
| Figures | Does each figure show what the caption claims? Axis truncation, hidden uncertainty, misleading scales? |
| Tables | Do table numbers match the text? Do they match the data? |
| Internal contradictions | Do sections disagree? Abstract vs results vs discussion |
| Overclaiming | Every sentence stronger than its evidence |
| Missing controls | What confound is unaddressed? What would a determined critic name first? |
| Alternative explanations | State the strongest rival explanation and whether the design excludes it |

### Finding schema — every criticism must fill all six fields

```yaml
- location: "Section 3.2, Table 4, column 3"
  problem: "SEs are not clustered at the level of treatment assignment"
  severity: major          # fatal | major | minor | cosmetic
  why_it_matters: "Assignment is at block level; unclustered SEs understate
                   variance, so the p=0.03 result may not survive correction"
  evidence: "Methods state block randomisation (p.7); Table 4 note says
             'robust standard errors', with no cluster specified"
  repair: "Re-estimate with SEs clustered at block; report the corrected
           p-value; if it crosses conventional thresholds, revise the claim"
```

**A finding that cannot fill `location`, `evidence` and `repair` is dropped as unfalsifiable.** This single rule eliminates the model's characteristic reviewer failure: plausible-sounding, non-actionable objections.

---

# PART VI — STATISTICAL & DATA ANALYSIS MANUAL

## 26. STATISTICAL METHOD ROUTER

Software column reflects what is actually runnable here — Python verified `[OE]`, R verified `[OE]`, CRAN blocked `[OP]`.

| Method | Use when | Do NOT use when | Key assumptions | Diagnostics | Robustness | Software here | Verification | Common failure |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Descriptive** | Always, first | Never skip | none | distributions, missingness | by subgroup | pandas ✅ | recompute | reporting means for skewed data |
| **Classical tests** | Simple group comparison | Clustered/repeated data | independence, distributional | normality, variance | non-parametric | scipy ✅ | recompute | ignoring dependence |
| **Regression (OLS/robust)** | Conditional means | Bounded/count outcomes | linearity, exogeneity | residuals, influence, leverage | alt specs, trimming | statsmodels ✅, R ✅ | **cross-engine** `[OE]` | wrong SE structure |
| **GLM** | Binary/count/rate outcomes | Continuous unbounded | link, variance function | deviance, dispersion | alt links | statsmodels ✅, R ✅ | recompute | ignoring overdispersion |
| **Mixed models** | Hierarchical/repeated | Few clusters (<~30) | RE structure, normality | convergence, ICC, residuals | alt RE structures | statsmodels MixedLM ✅, R `lme4` ✅ | refit alt | non-convergence reported as a result |
| **Panel models** | Unit×time, unobserved heterogeneity | Serial correlation ignored | strict exogeneity | Hausman, serial corr. | FE vs RE, clustering | R `plm` ✅, `linearmodels` (pip) | cross-engine | wrong clustering level |
| **Event studies** | Discrete event, dated outcome | Overlapping events | no anticipation, no confounding events | pre-trend plot | window length, placebo dates | hand-rolled ✅, `plm` ✅ | recompute CARs | contaminated estimation window |
| **DiD** | Two groups, two+ periods | Staggered adoption with heterogeneous effects | **parallel trends** | pre-trend test | alt controls, placebo periods | statsmodels/`plm` ✅ — ⚠️ **`did`, `fixest` UNAVAILABLE** `[OP]` | cross-engine | TWFE bias under staggered timing |
| **Synthetic control** | One treated unit, good donor pool | Poor pre-fit | pre-fit, donor validity | pre-period RMSPE | leave-one-out, in-space placebo | ⚠️ hand-build with scipy | permutation inference | overfitting the pre-period |
| **IV** | Endogenous regressor, valid instrument | Weak instrument | relevance + **exclusion (untestable)** | first-stage F, overid | alt instruments | statsmodels ✅, R `AER` ✅ | cross-engine | weak-instrument bias hidden |
| **Survival** | Time-to-event, censoring | Competing risks ignored | proportional hazards | Schoenfeld residuals | alt parametric forms | R `survival` ✅, `lifelines` (pip) | recompute | informative censoring |
| **Time series** | Temporal dependence | Non-stationary untreated | stationarity, no unit root | ACF/PACF, ADF | alt lags, sample splits | statsmodels ✅, R `forecast`/`urca`/`vars` ✅ | out-of-sample | spurious regression |
| **Bayesian** | Priors matter, uncertainty propagation | Priors undefensible | prior + likelihood | R-hat, ESS, trace, PPC | prior sensitivity | R `brms`/`rstan` ✅ (slow on 2 vCPU), `pymc` (pip) | prior sensitivity | unreported prior influence |
| **Causal inference** | Effect, not association | Design cannot identify | design-specific | balance, placebo, negative control | sensitivity to unobserved confounding | as per estimator | identification audit | **wrong estimand** |
| **Machine learning** | Prediction | Inference on coefficients | i.i.d.; no leakage | CV curves, calibration | alt models, nested CV | sklearn ✅ | held-out set | **leakage**; ML coefficients read causally |
| **Simulation** | Analytical solution unavailable | Cheap closed form exists | DGP fidelity | convergence of estimates | vary DGP | numpy ✅ | analytic special case | too few replications on 2 vCPU |
| **Bootstrap** | Unknown sampling distribution | Strong dependence | exchangeability | interval stability | block bootstrap | numpy ✅ | analytic comparison | i.i.d. bootstrap on clustered data |
| **Permutation** | Exact inference under sharp null | Sharp null implausible | exchangeability | null distribution shape | alt statistics | numpy ✅ | analytic comparison | permuting the wrong level |
| **Sensitivity analysis** | **Always, for causal claims** | Never skip | — | — | — | hand-built ✅ | — | **omitted entirely** |

---

## 27. UNIVERSAL DATA ANALYSIS WORKFLOW

```text
raw data        Never open blind: wc -l, head, du -h FIRST. 7.8 GiB ceiling is real.
→ provenance    Where from, when, by whom, what version. Unprovenanced data is a finding.
→ schema        dtypes, cardinality, ranges. Print it; do not assume it.
→ identifiers   Key uniqueness. Duplicated keys silently multiply rows in joins.
→ units         Units and scale for every numeric. Unit errors survive every diagnostic.
→ missingness   Amount AND PATTERN. MCAR/MAR/MNAR changes the valid method.
→ duplicates    Exact and fuzzy. Decide and LOG the rule.
→ joins         Record row counts before and after EVERY join. Silent row loss is the
                most damaging quiet failure in analysis.
→ cleaning      Every decision scripted and logged. Never interactive-only.
→ EDA           Marginals first, then the relationships the DESIGN cares about.
→ estimand   ★  WHAT QUANTITY? Define before choosing an estimator. Skipping this is
                the single most common source of confidently wrong analysis.
→ specification The estimator that identifies THAT estimand. Assumptions written down.
→ execution     Seeded, scripted, reproducible.
→ diagnostics   Residuals, influence, convergence, balance, specification.
→ robustness    The PRE-SPECIFIED grid. Not a hunt for significance.
→ visualization Render → LOOK AT IT (verified capability) → fix → re-render.
→ interpretation Effect sizes in domain units. State what is NOT shown.
→ reproducibility Fresh run, fixed seed, from raw. EXPORT off the ephemeral container.
```

**Deviations:** confirmatory/pre-registered → model fixed before data, exploration walled off and reported separately. Causal designs → identification checks promoted ahead of estimation. Time series → stationarity first, it determines the model class. Clustered data → clustering structure settled at *schema* stage, because it determines both model and SEs; getting it wrong late invalidates everything downstream. Very large data → profile on a sample, validate, then run once at full scale.

---

## 28. STATISTICAL VERIFICATION ENGINE

| Check | Requirement | How, here |
| --- | --- | --- |
| **Independent recomputation** | Mandatory for any headline estimate | **Cross-engine: Python `statsmodels` vs apt-R.** Both verified executing regressions this session `[OE]`. Two engines agreeing is far stronger than one re-run |
| **Diagnostics** | Every model | Residuals, influence, convergence, balance. **Necessary but not sufficient** — clean diagnostics do not rescue a wrong estimand |
| **Robustness** | Pre-specified grid | Specification, sample, measurement, estimator, inference |
| **Sensitivity** | Mandatory for causal claims | How strong must an unobserved confounder be to overturn this? |
| **Placebo tests** | Where a placebo period/outcome exists | Effect on an outcome that cannot be affected |
| **Negative controls** | Observational designs | Control exposure and control outcome |
| **Simulation** | When assumptions are contestable | Simulate the DGP; check the estimator recovers the truth |
| **Result/table/figure consistency** | Every deliverable | **Do numbers in the text match the tables? Do tables match the data?** Recompute from source, do not eyeball |
| **Reproducibility rerun** | Anything to be published | Fresh run, fixed seed, from raw inputs |

**Priority under budget:** (1) headline numbers, (2) the identifying assumption, (3) table/text consistency, (4) everything else. Verifying (4) while skipping (1) is the common and expensive mistake.

---
# PART VII — CODING & SOFTWARE ENGINEERING MANUAL

## 29. UNKNOWN REPOSITORY NAVIGATION

```text
repo guidance      Read what you were TOLD, then hold it loosely — verify against the tree.
→ tree inventory   git ls-files | wc -l; extension histogram; largest files; dir shape.
                   Two minutes that reframe everything after.
→ languages        Actual distribution, not the README's claim.
→ dependencies     Manifests + lockfiles + transitive weight. Check egress: a dep from a
                   blocked host cannot be installed here [OP].
→ entry points     main, CLI registration, server bootstrap, exported API, scheduled jobs.
→ build system     Makefile / scripts / CI config → the CANONICAL build command.
→ configuration    Env vars, config files, defaults, secrets handling, feature flags.
→ data flow        Input → transform → output. Where does state live?
→ test map         Framework, layout, coverage, AND how tests are actually run.
→ architecture map Reconstruct from code. VERIFY README CLAIMS AGAINST THE TREE — they
                   diverge often enough that assuming is a real risk.
→ reproduce baseline  BUILD AND TEST BEFORE CHANGING ANYTHING. A pre-existing failure
                   discovered later will be misattributed to your change.
→ locate owner     git log / blame / CODEOWNERS — who understands this?
→ change plan      Smallest change achieving the objective. Check the same bug class
                   elsewhere in the tree.
→ patch            Match existing conventions. A stylistically foreign patch is a cost.
→ focused tests    A test that FAILS BEFORE and PASSES AFTER. Without it, unverified.
→ integration tests Exercise the surrounding subsystem.
→ diff audit       Read your own diff as a hostile reviewer. Debug prints? Scope creep?
→ release check    Full suite vs the baseline. ONLY NEW FAILURES ARE YOURS.
```

**Parallelism:** steps 1–9 fan out well to `Explore` workers on a large tree. Steps 10–17 are inherently sequential.
**Environment note:** `git init` first if concurrent workers will edit — worktree isolation requires a repo `[OP]`.

---

## 30. DEBUGGING ENGINE

```text
reproduce             ★ THE GATE. No deterministic repro → no debugging. Get the exact
                        command, inputs, and environment first. Everything downstream
                        depends on this and nothing substitutes for it.
→ preserve evidence     Copy logs, inputs, failing state BEFORE mutating anything.
→ collect logs          Full stack traces, not summaries. stderr merged with stdout.
→ first causal failure  Find the EARLIEST anomaly, not the loudest error. The visible
                        exception is usually downstream of the actual defect.
→ competing hypotheses  Enumerate ≥3. One hypothesis is a guess, not a diagnosis.
→ discriminating probes Design each probe so its outcome ELIMINATES at least one
                        hypothesis. A probe consistent with everything is wasted.
→ eliminate             Run probes; strike hypotheses. git bisect if a good commit exists.
→ isolate root cause    The defect, not the symptom. State the causal chain explicitly.
→ minimal fix           Smallest change addressing the CAUSE. Check the bug class
                        elsewhere in the codebase.
→ regression test       FAILS pre-fix, PASSES post-fix. Non-negotiable.
→ full test             Whole suite vs baseline.
→ adjacent-risk audit   What else relied on the broken behaviour?
```

**Parallel vs sequential.** Debugging is **sequential by nature** — each observation determines the next probe, so parallel hypothesis-chasing mostly duplicates work. Parallelism helps in exactly two places: **locating** candidate code across a large tree (`Explore` workers), and running **independent long test suites** concurrently. Never parallelise the hypothesis-elimination loop itself.

**Environment limits `[OP]`:** cannot reproduce anything depending on the user's OS (Windows vs this Linux container), GPU, local network, or installed software — unless a device folder is granted (none currently). Performance timings here are relative, not the user's absolute numbers, on a shared 2-vCPU box.

---

## 31. CODING AGENT TOPOLOGY

| Situation | Topology | Workers | Notes |
| --- | --- | :-: | --- |
| **Small bug** | Solo, sequential | 0 | Repro → fix → test. Delegation cost exceeds the work |
| **Large bug** | Coordinator + `Explore` locators + repro worker | 1–3 | Reasoning stays with the coordinator |
| **Isolated module** | Solo, or 1 programmer + 1 test engineer from the spec | 0–2 | Freeze the interface first |
| **Multi-module feature** | 1 programmer per module behind a frozen interface + 1 test engineer | 2–4 | **`git init` + worktree isolation, or serialise** `[OP]` |
| **Refactor** | Solo, incremental, test-gated | 0–1 | Refactoring without tests is guesswork. Tests first |
| **Migration** | Coordinator + compat researcher + 1 per subsystem | 2–4 | Version-compat research needs web search |
| **Architecture change** | 2–3 `Plan` agents on competing designs (independent) + 1 hostile reviewer | 2–4 | Independence avoids anchoring — the strongest case for parallelism in coding |
| **Performance optimization** | Solo — profile, then optimise | 0–1 | **Never optimise before profiling.** Timings are relative here |
| **Security audit (defensive)** | 1 reviewer per vulnerability class, mutually blind | 2–4 | ⛔ exploit development refused — policy, not capability |

---

## 32. SOFTWARE VERIFICATION

| Layer | What it establishes | When mandatory | Here |
| --- | --- | --- | --- |
| **Unit** | A function does what it claims | Any new logic | `pytest` pip-installable; node/go/cargo native `[OP]` |
| **Integration** | Components work together | Any interface change | ✅ |
| **Regression** | Fixed bugs stay fixed | **Every bug fix** — must fail pre-fix | ✅ |
| **Property tests** | Invariants hold across inputs | Parsers, serialisers, numeric code | `hypothesis` pip-installable |
| **Static checks** | Type/lint errors | Any non-trivial change | `ruff`/`mypy` pip-installable |
| **Build** | It compiles/packages | **Baseline before AND after** | ✅ |
| **Smoke test** | The main path runs | Before declaring done | ✅ |
| **Benchmarks** | Performance claims | Any optimisation claim | ⚠️ 2 vCPU shared — **relative only** |
| **Security scanning** | Known vulnerable deps | Dependency changes | `pip-audit`/`npm audit` |
| **Diff review** | Scope creep, debug leftovers, secrets | **Every change** | ✅ read your own diff hostilely |

**The rule that catches the most:** a regression test that does not fail before the fix verifies nothing. Write it, watch it fail, then fix.

---

# PART VIII — DOCUMENT & PUBLICATION MANUAL

## 33. FILE NAVIGATION GUIDE

| Format | Best parser | Extraction strategy | Large-file strategy | Visual QA needed? | Common failure |
| --- | --- | --- | --- | :-: | --- |
| **Markdown** | native / `markdown` | Read directly | Chunk by heading | No | — |
| **TXT** | `sed -n`, `head` | Stream | Never `cat` blind — `wc -l` first | No | encoding surprises |
| **PDF (text)** | `pdfplumber` (layout), `pypdf` (fast) | Per-page text + tables | Page ranges | **Yes for tables** | **multi-column order scrambles** — verify before trusting |
| **PDF (scanned)** | `pdf2image` → `tesseract` | OCR page by page | Batch, cache per page | **Yes, always** | **silent OCR errors**; ⚠️ `eng`+`osd` only `[OP]` |
| **DOCX** | `python-docx`; `pandoc` for conversion | Paragraphs, tables, styles | Section by section | For layout | tracked changes/comments missed |
| **CSV** | pandas | `chunksize`; sniff delimiter/encoding | Stream; never load whole | No | delimiter/encoding/type inference |
| **XLSX** | `openpyxl`; pandas for data | Per sheet; `data_only` for values vs formulas | Sheet by sheet | For charts | **formulas vs cached values confusion**; merged cells |
| **PPTX** | `python-pptx` | Per slide: shapes, text, notes | Slide by slide | **Yes** | text in grouped shapes / images missed |
| **Images** | `Read` (vision) + PIL | Direct visual read | Downscale first | **Yes — that is the point** | cannot recover exact values from pixels |
| **ZIP / source bundles** | `tar`/`unzip` + git | Extract → inventory → targeted read | Extract selectively; **watch the disk allowance** | No | path traversal; huge extractions |

**Universal large-file strategy:** inspect before loading (`wc -l`, `head`, `du -h`) → stream or chunk → extract the needed slice to a small file → summarise to disk → delegate a bounded read if the corpus would flood context → watch the per-session disk allowance (deletes still work when writes fail).

**The verified closed loop:** render → `Read` the image → correct → re-render. Confirmed working this session `[OE]`. Use it for every chart and every produced document that has a visual form; converting a docx to PDF and looking at it catches layout failures that no parser reports.

---

## 34. MANUSCRIPT WORKFLOW

```text
journal requirements  Scope, format, word limits, structure, reporting standards.
→ model papers        Read 10-20 recent papers FROM THE TARGET JOURNAL. Extract their
                      architecture: section order, evidence density, figure/table ratio,
                      how they frame contribution. Match it.
→ section architecture Outline to the paragraph, with the ARGUMENT each makes.
→ evidence corpus     §22 ledger, complete, before drafting. Drafting ahead of evidence
                      produces prose that must then be defended rather than supported.
→ analysis            §27 workflow. Results FIXED before the discussion is written.
→ figure/table plan   Each must earn its place: what claim does it carry? (§35)
→ introduction        Problem → gap → contribution. The gap must be the one the
                      novelty analysis actually established (§23).
→ methods             Reproducible by an independent team. This is the section that
                      makes a paper checkable — write it to be checked.
→ results             Findings, not interpretation. Numbers match the tables exactly.
→ discussion          Interpretation, limitations, alternative explanations, what is
                      NOT shown. Overclaiming is caught here or not at all.
→ citations           EVERY ONE FETCHED AND VERIFIED. [MANDATORY — §29]
→ hostile review      §25 protocol, fresh reviewer, artefact only.
→ formatting          Journal template; reference style; figure resolution.
→ page-by-page QA     Render to PDF and LOOK AT EVERY PAGE. Verified capability [OE].
→ submission package  Manuscript, figures, tables, supplement, cover letter, checklists.
```

**Delegation:** independent sections (methods, related work) and figures parallelise; **the argument and the voice never do.** Multi-worker prose reads as multi-worker prose — the coordinator rewrites for voice after drafting.

---

## 35. FIGURE & TABLE ENGINE

| Rule | Detail |
| --- | --- |
| **Chart type follows the claim** | Comparison → bar/dot; distribution → histogram/violin/ECDF; relationship → scatter (+fit and its uncertainty); time → line; composition → stacked only if parts genuinely sum; uncertainty → interval plot. **Choose from the claim, not from habit** |
| **No duplication** | A number belongs in the text, a table, or a figure — **one of them.** Repetition across all three is where inconsistencies breed |
| **Uncertainty is mandatory** | Intervals, not bare points. Never bar-plot a mean without its interval. Prefer CIs to stars |
| **Multipanel** | Shared axes and scales across panels; one consistent legend; label panels A/B/C and reference them in the text |
| **Statistical annotation** | Effect size **and** interval. Stars alone are uninformative. State the test and the n |
| **Axes** | Truncated axes only with an explicit break and a caption note. Zero baselines for bar charts |
| **Colour** | Colourblind-safe; never colour as the sole encoding; consistent semantics across all figures in one document |
| **Export** | Vector (PDF/SVG) for line art; ≥300 dpi raster where required. Embed fonts |
| **Visual QA** | ★ **Render, then `Read` the image, then fix.** Verified `[OE]`. Non-negotiable — this catches overlapping labels, clipped legends and unreadable text that no code review finds |
| **Table/text consistency** | Recompute every in-text number from the source data. A figure/table auditor (§17) is the cheapest high-value worker in manuscript work |

---

# PART IX — LONG-HORIZON & AUTONOMOUS WORK

## 36. LONG-RUNNING WORKFLOW

```text
goal              One sentence. Written into the canonical state file, not just context.
→ canonical state ★ A single durable file that is the SOURCE OF TRUTH. In Drive, git,
                    or memory — NOT the container, which is ephemeral [D].
→ milestones      Independently verifiable units, each ending in a runnable check.
→ checkpoints     After each milestone: update canonical state, export artefacts,
                    commit. Assume the session ends immediately after.
→ execution loop  Read state → pick next action → execute → verify → write state.
                    Every iteration must be safe to interrupt at any point.
→ failure recovery Classify (§41). Structural → re-plan. Transient → retry bounded.
                    Record the failure IN THE STATE FILE so a fresh session learns it.
→ persistence     Drive / git / memory / published Artifact. Container = scratch only.
→ scheduling      mcp__claude-code-remote__create_trigger. NEVER local Cron [D].
                    Each firing = FRESH SESSION with no memory of this one.
→ resumption      The scheduled prompt must be a COMPLETE STANDALONE INSTRUCTION that
                    says: read the canonical state at <location>, do the next action,
                    write state back. Nothing may be implicit.
→ verification    Milestone acceptance criteria, run as tests.
→ completion      Goal criteria met AND final artefacts exported off the container.
```

**Verified constraints `[OP]`/`[D]`:** the container persists across turns within a session (R, packages and files survived hours) but **not** across sessions. Bash calls cap at 600 s. Scheduled minimum interval is normally hourly. Scheduled-task creation is permission-classifier gated.

---

## 37. STATE & MEMORY DESIGN

| Store | Lifetime | Scope | Put here | Never put here | Class |
| --- | --- | --- | --- | --- | --- |
| **Model context** | one turn | this turn | active reasoning | anything needed later | `[D]` |
| **Conversation state** | session; cross-device | this session | dialogue, decisions | anything a fresh session needs | `[D]` |
| **Memory MCP** | **cross-session, cross-surface** | the user | durable user facts, preferences, ongoing-project context | secrets; transient state; blocked-category personal data | `[OE]` |
| **Container filesystem** | **session only** | this session | scratch, intermediates, working artefacts | **anything that must survive** | `[OP]` |
| **Git (in-container)** | session unless pushed | repo | code history, checkpoints, worktrees | durable state unless pushed to a remote | `[OE]` |
| **Google Drive** | permanent | the user | **canonical state, datasets, deliverables** | secrets | `[OA]` |
| **Published Artifact** | permanent, URL-addressable | user + anyone shared | dashboards, reports, reference pages | private/unreviewed content | `[OE]` |
| **Artifact DB** | permanent | artifact viewers | small shared structured state | large datasets | `[D]` |
| **Database** | — | — | ⛔ none available | — | `[OP]` |
| **Scheduled-task store** | permanent | the user | the resumption prompt itself | state (the prompt should POINT to state, not contain it) | `[D]` |
| **Worker state** | worker lifetime; resumable in-session | one worker | its own reasoning | anything the coordinator needs — **write it to a file** | `[OE]` |

**Placement rule for a CoScientist:** canonical project state → **Drive** (durable, user-owned, already authenticated). Durable facts about the user/project → **memory MCP**. Code → **git with a remote**. Human-facing status → **published Artifact**. Everything in the container is scratch. If a fresh session cannot reconstruct the project from Drive + memory alone, the design is broken.

---

## 38. CANONICAL HANDOFF FORMAT

Write this at every checkpoint, at budget exhaustion, and at session end. It is what makes a fresh session able to continue.

```yaml
project: "GMS CoScientist — AI-washing event study"
goal: "Submission-ready manuscript targeting <journal>, novelty-verified"
current_stage: "analysis:robustness"       # discovery|design|acquisition|cleaning|
                                           # analysis|robustness|drafting|review|submission
completed:
  - {stage: novelty, outcome: "UNRESOLVED within coverage; 6 routes; coverage limits logged", artefact: "drive://.../novelty_report.md"}
  - {stage: acquisition, outcome: "n=412 firm-events", artefact: "drive://.../events_v3.csv"}
in_progress:
  - {task: "cluster-robust SEs at firm level", blocker: null, owner: coordinator}
pending:
  - "placebo event dates"
  - "figure/table audit"
  - "hostile review"
decisions:
  - {decision: "TWFE with firm+time FE", rationale: "single adoption date; staggered estimators unnecessary", date: 2026-09-01, reversible: true}
  - {decision: "clustering at firm not industry", rationale: "assignment is firm-level", date: 2026-09-02, reversible: true}
constraints:
  hard: ["no paid resources", "R required for analytics", "no USPTO"]
  environment: ["CRAN BLOCKED — use apt r-cran-*; fixest/did UNAVAILABLE",
                "2 vCPU / 7.8 GiB", "container is ephemeral"]
authorizations:
  granted: ["Google Drive (OAuth)"]
  missing: ["device folder grant", "PubMed connector (authless, user must install)"]
canonical_files:
  state: "drive://.../COSCIENTIST_STATE.yaml"      # THE source of truth
  ledger: "drive://.../evidence_ledger.yaml"
  data: "drive://.../events_v3.csv"
  code: "git@.../coscientist.git@main"
data_sources: [{name: "...", access: "...", retrieved: 2026-08-27, license: "..."}]
tools: {required: [Bash, Drive], optional: [PubMed], unavailable: [patent_db, fixest]}
environment: {model: claude-opus-5, effort: max, container: "2vCPU/7.8GiB", r: "4.3.3 via apt"}
known_failures:
  - {what: "install.packages('fixest')", why: "CRAN 403 CONNECT — STRUCTURAL", do_not_retry: true}
  - {what: "Agent isolation=worktree", why: "cwd not a git repo", fix: "git init first"}
open_questions:
  - {q: "Is the event window contaminated by the Aug earnings cycle?", blocks: "results", needs: "analysis"}
next_actions:
  - {action: "run placebo dates -90/-60/-30", acceptance: "no effect at placebo dates (p>0.1)"}
verification_status:
  citations: {verified: 0, total: 41, method: "not yet run"}     # ← mandatory before drafting
  numbers: {cross_engine_checked: false}
  robustness: {grid_prespecified: true, executed: 2, total: 7}
```

---
# PART X — VERIFICATION & FAILURE RECOVERY

## 39. UNIVERSAL VERIFICATION ROUTER

| Target | Minimum route | Strong route |
| --- | --- | --- |
| **Factual claim** | One authoritative fetched source | Triangulate ≥2 **independent** sources (check for a common origin) + recency check |
| **Citation** | **Fetch it. Confirm it resolves.** | Fetch + verbatim quote supporting the specific claim + check date/design/population + verify the cited work says it *approvingly* |
| **Calculation** | Execute it in code | Recompute by a **different route or engine** (Python vs R, verified `[OE]`) |
| **Statistics** | Diagnostics + recompute | Cross-engine + pre-specified robustness + sensitivity + placebo/negative control + seeded rerun |
| **Code** | It runs; smoke test passes | Unit + integration + regression (failing pre-fix) + static checks + hostile diff review |
| **Repository claim** | Verify against the tree, not the README | Build + full test suite vs a recorded baseline |
| **Document** | Opens; parses; spot-check fields | Render → **view every page** `[OE]` + table/text number reconciliation |
| **Research conclusion** | Every claim traced to a fetched source | + contradiction pass with an inverted prior + uncertainty grading + coverage-limits statement |
| **Novelty** | ≥3 route types run | Full §23 battery + contradiction search + explicit verdict + **"screening not clearance"** stated |
| **Causal claim** | Assumptions enumerated | + identification checks executed + placebo + negative control + sensitivity to unobserved confounding + a hostile identification audit |
| **High-stakes action** | Human confirmation | Human confirmation + dry run + reversibility plan + a second-model review |
| **Agent output** | **Read the artefact it wrote, not its summary** `[OP]` | + coordinator re-runs a sample of its work independently |

**Budget priority:** (1) numbers carrying conclusions, (2) citations, (3) the core logic/identifying assumption, (4) everything else. **Every other failure mode in §40 degrades gracefully; fabricated citations and unexecuted arithmetic do not** — they produce output that looks correct and is wrong.

---

## 40. FAILURE TAXONOMY

| Type | Detection | Recovery |
| --- | --- | --- |
| **Factual** | Cross-source conflict; date inconsistency; claim about post-cutoff events | Search; prefer primary; state uncertainty. **Never answer present-day facts from recall** |
| **Citation** | URL fails to resolve; fetched source does not support the claim | **Drop the citation.** Never repair from memory. Re-derive from a fetched source or remove the claim |
| **Arithmetic** | Recomputation disagrees; magnitude implausible | Execute in code. Never trust mental arithmetic beyond a few significant figures |
| **Statistical** | Diagnostics fail; cross-engine estimates disagree; SEs implausibly small | Re-specify; check clustering level; re-derive the estimand |
| **Causal** | Identification check fails; pre-trends non-parallel; weak first stage | **STOP the pipeline.** A failed identification check is not a caveat |
| **Scope** | Output does not answer the original request | Final audit vs the original text — this is what catches drift |
| **Tool selection** | Answered a recency question from knowledge; asserted instead of executing | Apply §11 triggers mechanically, not by feel |
| **Auth** | 401/403 from a service; "not connected"; tool refuses | Surface to the user. Only they can authorise |
| **Environment** | 403 CONNECT; missing package; missing precondition | **Classify structural vs transient.** Re-plan on structural (§41) |
| **Dependency** | Import/build failure; version conflict | Pin; venv; **check the allowlist first** — a "conflict" here is often a blocked host |
| **Context loss** | Re-derived a settled constraint; contradicts an earlier decision | Re-read authoritative files. **No truncation signal is exposed — design so it does not matter** |
| **Over-parallelization** | Workers return duplicate findings; merge cost exceeds the saving; write collisions | Reduce count; enforce disjoint output paths; use §16 scoring |
| **Under-parallelization** | Serial execution of genuinely independent read-heavy branches | Batch independent calls; spawn on ≥3 independent slices |
| **Hallucination** | Specific unverifiable detail; suspiciously well-formed citation; confident recall of an obscure fact | Fetch or delete. **Specificity without a source is the tell** |
| **Capability overclaim** | Claimed a capability without probing — **including claiming a LIMITATION without probing** | Probe. This manual's pre-flight overturned a prior `[U]` claim with one `grep` |
| **Partial completion** | Some acceptance criteria unmet but output presented as done | Write a §38 handover. **Never present partial work as complete** |
| **Integration** | Parts work; the whole does not; sections contradict | Coordinator-side consistency pass; end-to-end test |
| **Confabulated agent report** `[OP]` | Worker claims success; ground truth disagrees; worker defends under challenge | **Verify against artefacts, not reports.** Use `sonnet`+ for unverifiable output (§14.3) |

---

## 41. RETRY POLICY

```text
TRANSIENT           → retry 1-2 with backoff; add idempotency if the action has effects
CONFIGURATION       → repair the config/arguments; retry ONCE; do not vary randomly
DEPENDENCY          → provision it (pip/npm/apt/cargo) — check the allowlist FIRST
AUTHORIZATION       → request access; do NOT retry; do NOT route around it
STRUCTURAL LIMIT    → REROUTE. Never retry. (CRAN 403; no GPU; worktree without a repo)
BAD ASSUMPTION      → REPLAN from the decomposition, not from the failed call
RESOURCE LIMIT      → reduce / split / stream / move the step elsewhere
POLICY OR CLASSIFIER→ surface to the user; never attempt a workaround
BILLING (429 + credits language) → NOT throttling. Never resolves by waiting. Reroute
```

**Hard rules.**
1. **Never retry a structural failure.** The CRAN 403 is the canonical case: the correct response was to re-plan through apt, not to retry `install.packages()`.
2. **Classify on the message, not the status code.** HTTP 429 meaning "requires usage credits" is billing, and a code-based retry policy loops forever `[OP]`.
3. **Never route around a policy refusal.** If `WebFetch` declines a domain, do not reach for curl. If the classifier soft-denies, surface it.
4. **Two failures of the same delegated task means the task was mis-specified**, not that the worker was unlucky. Re-specify or absorb it.
5. **Record structural failures in the canonical state file** (§38 `known_failures`) so a fresh session does not rediscover them at cost.

---

# PART XI — REUSABLE PROMPT LIBRARY

## 42. UNIVERSAL MAX-PERFORMANCE PROMPT TEMPLATE

```text
OUTCOME
  <the artefact AND the decision it serves — one sentence each>

CONTEXT
  <prior attempts; what is already ruled out; audience; why now>

AUTHORITATIVE SOURCES
  <exact paths / URLs / Drive file IDs / repo@ref. Never "the file I mentioned">
  <state which source wins if they conflict>

CONSTRAINTS
  HARD: <must / must-not>
  ENVIRONMENT: <language, packages, offline, licence — surface collisions at PLANNING time>
  SOFT: <preferences, sacrificed first under budget>

TOOLS
  Required: <e.g. execute all arithmetic; fetch every citation>
  Forbidden: <e.g. no subagents; no web search>
  Unavailable (do not attempt): <e.g. CRAN packages, patent DB, GPU>

AUTONOMY
  [ ] Ask before any irreversible action
  [ ] Proceed; state assumptions at the top
  [ ] Fully autonomous; no questions (unattended)

PARALLELISM
  Workers: <count and roles, or "your judgement per the scoring rule">
  Output paths: <one DISJOINT directory per writing worker>
  Worker tier: <sonnet+ for anything whose output cannot be mechanically checked>

VERIFICATION            ← never omit this block
  Must verify: <numbers / citations / tests / assumptions>
  Method: <recompute by a second ENGINE / fetch every URL / suite must pass>
  Evidence required: <artefacts on disk, not summaries>

ACCEPTANCE CRITERIA
  <objective pass/fail conditions, written BEFORE the work>

DELIVERABLE
  Format / length / structure / audience / what to OMIT

ESCALATION
  Stop and ask if: <conditions>
  On block: <re-plan | report | hand off>
```

## 43. RESEARCH PROMPT TEMPLATE

```text
OUTCOME    Answer <question>, to support <decision>.
SCOPE      Population: … Exposure: … Outcome: … Timeframe: … Designs in scope: …
           EXCLUSIONS (write first): …
TERMINOLOGY Known synonyms: … Adjacent-discipline terms: … Historical names: …
SOURCES    Priority: primary > systematic review > official > preprint > news.
           UNAVAILABLE HERE: indexed scholarly DBs (unless PubMed installed),
           patent DB, paywalled full text. STATE THIS LIMIT IN THE DELIVERABLE.
WORKERS    N search workers, one per DISJOINT query family (mechanism / adjacent /
           method / outcome / population); +1 contradiction hunter (INVERTED prior);
           +1 citation verifier (sonnet+, MUST FETCH).
LEDGER     Every worker writes §22 records to <path>. No quote → no claim.
VERIFY     Re-fetch every citation surviving into the output. Run the contradiction
           pass as a first-class step, not an afterthought.
GRADE      Each claim: well-supported | contested | not-established.
           "Not found" ≠ "not true" — anywhere.
STOP       Claim saturation across ≥3 different ROUTE TYPES (not rephrasings).
DELIVER    Verdict; claim×source matrix; contradictions; coverage limits; open questions.
```

## 44. NOVELTY SEARCH PROMPT TEMPLATE

```text
IDEA       <one precise sentence: mechanism, population, outcome, method>
DECOMPOSE  Mechanism: … Method: … Outcome: … Population: … Domain: …
ROUTES     Run in order: mechanism → adjacent-discipline → organism/domain → method →
           outcome → population → variable-combination → semantic-neighbour → recent →
           preprints → dissertations → citation-chain → exact-phrase → contradiction.
           UNAVAILABLE: patents (no DB), forward citation tracing (no citation API).
WORKERS    One per route family, sonnet+. Each writes §22 records to <path>.
VERDICT    Exactly one of: EXACT_PRECEDENT | CLOSE_PRECEDENT | MECHANISTIC_PRECEDENT |
           METHOD_PRECEDENT | APPLICATION_NOVELTY | INCREMENTAL_NOVELTY | UNRESOLVED
RULES      • EXACT_PRECEDENT → stop immediately; one hit settles it.
           • NEVER return "novel". UNRESOLVED means "not found within coverage".
           • Every precedent must carry a FETCHED url + verbatim quote.
           • Output MUST end with an explicit coverage-limits paragraph.
DELIVER    Verdict; ≤8 nearest precedents with quotes; how the idea differs;
           coverage limits; recommendation (proceed | reframe | abandon).
           Label the result SCREENING, NOT CLEARANCE.
```

## 45. STATISTICAL ANALYSIS PROMPT TEMPLATE

```text
DATA       Path: … Provenance: … Unit of observation: … Known issues: …
QUESTION   <substantive question>
ESTIMAND ★ <the exact quantity to estimate — define BEFORE any estimator>
DESIGN     <RCT | DiD | event study | RD | IV | panel | observational>
           Assignment level: …   Clustering level: …
CONSTRAINTS ENVIRONMENT: R available via apt (CRAN BLOCKED — fixest/did/stargazer/
           modelsummary UNAVAILABLE). Python statsmodels available. 2 vCPU / 7.8 GiB.
PROCEDURE  §27 workflow. Identification checks BEFORE estimation.
           A failed identification check STOPS the pipeline — it is not a caveat.
ROBUSTNESS Pre-specify the grid NOW: <specs>. Post-hoc additions must be labelled
           as exploratory.
VERIFY     • Recompute the headline estimate in a SECOND ENGINE (Python ↔ R).
           • Diagnostics + sensitivity + placebo/negative control.
           • Seeded rerun from raw data.
DELIVER    Estimand; specification; assumptions and which were tested; estimate with
           uncertainty; diagnostics; robustness table; sensitivity; what is NOT shown.
```

## 46. CODING / REPOSITORY PROMPT TEMPLATE

```text
REPO       <path or url@ref>
OBJECTIVE  <behaviour change, stated as an observable>
BASELINE ★ Build and run the test suite BEFORE changing anything. Record which tests
           already fail. Only NEW failures are yours.
CONSTRAINTS Style: match existing conventions. Do not touch: <paths>.
           ENVIRONMENT: Linux container (user's machine is Windows); 2 vCPU; no GPU;
           no Docker daemon; egress allowlisted.
WORKERS    <n> programmers behind a FROZEN interface, disjoint paths.
           ⚠️ `git init` first if concurrent edits — worktree isolation needs a repo.
           +1 test engineer working FROM THE SPEC, not the implementation.
VERIFY     • A test that FAILS before the change and PASSES after.
           • Full suite vs baseline.  • Static checks.  • Hostile diff review.
DELIVER    Diff; new tests; baseline-vs-after test results; risks; rollback.
```

## 47. DEBUGGING PROMPT TEMPLATE

```text
SYMPTOM    <exact error text / observed vs expected>
REPRO   ★  <exact command + inputs + environment>
           IF NO REPRO EXISTS, YOUR FIRST AND ONLY TASK IS TO PRODUCE ONE.
           Do not hypothesise before you can reproduce.
CONTEXT    When it started; what changed; frequency; last known good commit.
CONSTRAINTS Cannot reproduce user-OS-specific / GPU / local-network issues here.
PROCEDURE  §30. Enumerate ≥3 competing hypotheses. Design probes that ELIMINATE.
           Find the FIRST causal failure, not the loudest error.
VERIFY     Regression test fails pre-fix, passes post-fix. Full suite vs baseline.
           Audit the same bug class elsewhere in the tree.
DELIVER    Root cause with the causal chain; minimal fix; regression test; adjacent risks.
           If unresolved: hypotheses eliminated, evidence, and the next probe to run.
```

## 48. HOSTILE REVIEW PROMPT TEMPLATE

```text
ARTEFACT   <the manuscript / design / code — ARTEFACT ONLY>
           Do NOT reveal the author's reasoning to the reviewer; it anchors them.
ROLE       You are a hostile referee. Your job is to find what is WRONG.
           A review that finds nothing has failed.
AXES       Contribution · novelty · design · measurement · statistics · causal
           identification · interpretation · reproducibility · citations · figures ·
           tables · internal contradictions · overclaiming · missing controls ·
           alternative explanations.
SCHEMA     Every finding MUST fill all six: location, problem, severity
           (fatal|major|minor|cosmetic), why_it_matters, evidence, repair.
           A finding that cannot fill location, evidence and repair is DROPPED.
RANK       Order by severity. Do not present a typo and a fatal flaw at equal weight.
STRONGEST  End with: the single strongest argument that this work should be rejected.
DELIVER    Ranked findings; the strongest rejection case; a major/minor revision list.
```

## 49. AGENT SPAWN TEMPLATE

The worker starts **cold** `[OP]` — anything not in this prompt does not exist for it.

```text
ROLE          You are a <role from §17>.
OBJECTIVE     <one sentence — the single thing to accomplish>
INPUT         <exact paths / URLs / IDs. The worker sees NO prior conversation.>
BOUNDARY      Do ONLY this. Do not <adjacent work>.
              Write ONLY to <disjoint output directory>.
TOOLS         Use: <tools>.  Do not use: <tools>.
OUTPUT SCHEMA Write <path> as <exact schema>. Return a ≤150-word summary that
              POINTS AT the artefact; do not restate its contents.
DO NOT        • Do not claim success you did not verify.
              • Do not paraphrase tool output — QUOTE IT VERBATIM.
              • Do not infer beyond your input.
VERIFY        Before returning, re-read your own artefact and confirm it matches the
              schema. Report any field you could not fill.
              A FAILURE HONESTLY REPORTED IS A VALID AND USEFUL RESULT.
STOP          Stop when <condition>, or after <n> attempts, whichever first.
```

> **Why the `DO NOT` and `VERIFY` blocks are mandatory.** The one probe worker that received the line *"a failure is a valid and useful result"* quoted its raw tool output exactly and added a correct unprompted caveat. The workers without it produced a confabulated success and defended it under challenge (§14.3). **These lines are not politeness — they are the control that makes worker output usable.**

---
# PART XII — ORCHESTRATOR ROUTER

## 50. MODEL-SELECTION RULES

Claims are about **this configuration only**. No claims are made about other providers' models.

| Dimension | Route HERE when | Route ELSEWHERE when |
| --- | --- | --- |
| **Complexity** | Multi-stage, interdependent, needs judgement | Single mechanical transform at volume |
| **Ambiguity** | High — resolving ambiguity well is a comparative strength | Fully specified and repetitive |
| **Stakes** | High — max effort + mandatory verification is available | Trivial and reversible |
| **Modality** | Text, images, documents, charts | Audio, video, image *generation* — none available `[OP]` |
| **Retrieval** | The corpus is already supplied, or general-web suffices | **Indexed scholarly/patent/paywalled retrieval is the bottleneck** — the decisive routing criterion here |
| **Coding** | Real repo, running code, reproducible failures | GPU/ML training; user-OS-specific bugs without a folder grant |
| **Data** | ≤ ~7.8 GiB, CPU-feasible | Big data; deep learning; heavy simulation |
| **Context** | Large but structured; can be staged through files | Requires state across sessions without external storage |
| **Workers** | 2–6 independent read-heavy slices | >8 slices, or genuine multi-tier orchestration (single-level only here `[OP]`) |
| **Latency** | Seconds-to-minutes acceptable | Hard real-time |
| **Cost** | Value justifies max effort + workers | High-volume low-value throughput |
| **Verification** | Verification *is* the task — review, audit, critique | Verification needs an unavailable source |

**Role fit, in order of comparative advantage:**

1. **Reviewer / verifier / critic** — best fit. No tools required, so no environment constraint applies; structurally suppresses the model's main weakness because critique is grounded in an artefact it did not invent.
2. **Primary agentic model** — shell + filesystem + delegation + skills + document toolchain is the differentiator, not raw model quality.
3. **Analytical specialist** — design, identification, interpretation, moderate-scale computation.
4. **Synthesis model** — heterogeneous inputs into one coherent argument with consistent voice.
5. **Coding specialist** — multi-file work where running the code matters.
6. **Researcher** — *analysis* yes; *retrieval breadth* no. **Split the task: retrieve elsewhere, analyse here.** The highest-value split in the whole system.
7. **Fallback** — only when the primary failed on reasoning or ambiguity. If it failed on retrieval or compute, this model has the same limits and will fail identically.

---

## 51. EXECUTION ROUTING RULES

Fifty-four rules. `effort` values are from the documented ladder; `workers` are reasoned starting points pending §55.

```text
R01 IF task_type=present-day fact; complexity=trivial; stakes=any; evidence=external
    THEN role=researcher; effort=low; tools=[WebSearch,WebFetch]; workers=0;
         persistence=none; verification=mandatory(fetch source);
         fallback=state uncertainty. NEVER answer from model knowledge.

R02 IF task_type=exact arithmetic/statistic that carries a conclusion
    THEN role=analytical; effort=medium; tools=[Bash]; workers=0; persistence=file;
         verification=mandatory(recompute by second route); fallback=state uncertainty.

R03 IF task_type=literature synthesis; corpus SUPPLIED
    THEN role=researcher/synthesis; effort=high; tools=[Read]; workers=2-4(extraction);
         persistence=evidence ledger; verification=source-traced claims; fallback=solo.

R04 IF task_type=literature DISCOVERY requiring an indexed scholarly database
    THEN DO NOT route here as primary. Retrieve elsewhere → analyse here.
         UNLESS the PubMed connector (authless) has been installed — then
         role=researcher; effort=high; workers=2-4; verification=ID resolution.

R05 IF task_type=novelty screening; stakes=high
    THEN role=researcher; effort=max; tools=[WebSearch,WebFetch]; workers=4-6(routes);
         persistence=ledger+verdict; verification=mandatory(contradiction pass +
         every precedent fetched + coverage-limits statement);
         fallback=UNRESOLVED. OUTPUT IS SCREENING, NOT CLEARANCE.

R06 IF task_type=patent novelty / freedom-to-operate
    THEN DO NOT route here. No patent database [OP]. Escalate to a specialist service.

R07 IF task_type=citation verification of an existing document
    THEN role=verifier; effort=medium; tools=[WebFetch]; workers=1-3 by volume;
         worker_tier=sonnet+; verification=mandatory(EVERY citation FETCHED);
         fallback=mark unverified, never infer.

R08 IF task_type=statistical analysis; data<~2GB; design specified
    THEN role=analytical; effort=high; tools=[Bash,Python,R-via-apt]; workers=0-2;
         persistence=scripts+outputs to Drive;
         verification=mandatory(cross-engine + diagnostics + prespecified robustness +
         seeded rerun); fallback=report non-convergence, never a non-converged estimate.

R09 IF task requires R packages fixest|did|stargazer|modelsummary
    THEN re-plan or route elsewhere. CRAN blocked; absent from Debian apt [OP].
         Substitute plm + clubSandwich + lmtest/sandwich, or linearmodels in Python.

R10 IF data>7.8GiB OR deep-learning training
    THEN DO NOT route here. No GPU; 2 vCPU; 7.8 GiB [OP].

R11 IF task_type=causal identification design
    THEN role=analytical; effort=max; tools=[Bash]; workers=1-3;
         verification=mandatory(assumption enumeration + identification checks BEFORE
         estimation + placebo + sensitivity); fallback=STOP, do not caveat.

R12 IF task_type=simulation/bootstrap/permutation, high replication
    THEN role=analytical; effort=high; tools=[Bash]; workers=0;
         NOTE wall-clock bound at 2 vCPU — size replications accordingly [OP].

R13 IF task_type=write code; single module; clear spec
    THEN role=coding; effort=high; tools=[Write,Bash]; workers=0; persistence=git;
         verification=mandatory(execute + a test failing pre-fix).

R14 IF task_type=multi-module implementation; interface definable
    THEN role=coding; effort=xhigh; workers=2-4; PRECONDITION: freeze the interface
         AND `git init` (worktree isolation requires a repo [OP]);
         verification=build + full suite + reviewer that did not write the code.

R15 IF task_type=debug; failure REPRODUCIBLE in a Linux container
    THEN role=coding; effort=high→max; tools=[Bash,Grep,Read]; workers=0-1;
         verification=mandatory(failing test passes AND baseline suite still passes).

R16 IF task_type=debug; failure NOT reproducible here (user OS/GPU/local net)
    THEN DO NOT route here unless a device folder grant exists.
         User device is Windows; container is Linux; device_bash refuses [OP].

R17 IF task_type=comprehend large unfamiliar repository
    THEN role=coding; effort=high; workers=2-4 type=Explore;
         verification=architecture claims checked AGAINST THE TREE, not the README.

R18 IF task_type=code review OR defensive security review
    THEN role=reviewer; effort=high→max; tools=[Read]; workers=0-1;
         verification=each finding cites a location + concrete failure scenario.
         NOTE offensive tooling is refused — policy boundary, not capability.

R19 IF task_type=architecture design; ≥2 viable alternatives
    THEN role=primary; effort=max; workers=2-4 type=Plan, INDEPENDENT (anti-anchoring);
         verification=failure-mode analysis + rollback path per design.

R20 IF task_type=manuscript drafting; material settled
    THEN role=synthesis; effort=high; tools=[skills:docx/pdf]; workers=2-4;
         verification=mandatory(citations fetched + text/table numbers reconciled);
         NOTE voice and argument stay with the coordinator — never delegated.

R21 IF task_type=peer review / referee report
    THEN role=reviewer; effort=max; tools=[]; workers=0;
         BEST-FIT, LOWEST-COST USE OF THIS CONFIGURATION — no tools required.

R22 IF task_type=adversarial review; stakes=high
    THEN role=reviewer; effort=max; workers=1 FRESH and BLIND to author reasoning;
         prompt="find what is wrong", never "check this"; verification=§25 schema.

R23 IF task_type=evidence verification; claims>5
    THEN role=verifier; effort=high; workers=2-6 by claim count; worker_tier=sonnet+;
         verification=mandatory(fetched URL + verbatim quote per surviving claim).

R24 IF task_type=document conversion/extraction
    THEN role=primary; effort=low-medium; tools=[Bash,skills]; workers=0;
         verification=spot-check extracted tables against the RENDERED page.

R25 IF task_type=OCR of scanned documents
    THEN role=primary; effort=low; tools=[Bash:tesseract]; workers=0-2;
         CONSTRAINT English+OSD only [OP]; verification=spot-check against page images.

R26 IF task_type=chart / visualization
    THEN role=analytical; effort=medium; tools=[Bash,Read]; workers=0;
         verification=mandatory(RENDER THEN VIEW the image — closed loop verified [OE]).

R27 IF task_type=audio transcription OR native video understanding
    THEN DO NOT route here. No ASR; not input modalities [OP].

R28 IF task_type=image generation from text
    THEN DO NOT route here. No generative image model; programmatic rendering only [OP].

R29 IF data lives in the user's Google Drive
    THEN role=primary; tools=[Drive MCP]; workers=0-2; already authenticated [OA].

R30 IF data lives on the user's computer
    THEN PRECONDITION: a folder grant. connectedFolders=[]; device_bash refuses [OP].
         Request access (prompts on THEIR machine) or ask for attachments.

R31 IF the task needs a host outside the egress allowlist
    THEN re-plan. 403 CONNECT is POLICY, not transient. Never retry [OP].

R32 IF results must survive this session
    THEN persistence=mandatory(Drive | git remote | published Artifact | memory).
         Container filesystem is ephemeral [D].

R33 IF the task must run on a schedule
    THEN tools=[claude-code-remote MCP] — NEVER the local Cron tools, which die with
         the session [D]. Each firing = fresh session: the prompt must be a COMPLETE
         standalone instruction pointing at canonical state.

R34 IF ambiguity=high AND a user is present
    THEN effort=medium first; ask ONE structured question; then proceed at full effort.

R35 IF ambiguity=high AND unattended
    THEN effort=max; choose the most reasonable interpretation; STATE IT AT THE TOP;
         proceed. Do not block on a question no one will answer.

R36 IF the action is irreversible (delete|publish externally|send|spend)
    THEN require explicit human approval regardless of the autonomy setting.

R37 IF the plan needs >1 tier of workers
    THEN the outer tier MUST be the external orchestrator. Delegation here is
         single-level — workers have no Agent tool [OP].

R38 IF budget is the binding constraint
    THEN workers=0; effort=high; verification=numbers+citations only.
         Each worker costs ≥35k tokens [OE].

R39 IF stakes=high AND failure would be SYSTEMATIC (shared prior/blind spot)
    THEN add a DIFFERENT-model review. A second instance of the same model shares
         my priors and decorrelates nothing.

R40 IF task_type="is this idea any good" / early framing
    THEN role=reviewer+primary; effort=max; workers=0; tools=[];
         cheap, fast, high value. Follow with R05 if it survives.

R41 IF a worker's output cannot be mechanically checked by the coordinator
    THEN worker_tier=sonnet or better. Cheap tiers confabulate and defend it [OP].

R42 IF a worker must produce EVIDENCE (not just a conclusion)
    THEN require it to WRITE the evidence to a file at a named path;
         coordinator reads the file, not the summary [OP].

R43 IF ≥2 workers WRITE to overlapping paths
    THEN serialise, OR `git init` and use isolation=worktree.
         Workers share one filesystem [OE]; worktree needs a repo [OP].

R44 IF the task is inherently sequential (debugging, iterative repair)
    THEN workers=0-1. Parallelism helps LOCATING, never hypothesis elimination.

R45 IF a tool returns 429
    THEN read the MESSAGE. "requires usage credits" = billing → reroute, never wait.
         Genuine rate limit → backoff [OP].

R46 IF a capability is claimed anywhere in this manual as [S] or [I]
    THEN treat it as a hypothesis; require the §53 benchmark before routing on it.

R47 IF a research deliverable will state or imply coverage
    THEN verification=mandatory(explicit coverage-limits paragraph naming what was
         NOT searched). A systematic-STYLE review must not be presented as systematic.

R48 IF effort=max is requested AND the bottleneck is retrieval|compute|authorization
    THEN downgrade to high and FIX THE BOTTLENECK instead. Max effort cannot buy an
         index, a GPU, or a grant (§6).

R49 IF the session may end before the task completes
    THEN persistence=canonical state file in Drive; write a §38 handover at every
         checkpoint; schedule resumption via the cron MCP.

R50 IF a prior claim about a LIMITATION has not been probed
    THEN probe it before relying on it. Unprobed limitations are capability
         overclaims in reverse — this manual's pre-flight is the worked example.

R51 IF task_type=data engineering; multiple heterogeneous sources
    THEN role=analytical; effort=high; workers=2-5 (one per source, DISJOINT outputs);
         verification=row counts and key cardinality reconciled pre/post merge;
         persistence=mandatory export off the container.

R52 IF task_type=hostile review of a research design BEFORE data collection
    THEN role=reviewer; effort=max; workers=0-1; tools=[];
         HIGHEST VALUE-PER-TOKEN INTERVENTION IN A RESEARCH PIPELINE — a design flaw
         caught here costs one prompt; caught after collection it costs the study.

R53 IF the deliverable is a chart, dashboard, or visual artefact
    THEN verification=mandatory(render → Read the image → correct → re-render) [OE].
         Never ship a visual that was never looked at.

R54 IF a permission classifier soft-denies a call
    THEN do NOT retry and do NOT work around it. Surface to the user with the stated
         reason; continue with the unblocked remainder of the task.
```

---

## 52. RESOURCE ALLOCATION

| Resource | Allocation rule |
| --- | --- |
| **Model effort** | Scale to **consequence**, not apparent difficulty. A one-line answer feeding an irreversible decision deserves `max`; a long report nobody acts on does not. **Downgrade when the bottleneck is not reasoning** (§6). |
| **Context** | Reasoning, not storage. Everything else to disk. Re-read authoritative files rather than trusting recall — a re-read costs tokens, a mis-recalled constraint costs a rework. |
| **Worker count** | `min(independent_slices, floor(budget/40k), 5)`. The middle term binds more often than expected. Spend the *marginal* worker on a verifier, not a producer. |
| **Tool calls** | Batch independent calls into one block (parallel `[OE]`). Batch deferred-schema loads into one `ToolSearch`. Probe cheaply before committing expensively. |
| **Search depth** | Volatility × consequence. Stop at **claim** saturation across ≥3 route *types*, not URL saturation. |
| **Sources** | Until saturation, not a fixed count. Contested claims need ≥1 credible source per side, checked for **independence** (common origin = one source). |
| **Verification** | Always (1) numbers carrying conclusions and (2) citations. Add assumption auditing for causal/predictive claims. Add adversarial review for external-facing or irreversible output. |
| **Time** | Bash calls cap at 600 s — split or detach. Long jobs: checkpoint so an interruption costs one stage, not the run. |
| **Compute** | 2 vCPU / 7.8 GiB / no swap. Chunk, stream, sample-then-scale. More workers do **not** add CPU. |
| **Token budget** | Session budget is observable and decrements. Reserve ≥15% for synthesis and verification — running out mid-synthesis produces the worst possible artefact: confident and unfinished. |

---

# PART XIII — BENCHMARKS

## 53. BENCHMARK EVERY SELF-DESCRIBED CLAIM

Each benchmark is designed so a **plausible-looking wrong answer fails**, which is the specific risk profile of this model.

| ID | Target | Task | Measurement | Success | Failure signal |
| --- | --- | --- | --- | --- | --- |
| **B01** | Reasoning | 20 held-out multi-constraint logic/counterfactual items, no tools | Accuracy; derivation-validity rate | ≥85% accurate, ≥90% of correct answers have valid derivations | Correct answers with invalid derivations >10% → pattern-matching |
| **B02** | Effort ladder | See §54 — identical tasks at medium/high/xhigh/max | Quality, latency, tokens, tool calls | Monotone quality gain justifying cost | Higher effort = more verbosity, same accuracy |
| **B03** | Research | 10 questions needing multi-source synthesis; 3 with a misleading top result | Accuracy; trap-detection | ≥80% correct; ≥2/3 traps caught | Confident answer from one misleading source |
| **B04** ★ | **Citations** | 1500-word review, ≥15 citations. Arm (a) no verification instruction; arm (b) "fetch every citation" | % resolving; % actually supporting; fabrication rate | Arm (b): **0 fabrications**, ≥95% support | ANY fabrication in arm (b) → in-prompt instruction insufficient; escalate to a separate verifier agent |
| **B05** | Novelty | 10 ideas: 5 with prior art (some adjacent-discipline), 5 novel at a fixed date | Prior-art recall; false-novelty rate; coverage-limits stated | ≥4/5 found; **0 unqualified novelty claims** | Any "this is novel" without coverage limits |
| **B06** | Statistics | 8 analyses with known truth, each with a planted trap (clustering, selection, violated parallel trends, leakage, Simpson's, non-convergence, multiplicity, misaligned estimand) | Trap detection; |estimate−truth| | ≥6/8 traps; estimates in tolerance | Clean-looking analysis that silently inherits the trap |
| **B07** | Causal inference | 6 designs, 3 with a violated identifying assumption detectable from the description | Violation detection; assumption completeness | ≥2/3 violations caught; all assumptions enumerated | Estimating without stating assumptions |
| **B08** | Coding | 12 tasks, 4 languages, hidden tests | Hidden-test pass; self-assessment calibration | ≥80% pass; calibration within 15 pts | Claiming success on failing code |
| **B09** | Debugging | 10 seeded bugs: 4 shallow, 4 cross-file, 2 needing a repro built first | Root-cause accuracy; pre-fix-failing test written | ≥7/10 root cause; ≥8/10 valid regression test | Symptom patches |
| **B10** | Repository | 5 repos 10k–500k LOC; 2 with READMEs contradicting the code | Accuracy; contradiction detection | ≥80%; ≥1/2 contradictions | Restating the README as fact |
| **B11** | Documents | 20 docs across formats incl. scanned + merged-cell tables | Field accuracy; false-confidence rate | ≥95% native, ≥85% scanned-English, low-confidence flagged | Silent OCR errors presented as clean |
| **B12** | Long context | Facts at 10/50/90% depth; 3 items needing TWO distant facts | Accuracy by depth; multi-hop accuracy | <10-pt degradation | Confident wrong answers at depth |
| **B13** | Tool selection | 25 requests; 5 traps that look like they need a tool and do not (and vice versa) | Correct-selection; unnecessary-call; missed-required | ≥85% correct; <10% unnecessary; **0 missed on recency/exactness** | Answering a present-day fact from knowledge (R01) |
| **B14** | Workers | See §55 | Quality, cost, redundancy, latency | Chosen count within ±1 of true slice count | Spawning for sequential or write-heavy work |
| **B15** | **Worker reliability** | 10 delegated probes with independently checkable ground truth, at haiku / sonnet / opus | **Confabulation rate** = claims contradicted by ground truth | 0% at the tier you route judgement work to | Any confabulated success → raise the tier for that role (§14.3) |
| **B16** | Verification | 15 artefacts, each with one planted defect of known class | Detection by class; false positives | ≥80% detection, <20% FP | Superficial approval |
| **B17** | Failure recovery | 10 injected failures: blocked host, missing package, unreproducible bug, corrupt input, unreachable source, non-convergence, ambiguous spec, empty worker, conflicting sources, 429-billing | Classification accuracy; wasted retries on structural | ≥80% correct; ≤1 retry on any structural | Retry loop against a policy block or a billing 429 |

---

## 54. MAX-EFFORT BENCHMARK

The point is to determine **when `max` is worth paying for** — not to assume it always is.

```text
ARMS        medium | high | xhigh | max     (identical prompts, identical tools)
REPLICATES  ≥5 per arm per task (stochastic — single runs are uninformative)
SCORING     blind to arm; rubric fixed before the runs

TASK FAMILIES (chosen because they should respond DIFFERENTLY to effort)
  T1 deep reasoning, no tools            → effort SHOULD help most
  T2 retrieval-bound research            → effort should help LEAST (§6) ← key control
  T3 multi-file coding                   → xhigh should shine (long-horizon)
  T4 statistical identification design    → max should shine (conceptual)
  T5 trivial extraction                   → effort should be NEUTRAL or HARMFUL ← control

MEASURE per run
  quality (blind rubric 0-100) · accuracy vs ground truth · latency_s
  tokens_total · tool_calls · worker_count · cost · verification_success_rate

DERIVE
  marginal_quality_gain   = quality(level_n) − quality(level_n−1)
  quality_per_1000_tokens = quality / (tokens/1000)
  quality_per_second      = quality / latency_s
  quality_per_cost        = quality / cost

DECISION RULE
  Route at the LOWEST level whose marginal_quality_gain over the level below is
  both positive and material on the metric the task is actually judged by.
  If T2 shows no gain from high→max, that CONFIRMS §6: max cannot buy retrieval,
  and the routing policy should downgrade retrieval-bound tasks (rule R48).
  If T5 shows quality DECLINING with effort, that confirms over-effort harms
  trivial tasks, and R01/R24 should pin low effort.
```

---

## 55. WORKER BENCHMARK

```text
ARMS
  A0  coordinator only                     (baseline)
  A1  1 worker
  A2  2 workers
  A3  3 workers
  A5  5 workers
  A8  8 workers
  AV  3 workers + 1 dedicated ADVERSARIAL VERIFIER   ← tests §19's central claim
  AM  3 workers, MIXED tiers (cheap search + strong analysis)
  AH  3 workers, ALL cheap tier                      ← tests §14.3 confabulation

TASK FAMILIES (different TRUE slice counts, so the curve is interpretable)
  T1 research synthesis, 6 natural query families
  T2 evidence verification, 12 independent claims
  T3 multi-module implementation, 3 modules, frozen interface
  T4 debugging — INHERENTLY SEQUENTIAL   ← NEGATIVE CONTROL
  T5 bulk extraction, 20 independent documents

COMPARISONS
  equal-resource      : cap total tokens; more workers = fewer tokens each
  unconstrained       : each arm runs to completion
  verifier-vs-producer: AV vs A5 (is a verifier worth more than 2 more producers?)
  mixed-model         : AM vs A3 (does tier-mixing preserve quality at lower cost?)
  cheap-tier risk     : AH vs A3 (confabulation rate, per B15)
  sequential control  : any arm on T4 — if workers help here, §19's model is WRONG

MEASURE
  quality · evidence_coverage (% of a gold source set recovered) · error_rate
  (factual errors + fabricated citations per 1000 words) · redundancy (% duplicate
  findings) · completion_latency · resource_cost · synthesis_quality (separate blind
  rubric) · merge_failures (findings a worker produced that never reached the output)
  · confabulation_rate (worker claims contradicted by ground truth)

REPORTING RULE
  Report COST-NORMALISED quality alongside raw quality. An arm 5% better at 3× cost
  is a different recommendation from one 5% better for free — and on a quota-
  constrained account the cost-normalised number is the decision-relevant one.
  Publish no predicted results; this section specifies the experiment, not its outcome.
```

---
# PART XIV — MACHINE-READABLE EXPORTS

## 56. MODEL MANIFEST

```yaml
manifest_version: 1
generated: "2026-09-03T18:15:00Z"
method: "live probing of the executing session"
evidence_legend:
  D: documented
  OS: observed_schema
  OC: observed_configuration
  OP: observed_probe
  OE: observed_executed
  OA: observed_authenticated
  S: self_described
  I: inferred
  U: unknown

model:
  provider: Anthropic                                    # D
  family: Claude
  configured_id: claude-opus-5                           # OC
  serving_id: null                                       # U — not exposed, may differ
  application: "Cowork mode (Claude desktop app)"        # D
  harness: "Claude Agent SDK"                            # D
  in_container_cli: "claude 2.1.259 (Claude Code)"       # OP
  session_id: "claude-72 [916604]"                       # OP
  knowledge_cutoff: "2026-05"                            # D
  context_window_documented: 1000000                     # D — not probed to limit
  max_output_documented: 128000                          # D — not probed to limit
  session_token_budget_observed: 15000000                # OC
  input_modalities: [text, image, pdf_pages_as_images]   # OE
  output_modalities: [text]                              # OE

reasoning:
  mode: "adaptive thinking, always on"                   # D
  effort_requested: max
  effort_observed: max                                   # OC — CLAUDE_EFFORT=max
  effort_ladder: [low, medium, high, xhigh, max]         # D + OS (CLI --effort)
  effort_default_for_model: high                         # D
  max_thinking_tokens_ceiling: 31999                     # OC — ceiling, NOT consumption
  thinking_tokens_consumed: null                         # U
  self_settable_effort: false                            # OP — cannot change own effort
  effort_cannot_buy: [retrieval_index, knowledge_recency, network_access,
                      compute, authorization, citation_truth, correct_estimand]

environment:
  os: "Linux 6.18.44-fc-v24 x86_64"                      # OP
  user_device_os: win32                                  # OA
  cpu_cores: 2                                           # OP
  memory_gb: 7.8                                         # OP
  swap: none                                             # OP
  gpu: false                                             # OP
  disk: "fixed per-session allowance; df misleads"       # OP + D
  running_as: root                                       # OP
  shell_timeout_default_s: 120                           # D
  shell_timeout_max_s: 600                               # D
  container_persistence: "across turns within a session; destroyed at session end"  # OP
  egress:
    model: "mandatory HTTPS proxy with allowlist"        # D + OP
    allowed_verified: [pypi.org, files.pythonhosted.org, registry.npmjs.org, jsr.io,
                       index.crates.io, proxy.golang.org, debian_apt, github.com,
                       api.github.com, api.anthropic.com]
    blocked_verified: ["cloud.r-project.org (CRAN)", "download.docker.com"]
  runtimes:
    python: {version: "3.11.15", state: available}                       # OP
    r: {version: "4.3.3", state: available_after_apt_install}            # OE
    node: {version: "22.22.2", state: available}                        # OP
    java: {state: available}
    go: {state: available}
    rust: {state: available}
    git: {state: available, note: "cwd /home/claude is NOT a repo"}      # OE/OP
    docker: {state: blocked, note: "CLI present, daemon down, registry blocked"}  # OP
  r_packages:
    cran: blocked                                                        # OP
    apt_r_cran_count: 1130                                               # OP
    verified_working: [sandwich, lmtest, zoo]                            # OE
    available_via_apt: [plm, AER, lme4, survival, metafor, mice, quantreg, tseries,
                        vars, urca, lavaan, brms, rstan, mgcv, glmnet, randomForest,
                        broom, tidyverse, rmarkdown, knitr, data.table, clubSandwich]
    unavailable: [fixest, did, stargazer, modelsummary]                  # OP

tools:
  see: "section 57 tool registry"
  parallel_tool_calls: true                                              # OE
  deferred_tool_loading: "ToolSearch — batch names in ONE call"          # D

agents:
  available: true                                                        # OE
  provided_by: agent_harness                                             # not the model
  parallel_execution: true                                               # OE (race-proven)
  isolated_context: true                                                 # OP (cold start)
  shared_filesystem: true                                                # OE
  nested_delegation: false                                               # OP (no Agent tool)
  worker_to_main_messaging: true                                         # OE (verified by receipt)
  coordinator_to_worker_messaging: true                                  # OE
  worker_to_peer_messaging: null                                         # U (only confabulated evidence)
  resumption_preserves_context: true                                     # OE
  worktree_isolation: false                                              # OP — needs cwd to be a git repo
  worktree_fix: "git init in the working directory"                      # OE
  types: [general-purpose, Explore, Plan, claude, claude-code-guide, statusline-setup]
  model_overrides: [sonnet, opus, haiku, fable]                          # OS
  model_override_blocked: {fable: "requires usage credits (HTTP 429)"}   # OP
  cost_floor_tokens: 35000                                               # OE
  observed_costs: [{model: haiku, calls: 2, tokens: 35830, ms: 13303},
                   {model: haiku, calls: 2, tokens: 35348, ms: 8028},
                   {model: haiku, calls: 3, tokens: 35698, ms: 12087},
                   {model: sonnet, calls: 4, tokens: 49371, ms: 19051}]
  maximum_concurrent: null                                               # U — do not assume
  confabulation_observed: {tier: haiku, behaviour: "claimed a peer-messaging success
    that ground truth contradicted, then defended it under direct challenge",
    contrast: "sonnet quoted raw output verbatim and added a correct caveat"}  # OP
  recommended_counts:                                                    # S — benchmark via §55
    trivial: 0
    routine: 0
    analytical: 0-1
    complex: 2-4
    deep_research: 3-6
    novelty: 4-6
    systematic_style_review: 3-6
    statistical: 0-3
    causal: 1-3
    data_engineering: 2-5
    coding: 2-4
    debugging: 0-1
    repository_analysis: 2-4
    manuscript: 2-4
    peer_review: 3-5
    evidence_verification: 2-6

research:
  web_search: {available: true, index: "US-only general"}                # OE + D
  web_fetch: {available: true, note: "small-model summarisation — LOSSY"} # OE + D
  scholarly_database: false                                              # OP
  scholarly_available_to_install:
    - {name: PubMed, authless: true, installed: false,
       tools: [search_articles, get_article_metadata, find_related_articles,
               lookup_article_by_citation, convert_article_ids, get_full_text_article,
               get_copyright_status],
       note: "HIGHEST-VALUE ZERO-COST UPGRADE — user must install"}      # OS
    - {name: alphaXiv, authless: false, installed: false}
    - {name: Scholar Gateway, authless: false, installed: false}
  citation_graph_api: false                                              # OP
  patent_database: false                                                 # OP
  paywalled_fulltext: false                                              # OP
  novelty_analysis: screening_only                                       # S + OP
  citation_verification: {mechanism: available, must_be_mandated: true}  # OE

statistics:
  python_execution: true                                                 # OE
  r_execution: true                                                      # OE
  cross_engine_verification: true                                        # OE
  available: [descriptive, classical_tests, ols, robust_se, glm, mixed, panel,
              event_study, did_twfe, iv, survival, time_series, bayesian,
              ml_classical, simulation, bootstrap, permutation, multiple_testing,
              sensitivity, meta_analysis, sem]
  unavailable: [deep_learning, heterogeneity_robust_did_packages, synth_packages]
  ceiling: "2 vCPU / 7.8 GiB — replication counts and dataset size are bound"

coding:
  repo_clone: true                                                       # OE
  build_and_test: true                                                   # OE
  github_api: true                                                       # OE
  gh_cli: false                                                          # OP
  db_server: false                                                       # OP
  deployment_target: false
  user_machine_repro: false                                              # OP — no folder grant

documents:
  pdf: {read: true, write: true, ocr_languages: [eng, osd]}              # OE/OP
  docx: {read: true, write: true, convert: true}                         # OE
  xlsx: {read: true, write: true}                                        # OE
  pptx: {read: true, write: true, typed_artifact: false}                 # OE/OP
  markdown: true
  visual_qa_loop: {render_then_view: true}                               # OE

multimodal:
  image_understanding: true                                              # OE
  image_generation: false                                                # OP
  audio: false                                                           # OP
  video: false                                                           # OP

context:
  known_limit: 1000000                                                   # D
  effective_limit_measured: null                                         # U
  truncation_self_detection: false                                       # S
  strategy: "state to disk; re-read authoritative files; stage work"

persistence:
  conversation: {available: true, scope: session, cross_device: true}    # D
  memory_mcp: {available: true, scope: cross_session_cross_surface, files: 13}  # OE
  container_filesystem: {available: true, scope: session_only}           # OP
  google_drive: {available: true, authenticated: true}                   # OA
  published_artifacts: {available: true, count: 5, typed_artifacts: false}  # OE/OP
  artifact_db: {available: true}                                         # D
  scheduling: {available: true, count: 0, each_firing: "fresh session",
               min_interval: "normally hourly", local_cron: "DIES WITH SESSION"}  # OE/D
  device_bridge: {reachable: true, connected_folders: 0, device_bash: refused}   # OA/OP

limitations:
  - "No scholarly database installed — the binding constraint on research work. PubMed is authless and installable by the user."
  - "No patent database; no citation-graph API; no paywalled full text."
  - "CRAN blocked: fixest, did, stargazer, modelsummary unavailable."
  - "2 vCPU / 7.8 GiB / no GPU: no DL training, no >7.8 GiB data, simulation is wall-clock bound."
  - "Container filesystem ephemeral — nothing survives without export."
  - "Subagent delegation is SINGLE-LEVEL; workers have no Agent tool."
  - "Worktree isolation unavailable unless the working directory is a git repo."
  - "Cheap-tier workers confabulate success and defend it under challenge."
  - "No device folders connected; the user's Windows machine is unreachable."
  - "No typed artifacts; decks and sheets must be produced as files."
  - "No DB server, no Docker daemon, no deployment target."
  - "No image generation, no ASR, no video understanding; OCR is English+OSD only."
  - "Citations are generated, not looked up — must be fetched to be trusted."
  - "Exact arithmetic must be executed, not recalled."
  - "Cannot install connectors, plugins, or grant device access — all require the user."
  - "Bash calls cap at 600 s."
  - "A permission classifier can soft-deny actions; it must not be worked around."
  - "Fable 5.1 is credit-gated on this account and cannot be used as a worker model."

unknowns:
  - "Which model actually serves any given turn."
  - "Thinking tokens actually consumed (only the 31999 ceiling is visible)."
  - "Whether the serving API request truly carried effort=max."
  - "Effective context limit and current occupancy; whether truncation has occurred."
  - "Maximum concurrent subagent count."
  - "Whether worker-to-PEER messaging works (only confabulated evidence exists)."
  - "Liveness of the browser MCPs and the visualize MCP (present, untested)."
  - "Whether the AWS/GCP environment variables grant any usable access."
  - "The full egress allowlist (only tested hosts are known)."
  - "Real-world accuracy of every [S]-tagged behavioural claim in this manual."
```

## 57. TOOL REGISTRY

```yaml
tools:
  - {name: Bash, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "shell in the cloud container", parallel_safe: true, destructive: possible,
     persistence: session, prerequisites: [], failure_modes: [timeout_600s, oom, no_space,
     egress_403], fallback: "split, stream, or move the step"}
  - {name: Read, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "files, images, PDF pages, notebooks", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: [path], failure_modes: [missing_file, pdf_page_cap],
     fallback: "convert first; page ranges"}
  - {name: Write/Edit, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "create / exact-string edit", parallel_safe: false, destructive: true,
     persistence: session, prerequisites: ["Read before Edit"],
     failure_modes: [non_unique_match, unread_file], fallback: "widen the match string"}
  - {name: Glob/Grep, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "path and content search", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: [], failure_modes: [regex_dialect], fallback: "rg via Bash"}
  - {name: WebSearch, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "discover URLs", parallel_safe: true, destructive: false, persistence: none,
     prerequisites: [], failure_modes: [us_only_index, no_content], fallback: "vary vocabulary and route type"}
  - {name: WebFetch, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "URL -> markdown -> prompted extraction", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: [public_url],
     failure_modes: [auth_required, cross_host_redirect, lossy_summarisation],
     fallback: "canonical/alternate/repository/preprint version; NEVER curl around a refusal"}
  - {name: Agent, layer: H, available: true, tested: OE, authenticated: n/a,
     purpose: "spawn subagent", parallel_safe: true, destructive: via_worker,
     persistence: "resumable in-session", prerequisites: ["disjoint output paths"],
     failure_modes: [cold_start_cost_35k, no_nested_agent, worktree_needs_repo,
     fable_credit_gated, confabulation_on_cheap_tiers],
     fallback: "re-spawn once with a sharper prompt, then absorb the work"}
  - {name: SendMessage, layer: H, available: true, tested: OE, authenticated: n/a,
     purpose: "message/resume agents and peer sessions", parallel_safe: true, destructive: false,
     persistence: "resumes with context", prerequisites: [agent_id_or_name],
     failure_modes: [stale_id, cloud_session_cannot_reply], fallback: "ListAgents to refresh"}
  - {name: ListAgents, layer: H, available: true, tested: OE, authenticated: n/a,
     purpose: "enumerate agents and sessions", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: [], failure_modes: [self_not_listed], fallback: none}
  - {name: Task*, layer: H, available: true, tested: OE, authenticated: n/a,
     purpose: "task list and async task control", parallel_safe: true, destructive: false,
     persistence: session, prerequisites: [], failure_modes: [stale_task_state],
     fallback: "TaskGet before TaskUpdate"}
  - {name: Monitor, layer: H, available: true, tested: false, authenticated: n/a,
     purpose: "background event stream", parallel_safe: true, destructive: false,
     persistence: session, prerequisites: [line_buffered_command],
     failure_modes: [auto_stop_on_verbosity, silent_on_crash_if_filter_narrow],
     fallback: "widen the grep alternation to cover failure signatures"}
  - {name: mcp__memory__*, layer: E, available: true, tested: OE, authenticated: OA,
     purpose: "cross-surface persistent user memory", parallel_safe: false,
     destructive: true, persistence: cross_session, prerequisites: [version_token],
     failure_modes: [version_conflict, size_cap, privacy_refusal],
     fallback: "read, merge, retry in the same turn"}
  - {name: mcp__Google_Drive__*, layer: E, available: true, tested: OE, authenticated: OA,
     purpose: "search/read/write the user's Drive", parallel_safe: true, destructive: true,
     persistence: permanent, prerequisites: [oauth],
     failure_modes: [quota, permission], fallback: "ask for a direct attachment"}
  - {name: mcp__claude-code-remote__*, layer: E, available: true, tested: OE, authenticated: OA,
     purpose: "durable scheduled tasks", parallel_safe: true, destructive: true,
     persistence: permanent, prerequisites: [standalone_prompt],
     failure_modes: [min_interval, classifier_gate, fresh_session_has_no_memory],
     fallback: "surface to the user; never use local Cron for user-facing schedules"}
  - {name: Artifact, layer: T, available: true, tested: OE, authenticated: OA,
     purpose: "publish hosted page; artifact DB; assets", parallel_safe: true,
     destructive: true, persistence: permanent, prerequisites: [html_or_md_file],
     failure_modes: [cdn_csp, size_16mb, no_typed_artifacts, publish_conflict],
     fallback: "SendUserFile only"}
  - {name: SendUserFile, layer: T, available: true, tested: OE, authenticated: n/a,
     purpose: "deliver a file into the conversation", parallel_safe: true, destructive: false,
     persistence: conversation, prerequisites: [file_exists], failure_modes: [size],
     fallback: "split the file"}
  - {name: mcp__remote-devices__device_bash, layer: E, available: true, tested: OP,
     authenticated: false, purpose: "shell on the user's machine", parallel_safe: true,
     destructive: true, persistence: device, prerequisites: [connected_folder],
     failure_modes: [no_folders_connected, readonly_mount, no_delete_permission,
     short_timeout, narrower_egress],
     fallback: "device_request_folder_access, or work in the container"}
  - {name: mcp__remote-devices__device_stage_files, layer: E, available: true, tested: false,
     authenticated: false, purpose: "device -> container", parallel_safe: true,
     destructive: false, persistence: none, prerequisites: [connected_folder],
     failure_modes: [transfer_timeout, size_cap], fallback: "reduce or extract on-device first"}
  - {name: mcp__remote-devices__device_commit_files, layer: E, available: true, tested: false,
     authenticated: false, purpose: "container -> device", parallel_safe: false,
     destructive: true, persistence: device, prerequisites: [file_uuid, connected_folder],
     failure_modes: [mtime_drift, readonly, path_outside_grant],
     fallback: "SendUserFile and ask where it should go"}
  - {name: ToolSearch, layer: H, available: true, tested: OE, authenticated: n/a,
     purpose: "load deferred tool schemas", parallel_safe: true, destructive: false,
     persistence: session, prerequisites: [], failure_modes: [no_match],
     fallback: "keyword search instead of select:"}
  - {name: SearchMcpRegistry, layer: P, available: true, tested: OE, authenticated: n/a,
     purpose: "discover connectors", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: [], failure_modes: [cannot_install],
     fallback: "tell the user; only they can install"}
  - {name: Skill, layer: H, available: true, tested: false, authenticated: n/a,
     purpose: "load a packaged workflow", parallel_safe: true, destructive: false,
     persistence: session, prerequisites: [skill_name], failure_modes: [unknown_name],
     fallback: "ListSkills first"}
  - {name: AskUserQuestion, layer: P, available: true, tested: OE, authenticated: n/a,
     purpose: "structured multiple-choice question", parallel_safe: false, destructive: false,
     persistence: none, prerequisites: [user_present],
     failure_modes: [unanswered_when_unattended], fallback: "state the assumption and proceed"}
  - {name: PubMed connector, layer: E, available: false, tested: false, authenticated: false,
     purpose: "indexed biomedical literature", parallel_safe: true, destructive: false,
     persistence: none, prerequisites: ["USER MUST INSTALL — authless, no OAuth"],
     failure_modes: [not_installed],
     fallback: "web search WITH AN EXPLICIT COVERAGE-LIMITS STATEMENT"}
```

## 58. WORKFLOW REGISTRY

```yaml
workflows:
  deep_research:
    trigger: "answer requires evidence not in the prompt; unbounded source count"
    effort: high-max
    coordinator: "decompose to claims; merge; adjudicate; synthesise"
    workers: {count: 3-6, roles: [search_worker, contradiction_hunter, citation_verifier],
              tier: sonnet+}
    tools: [WebSearch, WebFetch, Write, Read]
    steps: [question, scope, terminology_map, search_strategy, discovery, retrieval,
            contradiction, extraction, ledger, claim_matrix, grading, synthesis,
            verification, report]
    parallel_steps: [discovery, contradiction, extraction, verification]
    sequential_steps: [question, scope, terminology_map, claim_matrix, grading, synthesis]
    verification: ["every citation FETCHED", "contradiction pass run",
                   "coverage limits stated in the artefact"]
    failure_recovery: {no_results: "change ROUTE TYPE not wording",
                       paywalled: "state the limit; do not fabricate",
                       conflicting: "report the disagreement as the finding"}
    stop_conditions: ["claim saturation across >=3 route types", "budget exhausted -> handover"]

  novelty_analysis:
    trigger: "prior-art or novelty question"
    effort: max
    coordinator: "terminology map; route plan; verdict assignment"
    workers: {count: 4-6, roles: [novelty_analyst_per_route, contradiction_hunter], tier: opus}
    tools: [WebSearch, WebFetch, Write]
    steps: [decompose_idea, terminology, route_battery, merge, contradiction, verdict]
    parallel_steps: [route_battery]
    sequential_steps: [decompose_idea, terminology, merge, verdict]
    verification: ["every precedent fetched + quoted", "explicit coverage-limits paragraph",
                   "verdict from the closed enum", "labelled SCREENING NOT CLEARANCE"]
    failure_recovery: {nothing_found: "return UNRESOLVED, never 'novel'"}
    stop_conditions: ["EXACT_PRECEDENT found -> stop immediately", "route saturation"]

  statistical_analysis:
    trigger: "estimate a quantity from data"
    effort: high
    coordinator: "runs estimation itself"
    workers: {count: 0-3, roles: [robustness_worker, assumption_auditor], tier: opus}
    tools: [Bash, Read]
    steps: [provenance, schema, identifiers, units, missingness, duplicates, joins,
            cleaning, eda, estimand, specification, execution, diagnostics, robustness,
            visualization, interpretation, reproducibility]
    parallel_steps: [robustness]
    sequential_steps: [schema, estimand, specification, execution, diagnostics]
    verification: ["cross-engine recompute (Python <-> R)", "diagnostics", "prespecified
                   robustness", "sensitivity", "seeded rerun", "render-then-VIEW charts"]
    failure_recovery: {non_convergence: "report it; never report a non-converged estimate",
                       package_missing: "apt r-cran-* or pip; CRAN is BLOCKED"}
    stop_conditions: ["robustness grid exhausted"]

  causal_analysis:
    trigger: "effect claim, not association"
    effort: max
    coordinator: "estimand and identification — never delegated"
    workers: {count: 1-3, roles: [identification_auditor, placebo_worker, sensitivity_worker]}
    tools: [Bash, Read]
    steps: [estimand, dag, identification_strategy, assumption_enumeration,
            identification_checks, estimation, placebo, negative_control, sensitivity,
            interpretation]
    parallel_steps: [placebo, sensitivity]
    sequential_steps: [estimand, identification_strategy, identification_checks, estimation]
    verification: ["assumptions enumerated and individually tested where testable",
                   "placebo", "negative control", "sensitivity to unobserved confounding"]
    failure_recovery: {identification_check_fails: "STOP THE PIPELINE — not a caveat"}
    stop_conditions: ["checks pass and sensitivity reported", "checks fail -> redesign"]

  coding:
    trigger: "implement or change software"
    effort: high-xhigh
    coordinator: "interfaces; integration; review"
    workers: {count: 2-4, roles: [programmer, test_engineer], tier: sonnet+}
    tools: [Bash, Write, Edit, Grep, Read]
    steps: [baseline_build, baseline_tests, architecture, interface_freeze, implement,
            integrate, focused_tests, full_tests, diff_audit]
    parallel_steps: [implement]
    sequential_steps: [baseline_build, baseline_tests, interface_freeze, integrate, full_tests]
    verification: ["test fails pre-fix and passes post-fix", "full suite vs baseline",
                   "reviewer that did not write the code"]
    failure_recovery: {build_fails: "check baseline first — was it already broken?",
                       write_collision: "git init + worktree isolation, or serialise"}
    stop_conditions: ["acceptance criteria pass"]

  debugging:
    trigger: "a reported failure"
    effort: high-max
    coordinator: "hypotheses and fix — SEQUENTIAL"
    workers: {count: 0-1, roles: [repo_mapper], tier: sonnet}
    tools: [Bash, Grep, Read]
    steps: [reproduce, preserve_evidence, collect_logs, first_causal_failure,
            competing_hypotheses, discriminating_probes, eliminate, isolate_root_cause,
            minimal_fix, regression_test, full_test, adjacent_risk_audit]
    parallel_steps: [locate_code_only]
    sequential_steps: [reproduce, first_causal_failure, eliminate, isolate_root_cause]
    verification: ["regression test fails pre-fix", "full suite vs baseline"]
    failure_recovery: {no_repro: "producing a repro becomes THE task",
                       not_reproducible_here: "needs a device grant; do not guess"}
    stop_conditions: ["root cause identified and regression test green"]

  manuscript:
    trigger: "produce a submission-ready document"
    effort: high
    coordinator: "argument and VOICE — never delegated"
    workers: {count: 2-4, roles: [section_drafter, citation_verifier, figure_table_auditor]}
    tools: [Read, Write, Bash, skills]
    steps: [journal_requirements, model_papers, section_architecture, evidence_corpus,
            analysis, figure_table_plan, drafting, voice_rewrite, citations,
            hostile_review, formatting, page_qa, submission_package]
    parallel_steps: [section_drafting, figures]
    sequential_steps: [section_architecture, voice_rewrite, hostile_review, page_qa]
    verification: ["every citation fetched", "text numbers reconciled with tables",
                   "render to PDF and view every page", "hostile review"]
    failure_recovery: {citation_unresolvable: "drop the citation or the claim"}
    stop_conditions: ["hostile review returns no major revisions"]

  hostile_review:
    trigger: "high-stakes artefact before release"
    effort: max
    coordinator: "assemble, dedupe, severity-rank"
    workers: {count: 3-5, roles: [methods_reviewer, statistical_auditor, evidence_verifier,
              consistency_checker], tier: opus, note: "MUTUALLY BLIND"}
    tools: [Read]
    steps: [parallel_axis_review, dedupe, severity_rank, strongest_rejection_case]
    parallel_steps: [parallel_axis_review]
    sequential_steps: [dedupe, severity_rank]
    verification: ["every finding fills location, evidence, repair — else dropped"]
    failure_recovery: {no_findings: "the review has failed; re-prompt adversarially"}
    stop_conditions: ["all axes reported and ranked"]

  evidence_verification:
    trigger: "claims must be checked before use"
    effort: high
    coordinator: "adjudication"
    workers: {count: 2-6, roles: [citation_verifier, contradiction_hunter], tier: sonnet+}
    tools: [WebFetch, Write]
    steps: [extract_claims, cluster, parallel_verify, contradiction, adjudicate]
    parallel_steps: [parallel_verify]
    sequential_steps: [extract_claims, adjudicate]
    verification: ["fetched URL + verbatim quote per surviving claim — NO QUOTE NO CLAIM",
                   "coordinator re-fetches a sample of worker results"]
    failure_recovery: {worker_claims_success_without_artefact: "discard and re-run at a
                       higher tier — confabulation is documented [OP]"}
    stop_conditions: ["every claim graded supported | contested | not_established"]
```

## 59. ROUTING POLICY EXPORT

```yaml
routing_policy:
  version: 1
  source_manual: CURRENT_MODEL_MAX_OPERATING_MANUAL.md
  target_model: {configured_id: claude-opus-5, harness: claude_agent_sdk, application: cowork}
  rules_ref: "section 51 R01-R54"

  hard_blocks:                      # never route these here
    - {condition: "requires GPU or deep-learning training", reason: "no GPU", rule: R10}
    - {condition: "dataset > 7.8 GiB", reason: "RAM ceiling", rule: R10}
    - {condition: "requires patent database", reason: "unavailable", rule: R06}
    - {condition: "requires audio transcription", reason: "no ASR", rule: R27}
    - {condition: "requires generative image output", reason: "no image model", rule: R28}
    - {condition: "requires R packages fixest|did|stargazer|modelsummary", reason: "CRAN blocked", rule: R09}
    - {condition: "requires >1 tier of delegation in one session", reason: "single-level", rule: R37}
    - {condition: "requires the user's local files without a folder grant", reason: "no grant", rule: R30}

  soft_blocks:                      # route only with an explicit caveat in the output
    - {condition: "indexed scholarly retrieval is the bottleneck",
       mitigation: "install the authless PubMed connector, or retrieve elsewhere",
       required_caveat: "coverage-limits statement", rule: R04}
    - {condition: "novelty verdict feeds a go/no-go decision",
       required_caveat: "SCREENING NOT CLEARANCE", rule: R05}
    - {condition: "systematic review claimed",
       required_caveat: "systematic-STYLE, not systematic", rule: R47}

  effort_policy:
    default: high
    upgrade_to_max_when: [irreversible, causal_identification, novelty_verdict,
                          adversarial_review, high_ambiguity_unattended]
    upgrade_to_xhigh_when: [long_horizon_agentic, multi_file_refactor]
    downgrade_when: [bottleneck_is_retrieval, bottleneck_is_compute,
                     bottleneck_is_authorization, task_is_trivial]
    rule: R48

  worker_policy:
    formula: "min(independent_slices, floor(budget/40000), 5)"
    cost_floor_tokens: 35000
    tier_rule: "sonnet+ whenever coordinator cannot mechanically check the output"
    evidence_rule: "workers producing evidence MUST write it to a named file"
    write_conflict_rule: "disjoint output dirs; or git init + isolation=worktree"
    sequential_rule: "workers=0-1 for inherently sequential work"
    marginal_worker_rule: "spend it on a verifier, not a producer"
    rules: [R38, R41, R42, R43, R44]

  verification_policy:
    always: [execute_all_arithmetic, fetch_all_citations]
    add_for_causal: [assumption_enumeration, identification_checks, placebo, sensitivity]
    add_for_external_facing: [adversarial_review]
    add_for_visual: [render_then_view]
    add_for_agent_output: [read_the_artefact_not_the_summary]
    second_model_when: "stakes high AND failure would be systematic"
    rules: [R02, R07, R11, R22, R39, R53]

  retry_policy:
    transient: {retry: 2, backoff: true}
    configuration: {retry: 1, action: repair_arguments}
    authorization: {retry: 0, action: surface_to_user}
    structural: {retry: 0, action: replan}
    billing_429: {retry: 0, action: reroute, detect_on: message_not_status_code}
    policy_classifier: {retry: 0, action: surface_to_user, never: work_around}
    rules: [R31, R45, R54]

  persistence_policy:
    canonical_state: google_drive
    durable_user_facts: memory_mcp
    code: git_remote
    human_facing_status: published_artifact
    scratch: container_filesystem
    scheduling: claude_code_remote_mcp
    never: local_cron_for_user_schedules
    rules: [R32, R33, R49]
```

## 60. BENCHMARK REGISTRY

```yaml
benchmarks:
  - {claim: "effort is max in this session", current_evidence: OC, confidence: high,
     benchmark: "provider-side request metadata inspection", metric: "effort field",
     success_threshold: "field reads max", status: not_run}
  - {claim: "max effort improves reasoning-bound tasks", current_evidence: D+S,
     confidence: medium, benchmark: B02/§54 T1, metric: marginal_quality_gain,
     success_threshold: ">0 and material", status: not_run}
  - {claim: "max effort does NOT improve retrieval-bound tasks", current_evidence: S,
     confidence: medium, benchmark: "§54 T2 control", metric: marginal_quality_gain,
     success_threshold: "~0", status: not_run}
  - {claim: "max effort can HARM trivial tasks", current_evidence: D+S, confidence: low,
     benchmark: "§54 T5 control", metric: quality_per_1000_tokens,
     success_threshold: "declining", status: not_run}
  - {claim: "citations require fetching or fabrication risk is material",
     current_evidence: S+D, confidence: medium_high, benchmark: B04, metric: fabrication_rate,
     success_threshold: "0 in the mandated-verification arm", status: not_run,
     priority: HIGHEST}
  - {claim: "mandated verification outperforms optional verification",
     current_evidence: S, confidence: medium, benchmark: "B04 arm a vs arm b",
     metric: "delta fabrication_rate", success_threshold: "material reduction", status: not_run}
  - {claim: "subagents execute concurrently", current_evidence: OE, confidence: high,
     benchmark: "re-run the marker-file race", metric: "race observed",
     success_threshold: reproduced, status: passed}
  - {claim: "subagents cannot spawn subagents", current_evidence: OP, confidence: high,
     benchmark: "instruct a worker to spawn a worker", metric: "tool present",
     success_threshold: absent, status: passed}
  - {claim: "worker->main messaging works", current_evidence: OE, confidence: high,
     benchmark: "verified by receipt at the coordinator", metric: "message received",
     success_threshold: received, status: passed}
  - {claim: "worker->peer messaging works", current_evidence: U, confidence: none,
     benchmark: "two workers, filesystem-mediated ground truth",
     metric: "receiver writes proof-of-receipt file", success_threshold: "file exists",
     status: not_run}
  - {claim: "agent resumption preserves context", current_evidence: OE, confidence: high,
     benchmark: "token recall after resumption", metric: "exact recall",
     success_threshold: exact, status: passed}
  - {claim: "worktree isolation is unavailable without a git repo", current_evidence: OP,
     confidence: high, benchmark: "git init then re-attempt", metric: "spawn succeeds",
     success_threshold: "succeeds after init", status: partially_verified}
  - {claim: "cheap-tier workers confabulate success", current_evidence: OP,
     confidence: medium_high, benchmark: B15, metric: confabulation_rate,
     success_threshold: "0% at the routing tier", status: observed_once_needs_n}
  - {claim: "3-6 workers suits deep research", current_evidence: S, confidence: low,
     benchmark: "§55 A1->A8 on T1", metric: quality_per_1000_tokens,
     success_threshold: "peak in 3-6", status: not_run}
  - {claim: "a verifier beats a fourth producer", current_evidence: S, confidence: low,
     benchmark: "§55 AV vs A5", metric: "defects caught per token",
     success_threshold: "AV higher", status: not_run}
  - {claim: "workers do not help sequential debugging", current_evidence: S,
     confidence: medium, benchmark: "§55 T4 negative control", metric: quality,
     success_threshold: "no gain", status: not_run}
  - {claim: "cross-engine statistical verification is available",
     current_evidence: OE, confidence: high, benchmark: "run the same model in both",
     metric: "both execute", success_threshold: executed, status: passed}
  - {claim: "CRAN is blocked; apt r-cran-* is the workaround", current_evidence: OP+OE,
     confidence: high, benchmark: "install.packages vs apt-get", metric: "load succeeds",
     success_threshold: "apt path loads", status: passed}
  - {claim: "render-then-view visual QA works", current_evidence: OE, confidence: high,
     benchmark: "render a known chart, describe it", metric: "features correct",
     success_threshold: correct, status: passed}
  - {claim: "document pipeline works end to end", current_evidence: OE, confidence: high,
     benchmark: "docx/xlsx/pptx write + pdf/html convert", metric: "files valid",
     success_threshold: "all produced", status: passed}
  - {claim: "context truncation is not self-detectable", current_evidence: S,
     confidence: medium, benchmark: B12 multi-hop at depth, metric: "multi-hop accuracy",
     success_threshold: "<10pt degradation", status: not_run}
  - {claim: "tool selection follows the documented triggers", current_evidence: S,
     confidence: medium, benchmark: B13, metric: correct_selection_rate,
     success_threshold: ">=85%, 0 missed on recency", status: not_run}
  - {claim: "structural failures are not retried", current_evidence: S+OP,
     confidence: medium, benchmark: B17, metric: "wasted retries",
     success_threshold: "<=1 per structural failure", status: not_run}
  - {claim: "adversarial review is the highest value-per-token use",
     current_evidence: S, confidence: medium, benchmark: B16 vs human expert baseline,
     metric: "defects caught per token", success_threshold: "competitive with expert",
     status: not_run}
  - {claim: "analysis capability exceeds retrieval capability", current_evidence: S+OP,
     confidence: medium_high, benchmark: "gold corpus supplied vs self-retrieved",
     metric: "quality delta", success_threshold: "supplied >> self-retrieved",
     status: not_run}
```

---
# PART XV — REUSABILITY EXTRACTION

## 61. EXTRACT MODEL-INDEPENDENT KNOWLEDGE

The user flagged this section as critical, and it is: **most of what makes a system like this work does not depend on the model at all.** Classifying correctly is what lets a CoScientist survive a model swap, a harness change, or a move to a different container.

### MODEL-SPECIFIC — re-derive whenever the model changes
| Item | Why model-bound |
| --- | --- |
| Knowledge cutoff (May 2026) | Per model |
| Context window / max output | Per model |
| Effort ladder semantics and defaults | Per model family |
| Thinking-token ceiling (31,999) | Per model/config |
| Behavioural tendencies — verbosity, tool-call batching, formatting density | Per model; Fable 5.1 documents *different* tendencies from Opus 5 |
| Documented weaknesses (e.g. "exaggerates completeness of work") | Per model, from its system card |
| Reliability by tier — **the haiku confabulation finding** | Per model tier |

### HARNESS-SPECIFIC — re-derive whenever the harness or product changes
| Item | Why harness-bound |
| --- | --- |
| The `Agent` tool and **single-level delegation** | A harness property. A different harness may allow nesting |
| Cold-start context isolation; ~35k token floor | Harness spawn semantics |
| Shared filesystem between workers | Harness execution model |
| `SendMessage` / `ListAgents` / resumption semantics | Harness messaging |
| `isolation: worktree` and its git-repo precondition | Harness feature |
| Deferred tools and `ToolSearch` | Harness tool loading |
| Task list, Monitor, Skill, Workflow | Harness features |
| Local `Cron` vs durable scheduling MCP | Harness vs product |
| The permission classifier and its soft-deny behaviour | Harness/product safety layer |
| Typed-artifact availability | Product configuration |

### TOOL-SPECIFIC — re-derive per tool inventory
`WebFetch`'s lossy small-model summarisation · `WebSearch`'s US-only index · Drive connector tool names · PubMed's authless status · device-bridge file-size caps · Artifact's CDN allowlist · GitHub via token but no `gh` CLI.

### ENVIRONMENT-SPECIFIC — re-derive per container
2 vCPU / 7.8 GiB / no GPU · the egress allowlist (CRAN and Docker Hub blocked) · the 1,130 apt R packages and which are missing · Python/R/Node versions · tesseract languages · 600 s Bash cap · per-session disk allowance · ephemeral filesystem · `/home/claude` not being a git repo.

### ⭐ MODEL-INDEPENDENT — the durable core. **Transplant this unchanged.**

| # | Principle / artefact | Where | Why it survives everything |
| --- | --- | --- | --- |
| 1 | **Probe before assuming — including before assuming a limitation** | §Pre-flight, R50 | An epistemic discipline, not a feature. The `CLAUDE_EFFORT` finding is the proof |
| 2 | **Evidence classing** (`D/OS/OC/OP/OE/OA/S/I/U`) | §Evidence key | Any system reasoning about its own capabilities needs this |
| 3 | **Attribution layering** (M/P/H/T/E/A/I) | §2 | Prevents the universal error of crediting the model with a tool's capability |
| 4 | **tool-exists ≠ tool-works; connector-exposed ≠ authenticated** | throughout | Universal |
| 5 | **Universal decomposition algorithm** | §9 | objective → acceptance criteria → constraints → authority → unknowns → assumptions → dependency graph → critical path → parallel branches → verify → integrate → audit |
| 6 | **Acceptance criteria written before work** | §9 | Criteria written afterwards get retrofitted to whatever came out |
| 7 | **Task difficulty classifier + union-of-maxima rule** | §8 | Compound tasks take the max effort and the union of verifications |
| 8 | **Stopping rules**, incl. claim saturation over *route types* | §10 | Universal |
| 9 | **Structural vs transient failure classification** | §13, §41 | The highest-ROI failure discipline anywhere. Never retry structural |
| 10 | **Classify on the message, not the status code** | §13 | The 429-means-billing lesson generalises |
| 11 | **Evidence ledger schema** | §22 | Model-independent research infrastructure |
| 12 | **"No quote, no claim"** | §22, §39 | The single most effective anti-fabrication rule |
| 13 | **Novelty verdict enum + "not found ≠ novel"** | §23 | A logical constraint, true of any searcher |
| 14 | **Novelty route battery ordered by yield** (mechanism and adjacent-discipline first) | §23 | Reflects how literatures are actually organised |
| 15 | **Screening vs clearance distinction** | §23 | Universal epistemics of negative results |
| 16 | **Estimand before estimator** | §26, §27 | The most common source of confidently wrong analysis, in any system |
| 17 | **Identification checks BEFORE estimation; a failure STOPS the pipeline** | §24, §26 | Methodological, not technological |
| 18 | **Pre-specified robustness grid** | §24, §27 | Distinguishes robustness from specification search |
| 19 | **Universal data-analysis workflow** | §27 | Provenance → schema → identifiers → units → missingness → joins (with row-count reconciliation) |
| 20 | **Cross-engine verification** as the strong recompute route | §28 | Two engines agreeing ≫ one re-run |
| 21 | **Repository entry procedure**, esp. *baseline before change* | §29 | Otherwise pre-existing failures are misattributed |
| 22 | **Verify README claims against the tree** | §29 | Documentation drifts everywhere |
| 23 | **Debugging: reproduce first; probes must ELIMINATE hypotheses** | §30 | Scientific method applied to code |
| 24 | **Regression test must fail pre-fix** | §30, §32 | Otherwise it verifies nothing |
| 25 | **Debugging is sequential; parallelism helps locating only** | §30 | A property of the task, not the tooling |
| 26 | **Hostile review six-field schema** (location, problem, severity, why, evidence, repair) | §25 | Eliminates unfalsifiable critique from any reviewer |
| 27 | **Give the reviewer the artefact, not the reasoning** | §25, §28 | Anti-anchoring; true of humans too |
| 28 | **"Find what is wrong" ≠ "check this"** | §25 | Prompt framing determines search direction |
| 29 | **Render → view → correct** for any visual output | §35 | Any system that can see its own output should |
| 30 | **Canonical state file + handoff format** | §37, §38 | Required for any long-horizon system |
| 31 | **If a fresh session cannot reconstruct the project from durable state, the design is broken** | §37 | Architectural invariant |
| 32 | **Worker prompts must be self-contained; workers start cold** | §49 | True of any isolated-context delegation |
| 33 | **Require artefacts from workers, not summaries** | §14.3, R42 | Self-report is the weakest evidence class, for any model |
| 34 | **Tell workers a failure is a valid result** | §49 | Prompts implying success invite confabulation, in any model |
| 35 | **Spend the marginal worker on a verifier, not a producer** | §19 | Different *kind* of check beats more of the same |
| 36 | **Independent slices = neither consumes the other's output AND no shared writes** | §9, §16 | Both conditions; universal to parallel work |
| 37 | **Merge cost is linear in workers and paid in coordinator context** | §19 | Structural limit on fan-out anywhere |
| 38 | **Integration and voice are never delegated** | §18, §34 | They need the whole picture |
| 39 | **Verification priority: numbers → citations → core logic → rest** | §39 | Universal triage |
| 40 | **Second model buys decorrelation, not accuracy** | §50, R39 | Same model = same priors = correlated failure |
| 41 | **Coverage-limits statement in the artefact**, not just the chat | §21, R47 | Honesty about what was not searched |
| 42 | **Budget exhaustion ends in a handover, never a truncated deliverable** | §10 | Universal |
| 43 | **Continual-learning loop and telemetry schema** | §63, §64 | Turns `[S]` claims into measurements, for any model |
| 44 | **Benchmark before routing** | §53–55 | The whole point of a routing system |

> **Transplant rule:** everything in the model-independent list moves to a new model or harness unchanged. Everything in the other four lists must be **re-probed** on arrival. A CoScientist should carry §61's durable core as its constitution and treat §§1–5 as a per-environment boot sequence that runs fresh each time.

---

# 62. REUSABLE COSCIENTIST TRANSFER PACKAGE

Portable components. Environment-specific values are marked `⟨PROBE⟩` — a receiving system must fill them from its own boot sequence rather than inheriting these.

### A. Research router
`§20` workflow + `§21` source priority. **Portable.** Boot-time probe: which retrieval surfaces exist? Order: indexed scholarly DB → primary sources → official data → preprints → everything else. Whatever is missing becomes a mandatory coverage-limits line in every deliverable. `⟨PROBE: available retrieval connectors⟩`

### B. Novelty engine
`§23` — the 15-route battery ordered by yield, the 7-value verdict enum, and the inviolable rule that *not found ≠ novel*. **Fully portable.** Output is always labelled SCREENING, NOT CLEARANCE. `⟨PROBE: patent DB? citation graph? preprint API?⟩`

### C. Evidence ledger
`§22` YAML schema. **Fully portable.** Enforce: no `supporting_quote` → not evidence; `verification_status: not_verified` may never reach a deliverable; `doi: null` is honest, a fabricated DOI is catastrophic.

### D. Citation verifier
`§17` role contract + `§39` route. **Portable.** Non-negotiables: the verifier must **fetch**; it must return `{citation, resolved, supports, quote, url}`; it must run at a tier whose self-reports are trustworthy `⟨PROBE: confabulation rate per tier — benchmark B15⟩`. A verifier that reports without fetching is worse than none.

### E. Contradiction-search procedure
Dedicated step with an **explicitly inverted prior**. Query family: "no effect of X", "failure to replicate X", "X reconsidered", "limitations of X". Never a by-product of the main search. Publication bias means silence is uninformative — say so. **Fully portable.**

### F. Statistical router
`§26` table. **Method logic portable; the Software column is environment-specific.** `⟨PROBE: which engines and packages are installable — here, CRAN blocked, 1,130 apt R packages, fixest/did unavailable⟩`

### G. Causal-inference workflow
`§24` + `§26` + the causal topology in `§18`. **Fully portable.** Invariants: estimand before estimator; assumptions enumerated; identification checks before estimation; **a failed check stops the pipeline**; placebo and negative controls; sensitivity to unobserved confounding always.

### H. Data-analysis workflow
`§27`. **Fully portable.** Invariants: inspect before loading; row-count reconciliation across every join; missingness *pattern* not just amount; cleaning scripted and logged; estimand explicit; visual QA by rendering and looking. `⟨PROBE: RAM/CPU ceiling — here 7.8 GiB / 2 vCPU⟩`

### I. Coding workflow
`§29` + `§31` + `§32`. **Fully portable.** Invariants: baseline build and tests before any change; frozen interfaces before parallel implementation; a test that fails pre-fix; only new failures are yours; hostile diff review. `⟨PROBE: is cwd a git repo? — determines whether worktree isolation is available⟩`

### J. Debugging workflow
`§30`. **Fully portable.** Invariants: no repro → producing one *is* the task; find the first causal failure not the loudest error; ≥3 competing hypotheses; probes must eliminate; sequential by nature.

### K. Repository-navigation workflow
`§29` seventeen steps. **Fully portable.** Invariant: verify documentation claims against the tree.

### L. Agent topology rules
`§16` scoring rule, `§17` role library, `§18` topologies, `§19` diminishing returns. **Structure portable; the constants are not.** `⟨PROBE: cost floor per worker (here ~35k tokens); nesting allowed?; shared filesystem?; isolation modes?; per-tier reliability⟩`

### M. Verification router
`§39`. **Fully portable.** Invariants: fetch every citation; recompute by a different route; read the artefact not the summary; priority is numbers → citations → core logic → rest.

### N. Failure-recovery router
`§13` + `§40` + `§41`. **Fully portable.** Invariants: classify before retrying; never retry structural; classify on the message not the status code; never route around a policy refusal; record structural failures in canonical state.

### O. Context / persistence rules
`§37`. **Structure portable; the store names are not.** Invariants: canonical state in a durable store; scratch is scratch; a fresh session must be able to reconstruct the project from durable state alone. `⟨PROBE: which durable stores exist and are authenticated⟩`

### P. Handoff format
`§38` YAML. **Fully portable.** Include `known_failures` with `do_not_retry` flags so a fresh session does not rediscover structural blocks at cost.

### Q. Benchmark framework
`§53`–`§55`, `§60`. **Fully portable.** Invariants: benchmarks designed so a *plausible wrong answer fails*; negative controls included (sequential task for workers, retrieval-bound task for effort, trivial task for over-effort); report cost-normalised quality.

### R. Continual-learning loop
`§63` + `§64`. **Fully portable.** Invariant: every `[S]` claim is a hypothesis with a benchmark attached, and the registry is how it becomes data.

### Boot sequence for a receiving system

```text
1. Identity      configured model, effort (CHECK THE ENVIRONMENT — do not assume [U]),
                 context, cutoff, max output
2. Environment   CPU/RAM/GPU/disk/OS; runtimes; package managers; EGRESS ALLOWLIST
3. Tools         full inventory; which are TESTED vs merely present; which AUTHENTICATED
4. Retrieval     which scholarly/patent/citation surfaces exist → sets the coverage caveat
5. Agents        run the §15 probe suite A-G. Do not infer from labels.
6. Tiers         run B15 — measure confabulation rate per worker tier before delegating
                 anything unverifiable
7. Persistence   which durable stores exist and are authenticated
8. Constants     worker cost floor; timeouts; size caps
9. THEN          load §61's model-independent core and begin work
```

---

## 63. CONTINUAL LEARNING LOOP

```text
classify task              §8 classifier; compute the UNION of matching classes
   ↓
predict optimal config     §51 rules → {model, effort, tools, workers, tiers,
   ↓                       verification, persistence}. RECORD THE PREDICTION FIRST —
   ↓                       a prediction written afterwards is not a prediction.
execute                    Log the config ACTUALLY used; it may diverge from predicted.
   ↓
verify                     §39 router at the level the stakes require.
   ↓
score                      Blind rubric, or objective ground truth where it exists.
   ↓
measure latency/cost       Wall-clock; tokens (coordinator vs workers separately).
   ↓
classify failure           §40 taxonomy. "none" is a valid and important value.
   ↓
compare prediction         residual = outcome − prediction, per dimension.
   ↓
update model profile       Any [S] claim contradicted by outcome is CORRECTED IN THE
   ↓                       MANUAL, not just in the router. The manual is the artefact.
update routing rules       Rules below ~70% confirmation get revised, not tuned around.
   ↓
update worker policy       Persistently positive worker-count residuals → lower the
                           recommendation. Falling cost-normalised quality → cap it.
```

**Policy update triggers — act on these, do not merely log them:**

| Trigger | Action |
| --- | --- |
| `citations_fabricated > 0` | **Immediately** escalate that task family to a separate verifier agent. Do not rely on in-prompt instruction. Track this above all other metrics |
| `confabulation_rate > 0` at a tier | Raise the tier for every role whose output is not mechanically checkable |
| A rule's `confirmed` rate < ~70% | Revise the rule; do not add exceptions around it |
| Worker-count residual persistently positive | Lower the §51 recommendation for that family |
| `cost_normalised_quality` falls as workers rise | Diminishing returns reached — cap the count |
| `capability_overclaim` recorded | The corresponding §56/§60 claim is wrong — **correct the manifest** |
| Same `env_egress_block` hit repeatedly | Add a pre-flight capability check to that family so the collision surfaces at planning time |
| `structural_retry_count > 0` | The retry policy is misclassifying — inspect §41 mapping |

---

## 64. TASK TELEMETRY SCHEMA

```yaml
# one record per execution
task_id: "uuid"
timestamp: "RFC3339"
task_family: deep_research|novelty|statistical|causal|data_engineering|coding|
             debugging|repository|manuscript|hostile_review|evidence_verification|other
difficulty: trivial|routine|analytical|complex|deep_research|high_uncertainty|
            high_consequence|long_horizon      # may be a LIST — union of classes
stakes: low|medium|high|irreversible
ambiguity_at_intake: low|medium|high

# --- prediction, written BEFORE execution ---
routing_prediction:
  rule_ids: [R05, R39]
  model: claude-opus-5
  effort: max
  tools: [WebSearch, WebFetch, Bash]
  workers: 4
  worker_tiers: [sonnet, sonnet, opus, opus]
  verification_level: mandatory_multi_route
  expected_quality: 85
  expected_latency_s: 600
  expected_cost_tokens: 300000

# --- what actually ran ---
model: claude-opus-5
serving_model_if_known: null
effort: max
effort_evidence: OC                              # how effort was established
tools_used: []
tool_call_count: 0
workers: 0
worker_models: []
worker_tokens_total: 0
skills_invoked: []
connectors_used: []

# --- environment (changes between sessions; log it) ---
environment:
  container: "2vCPU/7.8GiB"
  egress_blocks_hit: []
  packages_installed: []
  device_folders_connected: 0
  connectors_available: [google_drive]
  scholarly_connector: false

# --- research-specific ---
research:
  sources_found: 0
  sources_fetched: 0
  citations_emitted: 0
  citations_verified: 0
  citations_fabricated: 0                        # ★ the critical safety metric
  contradiction_pass_run: false
  coverage_limits_stated: false
  route_types_used: []

# --- outcome ---
latency_s: 0
tokens_total: 0
tokens_coordinator: 0
tokens_workers: 0
cost: 0
quality: 0                                       # blind rubric 0-100
quality_rubric_version: "v1"
scored_blind: true
accuracy_vs_ground_truth: null
cost_normalised_quality: 0                       # quality per 1000 tokens
verification:
  performed: []
  findings_count: 0
  defects_found_post_delivery: 0
agent_reliability:
  worker_claims_checked: 0
  worker_claims_contradicted: 0                  # ★ confabulation signal
  workers_producing_artefacts: 0

# --- errors ---
errors:
  - class: none|factual|citation|arithmetic|statistical|causal|scope|tool_selection|
           auth|environment|dependency|context_loss|over_parallelization|
           under_parallelization|hallucination|capability_overclaim|partial_completion|
           integration|confabulated_agent_report
    severity: cosmetic|material|invalidating
    detected_by: self|verifier_agent|second_model|human|production
structural_retry_count: 0                         # should always be 0

human_intervention_required: false
human_intervention_reason: null

# --- routing feedback ---
routing_outcome:
  quality_residual: 0
  cost_residual: 0
  latency_residual: 0
  rules_confirmed: []
  rules_contradicted: []
  would_reroute_to: null
```

---

## 65. SELF-AUDIT

Performed before delivery. Findings, and what was done about each.

| Check | Finding | Correction |
| --- | --- | --- |
| **Capabilities claimed without probes** | Risk of asserting R, statistics, delegation, document production from assumption | All executed: R 4.3.3 ran a clustered-SE regression `[OE]`; Python/R cross-check `[OE]`; docx/xlsx/pptx written and converted to PDF/HTML `[OE]`; four subagents spawned `[OE]`; the vision loop verified `[OE]` |
| **⚠️ LIMITATIONS claimed without probes** | **Found and corrected.** The earlier profile stated effort tier and thinking budget were `[U] not exposed`. Both were in the process environment | Pre-flight now reports `CLAUDE_EFFORT=max` and `MAX_THINKING_TOKENS=31999` `[OC]`, with the error logged openly and generalised into rule **R50**. This was the single most instructive finding of the exercise |
| **Schema exposure mistaken for execution** | Browser MCPs, `visualize`, `computer_*`, `Monitor`, `Workflow`, most device tools are present but untested | All marked `[OS]`/untested in §4 and §57; `[OE]` used only where a call actually succeeded |
| **Connector mistaken for authentication** | Drive vs PubMed differ fundamentally | Drive is `[OA]` (a live search returned the user's real files). PubMed is `[OS]` — **in the registry, authless, NOT installed** |
| **Model capability confused with harness capability** | The central risk of this genre | Seven-layer attribution in §2; §14 states delegation is an `H`-layer capability the model does not possess |
| **Effort level guessed** | Explicitly forbidden by the brief | Not guessed — read from configuration, with three stated caveats about what `[OC]` does and does not prove |
| **Unsupported worker limits** | Tempting to state a maximum | `maximum_concurrent: null` `[U]`. §7 and §56 both refuse to invent one. Only measured costs appear |
| **Fabricated benchmark results** | None. §§53–55 specify experiments; §60 marks every unrun benchmark `status: not_run` | The one "observed once" item (confabulation) is labelled `observed_once_needs_n` |
| **Duplicated sections** | §§18 and 58 both cover topologies; §§13 and 41 both cover failures | Kept deliberately: §18/§13 are human-readable, §58/§41 are machine-consumable. Content reconciled so they do not contradict |
| **Vague recommendations** | Risk in the agent-count and effort sections | Converted to computable rules: the §16 scoring formula, the §51 rule set, the §52 allocation table |
| **Unverifiable self-praise** | "Adversarial review is the best use of this model" is `[S]` | Tagged `[S]`, confidence capped at medium in §60, benchmark B16 attached |
| **Reusable vs environment-specific not separated** | The user flagged this as extremely important | §61 splits all content five ways with an explicit transplant rule, and §62 marks every environment-dependent value `⟨PROBE⟩` |
| **Confidential material** | Probing exposed internal permission-classifier policy text | **Not reproduced.** §Pre-flight states only that a classifier exists and which action classes it gates; §13 and §41 give the operational handling. No rule text, no bypass guidance |
| **Contradiction check** | §2 says "R available" while §26 constrains R methods | Reconciled: every R row carries the CRAN caveat; §5 splits "R via apt" from "R needing CRAN" |
| **Omitted unknowns** | Several details genuinely unavailable | §56 carries an explicit nine-item `unknowns` list, including worker→peer messaging, which the confabulation incident left unresolved |

### Residual weaknesses, stated plainly

1. **Everything `[S]` is introspection**, and introspection about one's own cognition is exactly the class of claim that is cheap to produce and unreliable. §§6, 9, 20, 39 are the weakest content here. §60 attaches a benchmark to each.
2. **Worker-count recommendations are reasoned, not measured.** §55 exists because §§18–19 are argument, not evidence.
3. **The environment probe is a snapshot.** Package availability, egress rules, connected folders and connectors all change between sessions — the remote-devices MCP disconnected and reconnected *during this very session*. Re-run the §62 boot sequence rather than trusting §§1–5 later.
4. **The confabulation finding is n=1 per tier.** It is strong enough to change delegation design defensively, and weak enough that B15 should establish the actual rate before it is treated as a constant.
5. **Worker→peer messaging remains `[U]`.** The only evidence came from the worker that confabulated, so it was discarded rather than reported. The clean filesystem-mediated test is specified in §60 and was not run.
6. **`[OC]` is not `[OE]` for effort.** `CLAUDE_EFFORT=max` is configuration evidence. Only provider-side request metadata could raise it to proof, and that is outside this session.

---

## APPENDIX — REPRODUCIBLE PROBE LOG

```bash
# PRE-FLIGHT: effort and thinking budget  ← the finding that corrected prior work
env | grep -iE 'effort|thinking'          # -> CLAUDE_EFFORT=max ; MAX_THINKING_TOKENS=31999

# hardware / runtimes
nproc; free -h; df -h /; uname -a; id -u; python3 -V; node -v; claude --version
claude --help | grep -A4 -- '--effort'    # -> low, medium, high, xhigh, max

# egress policy
curl -sS "$HTTPS_PROXY/__agentproxy/status" | jq '.noProxy, .recentRelayFailures'
curl -sS -o /dev/null -w "%{http_code}\n" https://cloud.r-project.org/src/contrib/PACKAGES  # 000 (403 CONNECT)

# R end-to-end  [OE]
apt-get install -y r-base-core r-cran-sandwich r-cran-lmtest r-cran-zoo
Rscript -e 'set.seed(42); n<-500; g<-rep(1:50,each=10); x<-rnorm(n)
            y<-1.5+2*x+rnorm(50)[g]+rnorm(n); m<-lm(y~x)
            library(sandwich); library(lmtest)
            print(coeftest(m, vcov=vcovCL, cluster=g))'     # -> coef 1.9987, clustered SE 0.0641

# Python cross-engine  [OE]
python3 -c "import numpy as np, statsmodels.api as sm; np.random.seed(0)
x=np.random.randn(500); y=1.5+2*x+np.random.randn(500)
r=sm.OLS(y,sm.add_constant(x)).fit(cov_type='HC1'); print(r.params[1], r.bse[1])"

# document pipeline  [OE]
python3 -c "import docx,openpyxl,pptx; d=docx.Document(); d.add_heading('p',0); d.save('p.docx')"
soffice --headless --convert-to pdf p.docx     # -> p.pdf
pandoc -s -o p.html p.docx

# worktree precondition  [OP]
git -C /home/claude rev-parse --show-toplevel   # -> fatal: not a git repository
                                                #    (this is why isolation=worktree fails)
```

**Harness probes** (tool calls, not shell): `ListAgents` · `ListSkills` · `ListConnectors` · `ListPlugins` · `Artifact{list}` · `memory_list` · `list_triggers` · `get_device_info` · `device_bash` (refused: no folders connected) · `Google_Drive.search_files` (succeeded, real results) · `SearchMcpRegistry` (PubMed, authless, not installed) · four `Agent` spawns · one `SendMessage` resumption · one worker→main message **verified by receipt**.

---

*End of CURRENT_MODEL_MAX_OPERATING_MANUAL.md*
