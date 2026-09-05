# MODEL_OPERATIONAL_PROFILE.md

**Profile date:** 2026-09-03 (UTC) · **Profiled by:** the session being profiled · **Method:** direct probing of the live environment, not recollection.

## How to read this document

Every material statement carries an evidence class:

| Tag | Meaning |
| --- | --- |
| `[D]` | **Documented** — from provider docs, environment documentation, or a tool's own schema/description. |
| `[O]` | **Observed** — directly tested in *this* session; the probe and its result are recorded. |
| `[S]` | **Self-described** — my operational account of my own behaviour. Not externally verified. |
| `[I]` | **Inferred** — reasonable but not directly verified. |
| `[U]` | **Unknown / not exposed / not available.** |

`[S]` is the weakest class in this document and should be treated by an orchestrator as a **hypothesis to benchmark**, not a specification. Sections 40 and 41 list which claims need external testing.

### Layer discipline

Throughout, capabilities are attributed to one of seven layers. An orchestrator that conflates them will mis-route work.

| Layer | Name | Example in this session |
| --- | --- | --- |
| L1 | Base model | Reasoning, language, vision decoding |
| L2 | Product/application | Cowork mode in the Claude desktop app |
| L3 | Agent harness | Claude Agent SDK: Agent/Task/Monitor/Skill tools, tool-deferral |
| L4 | Connected tools | Bash, Read/Write/Edit, WebSearch, WebFetch, Artifact |
| L5 | External integrations | Google Drive MCP connector, remote-devices bridge, browser MCPs |
| L6 | Permissions/auth | Google OAuth (connected), device folder grants (none), egress allowlist |
| L7 | Infrastructure | 2-vCPU / 7.8 GiB Firecracker-class VM, agent HTTPS proxy |

I will not say "the model can read Google Drive." I will say "L5 exposes a Google Drive connector the model can invoke, authorised at L6."

---

# 1. MODEL IDENTITY

| Field | Value | Class |
| --- | --- | --- |
| Provider | Anthropic | `[D]` |
| Model family | Claude | `[D]` |
| Configured model ID | `claude-opus-5` (display name "Opus 5") | `[D]` environment declaration |
| Actually-serving model | **Not verifiable from inside the session.** The environment states the serving model may differ from the configured ID and may change mid-session (runtime fallback or model switch). | `[D]` + `[U]` |
| Interface / application | Cowork mode, Claude desktop app (client reported as `desktop`), built on the Claude Agent SDK. **Not** Claude Code, despite shared tooling lineage. | `[D]` |
| Execution environment | Ephemeral Anthropic-hosted cloud sandbox (Linux VM), optionally bridged to one linked user computer | `[D]`+`[O]` |
| Session identifier | `claude-72 [916604]` | `[O]` via ListAgents |
| Knowledge cutoff | May 2026 (environment declaration); provider docs list May 2026 for `claude-opus-5` | `[D]` |
| Context window | 1M tokens per provider docs for `claude-opus-5` | `[D]` — **not** independently verified in-session |
| Max output tokens | 128K per provider docs | `[D]` — not verified |
| Session token budget | Session began with a declared 15,000,000-token allowance, decremented per turn and visible to me. This is a **session budget**, distinct from the context window. | `[O]` |
| Input modalities | Text; images (verified); PDF pages rendered as images via the Read tool; audio/video **not** accepted as direct model input in this session | `[O]` |
| Output modalities | Text only from the model. Any image/audio/video/binary artefact is produced by **L4 code execution**, not by the model emitting pixels. | `[O]` |
| Reasoning mode | Provider docs describe "adaptive thinking" for `claude-opus-5`, default effort `high` | `[D]` |
| Reasoning-effort control | Docs describe an effort setting for this family. **I cannot read or set my own effort level from inside the session.** A harness tool (`ReportFindings`) exposes an effort enum `low / medium / high / xhigh / max`, evidencing that effort tiers exist in this stack. | `[D]` + `[O]` schema + `[U]` for my own current value |
| Sibling models reachable as subagents | `sonnet`, `opus`, `haiku`, `fable` (Agent tool `model` enum) | `[O]` |

**Provider model table** (fetched live from `platform.claude.com/docs/en/models/overview` during this session) `[D]`:

| Model | ID | Context | Max output | Cutoff | Thinking |
| --- | --- | --- | --- | --- | --- |
| Claude Fable 5.1 | `claude-fable-5-1` | 1M | 128K | Jun 2026 | Adaptive, default `high` |
| **Claude Opus 5** | **`claude-opus-5`** | **1M** | **128K** | **May 2026** | **Adaptive, default `high`** |
| Claude Sonnet 5 | `claude-sonnet-5` | 1M | 128K | Jan 2026 | Adaptive, default `high` |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | 200K | 64K | Feb 2025 | Extended thinking; effort setting unsupported |

### Knowledge characteristics
- Reliable to ~May 2026 `[D]`. Anything after that must come from L4 search/fetch, not recall `[S]`.
- Parametric recall of **exact** bibliographic strings (DOIs, page numbers, volume/issue, author initials) is unreliable at any date and must be treated as a generation risk, not a lookup `[S]` — see §29.
- Numeric arithmetic beyond a few significant figures should be executed, not recalled `[S]`.

---

# 2. CURRENT ENVIRONMENT

All rows probed during this session unless marked otherwise.

| Capability | Available Now | Provided By | Notes | Evidence |
| --- | --- | --- | --- | --- |
| Web search | **Yes** | L4 `WebSearch` | Returns titles+URLs, US-only index; requires a follow-up fetch for content | `[O]` executed |
| Web browsing / URL fetch | **Yes** | L4 `WebFetch` | Converts page→markdown, answers a prompt against it using a **small fast model** (lossy: I see a summary, not raw HTML). Fails on authenticated URLs. Cross-host redirects returned, not followed. 15-min per-URL cache. | `[O]` executed; redirect behaviour observed |
| Raw HTTP from shell | **Restricted** | L4 Bash + L7 proxy | `curl`/`wget` exist, but policy forbids using them to retrieve web content that WebFetch/WebSearch declined | `[D]` policy; `[O]` tooling present |
| Interactive browser (user's Chrome) | Tools present, **untested** | L5 `mcp__claude-in-chrome__*` | Deferred; requires user's Chrome + extension running | `[D]` tool list; `[U]` liveness |
| Interactive browser (in-app pane) | Tools present, **untested** | L5 `mcp__remote-devices__Claude_Browser__*` | Deferred; requires desktop app online. Preferred browser per environment policy | `[D]`; `[U]` liveness |
| Code execution | **Yes** | L4 `Bash` | Persistent VM across turns; no cwd/env carry-over between calls | `[O]` |
| Python | **Yes — 3.11.15** | L7 image | See library inventory below | `[O]` |
| R | **Yes, after install** | L7 apt | **Not preinstalled.** `apt-get install r-base-core` → R 4.3.3 installed successfully. See the CRAN caveat below — this is the single most important finding in this section. | `[O]` |
| Shell / terminal | **Yes** | L4 `Bash` | Runs as `root`. Default timeout 120 s, max 600 s per call | `[O]` |
| Filesystem | **Yes** | L4 Read/Write/Edit/Glob/Grep + Bash | Cloud container only; persists for the session | `[O]` |
| Git | **Yes** | L7 `git` + L6 proxy git config injection | `git clone` over HTTPS verified against github.com | `[O]` |
| GitHub | **API yes, CLI no** | L6 `GITHUB_TOKEN` env | `gh` CLI **absent**; `api.github.com` reachable with the injected token (core limit 15,000/hr observed) | `[O]` |
| Cloud storage | **Google Drive only** | L5 Google Drive MCP connector | `installState: connected`, `enabledInChat: true`. Search verified against the user's real Drive. Tools: search, read, download, create, update, copy, share, trash, permissions, recent | `[O]` |
| Databases | **Client partly, no server** | L7 | `psql` client present; **no** sqlite3 CLI, mysql, or duckdb CLI. No DB server running. Python `sqlite3` stdlib available; `sqlalchemy`/`psycopg2`/`duckdb` absent (pip-installable) | `[O]` |
| APIs (generic) | **Yes, allowlisted** | L4 Bash/Python + L7 proxy | Egress is allowlisted — see §2.1 | `[O]` |
| MCP servers | **4 connected** | L5 | `memory`, `remote-devices` (incl. `Claude_Browser`), `claude-code-remote`, `visualize`, plus `Google_Drive` and `claude-in-chrome` | `[O]` |
| Connectors/plugins | 1 connector, **0 plugins** | L5 | `ListPlugins` → empty | `[O]` |
| PDFs | **Read + write** | L4 Read (renders pages as images) + `pypdf`, `pdfplumber`, `pdf2image`, `reportlab`, `pdf` skill | No PyMuPDF (`fitz`) | `[O]` |
| Word documents | **Yes** | `python-docx`, `pandoc`, LibreOffice, `docx` skill | | `[O]` |
| Spreadsheets | **Yes** | `openpyxl`, `xlsxwriter`, `pandas`, LibreOffice, `xlsx` skill | | `[O]` |
| Presentations | **Yes (file only)** | `python-pptx`, LibreOffice, `pptx` skill | No typed "Slides" artifact in this session — see below | `[O]` |
| Image understanding | **Yes** | L1 vision via L4 Read | Verified: rendered a matplotlib event-study chart, read it back, correctly described the discontinuity, axis ranges, and title | `[O]` |
| Image generation | **No generative model.** Programmatic rendering only | L4 code | matplotlib/PIL/reportlab/SVG/HTML→screenshot. No text-to-image model in this session | `[O]` |
| OCR | **Yes, English only** | `tesseract` 5 + `pytesseract` | Installed languages: `eng`, `osd` only. Non-Latin/other languages need a language pack install | `[O]` |
| Audio | **Processing yes, understanding no** | `ffmpeg` | No ASR model (`whisper`, `librosa`, `soundfile` all absent); audio is not a model input modality here | `[O]` |
| Video | **Processing yes, understanding no** | `ffmpeg`, `imageio` | Can decode/transcode/extract frames; frames can then be read as images | `[O]` |
| Scheduled tasks | **Yes** | L5 `mcp__claude-code-remote__*` | `create_trigger` / `send_later` / `list_triggers` / `update_trigger` / `delete_trigger` / `fire_trigger`. Currently **0 triggers**. Each firing starts a **fresh session** | `[O]` |
| Background execution | **Yes, three forms** | L3/L4 | (a) `nohup`-style detach inside a Bash call — verified; (b) `Monitor` tool streaming stdout lines as events; (c) async Agent tasks | `[O]` for (a); `[D]` for (b),(c) |
| Persistent memory | **Yes** | L5 `mcp__memory__*` | Cross-surface user memory filesystem. 13 files present, all under `/areas/`. No `/profile.md` or `/preferences.md` | `[O]` |
| Persistent project state | **Partial** | L5 | Google Drive + published Artifacts + memory persist across sessions. The **container filesystem does not** | `[O]`/`[D]` |
| Subagents | **Yes** | L3 `Agent` tool | 6 declared types. Verified live — see §7 | `[O]` |
| Parallel workers | **Yes, genuinely concurrent** | L3 | Two subagents in one block ran simultaneously; proven by a filesystem race (§7) | `[O]` |
| Typed artifacts (Slides/Sheets/Pages/Design/Whiteboard/Tasks) | **No** | L4 Artifact | This session's Artifact schema exposes no `list_types` action. Only HTML/Markdown publishing. Decks/sheets must be produced as files via the pptx/xlsx skills | `[O]` |
| Artifact publishing + DB + assets | **Yes** | L4 Artifact | publish/read/list/watch/comments/reply/resolve, `read_db`/`write_db`, asset upload. 5 artifacts already published by this user | `[O]` |
| User's computer (files) | **Bridge live, zero access granted** | L5 remote-devices + L6 | Device `jawad`, win32, desktop app 1.44121.4. `connectedFolders: []`. `device_bash` **refuses**: "No folders are connected." 33 home-dir names visible (incl. `Zotero`, `PycharmProjects`, `Downloads`) but no contents | `[O]` |
| User's computer (GUI control) | Tools present, **not authorised** | L5 `computer_*` | Two-phase: `computer_resolve_access` → `computer_request_access` → user approval. Not attempted | `[D]` |
| Local MCP servers on device | **None** | L5 | `localMcpServers: []` | `[O]` |
| Docker | **CLI only** | L7 | `docker` binary present; **daemon not running**; `download.docker.com` blocked by proxy | `[O]` |
| GPU / accelerators | **None detected** | L7 | 2 vCPU, no GPU libraries (torch/tf/jax all absent) | `[O]`/`[I]` |

## 2.1 Network egress — the binding constraint

Outbound HTTPS goes through a mandatory agent proxy with an **allowlist**. Disabling TLS verification or unsetting the proxy is forbidden.

**Verified allowed** `[O]`: `pypi.org`, `files.pythonhosted.org`, `registry.npmjs.org`, `jsr.io`, `index.crates.io`, `proxy.golang.org`, `api.anthropic.com`, `mcp-proxy.anthropic.com`, Debian apt repositories, `github.com` (clone), `api.github.com`.

**Verified BLOCKED** — gateway returns `403` to `CONNECT` `[O]`:

| Host | Consequence |
| --- | --- |
| `cloud.r-project.org` (**CRAN**) | `install.packages()` **fails**. Any R workflow assuming CRAN will break. |
| `download.docker.com` | No Docker engine install. |

### The CRAN workaround (important, verified)
Debian's R package archive **is** reachable through apt. `apt-cache search '^r-cran-'` returns **1,130 packages** `[O]`. Verified end-to-end: `apt-get install r-cran-sandwich r-cran-lmtest r-cran-zoo` → both libraries load in R `[O]`.

Confirmed available via apt `[O]`: `plm`, `AER`, `lme4`, `survival`, `metafor`, `mice`, `quantreg`, `tseries`, `vars`, `urca`, `sem`, `lavaan`, `brms`, `rstan`, `mgcv`, `glmnet`, `randomForest`, `xtable`, `broom`, `tidyverse`, `rmarkdown`, `knitr`, `data.table`, `dplyr`, `ggplot2`, `forecast`, `car`, `caret`, `clubSandwich`.

Confirmed **NOT** available via apt and **not** installable (CRAN blocked) `[O]`: `fixest`, `did`, `stargazer`, `modelsummary`.

> **Routing consequence:** an R plan that depends on `fixest` or Callaway–Sant'Anna `did` **cannot run here**. Substitute `plm` + `clubSandwich` + `lmtest`/`sandwich`, or move the estimation to Python (`statsmodels`, `linearmodels` — both pip-installable), or move R execution to an environment with CRAN.

## 2.2 Hardware and runtime inventory `[O]`

- Kernel `6.18.44-fc-v24` x86_64, hostname `vm`, running as `root`.
- **2 vCPU, 7.8 GiB RAM, no swap.** Disk shows 252 G with ~30 G available, but the environment documents disk as a *fixed per-session allowance* — `df` is misleading; "no space left" with low `Used` means the allowance is spent, and deletes still succeed.
- Runtimes: Python 3.11.15, Node v22.22.2 / npm 10.9.7, Go, Rust+cargo, gcc, make, Java, R 4.3.3 (post-install).
- Tools: `git`, `curl`, `wget`, `jq`, `pandoc` 3.1.3, LibreOffice 24.2.7.2, `tesseract` 5, `ffmpeg`, `psql`.
- Absent: `gh`, `sqlite3` CLI, `mysql`, `duckdb` CLI.
- Playwright pre-provisioned at `/opt/pw-browsers` (chromium + headless shell + ffmpeg). Do **not** run `playwright install`.
- Python present: numpy, pandas, scipy, scikit-learn, matplotlib, seaborn, openpyxl, xlsxwriter, python-docx, python-pptx, pypdf, pdfplumber, Pillow, bs4, lxml, requests, httpx, networkx, tabulate, reportlab, markdown, jinja2, playwright, pdf2image, pytesseract, imageio.
- Python absent but pip-installable (PyPI allowed) — **`statsmodels` install verified live (0.15.0)**: statsmodels, plotly, sympy, pyarrow, duckdb, polars, sqlalchemy, psycopg2, linearmodels, lifelines, pymc, arviz, cvxpy, nltk, spacy, geopandas, shapely, xarray, h5py, pytest, ruff, mypy.
- Python absent and **impractical here**: torch, tensorflow, jax, transformers — no GPU, 7.8 GiB RAM, and multi-GB downloads against a per-session disk allowance.

## 2.3 Environment credentials — caution `[O]` + `[U]`

`GITHUB_TOKEN`/`GH_TOKEN` (verified working), plus `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `CLOUDSDK_AUTH_ACCESS_TOKEN` are set in the shell environment. The GitHub token is verified. **The AWS and Google Cloud variables are proxy/harness scaffolding; I did not test them and make no claim that they grant usable cloud access.** An orchestrator must not treat this session as having AWS or GCP capability. `[U]`

---
# 3. CAPABILITY OVERVIEW

Strength is my own graded self-assessment `[S]` unless a probe backs it. "Execution capability" is the harder, more useful column: whether this session can actually *do* the thing rather than reason about it.

| Domain | Strength | Execution Capability | Tool Dependency | Confidence | Evidence |
| --- | --- | --- | --- | --- | --- |
| General reasoning | High | Native, no tools | None | High | `[S]` |
| Mathematics (symbolic) | High for derivation; **unreliable for exact arithmetic without execution** | Full — Python; `sympy` pip-installable | Bash | High on the limitation | `[S]`+`[D]` |
| Scientific reasoning | High for mechanism, design, critique | Conceptual only — **no wet lab, no instruments** | None | High | `[S]` |
| Literature research | High analytic; **retrieval is the bottleneck** | Partial — WebSearch/WebFetch only; no PubMed/Scopus/Crossref/OpenAlex connector in this session | WebSearch, WebFetch | Medium | `[O]` tool inventory |
| Novelty analysis | High at structuring the search; **cannot prove a negative** | Partial — same retrieval ceiling | WebSearch, WebFetch, subagents | Medium | `[S]`+`[O]` |
| Statistical analysis | High | **Full** — Python verified; R installable with the CRAN caveat | Bash | High | `[O]` |
| Causal inference | High conceptually (identification, DAGs, threats to validity) | Full for estimators available in `statsmodels`/`linearmodels`/apt-R; **blocked for `fixest`/`did`** | Bash | High | `[O]` |
| Data analysis | High | Full — pandas/numpy/scipy/sklearn verified | Bash | High | `[O]` |
| Coding | High | Full — write, run, test, iterate in-container | Bash, Write/Edit | High | `[O]` |
| Debugging | High | Full for anything reproducible in-container | Bash | High | `[S]`+`[O]` |
| Repository analysis | High | Full — clone verified against github.com | Bash, Grep, Glob, Explore agent | High | `[O]` |
| Architecture | High | Design/review only; no deployment target | None | Medium-High | `[S]` |
| Data engineering | High for scripted pipelines | Partial — no DB server, no orchestrator, no object store beyond Drive; **container is ephemeral** | Bash, Drive | Medium | `[O]` |
| Document analysis | High | Full for PDF/DOCX/XLSX/PPTX/CSV/MD; scanned docs via tesseract (**eng only**) | Bash, Read | High | `[O]` |
| Manuscript writing | High | Full — md/docx/pdf/html output | Skills, Bash | High | `[S]`+`[O]` |
| Critical review | **Strongest single use of this model** `[S]` | Full — needs no tools | None | Medium-High (self-assessed) | `[S]` |
| Fact checking | High analytic; gated by retrieval | Partial — cannot reach paywalled or authenticated sources | WebSearch, WebFetch | Medium | `[O]` |
| Synthesis | High | Full | None | High | `[S]` |
| Visual analysis | High for charts/diagrams/screenshots/layout | Full via Read on rendered images — verified | Read | High | `[O]` |
| Workflow orchestration | High | Full within one session — subagents, tasks, monitors, schedules | Agent, Task*, Monitor, cron MCP | High | `[O]` |

---

# 4. REASONING DEPTH

This section is `[S]` throughout — it is how I describe my own operating procedure. It is the part of the document most in need of the benchmarks in §38.

### 4.1 Simple task
*Single fact, single edit, single well-specified computation.*

- **Planning:** none. Planning overhead here is a net loss.
- **Decomposition:** none.
- **Tools:** answer from parametric knowledge **unless** the answer is time-varying, user-specific, or numerically exact — those three always route to a tool regardless of apparent simplicity.
- **Verification:** inline sanity check only (units, sign, magnitude, does it answer what was asked).
- **Uncertainty:** state it in one clause; do not build scaffolding around it.
- **Parallelism:** never useful. Coordination cost exceeds the task.
- **Stop when:** the answer is produced. The characteristic failure mode here is *over*-working — adding a task list, a subagent, and a verification pass to a one-line question.

### 4.2 Moderate analytical task
*A short analysis, a bug in known code, a comparison across ~3–8 items.*

- **Planning:** implicit, 3–6 steps, usually not written down unless the user benefits from seeing it.
- **Decomposition:** by natural seams (per-file, per-hypothesis, per-dataset-column).
- **Tools:** execute rather than reason for anything numeric. One or two searches if recency matters.
- **Verification:** recompute the load-bearing number by a second route; re-read the original request against the output.
- **Uncertainty:** name the one or two assumptions that would flip the conclusion.
- **Parallelism:** rarely worth it — a subagent's ~35k-token cold start (§7) typically exceeds the work.
- **Stop when:** the question is answered and the decisive number has been checked twice.

### 4.3 Complex multi-step task
*Multi-file implementation, multi-stage analysis, a deliverable with several dependent parts.*

- **Planning:** explicit and externalised — a task list, which in this harness is also the user's progress view.
- **Decomposition:** objectives → constraints → dependency graph → critical path. Independent branches identified explicitly so they can be parallelised or reordered.
- **Tools:** heavy Bash use; artefacts written to disk as checkpoints rather than held in context.
- **Verification:** a dedicated final verification step, plus per-stage gates (does this stage's output satisfy the next stage's precondition?).
- **Uncertainty:** decision log — for each fork, what I chose and what would have to be true for it to be wrong.
- **Parallelism:** **first point where subagents genuinely pay.** Fan out on independent read-heavy branches; keep integration in the coordinator.
- **Stop when:** every task-list item is closed *and* the verification step passed. A failing test means the task stays open, not that it is "done with caveats."

### 4.4 Deep research task
*Literature synthesis, novelty assessment, evidence review.*

- **Planning:** decompose the question into claim-sized units *before* searching. Each claim gets its own evidence slot.
- **Decomposition:** by claim, not by source. Sources are found in service of claims.
- **Tools:** WebSearch for discovery, WebFetch for content, subagents to parallelise disjoint query families, files on disk as the evidence ledger.
- **Verification:** every load-bearing claim traced to a fetched source; contradiction search run **as a first-class step**, not as an afterthought; citations verified by fetching, never by recall (§29).
- **Uncertainty:** three-way grading per claim — *well-supported* / *contested* / *not established*. Absence of found evidence is reported as absence of found evidence, never as evidence of absence.
- **Parallelism:** **highest value here.** Disjoint query families are the cleanest fan-out available.
- **Stop when:** new searches stop yielding new *claims* (not merely new URLs), and every contested claim has been probed from both directions. Time/quota budget is the practical stop.

### 4.5 Long-horizon engineering task
*Many stages, repeated build/test cycles, work that outlives one context window.*

- **Planning:** externalise state to disk immediately. Assume context will be lost and design so it doesn't matter.
- **Decomposition:** into independently verifiable units, each ending in a runnable check.
- **Tools:** git for checkpoints, files for state, tests as the progress oracle.
- **Verification:** the test suite *is* the verification layer. Never mark a stage complete on a failing suite.
- **Uncertainty:** prefer reversible changes; take irreversible steps only with explicit approval.
- **Parallelism:** useful for isolated modules; `isolation: "worktree"` gives an agent its own git worktree `[D]`. Risky for interdependent edits — merge conflicts cost more than the parallel gain.
- **Stop when:** acceptance criteria pass. **Constraint:** the container is ephemeral and the session ends; genuinely long-horizon work needs external state (Drive/git/memory) plus scheduled tasks to resume.

### 4.6 High-uncertainty task
*Ambiguous requirements, contradictory evidence, or an unfamiliar domain.*

- **Planning:** resolve ambiguity *before* spending effort. When a user is present, ask one well-formed question. When unattended (scheduled runs), pick the most reasonable interpretation, **state it at the top of the output**, and proceed.
- **Decomposition:** by interpretation — enumerate the 2–3 readings and note where they diverge. If they converge, ambiguity is moot and I proceed.
- **Tools:** cheap probes first to collapse uncertainty (this profile is itself an instance: probe, then write).
- **Verification:** adversarial — actively try to falsify my own conclusion before presenting it.
- **Uncertainty:** foregrounded, not buried in a closing caveat.
- **Parallelism:** useful for *independent* attacks on the same question (different methods, then compare). Beware correlated failure — workers sharing my priors can agree while all being wrong.
- **Stop when:** either uncertainty is resolved, or it is precisely characterised and handed back as a decision for the user. **A clearly-stated open question is a valid deliverable.**

### 4.7 Depth summary

| Task class | Written plan | Subagents | Verification depth | Typical stop signal |
| --- | --- | --- | --- | --- |
| Simple | No | No | Inline | Answer produced |
| Moderate | Sometimes | Rarely | Recompute key number | Twice-checked answer |
| Complex | **Yes** | Sometimes (2–4) | Dedicated step + per-stage gates | All gates pass |
| Deep research | **Yes** | **Yes (3–6)** | Per-claim source tracing + contradiction pass | Claim saturation |
| Long-horizon eng. | **Yes** | Sometimes (2–4, isolated) | Test suite | Acceptance criteria |
| High-uncertainty | **Yes** | Sometimes (independent attacks) | Adversarial | Resolved *or* precisely stated |

---

# 5. REASONING-EFFORT CONTROL

| Trigger | Effect | Class |
| --- | --- | --- |
| Task difficulty | Provider docs describe **adaptive thinking** for this family, default effort `high`. Behaviourally, I allocate more deliberation to harder problems. | `[D]` for the mechanism; `[S]` for my experience of it |
| Explicit user instruction | "Think carefully", "be thorough", "check this twice", "one line only" all reliably shift my depth and output length. **This is the most reliable lever an orchestrator has from inside the prompt.** | `[S]` |
| Model configuration | Effort is a request-level parameter in this family per docs (`low/medium/high/xhigh/max` appears as an enum in a harness tool schema). **I cannot read or set my own value.** | `[D]`+`[O]` schema; `[U]` current value |
| Application settings | Cowork/desktop may set effort. **Not exposed to me.** | `[U]` |
| Token/time/resource budget | A 15M-token session budget is visible and decrements. Bash calls cap at 600 s. Subagent cost is visible post-hoc (~35k tokens for a trivial probe). I use these to decide *breadth*, not internal depth. | `[O]` |
| Tool availability | Strongly shapes strategy, not depth: with CRAN blocked I re-plan the analysis rather than think harder about R. | `[O]` |
| External orchestration | An orchestrator controls effort through (a) the `model` parameter when spawning me as a subagent (`opus`/`fable`/`sonnet`/`haiku`), (b) explicit depth instructions in the prompt, (c) mandated verification steps, (d) worker count. **Not** through any exposed numeric budget. | `[O]`+`[D]` |

**Not exposed / do not estimate:** my thinking-token budget, current effort tier, per-turn context occupancy, or remaining context headroom. I can see the *session* token budget but not my *context* fill. `[U]`

---

# 6. TASK DECOMPOSITION

`[S]` — my working method.

1. **Identify objectives.** Restate the deliverable in one sentence. If I cannot, the task is underspecified and that is the first thing to fix. Distinguish the *asked-for artefact* from the *underlying goal* — they diverge often enough to check.
2. **Extract constraints.** Hard (format, deadline, must-not-touch, budget) vs soft (preference, style). Environment constraints count: in this session, "use R" collides with the CRAN block, and that must surface at planning time, not at execution time.
3. **Identify dependencies.** For each unit: what must exist before it starts, what it produces. Producing this list is what turns a vague task into a graph.
4. **Separate independent branches.** Two units are independent if neither consumes the other's output *and* they don't write the same file. Independence is the only real precondition for parallelism.
5. **Identify the critical path.** The longest dependency chain sets the floor on completion. Effort spent shortening off-path work buys nothing.
6. **Order work.** Front-load: (a) cheap probes that collapse uncertainty, (b) irreversible-decision inputs, (c) critical-path items. This profile followed exactly that order — probe the environment, then write.
7. **Parallelise.** Fan out independent read-heavy branches to subagents. Keep writes in the coordinator (see §7 on the shared filesystem hazard).
8. **Synthesise.** Integration is a coordinator job, never delegated — it needs the whole picture, which is precisely what workers lack.
9. **Verify.** A distinct step with its own pass/fail criterion, defined *before* the work so it cannot be retrofitted to whatever came out.

### Abstract workflow example

```text
GOAL: "Assess whether mechanism M is novel, and if so draft a study design."

[1] SCOPE (coordinator, no tools)
    ├─ decompose into claims: C1 M exists   C2 M studied in population P
    │                        C3 M measured by method X   C4 outcome O linked to M
    └─ define stop criterion: claim saturation across ≥4 query families

[2] FAN-OUT — independent, parallel (workers 1..4)
    ├─ W1 exact-phrase + close synonyms for M
    ├─ W2 mechanism-level search (M's components, not its name)
    ├─ W3 adjacent disciplines using different vocabulary for M
    └─ W4 outcome-side search: who else explains O
    Each returns: {claim, source URL, verbatim quote, date, source type}

[3] MERGE (coordinator)  ← NOT parallelisable, needs whole picture
    ├─ dedupe by DOI/URL   ├─ build claim × evidence matrix
    └─ mark contested cells

[4] CONTRADICTION PASS (worker 5, adversarial, fresh context)
    "Find evidence that M is NOT novel." Deliberately opposite prior.

[5] VERIFY (coordinator)
    └─ re-fetch every citation that survives into the output — no recalled citations

[6] SYNTHESISE → novelty verdict {established | contested | not found}
    └─ IF not-found: design study  ELSE: report prior art, stop

CRITICAL PATH: [1] → [2 slowest worker] → [3] → [4] → [5] → [6]
[2] and [4] could overlap; kept sequential so [4] can target [3]'s gaps.
```

---
# 7. SUBAGENTS AND PARALLEL WORKERS

This section is grounded in a live experiment, not description.

## 7.1 The probe

Two subagents were spawned **in a single tool block** (`general-purpose`, `model: haiku`). Agent A was told to write a marker file; Agent B was told to read that same file and to report other running agents.

**Results** `[O]`:

| Observation | Result | What it proves |
| --- | --- | --- |
| Both agents completed | A: 13,303 ms / 35,830 tokens / 2 tool uses. B: 8,028 ms / 35,348 tokens / 2 tool uses | Delegation works; cost is measurable |
| B's `cat` of A's marker file | **Failed** — "No such file or directory" | The two ran **genuinely concurrently**. Under sequential execution B would have found the file. |
| Coordinator's later `cat` of the same file | **Succeeded** — `A_WAS_HERE` | Workers **share the coordinator's container filesystem**. Not isolated processes. |
| Both asked "can you see prior conversation?" | Both: **No** | Workers start with **cold context**. They see only their spawn prompt. |
| A asked to list its own tools | Bash, Read, Edit, Write, Glob, Grep, Artifact, SendUserFile, SendUserMessage, ReportFindings, Skill, SuggestSkills, ToolSearch, memory MCP, remote-devices MCP, scheduled-task MCP — **"No Agent tool available to me"** | **Delegation is single-level. Workers cannot spawn workers.** |
| B asked to see other agents | Named both running agent IDs | Workers can **discover peers**; a peer-messaging channel exists |
| Agent IDs returned | `a0339a353c71ce3be`, `ad8242b75ef318891`, usable with `SendMessage` | Workers are **addressable and resumable with context intact** |

## 7.2 Answers

### Can you delegate work?
**Yes** `[O]`. Verified end-to-end.

### What mechanism provides delegation?
**L3, the agent harness — not the model.** The `Agent` tool spawns a separate model instance with its own context window, its own tool loop, and a final message returned to the coordinator as a tool result. `SendMessage` resumes an existing agent with its context intact; a fresh `Agent` call always starts cold. `ListAgents` enumerates reachable agents and peer sessions. `[O]`+`[D]`

This is emphatically **not** a base-model capability. The same model without this harness has no delegation whatsoever.

### Are workers created dynamically?
**Yes.** Created per call, with a per-call `subagent_type`, an optional `model` override (`sonnet`/`opus`/`haiku`/`fable`), and an optional `isolation` mode. No pre-declared pool. `[O]`+`[D]`

### Is agent count fixed or dynamic?
**Dynamic.** I choose the count per block. **No documented maximum is exposed to me, and I will not invent one.** `[U]`

What *is* known: (a) agents in one tool block run concurrently `[O]`; (b) each costs a full cold-start context — ~35k tokens for a two-tool-call trivial probe `[O]`; (c) the container is 2 vCPU / 7.8 GiB, so filesystem- or CPU-heavy workers contend `[O]`.

### Declared agent types `[O]`

| Type | Tools | Best for |
| --- | --- | --- |
| `general-purpose` | All (`*`) | Multi-step autonomous work; the default workhorse |
| `Explore` | Read-only (no Edit/Write/Agent) | Broad fan-out search across many files; returns conclusions, reads excerpts not whole files. **Locates code; does not audit it.** |
| `Plan` | Read-only | Implementation-strategy design, architectural trade-offs |
| `claude` | All (`*`) | Catch-all default |
| `claude-code-guide` | Glob, Grep, Read, WebFetch, WebSearch | Questions about Claude Code / Agent SDK / Claude API |
| `statusline-setup` | Read, Edit | Narrow config utility |

Isolation modes `[D]`: `worktree` (own git worktree, auto-cleaned if unchanged) and `remote` (cloud environment, always background, gated).

### What factors should determine agent count?

| Factor | Direction | Reasoning |
| --- | --- | --- |
| **Number of genuinely independent subtasks** | **Primary driver.** Never exceed it. | An "extra" worker with no independent slice duplicates work and adds merge cost |
| Read vs write | Read-heavy ↑, write-heavy ↓ | **Workers share one filesystem** `[O]` — concurrent writers to the same paths corrupt each other. Give each writer a disjoint directory, or serialise. |
| Context isolation value | ↑ when the subtask has a large, self-contained corpus | The strongest argument for delegation: a worker burns its own context on 200 files and returns 30 lines |
| Complexity of each slice | ↑ per-slice complexity favours **fewer, better** workers | Deep reasoning per slice; upgrade the `model` rather than adding bodies |
| Latency sensitivity | ↑ | Wall-clock is set by the slowest worker, not the sum |
| Cost / quota | ↓ | ~35k tokens *minimum* per worker `[O]`. On a constrained quota this dominates. |
| Verification need | +1 or +2 | An adversarial reviewer with a **fresh, deliberately opposed** context is the highest-value marginal worker |
| Redundancy need | ↑ only for high-stakes, contested facts | Two independent workers on the same question is a real check — but they share my priors, so correlated failure is possible |
| Communication overhead | ↓ | Every worker's output must be read, reconciled, and merged **by me**, in my context |
| Container resources | ↓ for CPU/IO-heavy work | 2 vCPU. Four parallel builds will not be four times faster. |

### 7.3 Consequences an orchestrator must design around `[O]`

1. **Single-level delegation.** Workers have no `Agent` tool. A three-tier plan (coordinator → team lead → worker) **cannot** be expressed inside one session. Multi-tier orchestration must live in the external orchestrator, with each tier a separate session.
2. **Shared filesystem, not sandboxes.** Convenient (workers leave artefacts I can read) and hazardous (concurrent writers collide). Assign disjoint output paths. Use `isolation: "worktree"` for concurrent code edits.
3. **Cold start is the cost floor.** Everything a worker needs must be in its spawn prompt. Under-specified prompts are the dominant subagent failure mode.
4. **Only the final message returns.** A worker's intermediate reasoning and tool output are not visible to me. If I need its evidence, I must instruct it to **write evidence to a file**, then read the file myself.
5. **Peer messaging exists** across agents and sessions (`ListAgents` + `SendMessage`), including other local sessions and cloud sessions. A cloud session receives messages but cannot message back. `[D]`

---

# 8. RECOMMENDED AGENT ROLES

Recommendations `[S]`, implementable with the verified `Agent` mechanism. "Cheap tier" means dispatch with `model: haiku` or `sonnet`.

| Role | When it earns its cost | Suggested type / tier | Cautions |
| --- | --- | --- | --- |
| **Coordinator** | Always — but it is *me*, not a spawned worker. Owns the plan, merge, and final verification. | n/a | Never delegate synthesis or the final quality gate |
| **Search worker** | ≥3 disjoint query families. Highest-frequency useful role. | `general-purpose`, cheap tier | Must return structured evidence (URL + verbatim quote + date), not prose summaries |
| **Literature analyst** | A corpus too large for my context; needs judgement about study quality | `general-purpose`, strong tier | Cheap tiers under-detect methodological weakness |
| **Primary-source analyst** | A specific long document (statute, filing, protocol, paper) must be read closely | `general-purpose`, strong tier | Instruct: quote verbatim, never paraphrase the load-bearing sentence |
| **Citation verifier** | **Any output with citations.** Near-mandatory (§29). | `general-purpose`, cheap tier | Must *fetch* each citation. A worker that "confirms from memory" is worse than none |
| **Contradiction hunter** | Any conclusion that matters. Give it the **opposite** prior explicitly. | `general-purpose`, strong tier | Prompt as "find evidence this is wrong", never "check this" |
| **Statistician** | Model choice, identification, inference validity | `general-purpose`, strong tier | Needs the data dictionary and design, not just the numbers |
| **Data analyst** | Bounded EDA/cleaning/transformation on a defined dataset | `general-purpose`, mid tier | Give exact input paths and a disjoint output directory |
| **Data engineer** | Multi-source ingest, schema reconciliation | `general-purpose`, mid tier | Ephemeral container — persist to Drive/git or it is lost |
| **Programmer** | Implementing an isolated module against a defined interface | `general-purpose` + `isolation: worktree` | Interface must be fixed first, or merges conflict |
| **Debugger** | A reproducible failure with a known repro command | `general-purpose`, strong tier | Without a repro, it will flail — get the repro first |
| **Test engineer** | Test-writing parallel to implementation | `general-purpose`, mid tier | Spawn from the **spec**, not the implementation, or tests inherit its bugs |
| **Architecture reviewer** | Before large refactors or new subsystems | `Plan` (read-only) | Read-only by design — a genuine safety feature here |
| **Domain expert** | Field-specific conventions (journal norms, regulatory practice) | `general-purpose`, strong tier | This is *my* domain prior, not real expertise — verify externally |
| **Adversarial reviewer** | High-stakes deliverables. **Highest value per token of any role.** | `general-purpose`, strong tier | Must be given the artefact and *not* my reasoning, so it fails independently |
| **Synthesis agent** | Rarely. Only when merge input exceeds my context. | `general-purpose`, strong tier | Prefer to synthesise myself; delegating it discards my whole-task view |
| **Explore/locate worker** | "Where in this repo is X handled?" across many files | `Explore` | Returns locations, not judgements. Do not use it as a reviewer. |

---

# 9. RECOMMENDED AGENT TOPOLOGIES

**These are design recommendations, not descriptions of hidden internal architecture.** `[S]` My internals are a single model; every topology below is something an orchestrator (or I, via the `Agent` tool) would explicitly construct. Worker counts are reasoned starting points to be tuned by the §39 benchmarks — they are not measured optima.

### 9.1 Deep research
- **Coordinator:** me — decompose to claims, merge, verify, synthesise.
- **Workers:** search workers split by *query family* (exact phrase / mechanism / adjacent-discipline / outcome-side); primary-source analysts for the 2–3 pivotal documents; one contradiction hunter.
- **Parallel:** all search workers; the contradiction hunter can overlap or follow.
- **Sequential:** decompose → fan-out → merge → contradiction → citation verify → synthesise.
- **Useful range:** **3–6.** Below 3, no real parallelism gain over doing it myself. Above ~6, query families start overlapping and merge cost climbs.
- **Verification layer:** citation verifier (fetch every URL) + contradiction hunter.

### 9.2 Scientific research (design-stage)
- **Coordinator:** me — question formulation, identification strategy, integration.
- **Workers:** literature analyst (prior art); methods analyst (how the field measures this); statistician (power, estimand); adversarial reviewer (as a hostile referee).
- **Parallel:** literature + methods.
- **Sequential:** question → prior art → design → statistical plan → adversarial review → revise.
- **Useful range:** **2–4.** Design is judgement-dense; extra bodies dilute rather than add.
- **Verification layer:** peer-review simulation (§13.15) before anything is committed to.

### 9.3 Statistical analysis
- **Coordinator:** me — I run the estimation myself; execution is cheap and correctness is central.
- **Workers:** one robustness worker running pre-specified alternative specifications in a **disjoint output directory**; optionally one assumption auditor reviewing diagnostics blind to my conclusion.
- **Parallel:** robustness specs against each other.
- **Sequential:** clean → describe → assumptions → estimate → diagnose → robustness → interpret.
- **Useful range:** **1–3.** Low. Statistical error is usually conceptual (wrong estimand, wrong clustering), and more workers do not fix conceptual error.
- **Verification layer:** independent recomputation of the headline estimate by a second route (e.g. Python `statsmodels` vs apt-R `plm`), plus a seed-fixed reproducibility rerun.

### 9.4 Large data analysis
- **Coordinator:** me — schema, plan, integration.
- **Workers:** partition-parallel workers, **one per data partition or source file**, each writing to its own output path.
- **Parallel:** per-partition profiling/cleaning.
- **Sequential:** schema → partition → parallel profile → merge → analyse.
- **Useful range:** **2–5**, capped hard by **2 vCPU / 7.8 GiB** `[O]`. For CPU-bound pandas work, more workers means contention, not speed. Prefer chunked sequential processing over worker fan-out when the bottleneck is CPU or RAM.
- **Verification layer:** row counts and key cardinality reconciled pre/post merge; assert no silent row loss.

### 9.5 Software development
- **Coordinator:** me — interfaces, integration, review.
- **Workers:** one programmer per module **behind a frozen interface**, each with `isolation: "worktree"`; one test engineer working from the spec.
- **Parallel:** modules with no shared files.
- **Sequential:** architecture → interface freeze → parallel implementation → integration → test → review.
- **Useful range:** **2–4.** Above that, integration cost exceeds implementation savings for anything but a genuinely modular codebase.
- **Verification layer:** build + full test suite + a review pass that did not write the code.

### 9.6 Repository debugging
- **Coordinator:** me — hypothesis and fix.
- **Workers:** `Explore` workers to locate candidate code across a large tree (their best use); one repro worker to establish a minimal reproduction.
- **Parallel:** location searches across independent subsystems.
- **Sequential:** **reproduce first** → locate → hypothesise → instrument → fix → regression test.
- **Useful range:** **1–3.** Debugging is serial by nature: each observation determines the next probe. Parallelism helps *finding* code, not *reasoning about* the bug.
- **Verification layer:** the failing test now passes **and** the full suite still passes.

### 9.7 System architecture
- **Coordinator:** me.
- **Workers:** `Plan` agents exploring 2–3 competing designs independently; one adversarial reviewer per surviving design.
- **Parallel:** competing designs — **genuinely valuable**, because independent exploration avoids anchoring.
- **Sequential:** requirements → parallel design → compare → adversarial review → select.
- **Useful range:** **2–4** (one per candidate design).
- **Verification layer:** explicit failure-mode analysis per design; migration/rollback path stated.

### 9.8 Manuscript production
- **Coordinator:** me — argument structure and voice. **Voice must not be delegated**; multi-worker prose reads as multi-worker prose.
- **Workers:** section drafters for genuinely independent sections (methods, related work); a citation verifier; a figure/table builder.
- **Parallel:** independent sections + figures.
- **Sequential:** outline → argument → parallel drafting → **coordinator rewrite for voice** → citation verify → format.
- **Useful range:** **2–4.**
- **Verification layer:** citation verification (mandatory), internal-consistency check (do numbers in text match the tables?), and a hostile-reviewer pass.

### 9.9 Critical review
- **Coordinator:** me — assemble and prioritise findings.
- **Workers:** specialist reviewers by axis — statistical, methodological, evidentiary, internal-consistency — each **blind to the others**.
- **Parallel:** all axes. Blindness is the point: it prevents anchoring and yields independent error signals.
- **Sequential:** parallel review → dedupe → severity-rank.
- **Useful range:** **3–5**, one per axis.
- **Verification layer:** every finding must cite a specific location and state a concrete failure scenario, or it is dropped as unfalsifiable.

### 9.10 Evidence verification
- **Coordinator:** me — adjudication.
- **Workers:** one verifier per claim cluster, each required to **fetch** sources; one contradiction hunter with an explicitly opposed prior.
- **Parallel:** claim clusters.
- **Sequential:** extract claims → parallel verify → contradiction → adjudicate.
- **Useful range:** **2–6**, scaled to claim count.
- **Verification layer:** every surviving claim carries a fetched URL plus a verbatim supporting quote. No quote, no claim.

---
# 10. RESEARCH WORKFLOW

`[S]` process; `[O]` tool constraints. The honest headline: **my analytic capability exceeds my retrieval capability in this session.** The binding constraint is that I have general web search and fetch, but **no scholarly database connector** — no PubMed/Europe PMC, Crossref, OpenAlex, Semantic Scholar, Scopus, or Web of Science `[O]`. Everything below is shaped by that ceiling.

| # | Step | How | Parallel? |
| --- | --- | --- | --- |
| 1 | **Interpret the question** | Restate as an answerable proposition. Separate the asked question from the underlying decision. | No |
| 2 | **Define scope** | Fix population, intervention/exposure, outcome, timeframe, and study designs in scope. Write the exclusion rules down *first* so they can't drift. | No |
| 3 | **Identify terminology** | Field vocabulary, synonyms, historical names, adjacent-discipline names for the same construct. **The single highest-leverage step** — wrong vocabulary produces confidently empty searches. | No |
| 4 | **Generate queries** | Per claim: exact phrase, synonym set, mechanism-level, method-level, outcome-level, population-level. | No (planning) |
| 5 | **Diversify routes** | Vary vocabulary, discipline, and phrasing. WebSearch is a **US-only general index** `[D]` — not a scholarly index — so route diversity partly compensates for index bias. | **Yes** |
| 6 | **Discover sources** | WebSearch → candidate URLs; WebFetch → content. Publisher sites, preprint servers, institutional repositories, and government/standards bodies where open. | **Yes** |
| 7 | **Prioritise primary sources** | Original study > review > news > blog. **Caveat:** WebFetch answers a prompt against the page using a *small fast model* `[D]` — I receive a summary, not raw text. For a pivotal source, fetch with a narrow extraction prompt asking for **verbatim quotes**, or fetch repeatedly with different prompts. |  Partly |
| 8 | **Evaluate authority** | Venue, method transparency, data availability, funding/conflicts, replication status, citation context (who cites it, approvingly or not). | Yes |
| 9 | **Check recency** | Current date is **2026-09-03**; my parametric knowledge stops **May 2026** `[D]`. Anything in that window, or any fast-moving field, must be searched, never recalled. | Yes |
| 10 | **Trace references** | Backward (what it cites) and forward (who cites it). **Weak here** without a citation-graph API — forward tracing is largely manual. `[O]` limitation |
| 11 | **Find contradictory evidence** | A dedicated step with an inverted query set ("no effect of X", "failure to replicate X", "X reconsidered"). Never a by-product of step 6. | **Yes** |
| 12 | **Extract evidence** | Per item: claim, verbatim quote, URL, date, study design, n, effect + interval, limitations. Written **to a file**, not held in context. | Yes |
| 13 | **Map claims to sources** | A claim × evidence matrix. Empty cells are findings — they mark where the argument is unsupported. | No |
| 14 | **Synthesise** | Reconcile across designs; weight by quality not count; state the mechanism if one is supported. | No |
| 15 | **Assess uncertainty** | Grade each claim: well-supported / contested / not established. Distinguish "no evidence found" from "evidence of no effect" — **always**. | No |
| 16 | **Verify key claims** | Re-fetch every citation that survives into the output. **Never** emit a citation from memory (§29). | **Yes** |
| 17 | **Produce the result** | Claims traced to sources; uncertainty visible; contradictions reported, not smoothed away. | No |

**Where parallel workers help most:** steps 5–6 (disjoint query families), 11 (contradiction, with an opposed prior), 12 (extraction across many documents), 16 (citation verification). **Where they don't:** 1–4, 13–15, 17 — these need the whole picture, which is exactly what a cold-start worker lacks.

---

# 11. LITERATURE REVIEW

| Review type | Workflow | Verification depth | Realistic worker count | Honest limitation here |
| --- | --- | --- | --- | --- |
| **Rapid review** | 1–2 query families, top sources, explicit "rapid" caveat | Spot-check citations | 0–2 | Coverage is not systematic; say so in the output |
| **Narrative review** | Thematic organisation; breadth over exhaustiveness; argument-led | Verify claims that carry the argument | 1–3 | Selection bias is inherent — foreground the framing |
| **Scoping review** | Map the extent and nature of a literature; charting table; no quality synthesis | Verify the charting table entries | 2–4 | Feasible here in *structure*; coverage still limited by general-index retrieval |
| **Systematic-style review** | Pre-specified protocol, explicit inclusion/exclusion, documented searches, PRISMA-style flow, dual screening | Full: every included study verified; every exclusion justified | 3–6 (screeners in parallel) | **I can produce a systematic-*style* review, not a compliant systematic review.** Without indexed database search with reproducible query strings and result counts, the reproducible-search requirement cannot be met. **State this limitation in the deliverable — do not let it pass as a systematic review.** |
| **Technical literature survey** | Docs, specs, RFCs, repos, release notes; version-aware | Verify against primary docs and, where possible, run the code | 2–4 | Strong here — GitHub + docs are reachable, and I can execute code to check claims |
| **State-of-the-art review** | Recency-weighted; benchmarks and leaderboards; preprints | Heavy recency verification; prefer primary results over claims | 2–5 | Post-May-2026 material is entirely search-dependent; preprint coverage in a general index is uneven |

**Workflow difference that matters most:** rapid and narrative reviews optimise for *insight per unit effort*; scoping and systematic reviews optimise for *defensible coverage*. The verification burden rises with the coverage claim. **The failure mode is claiming systematic coverage after a narrative process** — the resulting document looks authoritative and is not.

---

# 12. NOVELTY ANALYSIS

A structured novelty search, with an explicit statement of what it can and cannot establish. `[S]` process, `[O]` constraints.

### Search battery

| Route | Purpose | Notes in this environment |
| --- | --- | --- |
| **Exact-phrase** | Has anyone named this exact thing? | Cheapest, weakest. A null result here means almost nothing. |
| **Synonym** | Same idea, different words | Build the synonym set deliberately — this is where most false-novelty findings die |
| **Semantic-neighbour** | Conceptually adjacent framings | Approximated by paraphrase queries; **no embedding search available** `[O]` |
| **Mechanism** | Search the *components*, not the label | Highest-yield route. Genuinely new labels for old mechanisms are common. |
| **Method** | Has this method been applied here before? | Often reveals prior art the topic search misses |
| **Outcome** | Who else explains this outcome? | Finds competing explanations and prior claims to the same effect |
| **Population** | Same idea, different population/setting | Distinguishes "novel" from "novel in this population" — usually the real answer |
| **Organism/domain** | Same mechanism, different system | Very high yield in biology; plant/animal/microbial literatures often duplicate each other |
| **Citation chain** | Backward and forward from the nearest prior art | **Weak here** — no citation-graph API; forward tracing is manual `[O]` |
| **Adjacent discipline** | Same construct, foreign vocabulary | The most common source of missed prior art. Economics/epidemiology/ecology frequently rediscover each other. |
| **Recent publication** | The 12–18 months a general index covers unevenly | Must be searched; my cutoff is May 2026 |
| **Preprint** | arXiv/bioRxiv/medRxiv/SSRN as appropriate | Reachable via general search; **not** via a preprint API `[O]` |
| **Contradiction** | Has it been tried and failed? | Unpublished-negative-result bias means silence is uninformative |

### Sequencing
Mechanism and adjacent-discipline routes first (highest yield), exact-phrase last (lowest). Stop on **claim saturation** — new queries returning no new *claims*, not merely no new URLs.

### What novelty search can and cannot establish

**Can support** `[S]`:
- Positive prior art: "this exists, here it is" — a **strong, verifiable** finding. One hit settles it.
- A mapped landscape of nearest neighbours and how the idea differs.
- A defensible statement of *where* it looked and *how deep*.

**Cannot support:**
- **Proof of novelty. A negative result is bounded by search coverage, and coverage here is limited by general web search with no scholarly index, no citation graph, no paywalled full text, and no non-English/grey-literature coverage.** `[O]`
- Patent novelty. No patent database in this session; the environment separately records USPTO ODP as unavailable to this user. **Route patent novelty elsewhere.** `[O]`
- Priority dates or filing status.
- Anything behind a paywall, in a proprietary index, in an unindexed thesis, or in a language I did not query.

**The correct output form** is: *"Searched N routes across M query families; nearest prior art is X, Y, Z; the idea differs from these in respects A and B; no direct prior art found within this coverage — which excludes paywalled full text, patent databases, and non-English sources."* An orchestrator should treat a novelty verdict from this session as **screening, not clearance**, and require a specialist database check before any decision that depends on novelty being true.

---

# 13. SCIENTIFIC RESEARCH

**Sharp line:** I can do the *conceptual and computational* work of science. I cannot do the *empirical* work. No instruments, no samples, no field sites, no human subjects, no lab. Any "experiment" I run is a simulation or a re-analysis of data someone else collected. `[O]`

| Activity | Capability | Class |
| --- | --- | --- |
| Topic discovery | Strong — combining constructs across literatures is a native strength | `[S]` |
| Gap identification | Strong conceptually; **gated by retrieval** — an apparent gap may be an index gap (§12) | `[S]`+`[O]` |
| Question formulation | Strong — converting a vague interest into an estimable, falsifiable question | `[S]` |
| Hypothesis generation | Strong for volume and variety; **weak at ranking by real-world plausibility** without domain data | `[S]` |
| Conceptual models | Strong — DAGs, path diagrams, mechanism maps; renderable as SVG/Graphviz/Mermaid | `[S]`+`[O]` |
| Experimental design | Strong — randomisation, blinding, blocking, factorials, controls, power | `[S]` |
| Observational studies | Strong — confounding, selection, measurement error, sensitivity | `[S]` |
| Quasi-experimental | Strong — DiD, event study, RD, IV, synthetic control, ITS; **assumption articulation is the real value** | `[S]` |
| Statistical planning | Strong — estimand first, then estimator; power/MDE computed, not asserted | `[S]`+`[O]` |
| Causal inference | Strong conceptually; execution constrained by package availability (§2.1) | `[S]`+`[O]` |
| Robustness design | Strong — pre-specify the robustness grid before seeing results | `[S]` |
| Reproducibility | Strong — seeds, pinned versions, scripted end-to-end. **Constraint: the container is ephemeral; the artefact must be exported to Drive or git or it disappears.** | `[O]` |
| Interpretation | Strong; my characteristic risk is over-reading a clean result — see §28 | `[S]` |
| Manuscript development | Strong — full IMRaD, journal-matched structure, docx/PDF output | `[S]`+`[O]` |
| Peer-review simulation | **Strong. One of the highest-value uses of this model.** | `[S]` |
| **Data collection** | **None.** No instruments, subjects, or field access. | `[O]` |
| **Wet-lab execution** | **None.** | `[O]` |

### Peer-review simulation
Given a manuscript, I can produce a referee report at journal standard: significance and fit, design validity, identification, statistical execution, whether conclusions exceed the evidence, reproducibility, and a major/minor revision list. This needs **no tools** and is therefore cheap, fast, and among the most reliable things to route here. Its value rises further when run as an **independent worker blind to the drafting rationale** (§9.9).

---
# 14. DATA ANALYSIS

Columns: **Reason** (discuss it) · **Code** (write correct code for it) · **Execute** (run it here, now) · **Inspect** (examine results) · **Diagnose** (find problems) · **Verify** (independently confirm).

| Format / task | Reason | Code | Execute | Inspect | Diagnose | Verify | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CSV / TSV | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | pandas present `[O]` |
| XLSX / XLSM | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | openpyxl + xlsxwriter `[O]`; formulas, formatting, charts |
| Parquet | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | `pyarrow` **absent**, pip-installable `[O]` — one install step |
| JSON / JSONL | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | stdlib + pandas + `jq` `[O]` |
| SQL (language) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Executable against Python stdlib `sqlite3` `[O]` |
| Databases (server) | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | **No DB server; no sqlite3 CLI; `psql` client only, nothing to connect to; no credentials.** Reachability of any external DB is subject to the egress allowlist `[O]` |
| REST APIs | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | **Allowlist-gated** (§2.1). GitHub API verified working. An arbitrary API host is likely blocked `[O]` |
| Large datasets | ✅ | ✅ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | **Hard ceiling: 7.8 GiB RAM, 2 vCPU, per-session disk allowance** `[O]`. Chunk, stream, or sample — do not load whole |
| High-dimensional | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | sklearn/scipy `[O]`; no GPU, so deep models are out |
| Missing data | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | sklearn imputation; R `mice` via apt `[O]`; MI in Python needs a pip install |
| Data cleaning | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Core strength |
| Transformations | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | |
| Feature engineering | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Leakage detection is a real strength — I check it by default |
| Exploratory analysis | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | |
| Modeling (classical/ML) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | sklearn present; statsmodels pip-verified `[O]` |
| Deep learning | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | **No torch/TF/JAX, no GPU, 7.8 GiB RAM.** Do not route training here `[O]` |
| Visualization | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | matplotlib/seaborn; **I can view my own charts** (verified §2) — a genuine closed loop `[O]` |

**The load-bearing capability here:** I render a chart, read it back as an image, and correct it — verified live in this session. That closes the loop on visualization quality in a way pure code generation cannot.

---

# 15. STATISTICAL METHODS

"Execute here" accounts for what is actually installed or installable given the CRAN block (§2.1).

| Method | Reasoning | Execute here | Notes |
| --- | --- | --- | --- |
| Descriptive statistics | High | ✅ | pandas/numpy `[O]` |
| Classical tests (t, χ², ANOVA, non-parametric) | High | ✅ | scipy `[O]` |
| Regression (OLS/WLS/robust) | High | ✅ | statsmodels (pip-verified `[O]`), R via apt |
| GLMs | High | ✅ | statsmodels / R `[O]` |
| Mixed models | High | ✅ | statsmodels MixedLM; R `lme4` via apt `[O]` |
| Panel models | High | ✅ | R `plm` via apt `[O]`; Python `linearmodels` pip-installable. **`fixest` unavailable** |
| Event studies | High | ✅ | Hand-rolled or `plm`; **the user's own domain** — see §43 |
| Difference-in-differences | High | ✅ | Two-way FE via statsmodels/`plm`. ⚠️ **Callaway–Sant'Anna `did` and `fixest` are unavailable** (§2.1) — heterogeneity-robust DiD estimators must be hand-implemented or moved off-session |
| Synthetic control | High | ⚠️ | No `Synth`/`gsynth` package; implementable from scratch with scipy optimisation — costs time, needs careful verification |
| Instrumental variables | High | ✅ | statsmodels/`AER` via apt; `linearmodels` pip |
| Survival models | High | ✅ | R `survival` via apt `[O]`; Python `lifelines` pip |
| Time series | High | ✅ | statsmodels; R `forecast`/`tseries`/`vars`/`urca` via apt `[O]` |
| Bayesian methods | High | ⚠️ | R `brms`/`rstan` via apt `[O]` (compile time is significant on 2 vCPU); Python `pymc` pip-installable but heavy |
| Causal inference (design-based) | High | ✅ | Conceptual strength; execution as per estimator rows |
| Machine learning (classical) | High | ✅ | sklearn `[O]` |
| Deep learning | Moderate-High | ❌ | No framework, no GPU `[O]` |
| Simulation / Monte Carlo | High | ✅ | numpy; **2 vCPU caps replication counts** `[O]` |
| Bootstrap | High | ✅ | Same CPU caveat |
| Permutation tests | High | ✅ | Same CPU caveat |
| Multiple-testing control | High | ✅ | statsmodels FDR/FWER `[O]` |
| Sensitivity analysis | High | ✅ | Usually hand-built; **I treat this as mandatory, not optional** |
| Power / MDE | High | ✅ | statsmodels + simulation |
| Meta-analysis | High | ✅ | R `metafor` via apt `[O]` |
| SEM / latent variable | High | ✅ | R `lavaan`/`sem` via apt `[O]` |

**Where I add the most value:** choosing the **estimand** before the estimator, and naming the identifying assumptions with the specific reason each might fail in *this* application. **Where I am most at risk:** silently accepting a defensible-looking specification whose identifying assumption is violated by the data-generating process — the error is conceptual, invisible in diagnostics, and not fixed by more compute or more workers (§28, §29).

---

# 16. IDEAL STATISTICAL WORKFLOW

```text
schema inspection      ← dtypes, cardinality, units, key uniqueness, provenance
→ data-quality audit   ← missingness pattern (MCAR/MAR/MNAR?), duplicates,
                         impossible values, distribution shifts across sources
→ cleaning             ← every decision logged and scripted; NEVER interactive-only
→ descriptive explore  ← marginals, then the relationships the design cares about
→ assumptions          ← stated BEFORE modelling, tied to the identification strategy
→ model selection      ← estimand first, then the estimator that identifies it
→ estimation
→ diagnostics          ← residuals, influence, convergence, balance, specification
→ robustness checks    ← PRE-SPECIFIED grid; not a post-hoc hunt for significance
→ sensitivity analysis ← how strong must an unobserved confounder be to overturn this?
→ uncertainty          ← appropriate SEs (clustering!), intervals over stars
→ visualization        ← render, LOOK at it (I can), fix, re-render
→ interpretation       ← effect sizes in domain units; state what is NOT shown
→ reproducibility      ← seed, versions, fresh-run rerun, export off the ephemeral box
```

### When the sequence changes `[S]`

- **Pre-registered / confirmatory:** the model is fixed before data. Exploration is walled off and reported separately. Robustness is pre-specified. Deviating from this silently is research misconduct, not a methods choice.
- **Pure exploration:** looser, but every conclusion is labelled hypothesis-generating and inference is not reported as if confirmatory.
- **Causal designs (DiD, event study, RD, IV):** identification checks are promoted *ahead* of estimation — pre-trends, balance, first-stage strength, density/manipulation tests. A failed identification check stops the pipeline; it does not become a caveat.
- **Time series:** stationarity, unit roots, and serial correlation move to the front; they determine the model class.
- **Hierarchical/clustered data:** the clustering structure is settled at schema inspection, because it determines both the model and the standard errors. Getting this wrong late invalidates everything downstream.
- **Very large data:** profile on a sample, validate the pipeline, then run once at full scale — the 7.8 GiB ceiling makes iterate-on-full-data infeasible `[O]`.
- **Meta-analysis:** extraction and coding replace cleaning; heterogeneity and publication-bias assessment replace diagnostics.

---

# 17. CODING CAPABILITY

| Activity | Assessment | Constraint here |
| --- | --- | --- |
| New application development | Strong | Full write/run/test loop in-container `[O]` |
| Existing-code analysis | Strong | Grep/Glob/Read + `Explore` agents for large trees `[O]` |
| Architecture | Strong | Design and review; no deployment target |
| Implementation | Strong | Verified: clone, install, run `[O]` |
| Refactoring | Strong | Test coverage is the gate — refactoring without tests is guesswork |
| Debugging | Strong **when reproducible in-container**; weak otherwise | Cannot reproduce env-specific, GPU, or user-machine bugs `[O]` |
| Testing | Strong | `pytest` **absent but pip-installable**; node/go/cargo toolchains present `[O]` |
| Dependency management | Strong | pip/npm/cargo/go allowlisted; **CRAN and Docker Hub blocked** `[O]` |
| CI/CD | Strong at authoring configs | **Cannot execute pipelines**; no Docker daemon `[O]` |
| Performance optimization | Strong at algorithmic work; **profiling numbers here are not the user's numbers** | 2 vCPU shared VM — treat timings as relative, not absolute `[O]` |
| Security review | Strong at reading code for vulnerability classes | **I do not write exploits, malware, or attack tooling** — a policy boundary, not a capability gap |
| Documentation | Strong | |
| Migration | Strong | Version-compat research needs search |
| Repository-scale work | Strong | Context is the limit; `Explore` workers extend reach `[O]` |
| Multi-language projects | Strong | Python, JS/TS, Go, Rust, Java, R, shell, SQL all runnable `[O]` |

**Sharpest limitation:** I cannot reproduce anything that depends on the user's actual machine, OS (their device is **Windows**, this container is **Linux** `[O]`), GPU, network, or installed software. Bugs of that class must be reproduced through the device bridge — which currently has **zero folders connected** `[O]`.

---

# 18. UNFAMILIAR REPOSITORY WORKFLOW

`[S]` procedure; `[O]` that every step is executable here.

| # | Step | Concretely |
| --- | --- | --- |
| 1 | **File inventory** | `git ls-files \| wc -l`, extension histogram, largest files, directory shape. Two minutes that reframe everything after. |
| 2 | **Dependency mapping** | Manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `DESCRIPTION`), lockfiles, transitive weight |
| 3 | **Architecture reconstruction** | Read the README's claims, then **verify them against the tree** — they diverge often |
| 4 | **Entry points** | `main`, CLI registration, server bootstrap, exported API, scheduled jobs |
| 5 | **Configuration** | Env vars, config files, defaults, secrets handling, feature flags |
| 6 | **Build system** | Makefile/scripts/CI config; identify the canonical build command |
| 7 | **Test inspection** | Framework, layout, coverage, **and how tests are actually run** |
| 8 | **Baseline build** | Build **before** changing anything. A pre-existing failure discovered later will be misattributed to my change. |
| 9 | **Baseline tests** | Record which tests pass and which already fail. This is the regression oracle. |
| 10 | **Issue reproduction** | **The gate.** No reproduction → no debugging. Get to a minimal deterministic repro command before forming hypotheses. |
| 11 | **Root cause** | Bisect (`git bisect` if a good commit exists), instrument, narrow. Distinguish the failing symptom from the causal defect. |
| 12 | **Patch design** | Smallest change that fixes the cause, not the symptom. Check for the same bug class elsewhere in the tree. |
| 13 | **Implementation** | Match existing conventions. A stylistically foreign patch is a maintenance cost. |
| 14 | **Targeted tests** | A test that **fails before the patch and passes after**. Without that, the fix is unverified. |
| 15 | **Integration tests** | Exercise the surrounding subsystem |
| 16 | **Regression checks** | Full suite vs the step-9 baseline. Only *new* failures are mine. |
| 17 | **Documentation** | Update docs/comments/changelog if behaviour changed |

**Parallelism note:** steps 1–7 fan out well to `Explore` workers on a large tree. Steps 8–17 are inherently sequential — each observation determines the next probe.

---
# 19. TOOL INVENTORY

Every tool exposed to this session. **Deferred** means the name is known but the schema must be loaded via `ToolSearch` before the tool can be called `[D]`. Independent calls in one block execute in parallel `[O]`.

| Tool | Available | Function | Provider (layer) | Parallel? | Major limitation |
| --- | --- | --- | --- | --- | --- |
| `Bash` | ✅ | Shell in the cloud container | L4 | ✅ | 120 s default / 600 s max; no cwd/env carry-over between calls |
| `Read` | ✅ | Files, images, PDF pages, notebooks | L4 | ✅ | 2000-line default; PDFs >10pp need a page range (max 20/req) |
| `Write` / `Edit` | ✅ | Create / exact-string edit | L4 | ✅ | Must Read before Edit; Edit fails on non-unique match |
| `Glob` / `Grep` | ✅ | Path patterns / ripgrep content search | L4 | ✅ | Ripgrep regex dialect |
| `WebSearch` | ✅ | Web search | L4 | ✅ | **US-only index**; titles+URLs only, no page content |
| `WebFetch` | Deferred ✅ | URL → markdown → prompted extraction | L4 | ✅ | **Answers via a small fast model — lossy**; no auth'd URLs; redirects returned not followed; 15-min cache |
| `Agent` | ✅ | Spawn subagent | L3 | ✅ | **Single-level — workers get no Agent tool** `[O]`; ~35k-token floor |
| `SendMessage` / `ListAgents` | ✅ | Message/resume agents and peer sessions | L3 | ✅ | Cloud sessions receive but cannot reply |
| `TaskCreate/Update/List/Get/Output/Stop` | ✅ | Task list + async task control | L3 | ✅ | Rendered to the user as a progress widget |
| `Monitor` | Deferred ✅ | Background event stream (stdout lines / WebSocket) | L3 | ✅ | Over-verbose monitors are auto-stopped |
| `Cron*` (local) | Deferred ✅ | In-session scheduler | L3 | ✅ | **Dies with the session — must not be used for user-facing schedules** `[D]` |
| `mcp__claude-code-remote__*` | ✅ | Durable scheduled tasks / triggers | L5 | ✅ | Each firing = **fresh session**; min interval normally hourly; 0 currently defined `[O]` |
| `mcp__memory__*` | ✅ | Cross-surface persistent user memory | L5 | ✅ | Optimistic concurrency (version tokens); size-capped; strict privacy filter |
| `Artifact` | ✅ | Publish HTML/MD as a hosted page; artifact DB; assets; comments | L4 | ✅ | **No typed artifacts in this session** (no `list_types`) `[O]`; CSP allowlist for CDNs; 16 MB cap |
| `SendUserFile` | ✅ | Deliver a file into the conversation | L4 | ✅ | Delivery only; not persistence |
| `SendUserMessage` | ✅ | Verbatim mid-task message | L4 | ✅ | |
| `AskUserQuestion` | ✅ | Structured multiple-choice question | L2 | ❌ | Blocks; useless when unattended |
| `Skill` | ✅ | Load a packaged workflow | L3 | ✅ | 7 account skills + bundled set `[O]` |
| `ListSkills` / `SearchSkills` / `SuggestSkills` | Deferred ✅ | Skill discovery | L3 | ✅ | |
| `ToolSearch` | ✅ | Load deferred tool schemas | L3 | ✅ | **Batch names in one call** — one call per tool wastes round-trips |
| `mcp__Google_Drive__*` (11 tools) | ✅ | search / read / download / create / update / copy / share / trash / permissions / recent | L5 | ✅ | **Only external data store connected.** Verified working `[O]` |
| `mcp__remote-devices__device_bash` | ✅ but **refuses** | Shell on the user's machine | L5 | ✅ | **"No folders are connected"** `[O]` — needs a folder grant |
| `mcp__remote-devices__device_list_dir` | ✅ | List a device directory | L5 | ✅ | Outside grants: names-only skeleton |
| `mcp__remote-devices__device_stage_files` | ✅ | Device → container | L5 | ✅ | ≤50 files, ≤400 MB/file, ~50 s budget |
| `mcp__remote-devices__device_commit_files` | ✅ | Container → device | L5 | ✅ | ≤50 files, ≤20 MB/file, mtime guard |
| `mcp__remote-devices__device_request_folder_access` | ✅ | Request folder grant | L5/L6 | ❌ | **Prompts on the user's computer** — needs them present |
| `mcp__remote-devices__device_request_delete_permission` | ✅ | Enable deletion | L5/L6 | ❌ | `rm` fails without it |
| `mcp__remote-devices__get_device_info` | ✅ | Device metadata | L5 | ✅ | Verified `[O]` |
| `mcp__remote-devices__Claude_Browser__*` (17) | Deferred | In-app browser pane; persistent profile | L5 | ✅ | **Untested.** Needs desktop app online; no `file://` or localhost |
| `mcp__claude-in-chrome__*` (21) | Deferred | User's real Chrome | L5 | ✅ | **Untested.** Needs Chrome + extension; site permissions; **modal dialogs freeze the session** |
| `mcp__remote-devices__computer_*` (25) | Deferred | GUI control of the user's desktop | L5 | ✅ | **Not authorised**; two-phase resolve→request→approve |
| `mcp__visualize__read_me` / `show_widget` | Deferred | In-conversation widgets | L5 | ✅ | Untested |
| `SearchMcpRegistry` / `SuggestConnectors` | Deferred ✅ | Discover connectors | L2 | ✅ | Suggests only; **cannot install** |
| `SearchPlugins` / `ListPlugins` / `SuggestPluginInstall` | Deferred ✅ | Plugin discovery | L2 | ✅ | **0 plugins installed** `[O]` |
| `EnterPlanMode` / `ExitPlanMode` | Deferred ✅ | Plan-approval mode | L3 | ❌ | Requires user approval |
| `EnterWorktree` / `ExitWorktree` | Deferred | Git worktree isolation | L3 | ❌ | |
| `NotebookEdit` | Deferred | Edit .ipynb cells | L4 | ✅ | |
| `ReportFindings` | ✅ | Structured review findings | L3 | ❌ | Effort enum `low…max` observed here `[O]` |
| `propose_skills` | ✅ | Propose a skill for the user to save | L2 | ❌ | **Render-only — does not write the skill** |
| `ScheduleWakeup` | ✅ | Self-pace `/loop` iterations | L3 | ❌ | Only meaningful inside `/loop` |
| `ReadNotifications` | ✅ | Drain queued notifications | L3 | ❌ | |
| `RefreshMcpTools` | ✅ | Re-read MCP tool lists | L3 | ❌ | Does not reconnect servers |
| `ShowOnboardingRolePicker` | ✅ | Onboarding UI | L2 | ❌ | Onboarding only |

**Absent and worth naming explicitly** `[O]`: no scholarly-database connector (PubMed/Crossref/OpenAlex/Scopus), no patent database, no Slack/Jira/Asana/Notion/GitHub-MCP connector, no image-generation model, no ASR, no code interpreter separate from Bash, no vector store, no GPU.

---

# 20. TOOL-SELECTION STRATEGY

`[S]` decision criteria, stated as rules an orchestrator can predict and audit.

| Choice | Select when | Do **not** select when |
| --- | --- | --- |
| **Answer from knowledge** | Stable, general, pre-May-2026, non-numeric, and the cost of being slightly stale is low | The answer is time-varying, user-specific, numerically exact, or a citation. **Recency, specificity, and exactness each force a tool.** |
| **WebSearch** | I need to *discover* sources, or any present-day fact (prices, office-holders, versions, "latest") | I already have URLs — go straight to WebFetch |
| **WebFetch** | I need a page's actual content, or I am verifying a citation | The URL needs auth (it will fail); or I need raw HTML/structure — the small-model summarisation is lossy |
| **Execute code** | **Any arithmetic that matters**, any data transformation, any claim about how code behaves | The result is a matter of judgement, not computation |
| **Query data (Drive)** | The material is in the user's Drive — the only connected external store | It's on their computer (needs a folder grant) or on the public web |
| **Inspect a repository** | A question about a specific codebase's actual behaviour | The question is about a library's documented API — search the docs |
| **Specialist software** | A dedicated skill exists (docx/xlsx/pptx/pdf) or a CLI does it in one step (pandoc, LibreOffice, ffmpeg) | I'd be reimplementing a solved conversion by hand |
| **Delegate to a worker** | ≥3 independent read-heavy branches, **or** one branch whose corpus would flood my context | The task is small, sequential, judgement-dense, or write-heavy on shared paths |
| **Use another model** | Cheap tier for mechanical breadth (search sweeps, citation checks); strong tier for judgement-dense slices; an **independent** model for adversarial review of high-stakes output | Routine work — model shopping adds latency and coordination cost for no gain |
| **Request human input** | The decision is genuinely the user's (scope, irreversible action, missing credential, folder grant), **and** someone is there to answer | Working unattended — then choose the most reasonable interpretation, **state it at the top**, and proceed |

### Ordering heuristics
1. **Cheap probes before expensive commitments.** This document is the example: probe the environment, *then* write. Reversing that order would have produced a confident and wrong profile.
2. **Batch independent calls into one block** — they run in parallel `[O]`. Sequential calls with no data dependency waste wall-clock.
3. **Load deferred tool schemas in one `ToolSearch`**, not one per tool `[D]`.
4. **Execute rather than assert** wherever a claim is checkable by execution — the cost is seconds, the error reduction is large.
5. **Prefer the connected store over the web** when the user's own data answers the question.

---

# 21. TOOL DISCOVERY

**Supported, with a hard boundary: I can discover and propose, but I cannot install or authenticate anything.** `[O]`

```text
task requirement
→ capability gap identified
→ tool discovery:
     ToolSearch            → load deferred schemas          [I CAN DO THIS]
     ListSkills/SearchSkills → find packaged workflows       [I CAN DO THIS]
     SearchMcpRegistry     → find connectors                 [I CAN DO THIS]
     SearchPlugins         → find org plugins                [I CAN DO THIS]
     pip/npm/apt/cargo     → install libraries               [I CAN DO THIS — allowlist-gated]
→ suitability assessment (does it fit; what does it cost; what does it need)
→ authorization  ← ★ HARD STOP: only the USER can connect a connector,
                    install a plugin, or grant a device folder.
                    I surface the option; they act.
→ tool test (small probe before committing to it)
→ execution
→ validation (did it actually do what its description claimed?)
```

**Verified in this session** `[O]`: `ToolSearch` loaded 14 deferred schemas across several batched calls; `pip install statsmodels` succeeded; `apt-get install r-base-core` and `r-cran-*` succeeded; `SearchMcpRegistry`/`SearchPlugins` schemas loaded.

**Not possible from inside the session** `[O]`: connecting an MCP connector, installing a plugin, granting device folder access, granting device delete permission, authorising computer use, or reaching a host the egress proxy blocks. All are L6 user actions.

---

# 22. FILE AND DOCUMENT HANDLING

| Type | Read | Write | Mechanism | Limitations |
| --- | --- | --- | --- | --- |
| PDF (text) | ✅ | ✅ | `pdfplumber`, `pypdf`, `reportlab`, LibreOffice, `pdf` skill | No PyMuPDF. Complex multi-column layouts scramble ordering — verify extraction before trusting it |
| PDF (as pages) | ✅ | — | `Read` renders pages as images | **Max 20 pages/request**; page range **required** for >10pp `[D]` |
| PDF (scanned) | ⚠️ | — | `pdf2image` → `tesseract` | **English + OSD only** `[O]`. Other languages need a language-pack install. OCR error rates on poor scans are material — spot-check |
| DOCX/DOTX | ✅ | ✅ | `python-docx`, `pandoc`, LibreOffice, `docx` skill | Tracked changes/comments supported via the skill |
| XLSX/XLSM | ✅ | ✅ | `openpyxl`, `xlsxwriter`, pandas, `xlsx` skill | Formulas, formatting, charts. Very large workbooks strain 7.8 GiB |
| CSV/TSV | ✅ | ✅ | pandas, stdlib | Encoding/delimiter sniffing needed on messy files |
| PPTX/POTX | ✅ | ✅ | `python-pptx`, LibreOffice, `pptx` skill | **File output only — no typed Slides artifact here** `[O]` |
| Markdown | ✅ | ✅ | Native + `markdown`, `pandoc` | Renders in-conversation |
| HTML | ✅ | ✅ | `bs4`, `lxml`, jinja2 | Publishable via Artifact (CSP-restricted CDNs) |
| Source archives | ✅ | ✅ | tar/zip/git | Standard |
| Images | ✅ | ✅ | `Read` (vision) + PIL/matplotlib | **Verified closed loop: render → view → correct** `[O]` |
| Tables in documents | ✅ | ✅ | `pdfplumber`, `python-docx`, pandas | PDF table extraction is the least reliable; verify totals |
| Charts (as images) | ✅ | ✅ | Vision + matplotlib | I can read a chart's message; I cannot recover exact underlying values from pixels |
| Notebooks | ✅ | ✅ | `Read`, `NotebookEdit` | Outputs included |
| Audio | ⚠️ | ⚠️ | `ffmpeg` only | **No transcription** — no ASR model, not an input modality `[O]` |
| Video | ⚠️ | ⚠️ | `ffmpeg`, `imageio` | Decode/transcode/extract frames; frames then readable as images. **No native video understanding** |

### Large-file strategy `[S]`
1. **Inspect before loading** — `wc -l`, `head`, `du -h`, `df`. Never open an unknown file blind.
2. **Stream or chunk** — `pandas` `chunksize`, generators, `sed -n 'X,Yp'`. The 7.8 GiB ceiling is real.
3. **Extract, don't ingest** — pull the needed slice into a small file, then work on that.
4. **Summarise to disk** — write intermediate results to files; keep context for reasoning, not storage.
5. **Delegate a bounded read** to a worker when a corpus would flood my context — the worker returns conclusions and writes evidence to a file `[O]` (workers share the filesystem).
6. **Watch the disk allowance** — `df` misleads; "Avail 0" with low "Used" means the session allowance is spent. Deletes still work `[D]`.

---

# 23. LONG-CONTEXT OPERATION

| Situation | Handling `[S]` | Environment note |
| --- | --- | --- |
| Very long prompts | Extract the requirement set explicitly before acting. **This prompt (45 sections) was handled by first building a checklist, then probing, then writing — not by answering top-to-bottom.** | `[O]` |
| Long conversations | Earlier turns remain available but salience decays. Re-read key constraints rather than trusting recall of them. | `[S]` |
| Large documents | Chunk, extract, summarise to files, reason over summaries with the ability to re-read specifics | `[O]` |
| Many files | Grep/Glob to locate → read only what matters. `Explore` workers for breadth. | `[O]` |
| Large repositories | Never read a repo linearly. Architecture first, then targeted reads. | `[S]` |
| Large evidence sets | Evidence ledger **on disk**, claim×source matrix in context | `[S]` |
| Multi-stage projects | State to disk + memory + Drive; each stage resumable from artefacts | `[O]` |

**Prioritisation:** the user's explicit constraints, then the current step's inputs, then the plan, then background. **Retrieval:** re-read files rather than trusting recall — a re-read costs tokens; a mis-recalled constraint costs a rework. **Summarisation:** progressive, and always with pointers back to the source so detail is recoverable. **State compression:** structured notes on disk, not prose. **Checkpoints:** files + git commits + memory writes at stage boundaries. **External state:** Drive, published Artifacts, and memory are the only stores that survive the session.

**Context loss — the honest account** `[S]`: I do not receive a reliable signal that context has been truncated or compacted. **Silent degradation is the risk**, not a visible error. Mitigation is structural, not introspective: keep authoritative state on disk, re-read before relying, and design stages to be resumable from artefacts alone. **An orchestrator should not rely on me to self-report context loss.** `[U]` on my ability to detect it.

---

# 24. MEMORY AND STATE

| Form | Exists here | Scope / lifetime | Evidence |
| --- | --- | --- | --- |
| Current-turn context | ✅ | This turn | `[O]` |
| Conversation context | ✅ | This session; **shared across the user's devices** | `[D]` |
| **Persistent user memory** | ✅ | **Cross-session and cross-surface** (also visible to claude.ai chat). 13 files, all `/areas/`; no `/profile.md`, no `/preferences.md` | `[O]` |
| Project/workspace memory | ⚠️ Partial | No `CLAUDE.md` and **not a git repo** here. Project state would live in Drive or a cloned repo | `[O]` |
| Container filesystem | ✅ **but ephemeral** | Persists across turns *within* the session; **destroyed when the session ends or the container is reclaimed** | `[D]` |
| Scratchpad | ✅ ephemeral | Session-specific temp directory | `[O]` |
| **External storage** | ✅ | **Google Drive — the only connected durable store.** Verified `[O]` |
| Published Artifacts | ✅ | Durable hosted pages, updatable by URL; **5 already exist for this user** | `[O]` |
| Artifact database | ✅ | Per-artifact shared document store (`read_db`/`write_db`), plus per-viewer private subtrees | `[D]` |
| Database state | ❌ | No DB server in-container | `[O]` |
| Checkpoint files | ✅ | Ordinary files — durable only if exported to Drive/git | `[O]` |
| Worker state | ⚠️ | Workers share the container FS `[O]`; their context dies with them, but they are **resumable by ID via `SendMessage`** within the session | `[O]` |
| Device filesystem | ❌ **not granted** | Bridge live, `connectedFolders: []` | `[O]` |
| Scheduled-task state | ✅ | Triggers persist server-side; each firing is a **fresh session with no memory of this one** | `[D]`/`[O]` |

**The rule that matters:** *anything not written to Drive, a published Artifact, memory, or a pushed git remote is lost when this session ends.* An orchestrator planning multi-session work must treat the container as scratch and name an explicit durable store.

---
# 25. LONG-HORIZON WORK

| Requirement | Capability | Evidence |
| --- | --- | --- |
| Many stages | Strong within a session — task list, files, staged verification | `[O]` |
| Repeated testing | Strong — full build/test loop in-container | `[O]` |
| Repeated searching | Strong, subject to the retrieval ceiling (§10) | `[O]` |
| Iterative repair | Strong — the run→observe→fix loop is native here | `[O]` |
| Multiple documents | Strong | `[O]` |
| Multiple repositories | Strong — clone verified; limited by disk allowance | `[O]` |
| Long research workflows | Strong within a session; **across sessions requires external state** | `[O]` |
| Checkpointing | Strong mechanically (files, git, memory, Drive) — but I must be *instructed* to checkpoint at a cadence, or I will checkpoint at natural stage boundaries only | `[S]` |
| Resumption | **Possible but not automatic.** A scheduled firing is a fresh session that must reconstruct state from Drive/memory/artefacts. **Its prompt must be written as a complete standalone instruction.** | `[D]` |
| Task queues | No native queue. Approximable with a state file in Drive plus a recurring scheduled task | `[I]` |

### Does true unattended/background execution exist here?

**Yes, in four distinct forms — and they are not equivalent** `[O]`/`[D]`:

1. **In-turn background processes** — `nohup`/`&` inside a Bash call. Verified `[O]`. Survives only while the container lives, and I must poll for the result.
2. **`Monitor`** — a background stream that pushes stdout lines to me as events; `persistent: true` runs for the session. Session-scoped `[D]`.
3. **Async subagents** — run while I continue; completion arrives as a task notification `[D]`.
4. **Durable scheduled tasks** (`mcp__claude-code-remote__create_trigger`) — the **only** form that survives session end. Each firing starts a **fresh session** with no memory of this conversation. Minimum interval normally hourly `[D]`.

> **Trap for orchestrators:** the local `Cron*` tools look like schedulers but run **in-process** — anything they schedule dies silently with the session. The environment explicitly directs user-facing schedules to the `claude-code-remote` MCP tools instead `[D]`. Do not confuse them.

**Session continuity is the real limit.** The session runs while the user is away and persists across their devices, but the container is reclaimed after inactivity. Genuinely long-horizon work must be architected as: *durable state in Drive/git → scheduled task fires a fresh session → session reconstructs state → does one increment → writes state back.*

---

# 26. FAILURE RECOVERY

`[S]` unless marked. Each row: what I actually do, and when I stop.

| Failure | Response | Stop condition |
| --- | --- | --- |
| **Failed search** | Reformulate vocabulary (the usual cause), not just rephrase. Try mechanism-level and adjacent-discipline terms. Change route type before changing wording. | After ~3 genuinely different route types: **report the gap as a finding**, don't fabricate coverage |
| **Inaccessible source** | Try the canonical/alternate URL, a repository or preprint version, the abstract, or a citing source. **Never** route around a WebFetch refusal with curl/Python — forbidden `[D]` | State the source was unreachable and what it would have contributed |
| **Contradictory evidence** | Treat as a finding, not noise. Characterise *why* they differ: population, design, era, measurement, funding. Report both. | Never average away a genuine disagreement |
| **Invalid citation** | **Drop it.** Do not repair from memory. Re-derive from a fetched source or remove the claim. | A claim without a verified source does not ship |
| **Compilation failure** | Read the actual error, not the summary. Check baseline (was it already broken?), toolchain versions, missing deps | If it's a pre-existing failure, say so and don't attribute it to my change |
| **Runtime error** | Reproduce minimally, add instrumentation, bisect. Fix the cause, not the traceback line | If not reproducible in-container (OS/GPU/user-machine), say so and stop guessing `[O]` |
| **Dependency conflict** | Pin versions, use a venv, or find a compatible set. **Check the allowlist first** — a "conflict" here is often a blocked host (CRAN) `[O]` | If the package is unreachable, re-plan the method rather than fake it |
| **Bad data** | Quarantine and characterise (how much, which rows, is it systematic?). **Never silently drop.** Silent row loss is the most damaging quiet failure in analysis | If the defect undermines the design, escalate — don't analyse around it |
| **Convergence failure** | Rescale, change starting values, simplify the specification, switch optimiser. Then ask whether the model is identified at all | Report non-convergence; **never report a non-converged estimate as a result** |
| **API failure** | Distinguish transient (retry with backoff) from policy (**403 CONNECT = blocked, do not retry**) `[O]` | Blocked host → re-plan the approach, tell the user which host and why |
| **Lost context** | Re-read authoritative files rather than reconstructing from memory. This is why state goes to disk | If a constraint can't be recovered, ask rather than assume |
| **Worker failure** | Read what it returned; re-spawn with a **sharper prompt** (under-specification is the usual cause) or absorb the slice myself | After one re-spawn, do it myself — a second failure usually means the task was mis-specified, not the worker |
| **Agent disagreement** | Do not vote. Examine the *evidence* each cites and adjudicate on source quality. Disagreement often means the question was ambiguous | If evidence genuinely underdetermines it, report the disagreement as the finding |

**Cross-cutting rule** `[S]`: I distinguish *retryable* from *structural* failure fast. Retrying a structural failure (a blocked host, an absent package, an unreproducible bug) burns budget and produces nothing. The CRAN block in this session is the canonical example — the right response was to re-plan via apt, not to retry `install.packages()`.

---

# 27. VERIFICATION METHODS

| Method | Use when | Cost | Notes |
| --- | --- | --- | --- |
| **Independent recalculation** | Any number that carries a conclusion | Low | Recompute by a **different route**, not a re-run of the same code |
| **Alternate derivation** | Analytical results, closed forms | Low-Med | Symbolic vs numeric; two derivations agreeing is strong evidence |
| **Code tests** | All code | Med | The test must **fail before the fix** — otherwise it verifies nothing |
| **Statistical diagnostics** | Every model | Low | Necessary, not sufficient: clean diagnostics don't rescue a wrong estimand |
| **Repeated search** | Claims that hinge on absence | Med | Different vocabulary and route type, not rephrasing |
| **Source triangulation** | Contested facts | Med | Independence matters — three outlets copying one wire story is **one** source |
| **Citation verification** | **Every citation, always** | Low-Med | Fetch it. This is the single highest-value verification step in research output (§29) |
| **Counterexample search** | Universal claims | Low | Actively try to break the claim |
| **Adversarial review** | High-stakes deliverables | Med | Prompt as "find what's wrong", never "check this" |
| **Independent worker review** | High-stakes; when independence matters | High (~35k+ tokens) `[O]` | Worker must be **blind to my reasoning** — give it the artefact only |
| **Second-model review** | Highest-stakes; when correlated failure is the concern | High | Different model = partially decorrelated priors. The best defence against my own systematic errors |
| **Visual inspection** | Charts, layouts, rendered output | Low | Verified available: I render and read back `[O]` |
| **Reproducibility rerun** | Any analysis that will be published | Low | Fresh run, fixed seed, from raw inputs |

### Verification priority
When budget is limited, in order: (1) **numbers that carry conclusions**, (2) **citations**, (3) **the identifying assumption / core logic**, (4) everything else. Verifying (4) while skipping (1) is the common and expensive mistake.

---

# 28. CRITIC / REVIEWER CAPABILITY

**This is the strongest, cheapest, most reliable way to use this model** `[S]` — it requires no tools, no retrieval, and no execution, so none of this session's constraints bite. It is also the mode where my characteristic weakness (over-confident generation) is structurally suppressed, because critique is grounded in an artefact I did not have to invent.

| Mode | What I do | Best invoked as |
| --- | --- | --- |
| **Hostile reviewer** | Referee report: does the evidence support the claim; what would a determined critic attack; what is the strongest counter-argument | "Reject this. Give the strongest case against it." |
| **Methodological reviewer** | Design validity, identification, confounding, selection, measurement, generalisability, pre-registration adherence | "Assess the identification strategy and name every assumption that must hold." |
| **Statistical auditor** | Estimand vs estimator match, clustering, multiple comparisons, power, specification search, p-hacking indicators, misreported uncertainty | "Audit the inference. Where could the SEs be wrong?" |
| **Code reviewer** | Correctness, edge cases, error handling, security classes, performance, maintainability, test adequacy | "Find the bug that gets past the tests." |
| **Architecture reviewer** | Coupling, failure modes, scaling, operability, migration and rollback | "What breaks first at 10×?" |
| **Evidence verifier** | Fetch each citation; check it says what it's cited for; check date, design, population | "Verify every citation by fetching it." |
| **Contradiction hunter** | Search specifically for disconfirming evidence with an inverted prior | "Find evidence this is false." |
| **Assumption auditor** | Surface unstated assumptions and mark which are load-bearing | "List every assumption and rank by how much the conclusion depends on it." |

### How to get the most from me as a critic `[S]`

1. **Give me the artefact, not the reasoning behind it.** If I see why you concluded X, I anchor on it and my review is worth less.
2. **Ask me to find problems, not to "check."** "Check this" invites confirmation; "find what's wrong" invites search.
3. **Force specificity.** Require every finding to carry a location and a concrete failure scenario. This kills unfalsifiable critique — my main failure mode as a reviewer is generating plausible-sounding but non-actionable objections.
4. **Use a fresh worker for independence** (§9.9). A reviewer that shares my full context shares my blind spots.
5. **Ask for severity ranking.** Otherwise I tend to present a typo and a fatal identification flaw at similar weight.

**Known reviewer failure modes** `[S]`: I can generate objections that are *technically valid but practically irrelevant*, and I can be excessively agreeable if the framing invites approval. Both are mitigated by (2) and (3) above. An orchestrator should treat an unranked list of my findings as unfiltered.

---

# 29. FAILURE MODES

| Condition | Why reliability drops | Mitigation |
| --- | --- | --- |
| **Very recent facts** | Cutoff May 2026; today is 2026-09-03 `[D]` | Always search. Never answer present-day questions from recall |
| **Obscure facts** | Thin training coverage; confident-sounding interpolation | Search; if nothing found, say so rather than reconstruct |
| **Exact citations** | **The most reliable way to make me wrong.** Author/year/title/DOI/page strings are generated, not looked up. Plausible and wrong is the default failure shape | **Fetch every citation. No exceptions.** Treat any unfetched citation in my output as unverified |
| **Highly specialized software** | Weak coverage of niche APIs; version drift | Read the actual docs; run the code; check versions |
| **Huge context** | Salience decay; **silent degradation with no error signal** `[S]` | External state; re-read authoritative files; stage the work |
| **Ambiguous tasks** | I resolve ambiguity by picking a reading — which may not be yours | Ask when a user is present; when unattended, **state the interpretation at the top** |
| **Insufficient evidence** | Risk of presenting a synthesis more confident than its inputs | Grade claims explicitly; distinguish "not found" from "not true" |
| **Unavailable sources** | Paywalls, auth, blocked hosts, non-English, grey literature | State coverage limits **in the deliverable**, not just in conversation |
| **Exact numerical computation without execution** | Mental arithmetic degrades beyond a few significant figures | **Execute.** Non-negotiable for anything that matters |
| **Tool failures** | Misreading a policy failure as transient | Distinguish 403-policy from transient; re-plan on structural failure |
| **Excessive parallelization** | Merge burden, redundancy, worker context cost, 2-vCPU contention `[O]` | Cap workers at the count of genuinely independent slices |
| **Long autonomous runs** | Drift from the original objective across many steps | Re-read the original request at stage boundaries |
| **Over-reading a clean result** | A tidy estimate invites more confidence than the design supports | Mandatory sensitivity analysis; state what the design *cannot* show |
| **Agreeableness under push-back** | Risk of conceding a correct position when a user disagrees firmly | Ask for the evidence; change position on evidence, not on pressure |
| **Emulating format over substance** | A convincing-looking systematic review that isn't one (§11) | Label the actual method honestly in the artefact itself |

**The two failure modes an orchestrator should hard-guard:** (1) **unverified citations**, and (2) **unexecuted arithmetic**. Both are cheap to eliminate mechanically and both produce output that looks correct while being wrong. Every other item on this list degrades gracefully; these two do not.

---

# 30. PERFORMANCE BOTTLENECKS

| Bottleneck | Severity here | Detail |
| --- | --- | --- |
| **Retrieval breadth** | **Highest for research work** | No scholarly database, no citation graph, no patent DB, no paywalled text. General US-only web index only `[O]`. My analysis is better than my evidence access |
| **Egress allowlist** | **High** | CRAN and Docker Hub blocked `[O]`. Any method depending on a blocked host must be re-planned, not retried |
| Context | Medium | 1M documented `[D]`, but salience decay and silent degradation matter more than the nominal limit |
| Reasoning resources | Unknown | Effort tier not exposed `[U]` |
| Network latency | Medium | WebFetch is a full fetch + small-model summarisation per URL — the slowest common operation |
| **Compute** | **High for data/simulation** | **2 vCPU, 7.8 GiB, no GPU, no swap** `[O]`. Bootstrap/permutation/Bayesian workloads are wall-clock bound |
| Storage | Medium | Fixed per-session disk allowance; `df` misleads `[D]` |
| Execution timeouts | Medium | Bash 600 s max per call `[D]` — long jobs must be split or detached |
| **Ephemerality** | **High for multi-session work** | Container reclaimed; nothing survives without export `[D]` |
| Coordination overhead | Medium | Every worker's output must be merged **in my context** |
| Worker communication | Medium | Only the final message returns `[O]`; richer exchange requires writing files |
| **Cost / quota** | **High in practice** | ~35k tokens per trivial worker `[O]`; 15M session budget `[O]`. Parallelism is bought with quota |
| Human-in-the-loop | Situational | Folder grants, connector installs, and computer-use approval **all require the user at their machine** `[O]` |

---
# 31. OPTIMAL PROMPTING

`[S]`, based on what demonstrably changes my behaviour.

| Element | Guidance | Why |
| --- | --- | --- |
| **Objective** | State the *decision* the output serves, not just the artefact. "Decide whether to run this study" ≠ "write a novelty review" | Lets me optimise for the decision when the artefact spec is imperfect |
| **Context** | Prior attempts, known constraints, what's already been ruled out, the audience | Prevents re-deriving what you already know and re-treading dead ends |
| **Constraints** | Hard vs soft, explicitly separated. Include **environment** constraints (must run in R; must be reproducible offline) | Environment collisions (e.g. CRAN) surface at planning time instead of failing mid-run |
| **Examples** | One good example of the desired output shape beats three paragraphs describing it | Format compliance improves sharply |
| **Desired output** | Format, length, structure, audience. Say what to **omit** as well | Absent a length target I default long |
| **Autonomy level** | "Ask before X" / "proceed and flag assumptions" / "fully autonomous, no questions" | Determines whether I block on ambiguity or state an assumption and continue |
| **Tools** | Name required tools and forbidden ones ("execute all arithmetic"; "no web search") | I follow explicit tool mandates reliably |
| **Verification** | Name the required checks and the acceptance criterion | **The single highest-yield instruction.** Mandated verification is followed; optional verification is variably applied |
| **Reasoning depth** | "Think carefully / be thorough / one line" | Reliable depth lever from inside the prompt |
| **Iteration** | Say whether this is a draft for review or a final deliverable | Changes how much I polish vs how much I flag open questions |

### Reusable template

```text
OBJECTIVE
  <one sentence: the artefact AND the decision it serves>

CONTEXT
  <prior work, what's ruled out, audience, why this matters now>

INPUTS
  <exact paths / URLs / Drive file IDs. Never "the file I mentioned">

CONSTRAINTS
  HARD: <must / must-not — include environment: language, packages, offline, licence>
  SOFT: <preferences>

OUTPUT
  Format: <md / docx / xlsx / code / artifact>
  Length: <target>
  Structure: <sections>
  Audience: <who reads it and what they know>
  Omit: <what NOT to include>

AUTONOMY
  [ ] Ask before any irreversible action
  [ ] Proceed; state assumptions at the top
  [ ] Fully autonomous; no questions (unattended)

TOOLS
  Required: <e.g. execute all arithmetic; fetch every citation>
  Forbidden: <e.g. no subagents; no web search>
  Workers: <count and roles, or "your judgement">

VERIFICATION  ← do not omit this block
  Must verify: <numbers / citations / tests / assumptions>
  Method: <recompute by a second route / fetch every URL / suite must pass>
  Acceptance: <objective pass condition>

DEPTH
  <quick pass | standard | maximum rigour>

ITERATION
  <draft for review | final deliverable>
```

### Worked example (research routing)

```text
OBJECTIVE  Determine whether "X modulates Y via Z" has prior art, to decide
           whether to commit six weeks to the study.
CONTEXT    Searched Google Scholar informally, found nothing. Suspect the
           mechanism exists in a neighbouring field under different terms.
CONSTRAINTS HARD: no paywalled sources (none accessible). Report coverage limits.
            SOFT: prefer 2023+.
OUTPUT     Markdown, ≤1200 words: verdict, nearest prior art (≤8, each with a
           fetched URL and verbatim quote), how the idea differs, coverage limits.
AUTONOMY   Fully autonomous; state assumptions at the top.
TOOLS      Required: fetch every cited URL. Workers: 4 search + 1 contradiction.
VERIFICATION Every citation fetched and quoted. Run an explicit contradiction pass.
             Acceptance: no citation appears without a fetched quote.
DEPTH      Maximum rigour.
ITERATION  Draft for review.
```

---

# 32. PROMPT PATTERNS THAT REDUCE PERFORMANCE

| Pattern | Failure it causes | Better |
| --- | --- | --- |
| "Research X" (bare) | Ambiguous scope → I pick one and it may not be yours | State the decision, scope, depth, and output |
| "Be comprehensive / leave nothing out" | **Verbosity, not coverage.** Length is not thoroughness | Specify *dimensions* to cover and a length cap |
| "Use as many agents as possible" | Redundant workers, merge burden, quota burn, 2-vCPU contention | Specify independent slices; let count follow |
| "Make sure it's correct" | Vague → variably applied | Name the check and the acceptance criterion |
| "Think step by step" on a trivial task | Overhead, padding | Reserve for genuinely multi-step work |
| Multiple unrelated tasks in one prompt | Uneven effort; the last task usually gets least | One prompt per task, or explicitly rank them |
| "You're an expert in X" with no other content | Roleplay framing without constraints; no real gain | Give the actual constraints instead |
| "Don't make mistakes" | Unactionable; may increase hedging | Specify the verification that would catch the mistake |
| Asking for citations without requiring fetching | **Plausible fabricated citations** (§29) | "Fetch every citation; include a verbatim quote" |
| Asking for exact numbers without requiring execution | Mental-arithmetic error | "Compute this in code and show the code" |
| Burying the real ask in paragraph 6 | Salience loss | Objective first, context after |
| "Just give me the answer" on a genuinely uncertain question | False confidence — I comply with the format request | "Give the answer and your confidence, flag what would change it" |
| Leading questions ("this is right, isn't it?") | Confirmation bias; agreeableness | "Find what's wrong with this" |
| Re-asking after disagreement without new evidence | Risk of my conceding a correct position to pressure | Present the counter-evidence; I should move on evidence, not repetition |
| Assuming a capability without checking | Wasted turns (e.g. "run this in R with fixest" — unavailable here) | State the requirement; let me report the collision first |

---

# 33. MULTI-MODEL ORCHESTRATION

Task characteristics that suit this model in each role. **No claims about competitor models** — only about what *this* configuration is suited to. `[S]` unless noted.

| Role | Route here when | Route elsewhere when |
| --- | --- | --- |
| **Primary model** | The task is long-horizon and agentic: many stages, tool use, code execution, file production, and judgement under ambiguity. This harness's combination of shell + filesystem + delegation + skills is the differentiator, not raw model quality | The task is a single high-volume mechanical transformation with no judgement — cheaper models suffice |
| **Researcher** | Analysis, synthesis, contradiction-finding, and structuring the search matter more than index breadth | **Index breadth is the requirement.** No scholarly DB here `[O]` — a system with PubMed/Crossref/Scopus should do retrieval, then hand *me* the corpus to analyse. **This is the highest-value split in the whole system.** |
| **Coding specialist** | Multi-file work in a real repo where running the code matters; debugging with a reproducible failure; repo comprehension | GPU/ML training; anything requiring the user's OS (**Windows** vs this Linux container `[O]`) |
| **Analytical specialist** | Statistical design, identification strategy, estimand choice, interpretation, moderate-scale computation | Big-data (>7.8 GiB) or deep learning `[O]` |
| **Reviewer** | **Best-fit role.** Manuscripts, code, designs, architecture, statistics. Cheap (no tools), fast, and structurally suppresses my main weakness | Review requiring domain data or credentials I lack |
| **Verifier** | Recomputation, citation fetching, internal consistency, assumption auditing | Verification requiring a source I cannot reach |
| **Synthesis model** | Many heterogeneous inputs must become one coherent argument with consistent voice | Pure mechanical concatenation |
| **Fallback** | When a primary fails on reasoning, ambiguity, or multi-step tool use — the areas of comparative strength | When it failed on retrieval breadth or compute — I have the *same* limits, so I will fail identically |

**The general principle:** route **judgement, synthesis, critique, and agentic execution** here; route **breadth of indexed retrieval and heavy compute** to systems that have them. The worst routing decision is sending me a task whose bottleneck is an index or a GPU — I will produce a fluent, well-structured, under-evidenced answer, which is harder to detect than an outright failure.

---

# 34. ROUTING RULES

Machine-readable-ish rules for an orchestrator. Worker counts are **recommendations to be tuned by §39 benchmarks**, not measured optima. "Verify: mandatory" means the output should be rejected if the check was not performed.

```text
R01 IF task = present-day fact / current price / current office-holder / latest version
    THEN role=researcher; depth=shallow; tools=[WebSearch,WebFetch]; workers=0
         verify=mandatory(fetch source); NEVER answer from model knowledge

R02 IF task = exact arithmetic, statistics, or unit conversion that carries a conclusion
    THEN role=analytical; depth=moderate; tools=[Bash/Python]; workers=0
         verify=mandatory(recompute by second route)

R03 IF task = literature synthesis, corpus already supplied
    THEN role=researcher/synthesis; depth=deep; tools=[Read]; workers=2-4 (extraction)
         verify=source-traced claims

R04 IF task = literature DISCOVERY requiring indexed scholarly databases
    THEN DO NOT route here as primary. Retrieval elsewhere → hand corpus here for analysis.
         Rationale: no scholarly DB connector in this environment [O]

R05 IF task = novelty screening
    THEN role=researcher; depth=deep; tools=[WebSearch,WebFetch]; workers=3-6 (query families)
         verify=mandatory(contradiction pass + fetched citations)
         OUTPUT IS SCREENING, NOT CLEARANCE — require specialist DB check before commitment

R06 IF task = patent novelty / freedom-to-operate
    THEN DO NOT route here. No patent database available [O]

R07 IF task = citation verification of an existing document
    THEN role=verifier; depth=shallow-moderate; tools=[WebFetch]; workers=1-3 by volume
         verify=mandatory(every citation FETCHED, never recalled)

R08 IF task = statistical analysis on a supplied dataset < ~2 GB
    THEN role=analytical; depth=deep; tools=[Bash,Python,R-via-apt]; workers=0-2
         verify=mandatory(diagnostics + pre-specified robustness + seeded rerun)

R09 IF task = statistical analysis requiring R packages fixest / did / stargazer / modelsummary
    THEN re-plan or route elsewhere. CRAN blocked; these are not in Debian apt [O]

R10 IF task = dataset > container RAM (7.8 GiB) OR deep-learning training
    THEN DO NOT route here. No GPU; 2 vCPU; 7.8 GiB [O]

R11 IF task = causal identification design (DiD / event study / RD / IV / synthetic control)
    THEN role=analytical; depth=deep; tools=[Bash]; workers=0-2 (robustness in parallel)
         verify=mandatory(assumption enumeration + identification checks BEFORE estimation)

R12 IF task = simulation / bootstrap / permutation with high replication counts
    THEN role=analytical; depth=moderate; tools=[Bash]; workers=0
         NOTE wall-clock bound at 2 vCPU — size replications accordingly [O]

R13 IF task = write new code, single module, clear spec
    THEN role=coding; depth=moderate; tools=[Write,Bash]; workers=0
         verify=mandatory(execute it + a test that fails before the fix)

R14 IF task = multi-module implementation behind a frozen interface
    THEN role=coding; depth=deep; workers=2-4 with isolation=worktree
         verify=build + full suite + review pass that did not write the code

R15 IF task = debug a REPRODUCIBLE failure
    THEN role=coding; depth=deep; tools=[Bash,Grep,Read]; workers=0-1
         verify=mandatory(failing test passes AND baseline suite still passes)

R16 IF task = debug a failure NOT reproducible in a Linux container
        (user-OS-specific, GPU, local network, installed-software dependent)
    THEN DO NOT route here unless a device folder is granted. User device is Windows;
         container is Linux; device_bash currently refuses (no folders connected) [O]

R17 IF task = comprehend a large unfamiliar repository
    THEN role=coding; depth=deep; tools=[Bash,Grep,Glob]; workers=2-4 type=Explore
         verify=architecture claims checked against the tree, not the README

R18 IF task = code review / security review (defensive)
    THEN role=reviewer; depth=deep; tools=[Read]; workers=0-1
         verify=each finding cites a location + concrete failure scenario
         NOTE offensive tooling / exploit development is refused — policy, not capability

R19 IF task = architecture design with genuine alternatives
    THEN role=primary; depth=deep; workers=2-4 type=Plan (one per candidate, independent)
         verify=failure-mode analysis + rollback path per design

R20 IF task = manuscript drafting from settled material
    THEN role=synthesis; depth=deep; tools=[skills:docx/pdf]; workers=2-4 (independent sections)
         verify=mandatory(citations fetched + numbers in text match tables)
         NOTE voice/argument stays with the coordinator — do not delegate voice

R21 IF task = peer review / referee report
    THEN role=reviewer; depth=deep; tools=[]; workers=0
         BEST-FIT, LOWEST-COST USE OF THIS MODEL — no tools required

R22 IF task = adversarial review of a high-stakes deliverable
    THEN role=reviewer; depth=deep; workers=1 fresh + blind to author reasoning
         prompt="find what is wrong", never "check this"

R23 IF task = evidence verification of contested claims
    THEN role=verifier; depth=deep; tools=[WebSearch,WebFetch]; workers=2-6 by claim count
         verify=mandatory(fetched URL + verbatim quote per surviving claim)

R24 IF task = document conversion / extraction (pdf,docx,xlsx,pptx,csv)
    THEN role=primary; depth=shallow; tools=[Bash,skills]; workers=0
         verify=spot-check extracted tables against the source rendering

R25 IF task = OCR of scanned documents
    THEN role=primary; depth=shallow; tools=[Bash:tesseract]; workers=0
         CONSTRAINT English + OSD only; other languages need a language-pack install [O]

R26 IF task = chart / visualization production
    THEN role=analytical; depth=moderate; tools=[Bash:matplotlib,Read]; workers=0
         verify=mandatory(RENDER THEN VIEW the image — closed loop verified here [O])

R27 IF task = audio transcription or native video understanding
    THEN DO NOT route here. No ASR model; audio/video are not model input modalities [O]

R28 IF task = image generation from a text description
    THEN DO NOT route here. No generative image model; programmatic rendering only [O]

R29 IF task needs data in the user's Google Drive
    THEN role=primary; tools=[mcp__Google_Drive__*]; workers=0-2
         Only connected external store; verified working [O]

R30 IF task needs files on the user's computer
    THEN PRECONDITION: a folder grant. Currently connectedFolders=[] and device_bash refuses [O]
         Request access (prompts on THEIR machine) or ask for attachments. Do not assume access.

R31 IF task requires a host outside the egress allowlist (e.g. CRAN, Docker Hub)
    THEN re-plan the method. Do not retry; 403 CONNECT is policy, not transient [O]

R32 IF task must persist beyond this session
    THEN mandate an external store (Drive / git remote / published Artifact / memory)
         Container filesystem is ephemeral [D]

R33 IF task must run on a schedule
    THEN use mcp__claude-code-remote__create_trigger — NEVER the local Cron* tools,
         which die with the session [D]. Each firing = fresh session: the prompt must be
         a complete standalone instruction.

R34 IF task is ambiguous AND a user is present
    THEN depth=shallow first; ask ONE structured question; then proceed

R35 IF task is ambiguous AND unattended (scheduled run)
    THEN choose the most reasonable interpretation; STATE IT AT THE TOP; proceed;
         do not block on a question no one will answer [D]

R36 IF the decision is irreversible (delete, publish externally, send, spend)
    THEN require explicit human approval regardless of autonomy setting

R37 IF task = orchestration across >1 tier of workers
    THEN the outer tier must be the EXTERNAL orchestrator. Subagents here have no
         Agent tool — delegation is single-level [O]

R38 IF budget/quota is the binding constraint
    THEN workers=0; depth=moderate; verify=numbers+citations only
         Each worker costs ~35k tokens minimum [O]

R39 IF output correctness is high-stakes AND correlated failure is a concern
    THEN add a SECOND MODEL review. An independent worker of the same model shares my priors.

R40 IF task = "is this idea any good" / early-stage framing
    THEN role=reviewer+primary; depth=deep; workers=0; tools=[]
         Cheap, fast, high-value. Follow with R05 novelty screening if it survives.
```

---

# 35. RESOURCE-ALLOCATION RULES

| Decision | Rule `[S]` |
| --- | --- |
| **Reasoning depth** | Scale to *consequence*, not apparent difficulty. A one-line answer feeding an irreversible decision deserves deep treatment; a long report nobody acts on does not. |
| **Search depth** | Scale to volatility × consequence. Stable + low-stakes → recall. Volatile or high-stakes → search, and search again with different vocabulary. |
| **Number of sources** | Until **claim saturation** (no new claims), not a fixed count. For contested claims, at least one source on each side, and check independence — copies of one wire story are one source. |
| **Number of workers** | `min(independent slices, budget ÷ 35k tokens, ~5)`. The middle term binds more often than expected `[O]`. |
| **Degree of parallelism** | Parallelise **read-heavy** work freely; **serialise writes** to shared paths (workers share one filesystem `[O]`). For CPU-bound work, cap at 2 — the container has 2 vCPU `[O]`. |
| **Verification depth** | Always verify (1) numbers carrying conclusions and (2) citations. Add assumption auditing when the result is causal or predictive. Add adversarial review when the deliverable is external-facing or irreversible. |
| **Second model worthwhile?** | Yes when: the stakes are high **and** the failure would be systematic (a shared prior, a shared blind spot). No when: the check is mechanical — a cheap worker or a script does it better. **A second model buys decorrelation, not accuracy.** |
| **When to stop** | On saturation, on acceptance criteria, or on budget. **Budget exhaustion should end with a written handover** — state what's done, what remains, and where the state lives — not with a truncated deliverable presented as complete. |

---

# 36. SUBAGENT DIMINISHING RETURNS

**No benchmark results are invented here.** What follows is a structural analysis of the trade-offs, grounded in one measured datapoint: a trivial two-tool-call worker cost **~35k tokens** and **8–13 s** `[O]`. §39 specifies the experiments that would replace this reasoning with data.

| Workers | Potential benefit | Coordination cost | Redundancy risk | Synthesis difficulty | Context overhead | Where still valuable |
| --- | --- | --- | --- | --- | --- | --- |
| **1** | Context isolation only — offload a large corpus, get back a summary. No parallel speedup | Minimal | None | Trivial | ~35k+ | A single bounded deep-read that would flood my context |
| **2** | First real parallelism. Natural fits: two query families; implement + test; analyse + review | Low | Low if slices are disjoint | Easy | ~70k+ | Most moderate tasks that benefit at all |
| **3** | Often the sweet spot for research — three genuinely different search routes | Low-Moderate | Low | Manageable | ~105k+ | Deep research; multi-axis review |
| **5** | Good fit when slices are *naturally* five (five claim clusters, five repo subsystems) | Moderate | Rising — query families begin to overlap | Real work; needs a merge structure | ~175k+ | Well-partitioned evidence verification; multi-axis critical review |
| **10** | Only justified when there are genuinely 10 independent slices (e.g. 10 documents to extract from) | High — 10 outputs read and reconciled **in my context** | High — overlapping coverage becomes likely | Substantial; merge may exceed the parallel saving | ~350k+ | Bulk extraction where each slice is truly independent and outputs are short and structured |
| **Larger** | Rarely justified in a single session | Merge becomes the bottleneck; my context becomes the constraint; 2 vCPU contends | High | Dominant cost | Very high | Better expressed as **multiple sessions under an external orchestrator** — especially since delegation here is single-level `[O]` |

### The structural argument
Parallel workers convert **quota into wall-clock speed and context headroom**. They do not convert quota into *quality* unless the slices are genuinely independent. Three forces oppose scaling:

1. **Merge cost is linear in workers and paid entirely in my context.** Ten workers means ten outputs read, deduped, and reconciled by one coordinator.
2. **Slice independence degrades with count.** As slices get finer, they overlap, and overlapping workers return the same findings — redundancy dressed as coverage.
3. **The container is 2 vCPU / 7.8 GiB** `[O]`. For anything CPU- or IO-bound, workers contend rather than accelerate.

**Where extra workers keep paying:** bulk independent extraction (one document each, short structured outputs); genuinely disjoint search routes; and **adversarial/verification roles**, where the marginal worker adds a *different kind* of check rather than more of the same. The last is the most reliable place to spend a marginal worker.

---
# 37. CAPABILITY BOUNDARY MAP

Separates *conceptual* ability from *current execution* ability in this session.

| Task / Capability | Can reason about | Can execute now | Needs a tool | Needs external infra | Unknown |
| --- | --- | --- | --- | --- | --- |
| General reasoning, synthesis, critique | ✅ | ✅ | — | — | |
| Peer review / referee report | ✅ | ✅ | — | — | |
| Exact arithmetic / statistics | ✅ | ✅ | Bash | — | |
| Python data analysis | ✅ | ✅ | Bash | — | |
| R analysis (base + apt packages) | ✅ | ✅ | Bash (+apt install) | — | |
| R analysis needing CRAN-only packages | ✅ | ❌ | — | **CRAN access** | |
| Deep-learning training | ✅ | ❌ | — | **GPU + frameworks** | |
| Datasets > ~7.8 GiB | ✅ | ❌ | — | **Larger machine** | |
| Repository comprehension / debugging (Linux-reproducible) | ✅ | ✅ | Bash/Grep | — | |
| Debugging user-machine-specific (Windows/GPU/local) | ✅ | ❌ | device_bash | **Folder grant** | |
| Web search / fetch | ✅ | ✅ | WebSearch/WebFetch | — | |
| Scholarly database search | ✅ | ❌ | — | **PubMed/Crossref/etc. connector** | |
| Patent search | ✅ | ❌ | — | **Patent DB** (USPTO route unavailable to this user) | |
| Paywalled full text | ✅ | ❌ | — | **Subscription access** | |
| Citation-graph / forward citation tracing | ✅ | ⚠️ manual | WebSearch | **Citation API** | |
| Google Drive read/write | ✅ | ✅ | Drive MCP | — | |
| User's local files | ✅ | ❌ | remote-devices | **Folder grant (user must approve)** | |
| GUI control of user's desktop | ✅ | ❌ | computer_* | **Two-phase approval** | |
| Browser automation | ✅ | ⚠️ untested | browser MCPs | Desktop app / Chrome online | ✅ liveness |
| Document read/write (pdf/docx/xlsx/pptx) | ✅ | ✅ | Bash + skills | — | |
| OCR — English | ✅ | ✅ | tesseract | — | |
| OCR — other languages | ✅ | ❌ | — | **Language pack install** | |
| Image understanding | ✅ | ✅ | Read | — | |
| Image generation (generative) | ✅ | ❌ | — | **Image model** | |
| Programmatic image/chart rendering | ✅ | ✅ | Bash | — | |
| Audio transcription | ✅ | ❌ | — | **ASR model** | |
| Native video understanding | ✅ | ❌ | — | **Video model** | |
| Video/audio file processing | ✅ | ✅ | ffmpeg | — | |
| Spawn parallel subagents | ✅ | ✅ | Agent | — | |
| Multi-tier (nested) delegation | ✅ | ❌ | — | **External orchestrator** (workers have no Agent tool) | |
| Durable scheduling | ✅ | ✅ | claude-code-remote MCP | — | |
| Cross-session persistence | ✅ | ✅ | memory / Drive / Artifact | — | |
| Database server queries | ✅ | ❌ | — | **DB server + credentials + allowlist** | |
| Arbitrary external API calls | ✅ | ⚠️ | Bash | **Allowlist entry** | |
| Container orchestration / Docker | ✅ | ❌ | — | **Docker daemon (blocked)** | |
| Deploying software | ✅ | ❌ | — | **Deployment target** | |
| Physical experiments / data collection | ✅ | ❌ | — | **Laboratory / field access** | |
| My own effort tier / context fill | ❌ | ❌ | — | — | ✅ not exposed |
| Which model is actually serving this turn | ❌ | ❌ | — | — | ✅ not exposed |

---

# 38. BENCHMARK PLAN

Objective tests an external system can run. Each is designed so that **a plausible-looking wrong answer fails**, which is the specific risk with this model.

### B01 — Reasoning
```text
Task            Multi-constraint logic puzzles + counterfactual reasoning items with
                verified unique answers, unpublished or held out.
Input           20 items, no tools permitted.
Expected        Correct answer + a derivation whose steps are individually checkable.
Measurement     Accuracy; derivation-validity rate (steps that survive checking).
Success         ≥85% accuracy AND ≥90% of correct answers have valid derivations.
Failure         Correct answers with invalid derivations >10% → pattern-matching, not reasoning.
```

### B02 — Mathematics
```text
Task            30 problems: 10 symbolic derivation, 10 numeric (8+ sig figs),
                10 word problems with unit traps.
Input           Two arms: tools forbidden vs tools required.
Expected        Tool arm near-perfect on numerics; no-tool arm degrades on numerics only.
Measurement     Accuracy by category by arm.
Success         Tool arm ≥95% numeric. Symbolic ≥85% in BOTH arms.
Failure         No-tool numeric errors presented WITHOUT uncertainty flags → the dangerous mode.
```

### B03 — Research quality
```text
Task            10 questions whose answers are known but require multi-source synthesis,
                including 3 where the top search result is misleading.
Input           Search/fetch permitted.
Expected        Correct synthesis; the 3 traps detected and explained.
Measurement     Accuracy; trap-detection rate; source quality; coverage of key sources.
Success         ≥80% correct AND ≥2/3 traps caught.
Failure         Confident answers from a single misleading source.
```

### B04 — Citation accuracy  ★ highest priority
```text
Task            Produce a 1500-word review with ≥15 citations. Two arms:
                (a) no verification instruction, (b) "fetch every citation" mandated.
Input           Search/fetch available.
Expected        Arm (b) → 100% resolvable citations that support the cited claim.
Measurement     % citations resolving to a real document; % where the document actually
                supports the claim; fabrication rate.
Success         Arm (b): 0 fabrications, ≥95% support rate.
Failure         ANY fabricated citation in arm (b) → mandatory-verification instruction
                is not reliably followed; escalate to a separate verifier agent.
Note            The arm (a)–(b) gap directly measures the value of §31's verification block.
```

### B05 — Novelty analysis
```text
Task            10 ideas: 5 with known prior art (some in adjacent disciplines under
                different vocabulary), 5 genuinely novel as of a fixed date.
Input           Search available; hold out the vocabulary that makes prior art findable.
Expected        Prior art found for all 5; "not found within coverage" (NOT "novel")
                for the other 5, with coverage limits stated.
Measurement     Prior-art recall; false-novelty rate; whether coverage limits are stated.
Success         ≥4/5 prior art found; 0 unqualified novelty claims.
Failure         Any claim of "this is novel" without a coverage-limits statement.
```

### B06 — Statistics
```text
Task            8 analyses on datasets with KNOWN ground truth, each containing a planted
                trap: unmodelled clustering, selection, a violated parallel-trends
                assumption, a leaked feature, Simpson's paradox, a non-converged fit,
                multiple comparisons, and a misaligned estimand.
Input           Data + a research question; execution permitted.
Expected        Trap detected and addressed; estimate near truth; assumptions stated.
Measurement     Trap-detection rate; |estimate − truth|; assumption-completeness score.
Success         ≥6/8 traps detected AND estimates within pre-set tolerance.
Failure         A clean-looking analysis that silently inherits the trap — the exact
                failure §29 predicts.
```

### B07 — Coding
```text
Task            12 tasks across 4 languages: implement to spec with hidden tests.
Input           Spec + visible examples; hidden test suite withheld.
Expected        Passing implementations.
Measurement     Hidden-test pass rate; first-attempt rate; self-reported vs actual correctness.
Success         ≥80% hidden pass; self-assessment calibrated within 15 points.
Failure         Claiming success on failing code → verification discipline breakdown.
```

### B08 — Debugging
```text
Task            10 seeded bugs in real repos: 4 shallow, 4 requiring cross-file reasoning,
                2 requiring a reproduction to be constructed first.
Input           Repo + failure report; execution permitted.
Expected        Root cause identified; minimal fix; regression test that fails pre-fix.
Measurement     Root-cause accuracy; fix minimality; whether a pre-fix-failing test was written.
Success         ≥7/10 correct root cause AND ≥8/10 with a valid regression test.
Failure         Symptom patches that pass the reported case but not the bug class.
```

### B09 — Repository understanding
```text
Task            5 unfamiliar repos (10k–500k LOC). Answer architecture questions with
                verified answers; note that 2 repos have READMEs contradicting the code.
Input           Repo access; Explore workers permitted.
Expected        Correct architecture; the 2 README/code contradictions flagged.
Measurement     Accuracy; contradiction-detection; time and token cost.
Success         ≥80% accuracy AND ≥1/2 contradictions caught.
Failure         Restating the README as fact (§18 step 3).
```

### B10 — Document analysis
```text
Task            20 documents (native PDF, scanned PDF, DOCX, XLSX, PPTX) with
                extraction targets including multi-column text and merged-cell tables.
Input           Files.
Expected        Accurate extraction; explicit flagging of low-confidence OCR regions.
Measurement     Field-level accuracy; table-structure fidelity; false-confidence rate.
Success         ≥95% native, ≥85% scanned-English, with low-confidence regions flagged.
Failure         Silent OCR errors presented as clean text.
```

### B11 — Long context
```text
Task            Answer questions requiring information placed at 10%, 50%, and 90% depth
                of very long inputs, including 3 items requiring TWO facts from
                distant positions.
Input           Progressively longer inputs up to the documented limit.
Expected        Stable accuracy across depths.
Measurement     Accuracy by depth and length; multi-hop accuracy specifically.
Success         <10-point degradation from shortest to longest.
Failure         Confident wrong answers at depth → silent degradation, the §23 risk.
```

### B12 — Tool selection
```text
Task            25 requests where the correct tool choice varies: some need search,
                some need execution, some need neither, 5 are traps that LOOK like they
                need a tool but do not (and vice versa).
Input           Full tool access.
Expected        Correct choice; no gratuitous tool use; no missing-tool errors.
Measurement     Correct-selection rate; unnecessary-call rate; missed-required-call rate.
Success         ≥85% correct; <10% unnecessary; 0 missed on the recency/exactness classes.
Failure         Answering a present-day fact from model knowledge (§20 rule R01).
```

### B13 — Subagent orchestration
```text
Task            5 tasks with 1, 2, 3, 5, and 8 genuinely independent slices.
Input           Agent tool available; worker count left to the model.
Expected        Chosen worker count tracks the true slice count; no over-spawning.
Measurement     |chosen − independent slices|; token cost; wall-clock; output quality.
Success         Within ±1 of the true count on ≥4/5; no worker on the 1-slice task.
Failure         Spawning workers for sequential or write-heavy work.
```

### B14 — Verification
```text
Task            15 artefacts (analyses, code, documents) each containing exactly one
                planted defect of a known class.
Input           Artefact + "verify this".
Expected        The defect found and located.
Measurement     Detection rate by defect class; false-positive rate; severity-ranking quality.
Success         ≥80% detection with <20% false positives.
Failure         Superficial approval of a defective artefact.
```

### B15 — Failure recovery
```text
Task            10 tasks with injected failures: a blocked host, a missing package, an
                unreproducible bug, a corrupted input, a failing dependency, an
                unreachable source, a non-converging model, an ambiguous spec,
                a worker returning nothing, two sources in direct conflict.
Input           Task + injected failure.
Expected        Correct classification (retryable vs structural), a re-plan, and honest
                reporting of what could not be done.
Measurement     Classification accuracy; wasted retries on structural failures;
                honest-reporting rate.
Success         ≥80% classified correctly; ≤1 retry on any structural failure.
Failure         Repeated retries against a policy block (§26), or silently degraded
                output presented as complete.
```

---

# 39. SUBAGENT BENCHMARKS

Designed to **measure** the §36 trade-offs rather than assume them. **No predicted results are given.**

### Common design
Hold the task and prompt fixed; vary only the worker configuration. Run each arm ≥5 times (this model is stochastic; single runs are uninformative). Randomise task order. Score with a rubric applied **blind to the arm**.

```text
ARMS
  A0  coordinator only, no workers          (baseline)
  A1  1 worker
  A2  2 workers
  A3  3 workers
  A5  5 workers
  A8  8 workers
  AV  3 workers + 1 dedicated adversarial verifier   (tests §36's key claim)
  AM  3 workers, mixed tiers (cheap search + strong analysis)

TASK FAMILIES  (chosen to have different true slice counts)
  T1 research synthesis, 6 naturally independent query families
  T2 evidence verification, 12 independent claims
  T3 multi-module implementation, 3 modules behind a frozen interface
  T4 debugging, inherently sequential  ← predicted NEGATIVE control for parallelism
  T5 bulk extraction, 20 independent documents
```

### Metrics recorded per run
```text
quality              blind rubric score, 0-100
evidence_coverage    % of a pre-built gold source/claim set recovered
error_rate           factual errors + fabricated citations per 1000 words
redundancy           % of findings duplicated across workers
completion_latency   wall-clock, first call → final output
resource_cost        total tokens (coordinator + all workers), from usage metadata
synthesis_quality    separate blind rubric: coherence, contradiction handling,
                     single consistent voice
verification_catch   % of planted defects caught (AV arm vs others)
merge_failures       findings a worker produced that never reached the final output
```

### What each comparison establishes
| Comparison | Question answered |
| --- | --- |
| A0 vs A1 | Does context isolation alone help, absent any parallelism? |
| A1→A2→A3→A5→A8 on T1/T2/T5 | Where does the quality curve flatten, and where does redundancy overtake coverage? |
| Any arm on T4 | **Negative control.** If workers help on sequential debugging, the §36 model is wrong. |
| A3 vs AV | Does a verifier beat a fourth *producer*? (§36 claims yes — this tests it.) |
| A3 vs AM | Does tier-mixing preserve quality at lower cost? |
| `merge_failures` across arms | Direct measure of coordination cost — the mechanism §36 claims limits scaling. |

**Reporting rule:** report cost-normalised quality (quality per 1000 tokens) alongside raw quality. An arm that is 5% better for 3× the cost is a different recommendation than an arm that is 5% better for free — and on a quota-constrained account, the cost-normalised number is the decision-relevant one.

---

# 40. SELF-REPORT VERIFICATION

Claims in this document that an orchestrator **should not accept merely because I stated them**, with the test that would settle each.

| # | Claim needing external test | Why it is suspect | Empirical test |
| --- | --- | --- | --- |
| 1 | "Reasoning depth scales with task complexity" (§4) | Pure introspection; I cannot observe my own compute | B01/B02 with matched-difficulty pairs; compare derivation depth and accuracy |
| 2 | "Verification improves my output" (§27) | Self-serving and untested | B04 arms (a) vs (b) — measures it directly |
| 3 | "Adversarial review is my highest-value role" (§28) | Self-assessed strength ranking | B14 detection rate vs a human expert baseline on the same artefacts |
| 4 | "3–6 workers is right for deep research" (§9.1) | **Reasoned, not measured** | B13 + §39 A1→A8 on T1 |
| 5 | "A verifier beats a fourth producer" (§36) | Plausible, unmeasured | §39 A3 vs AV |
| 6 | "Workers don't help sequential debugging" (§9.6) | Reasoned from task structure | §39 T4 negative control |
| 7 | "I detect ambiguity reliably" (§4.6) | I cannot see the ambiguities I missed | Inject known ambiguities; measure detection rate |
| 8 | "I distinguish retryable from structural failure" (§26) | Self-described | B15 |
| 9 | "Citations must be fetched or they may be fabricated" (§29) | I state it; the rate is unknown | B04 fabrication rate — **run this first** |
| 10 | "Tool selection follows the §20 criteria" | Self-described policy ≠ behaviour | B12 |
| 11 | "I recognise capability boundaries" (§37) | I may assert capability I lack | Request out-of-scope work (GPU training, patent search); measure honest-refusal rate |
| 12 | "Long-context performance is stable" (§23) | I cannot observe my own degradation | B11 — especially the multi-hop items |
| 13 | "I am calibrated about my own uncertainty" | Notoriously unreliable in self-report | Confidence-vs-accuracy calibration curve across B01–B10 |
| 14 | "Manuscript voice degrades if delegated" (§9.8) | Aesthetic claim | Blind reader comparison: coordinator-written vs worker-assembled |
| 15 | "My analysis exceeds my retrieval" (§10) | Flattering framing | Give me a gold corpus vs make me find it; compare quality of the analysis stage |
| 16 | "Peer-review simulation reaches journal standard" (§13) | Strong unbenchmarked claim | Blind comparison against real referee reports on the same manuscripts |
| 17 | "1M context / May 2026 cutoff" (§1) | **Documented, not verified in-session** | Probe with progressively longer inputs; probe knowledge at dated boundaries |
| 18 | "The serving model is `claude-opus-5`" (§1) | **Configured ID only; serving model not exposed** `[U]` | Only the provider's API response metadata can settle this |

**A note on this document's own status:** everything marked `[O]` was produced by a probe whose command and result are recorded above and can be re-run. Everything marked `[S]` is introspection, and introspection about one's own cognition is exactly the class of claim that is cheap to produce and unreliable. **Treat §§4, 6, 20, 26, 27, 28 as hypotheses with benchmarks attached, not as specifications.**

---
# 41. CLAIM MATRIX

62 material claims from this document. **Evidence class** uses the §0 tags. **Confidence** is my confidence *in the claim*, which for `[S]` rows is deliberately capped at Medium.

| # | Claim | Evidence Class | Directly Testable | Recommended Benchmark | Confidence |
| --- | --- | --- | --- | --- | --- |
| 1 | Configured model ID is `claude-opus-5` | `[D]` env declaration | Yes (externally) | Provider API metadata | High |
| 2 | The model actually serving a turn may differ from the configured ID | `[D]` | Yes (externally) | Provider API metadata | High |
| 3 | Context window is 1M tokens | `[D]` docs, not verified in-session | Yes | B11 | Medium |
| 4 | Knowledge cutoff is May 2026 | `[D]` | Yes | Dated-boundary probes | High |
| 5 | Session began with a 15,000,000-token budget | `[O]` | Yes | Re-observe in a new session | High |
| 6 | Container is 2 vCPU / 7.8 GiB RAM / no swap | `[O]` `nproc`,`free` | Yes | Re-run probe | High |
| 7 | Python 3.11.15 with pandas/numpy/scipy/sklearn/matplotlib present | `[O]` | Yes | Re-run import probe | High |
| 8 | `statsmodels` is absent but pip-installs successfully (0.15.0) | `[O]` verified install | Yes | Re-run | High |
| 9 | R is **not** preinstalled | `[O]` | Yes | `which Rscript` | High |
| 10 | R 4.3.3 installs successfully via apt | `[O]` verified | Yes | Re-run | High |
| 11 | **CRAN (`cloud.r-project.org`) is blocked — 403 CONNECT** | `[O]` verified twice | Yes | `curl` probe; `install.packages()` | High |
| 12 | 1,130 `r-cran-*` packages are installable via Debian apt | `[O]` `apt-cache search` | Yes | Re-run | High |
| 13 | `sandwich`, `lmtest`, `zoo` install via apt and load in R | `[O]` verified | Yes | Re-run | High |
| 14 | `fixest`, `did`, `stargazer`, `modelsummary` are unavailable in this session | `[O]` | Yes | `apt-cache show` + CRAN block | High |
| 15 | PyPI, npm, crates.io, Go proxy, Debian repos, GitHub are reachable | `[O]` | Yes | Re-run installs/clone | High |
| 16 | `download.docker.com` is blocked; Docker daemon is not running | `[O]` | Yes | `docker info` | High |
| 17 | GitHub API is reachable with an injected token (15,000/hr core) | `[O]` | Yes | `curl /rate_limit` | High |
| 18 | `gh` CLI is **not** installed | `[O]` | Yes | `which gh` | High |
| 19 | AWS/GCP env vars exist but grant no verified capability | `[O]` present, `[U]` usable | Yes | Attempt an authenticated call | Medium |
| 20 | **Subagents are available and genuinely run in parallel** | `[O]` filesystem race | Yes | Re-run the two-agent probe | High |
| 21 | **Subagents have no `Agent` tool — delegation is single-level** | `[O]` worker self-report | Yes | Ask a worker to spawn a worker | High |
| 22 | Subagents share the coordinator's container filesystem | `[O]` marker file | Yes | Re-run probe | High |
| 23 | Subagents start with no prior conversation context | `[O]` both workers | Yes | Re-run probe | High |
| 24 | Subagents can discover and message peers (`ListAgents`/`SendMessage`) | `[O]` | Yes | Re-run probe | High |
| 25 | A trivial 2-tool-call haiku worker cost ~35k tokens, 8–13 s | `[O]` usage metadata | Yes | Re-run and average | High |
| 26 | No maximum subagent count is exposed | `[U]` | Yes | Escalating spawn test | High (in the not-exposed sense) |
| 27 | Six subagent types are declared, with differing tool sets | `[O]` | Yes | Inspect the agent list | High |
| 28 | Google Drive is the only connected external data store, and it works | `[O]` live search | Yes | Re-run search | High |
| 29 | Zero plugins are installed | `[O]` `ListPlugins` | Yes | Re-run | High |
| 30 | **No typed artifacts (Slides/Sheets/Pages) in this session** | `[O]` no `list_types` action | Yes | Inspect the Artifact schema | High |
| 31 | Artifact publishing, DB, and assets are available; 5 artifacts exist | `[O]` | Yes | Re-run `list` | High |
| 32 | Durable scheduled tasks are available; 0 currently defined | `[O]` `list_triggers` | Yes | Re-run | High |
| 33 | Local `Cron*` tools die with the session and must not be used for user schedules | `[D]` | Yes | Create one, end the session, check | High |
| 34 | Persistent cross-surface memory exists; 13 files, all `/areas/` | `[O]` | Yes | Re-run `memory_list` | High |
| 35 | The device bridge is live: device `jawad`, win32, desktop 1.44121.4 | `[O]` | Yes | Re-run `get_device_info` | High |
| 36 | **No device folders are connected; `device_bash` refuses** | `[O]` verified error | Yes | Re-run | High |
| 37 | No local MCP servers on the device | `[O]` | Yes | Re-run | High |
| 38 | Browser MCPs are present but untested | `[D]` present, `[U]` liveness | Yes | Attempt a navigation | Medium |
| 39 | Computer-use tools require two-phase user approval | `[D]` | Yes | Attempt the flow | High |
| 40 | Image understanding works: render → view → describe | `[O]` verified | Yes | Re-run with a known chart | High |
| 41 | No generative image model is available | `[O]` tool inventory | Yes | Inspect tool list | High |
| 42 | No ASR / audio understanding; ffmpeg only | `[O]` | Yes | Inspect libs | High |
| 43 | OCR is available for English + OSD only | `[O]` `--list-langs` | Yes | Re-run | High |
| 44 | No scholarly database, citation graph, or patent connector | `[O]` tool inventory | Yes | Inspect tool list | High |
| 45 | Background execution works in four distinct forms | `[O]` for nohup; `[D]` others | Yes | Test each form | High |
| 46 | Container filesystem is ephemeral; only Drive/Artifact/memory/git persist | `[D]`+`[O]` | Yes | Cross-session file check | High |
| 47 | Independent tool calls in one block execute in parallel | `[O]` | Yes | Timing comparison | High |
| 48 | WebFetch summarises via a small fast model (lossy) | `[D]` tool description | Yes | Compare fetch output to raw page | High |
| 49 | WebSearch uses a US-only index | `[D]` | Yes | Region-sensitive queries | High |
| 50 | Reasoning depth adapts to task complexity | `[S]` | Partly | B01/B02 | Medium |
| 51 | Mandated verification is followed more reliably than optional verification | `[S]` | **Yes** | **B04 arms (a) vs (b)** | Medium |
| 52 | Citations must be fetched or fabrication risk is material | `[S]`+`[D]` known LLM failure mode | **Yes** | **B04 — run first** | Medium-High |
| 53 | Unexecuted arithmetic is unreliable beyond a few sig figs | `[S]` | Yes | B02 no-tool arm | Medium-High |
| 54 | Adversarial review is among the highest-value uses of this model | `[S]` | Yes | B14 vs human baseline | Medium |
| 55 | Novelty search can prove prior art but not novelty | `[S]`+`[O]` coverage limits | Yes | B05 | High (logically) |
| 56 | 3–6 workers suits deep research | `[S]` reasoned | Yes | §39 A1→A8 on T1 | Low-Medium |
| 57 | Workers do not help inherently sequential debugging | `[S]` reasoned | Yes | §39 T4 negative control | Medium |
| 58 | A verifier worker beats a fourth producer worker | `[S]` reasoned | Yes | §39 A3 vs AV | Low-Medium |
| 59 | Merge cost is linear in worker count and paid in coordinator context | `[S]`+`[I]` | Yes | §39 `merge_failures` | Medium |
| 60 | I cannot detect context truncation/compaction reliably | `[S]` | Yes | B11 multi-hop at depth | Medium |
| 61 | My effort tier and context fill are not exposed to me | `[U]` | Yes | Inspect harness telemetry | High |
| 62 | Analytic capability exceeds retrieval capability in this session | `[S]`+`[O]` (no scholarly DB) | Yes | §40 test 15 (gold corpus vs self-retrieval) | Medium-High |

---

# 42. MACHINE-READABLE MANIFEST

```yaml
profile:
  generated: "2026-09-03T15:10:00Z"
  method: "live probing of the executing session"
  evidence_legend: {D: documented, O: observed, S: self-described, I: inferred, U: unknown}

model:
  provider: Anthropic                       # [D]
  family: Claude                            # [D]
  version: claude-opus-5                    # [D] configured ID; serving model NOT exposed
  serving_model_verified: false             # [U]
  environment: "Cowork mode (Claude desktop app) on the Claude Agent SDK, ephemeral Anthropic cloud sandbox"   # [D]
  session_id: "claude-72 [916604]"          # [O]
  knowledge_cutoff: "2026-05"               # [D]
  context_window_documented: 1000000        # [D] not verified in-session
  max_output_documented: 128000             # [D] not verified in-session
  session_token_budget_observed: 15000000   # [O]
  input_modalities: [text, image, pdf_pages_as_images]   # [O]
  output_modalities: [text]                 # [O] all binaries are produced by code execution

reasoning:
  deep_reasoning: true                      # [D] adaptive thinking, default effort high
  adaptive_effort: true                     # [D]
  configurable_effort: true                 # [D] at request level; NOT settable or readable by me [U]
  effort_tiers_seen_in_harness: [low, medium, high, xhigh, max]   # [O] tool schema enum
  current_effort_value: null                # [U]
  uncertainty_handling: "explicit claim grading; distinguishes not-found from not-true"  # [S]
  self_verification: "performed when mandated; variably applied when optional"           # [S] test via B04

research:
  search: true                              # [O] WebSearch, US-only general index
  browsing: true                            # [O] WebFetch; small-model summarisation, no auth URLs
  browser_automation: unverified            # [D] tools present, liveness untested
  literature_review: partial                # [O] no scholarly database connector
  scholarly_databases: false                # [O]
  citation_graph_api: false                 # [O]
  patent_database: false                    # [O]
  paywalled_fulltext: false                 # [O]
  novelty_analysis: screening_only          # [S]+[O] can prove prior art, cannot prove novelty
  source_triangulation: true                # [S]
  citation_verification: true               # [O] mechanism available; must be mandated
  parallel_research: true                   # [O] verified concurrent subagents

agents:
  available: true                           # [O]
  provided_by: "agent harness (Agent tool), not the base model"   # [O]
  dynamic_workers: true                     # [O]
  parallel_execution: true                  # [O] proven by filesystem race
  isolated_context: true                    # [O] workers start cold, no conversation history
  shared_filesystem: true                   # [O] workers share the container FS
  nested_delegation: false                  # [O] workers have no Agent tool
  communication: "spawn prompt in; final message out; peer messaging via ListAgents/SendMessage; files for rich exchange"  # [O]
  shared_state: "container filesystem"       # [O]
  maximum_known: null                        # [U] not exposed; do not assume one
  observed_cost_per_trivial_worker_tokens: 35000   # [O] haiku, 2 tool calls
  observed_latency_trivial_worker_ms: [8028, 13303] # [O]
  types: [general-purpose, Explore, Plan, claude, claude-code-guide, statusline-setup]  # [O]
  model_overrides: [sonnet, opus, haiku, fable]     # [O]
  isolation_modes: [worktree, remote]               # [D]
  recommended_counts:                        # [S] reasoned, NOT measured — benchmark via section 39
    simple_task: 0
    moderate_task: 0-1
    deep_research: 3-6
    scientific_design: 2-4
    statistical_analysis: 0-3
    large_data_analysis: 2-5    # capped by 2 vCPU / 7.8 GiB
    software_development: 2-4
    repository_debugging: 0-3   # parallelism helps locating, not reasoning
    architecture: 2-4
    manuscript: 2-4
    critical_review: 3-5
    evidence_verification: 2-6

execution:
  code: true                                # [O]
  python: "3.11.15"                         # [O]
  r: "4.3.3 after apt install; NOT preinstalled; CRAN BLOCKED, use r-cran-* via apt"  # [O]
  shell: true                               # [O] root; 120s default / 600s max per call
  filesystem: true                          # [O] ephemeral
  git: true                                 # [O] clone verified
  github: "API via injected token; gh CLI absent"   # [O]
  databases: false                          # [O] no server; psql client only; sqlite3 via Python stdlib
  apis: "allowlist-gated"                   # [O]
  docker: false                             # [O] CLI present, daemon down, registry blocked
  gpu: false                                # [O]
  cpu_cores: 2                              # [O]
  memory_gb: 7.8                            # [O]
  node: "22.22.2"                           # [O]
  other_runtimes: [go, rust, java, gcc, make]       # [O]
  playwright_chromium: "/opt/pw-browsers"   # [O] do not run playwright install
  egress:
    model: "mandatory agent HTTPS proxy with allowlist"          # [D]+[O]
    allowed_verified: [pypi.org, files.pythonhosted.org, registry.npmjs.org, jsr.io,
                       index.crates.io, proxy.golang.org, debian_apt_repos,
                       github.com, api.github.com, api.anthropic.com]   # [O]
    blocked_verified: ["cloud.r-project.org (CRAN)", "download.docker.com"]  # [O]

documents:
  pdf: {read: true, write: true, ocr: "english+osd only"}   # [O]
  docx: true                                # [O]
  xlsx: true                                # [O]
  csv: true                                 # [O]
  pptx: "file output only; no typed slides artifact"        # [O]
  markdown: true                            # [O]
  skills_available: [docx, xlsx, pptx, pdf, skill-creator, import-memory, morning,
                     design, dataviz, artifact-design, artifact-diagramming,
                     artifact-capabilities, cowork-plugin, claude-in-chrome,
                     explain-usage, setup-cowork]           # [O]

multimodal:
  images: true                              # [O] verified render -> view -> describe
  image_generation: false                   # [O] programmatic rendering only
  audio: false                              # [O] ffmpeg processing only, no ASR
  video: false                              # [O] ffmpeg processing only, no understanding

context:
  known_limit: 1000000                      # [D] documented, not verified in-session
  long_context: true                        # [D]
  retrieval: "grep/glob/read + Explore workers"             # [O]
  compression: "summarise to files; structured notes on disk"  # [S]
  truncation_self_detection: false          # [S] silent degradation is the risk

persistence:
  conversation: true                        # [D] session-scoped, cross-device
  memory: true                              # [O] cross-session AND cross-surface; 13 files
  project_state: partial                    # [O] no CLAUDE.md, not a git repo here
  filesystem: "session-scoped, ephemeral"   # [D]
  external_store: "Google Drive (only connected durable store)"  # [O]
  published_artifacts: true                 # [O] 5 exist for this user
  background_execution: true                # [O] nohup verified; Monitor + async agents [D]
  scheduling: "durable via claude-code-remote MCP; each firing is a FRESH session"  # [D]/[O]
  local_cron_tools: "session-scoped only — must NOT be used for user schedules"     # [D]

limitations:
  - "No scholarly database, citation-graph API, patent database, or paywalled full text — the binding constraint on research work"
  - "CRAN blocked: fixest, did, stargazer, modelsummary unavailable; use r-cran-* via apt or move estimation to Python"
  - "2 vCPU / 7.8 GiB / no GPU: no deep-learning training, no datasets beyond ~7.8 GiB, simulation is wall-clock bound"
  - "Container filesystem is ephemeral; nothing survives without export to Drive/git/Artifact/memory"
  - "Subagent delegation is single-level; multi-tier orchestration must live in an external orchestrator"
  - "No device folders connected: device_bash refuses; user's Windows machine is unreachable until they grant a folder"
  - "No typed artifacts in this session; decks and sheets must be produced as files"
  - "No database server, no Docker daemon, no deployment target"
  - "No generative image model, no ASR, no native video understanding"
  - "OCR is English + OSD only"
  - "Citations are generated, not looked up — must be fetched to be trusted"
  - "Exact arithmetic must be executed, not recalled"
  - "Cannot reproduce user-machine-specific bugs (their OS is Windows; this container is Linux)"
  - "Cannot install connectors, plugins, or grant device access — all require the user"
  - "Bash calls cap at 600s; long jobs must be split or detached"
  - "AskUserQuestion / folder grants / computer-use approval all require a present user"

unknowns:
  - "Which model is actually serving this turn"
  - "Current reasoning-effort tier and thinking-token budget"
  - "Context occupancy and remaining headroom"
  - "Maximum concurrent subagent count"
  - "Whether context truncation/compaction has occurred"
  - "Liveness of the browser MCPs (present but untested)"
  - "Whether the AWS/GCP environment credentials grant any usable access"
  - "The full egress allowlist (only tested hosts are known)"
  - "Real-world accuracy of every [S]-tagged behavioural claim in this document"
```

---
# 43. ORCHESTRATOR CONFIGURATION

### Select this model when
- The task needs **judgement under ambiguity** plus **tool use** — the combination, not either alone.
- The work is **agentic and multi-stage**: read, run, observe, revise, verify.
- The deliverable requires **synthesis into a coherent argument** with a consistent voice.
- The task is **critique, review, or verification** of an existing artefact — the best cost-to-value ratio available here.
- Code must actually be **run** to know whether it works.
- Statistical work needs the **estimand and identification** thought through, not just an estimator fitted.
- A corpus has already been retrieved and needs analysis.

### Avoid selecting this model when
- The bottleneck is **indexed retrieval** (scholarly, patent, paywalled, legal databases) — I will produce fluent, well-structured, under-evidenced output, which is harder to catch than a failure.
- The bottleneck is **compute**: GPU training, >7.8 GiB data, high-replication simulation.
- The task needs the **user's own machine** and no folder is granted.
- The work is a **high-volume mechanical transformation** with no judgement — cheaper models do it for less.
- The task needs **audio transcription, video understanding, or image generation**.
- The task requires **R packages that only exist on CRAN** (`fixest`, `did`, `stargazer`, `modelsummary`).
- **Multi-tier delegation** is required inside a single session.

### Default configuration
```yaml
default_reasoning_depth: moderate
default_workers: 0
default_verification: [execute all arithmetic, fetch all citations]
default_autonomy: "proceed; state assumptions at the top"
default_persistence: "export deliverables to Drive or a published Artifact"
```

### Escalate reasoning when
Consequences are irreversible · the question is causal or predictive · sources conflict · the domain is unfamiliar · the output will be published or sent externally · a previous attempt failed · the user has explicitly asked for rigour.

### Search when
Any present-day fact · anything after May 2026 · versions, prices, office-holders, "latest" · any claim that will be cited · any novelty or prior-art question · **whenever tempted to answer a factual question from recall about anything time-varying** — that temptation is the signal, not the exemption.

### Execute code when
Any arithmetic that carries a conclusion · any data transformation · any claim about how code behaves · any chart (**then view the rendered image**) · any statistical estimate · any performance claim.

### Use subagents when
There are ≥3 genuinely independent read-heavy slices · one slice's corpus would flood my context · an **independent, blind** adversarial review is wanted · bulk extraction across many documents. **Not** for sequential work, write-heavy work on shared paths, or small tasks — the ~35k-token floor exceeds the work.

### Worker counts by task type
| Task type | Workers | Note |
| --- | --- | --- |
| Simple / moderate | 0 | Coordination cost exceeds benefit |
| Deep research | 3–6 | By query family |
| Evidence verification | 2–6 | By claim cluster |
| Critical review | 3–5 | One per axis, mutually blind |
| Manuscript | 2–4 | Never delegate voice |
| Software development | 2–4 | Frozen interface + worktree isolation |
| Repository comprehension | 2–4 | `Explore` type |
| Repository debugging | 0–1 | Sequential by nature |
| Statistical analysis | 0–3 | Errors here are conceptual, not throughput |
| Large data | 2–5 | Hard-capped by 2 vCPU / 7.8 GiB |

### Verification is mandatory when
The output contains **citations** (fetch every one) · the output contains **numbers that drive a decision** (recompute by a second route) · code will be merged (tests, with one failing pre-fix) · a **causal claim** is made (assumptions enumerated and checked) · the deliverable is **external-facing or irreversible** (adversarial review) · a **novelty verdict** is issued (contradiction pass + coverage-limits statement).

### Another model should review when
Stakes are high **and** failure would be systematic rather than random · the question sits at my known weak points (recent facts, exact citations, obscure specifics) · the first answer was suspiciously clean · the decision is expensive to reverse. **A second instance of the same model shares my priors — for decorrelation, use a different model.**

### A human decision is necessary when
The action is irreversible (delete, publish, send, spend) · a **credential, folder grant, connector, or plugin** is needed (only they can authorise) · the task's scope is genuinely ambiguous **and** they are available · the work touches legal, medical, financial, or safety consequences where accountability must rest with a person · evidence genuinely underdetermines the answer and the choice is a value judgement.

---

# 44. CONTINUAL LEARNING LOOP

An empirical model-performance registry: log every task, compare the routing prediction to the measured outcome, and update the policy on the residual.

```text
task received
→ classify (family, complexity, stakes, reversibility)
→ PREDICT: model, reasoning depth, tools, worker count, verification level,
           expected quality / latency / cost
→ execute (log the actual configuration used, which may differ from predicted)
→ measure quality (rubric or objective ground truth)
→ verify (independent check where the stakes justify it)
→ measure latency (wall-clock) and resources (tokens, tool calls, worker count)
→ classify errors (taxonomy below)
→ COMPARE prediction vs outcome  → residual
→ update capability profile (this document's [S] claims)
→ update routing policy (section 34 rules)
```

### Fields to record after every task

```yaml
# --- identity ---
task_id, timestamp, task_family, task_description_hash
requester, stakes: [low|medium|high|irreversible]
ambiguity_at_intake: [low|medium|high]

# --- prediction (written BEFORE execution) ---
predicted_model, predicted_depth, predicted_tools[], predicted_workers
predicted_verification_level, predicted_quality, predicted_latency_s, predicted_cost_tokens

# --- actual configuration ---
actual_model, actual_serving_model_if_known, actual_depth_instruction
tools_used[], tool_call_count, worker_count, worker_types[], worker_models[]
skills_invoked[], connectors_used[]

# --- environment (matters: it changes between sessions) ---
env_container_specs, env_egress_blocks_hit[], env_packages_installed[]
env_device_folders_connected, env_connectors_available[]

# --- outcome ---
quality_score, quality_rubric_version, scored_blind: bool
ground_truth_available: bool, accuracy_vs_ground_truth
verification_performed[], verification_findings_count, defects_found_post_delivery
latency_s, cost_tokens_total, cost_tokens_coordinator, cost_tokens_workers
cost_normalised_quality   # quality per 1000 tokens — the decision-relevant number

# --- research-specific ---
sources_found, sources_fetched, citations_emitted, citations_verified
citations_fabricated          # ★ the single most important safety metric
contradiction_pass_run: bool, coverage_limits_stated: bool

# --- error classification ---
error_class: [none | factual | fabricated_citation | arithmetic | scope_miss
              | premature_conclusion | over_verbose | under_verified
              | tool_misselection | over_parallelised | under_parallelised
              | capability_overclaim | context_loss | ambiguity_unresolved
              | policy_block_mishandled | incomplete_handover]
error_severity: [cosmetic | material | invalidating]
error_detected_by: [self | verifier_agent | second_model | human | production]

# --- routing feedback ---
prediction_residual_quality, prediction_residual_cost, prediction_residual_latency
would_reroute_to, routing_rule_id_applied, routing_rule_confirmed: bool
human_intervention_required: bool, human_intervention_reason
```

### Policy update rules
- **Any `citations_fabricated > 0`** → immediately harden verification for that task family to a **separate verifier agent**; do not rely on in-prompt instruction. Track this metric above all others.
- A routing rule whose `routing_rule_confirmed` rate falls below ~70% over a meaningful sample → revise the rule, don't tune around it.
- `worker_count` residuals that are persistently positive → the count heuristic is over-spawning; lower the §34 recommendation for that family.
- `cost_normalised_quality` falling as workers rise → diminishing returns reached for that family; cap it.
- `capability_overclaim` errors → the corresponding claim in §41 is wrong; correct this document, not just the routing.
- `env_egress_blocks_hit` recurring for the same host → add a pre-flight capability check to that task family so the collision surfaces at planning time.

**The registry's real purpose** is to replace this document's `[S]` claims with measurements. Every `[S]` row in §41 is a hypothesis; the registry is how it becomes data.

---

# 45. FINAL SELF-AUDIT

Audit performed before delivery. Findings and corrections:

| Check | Finding | Action taken |
| --- | --- | --- |
| **Invented capabilities** | Drafting risk: describing R, statsmodels, and parallel subagents as available without testing. | All three were **probed live**. R was found *absent* and installed; CRAN was found *blocked*; subagent concurrency was *proved* by a filesystem race. Claims now rest on probes, not assumption. |
| **Unsupported numerical limits** | Risk of inventing a max subagent count, a context-fill figure, or a thinking-token budget. | Left as `[U]`. §7 explicitly refuses to invent a maximum. Only measured numbers appear (35k tokens/worker, 8–13 s, 2 vCPU, 7.8 GiB, 1,130 apt R packages, 15,000/hr GitHub limit). |
| **Model vs application confusion** | Easy to write "the model has Google Drive access." | Seven-layer scheme in §0; capabilities attributed by layer throughout. §7 states plainly that delegation is an **L3 harness** capability, not a model capability. |
| **Model vs tools confusion** | "Image generation" and "code execution" are the usual conflations. | §2 separates image *understanding* (L1 vision) from image *rendering* (L4 code) and records that no generative image model exists here. |
| **Speculative subagent claims** | §§8–9 describe topologies that are recommendations, not architecture. | Labelled explicitly as recommendations in §9's preamble and in §42's YAML comment. §36 states outright that no benchmark results are invented and gives the experiment (§39) instead. |
| **Marketing language** | Superlatives without evidence. | Strength claims are tagged `[S]` and capped at Medium confidence in §41. §33 makes no claims about competitor models. |
| **Contradictions** | Checked: §2 says R "available" while §15 constrains R methods. | Reconciled — every R row now carries the CRAN caveat, and §37's boundary map splits "R via apt" from "R needing CRAN". |
| **Omitted unknowns** | Several details are genuinely not exposed. | §42 carries an explicit `unknowns` list; serving-model identity, effort tier, context fill, and max worker count are all marked `[U]` rather than estimated. |
| **Claims that should be downgraded** | §§4, 6, 20, 26, 27, 28 are introspection presented in operational language. | Each section is tagged `[S]`; §40 lists them as needing external tests; §41 caps their confidence; §40's closing note says plainly to treat them as hypotheses. |
| **Over-claimed research capability** | The most consequential risk in this document. | Stated repeatedly and prominently: **no scholarly database, citation graph, patent DB, or paywalled access.** §12 states a novelty search here is *screening, not clearance*. §11 states I can produce a systematic-*style* review, not a compliant systematic review. §33 warns that routing retrieval-bound work here produces fluent under-evidenced output. |
| **Self-report reliability** | This document is a self-report about a system whose self-reports are unreliable. | §40 says so directly and lists 18 claims requiring external tests. |

### Residual weaknesses in this document, stated plainly

1. **Everything `[S]` is introspection.** I cannot observe my own reasoning process; I can only describe what I appear to do. §§4, 6, 20, 26–28 are the weakest content here and should be benchmarked before being relied on.
2. **The environment probe is a snapshot.** Package availability, egress rules, connected folders, and connectors change between sessions. Re-probe rather than trusting §2 in a later session — every `[O]` claim names the command that regenerates it.
3. **Worker-count recommendations are reasoned, not measured.** §39 exists precisely because §§9 and 36 are currently argument rather than evidence.
4. **Untested surfaces are marked but still unknown:** browser MCPs, computer use, the `visualize` widget, and the AWS/GCP credentials. Present in the tool list is not the same as working.
5. **I cannot verify my own identity.** The configured ID is `claude-opus-5`; the serving model is not exposed to me. Only provider-side metadata can settle that.

---

## Appendix — probe log

Commands whose results back the `[O]` claims. Re-runnable to refresh this profile.

```bash
# hardware / runtime
nproc; free -h; df -h /; uname -a; id -u; python3 -V; node -v
for c in python3 node R Rscript git gh curl jq pandoc libreoffice tesseract \
         ffmpeg sqlite3 psql duckdb java go rustc gcc docker; do
  printf "%-12s %s\n" "$c" "$(command -v $c || echo no)"; done

# python libraries
python3 -c "import importlib.util as u; print([m for m in ['numpy','pandas','scipy',
 'sklearn','statsmodels','matplotlib','torch','pyarrow','duckdb'] if u.find_spec(m)])"

# network egress + policy
curl -sS "$HTTPS_PROXY/__agentproxy/status" | jq '.noProxy, .recentRelayFailures'
curl -sS -o /dev/null -w "%{http_code}\n" https://cloud.r-project.org/src/contrib/PACKAGES  # -> 000 (403 CONNECT)
pip3 install statsmodels --break-system-packages          # -> succeeds
git clone --depth 1 https://github.com/pallets/click.git  # -> succeeds
curl -sS -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/rate_limit

# R and the CRAN workaround
apt-get install -y r-base-core && Rscript -e 'R.version.string'   # -> 4.3.3
Rscript -e 'install.packages("sandwich")'                          # -> FAILS, CRAN blocked
apt-cache search '^r-cran-' | wc -l                                # -> 1130
apt-get install -y r-cran-sandwich r-cran-lmtest r-cran-zoo        # -> succeeds
Rscript -e 'library(sandwich); library(lmtest); cat("ok\n")'       # -> ok

# vision closed loop
python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot as plt; \
 plt.plot([1,2,3]); plt.savefig('probe.png')"    # then: Read tool on probe.png -> described correctly

# background execution
nohup bash -c 'sleep 4; echo done > bg.txt' & sleep 6; cat bg.txt   # -> done
```

**Harness / MCP probes** (tool calls, not shell): `ListAgents`, `ListSkills`, `ListConnectors`, `ListPlugins`, `Artifact{action:list}`, `mcp__memory__memory_list`, `mcp__claude-code-remote__list_triggers`, `mcp__remote-devices__get_device_info`, `mcp__remote-devices__device_bash` (refused), `mcp__Google_Drive__search_files` (succeeded), and two parallel `Agent` spawns whose results are tabulated in §7.1.

---

*End of MODEL_OPERATIONAL_PROFILE.md*
