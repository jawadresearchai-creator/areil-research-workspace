# GPT-5.6 SOL XHIGH — OPERATIONAL CAPABILITY PROFILE

**Profile date:** 2026-09-03 · **Profile subject:** `gpt-5.6-sol` configured at `xhigh` reasoning effort · **Surface:** Codex in the ChatGPT desktop app on Windows · **Method:** current official OpenAI documentation plus read-only inspection of the live session.

This is an engineering profile for routing and orchestration. It describes the model, product, harness, tools, permissions, and host separately. It is not a claim about hidden weights or private reasoning traces.

## Evidence notation

| Mark | Interpretation |
| --- | --- |
| `[O]` | Observed in this session through configuration, tool metadata, or a read-only probe |
| `[D]` | Stated by current official OpenAI documentation |
| `[S]` | Operational self-description; useful as a hypothesis, not as benchmark evidence |
| `[I]` | Reasonable inference from observed behavior or architecture |
| `[U]` | Unknown, unavailable, or not safely established |

## Attribution layers

| Layer | Component | What belongs here |
| --- | --- | --- |
| M | Base model | Language, reasoning, code generation, vision interpretation, tool-call decisions |
| P | Product surface | ChatGPT desktop app and Codex task/thread UI |
| H | Agent harness | Shell sessions, patches, subagents, thread coordination, waits, automations |
| T | Connected tool | Web retrieval, image generation, MCP/app methods, document runtimes |
| E | External service | GitHub, Google Drive, market-data vendors, websites, hosted Sites |
| A | Authorization | User instructions, connector OAuth, workspace policy, approval/sandbox rules |
| I | Infrastructure | Windows host, local files, runtimes, network, hardware, durable storage |

The phrase “Sol can access Google Drive” is therefore imprecise. The accurate statement is: the current harness exposes Google Drive connector methods; usable access depends on connector authorization and user scope.

---

# 1. RUNTIME IDENTITY

| Field | Current value | Evidence |
| --- | --- | --- |
| Provider | OpenAI | `[D]` |
| Family | GPT-5.6 | `[D]` |
| Configured model | `gpt-5.6-sol` | `[O]` local Codex configuration |
| API alias | `gpt-5.6` routes to `gpt-5.6-sol` | `[D]` |
| Exact dated deployment snapshot | Not exposed | `[U]` |
| Reasoning effort | `xhigh` / Extra High | `[O]` local configuration; requested by user |
| Pro mode | No active-state indicator exposed | `[U]` |
| Application | Codex inside the ChatGPT desktop app | `[O]` |
| Host OS | Windows 11 Pro 64-bit, version 10.0.22631 | `[O]` |
| Local shell | PowerShell 7.6.4 | `[O]` |
| Working directory | `E:\Andriod Development` | `[O]` |
| Repository state | Working directory is not currently a Git repository | `[O]` |
| Current date/time zone | 2026-09-03, Asia/Karachi | `[O]` |
| Knowledge cutoff | 2026-02-16 | `[D]` |
| Documented API context window | 1,050,000 tokens | `[D]`; product-effective limit unverified |
| Documented API max output | 128,000 tokens | `[D]`; product-effective limit unverified |
| Base-model modalities | Text input/output; image input; no native audio or video | `[D]` |
| Fine-tuning | Not supported for this model | `[D]` |
| Function calling / structured outputs | Supported | `[D]` |

Official source: [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol). Current model guidance documents `none`, `low`, `medium`, `high`, `xhigh`, and `max`; `max` is a distinct tier above this profile’s `xhigh` setting: [GPT-5.6 guidance](https://developers.openai.com/api/docs/guides/latest-model).

### Identity caveats

- The model slug is observable, but the exact weights revision serving an individual turn is not.
- API context and output limits are not proof that the desktop application will expose the entire allowance in every task.
- `xhigh` is an effort configuration, not a different model family or a guarantee of correctness.
- Pro mode and reasoning effort are independent API controls. This session exposes xhigh but does not expose a reliable pro-mode status.
- Product-generated images, files, or automations come from tools and infrastructure, not text tokens directly becoming those artifacts.

---

# 2. LIVE EXECUTION ENVIRONMENT

## 2.1 Capability inventory

| Capability | Current state | Provider/layer | Qualification | Evidence |
| --- | --- | --- | --- | --- |
| Web search | Available | T | Live search was used successfully | `[O]` |
| Page retrieval | Available | T | Open, click, find, and PDF-page screenshot operations | `[O]` |
| Current information | Available | T/E | Reliability depends on source quality and coverage | `[O]` |
| Shell | Available | H/I | PowerShell process execution with long-running session support | `[O]` |
| Filesystem | Available | H/I | Current permission profile is unrestricted | `[O]` |
| Patch editing | Available | H | Structured local file changes | `[O]` |
| Python | Available | I | System and bundled Python 3.13.1 | `[O]` |
| Node.js | Available | I | Node 24.18.0 | `[O]` |
| Git | Available | I | Git 2.55.0; current directory is not a repository | `[O]` |
| Java / Android tooling | Partial | I | JDK 17 and `adb` present; no global Gradle found | `[O]` |
| Generic external HTTP APIs | Conditional | H/I/E | Network is enabled; endpoint, credentials, and authorization still required | `[O]` |
| GitHub | Connector methods exposed | T/E/A | 89 methods; connection/authentication not tested in this profile | `[O]` |
| Google Drive | Connector methods exposed | T/E/A | 45 Drive/Docs/Sheets/Slides methods; authentication not tested | `[O]` |
| Gmail | Not exposed | — | A recommended but uninstalled plugin is not a current capability | `[O]` |
| General calendar | Not exposed | — | Market calendars are not personal-calendar access | `[O]` |
| General SQL/database | Not exposed | — | Local code may use embedded DB libraries; no general live DB connector observed | `[O]` |
| Financial data | Exposed | T/E | Alpaca, Bigdata.com, and Financial Datasets methods | `[O]` |
| Scholarly discovery | Exposed | T/E | Consensus search/fetch methods | `[O]` |
| Hosted Sites | Exposed | T/E | Build, deploy, inspect, and specialized site-data methods | `[O]` |
| Documents | Available | H/I | PDF, DOCX, spreadsheet, and presentation skills plus libraries | `[O]` |
| Image inspection | Available | M/T | Base-model image input plus local image viewer | `[O][D]` |
| Image generation/editing | Available | T | Separate hosted image-generation tool | `[O]` |
| Audio understanding | Not exposed in this turn | — | Base model does not accept audio; `ffmpeg` only enables file processing | `[O][D]` |
| Video understanding | Not exposed | — | Frames could be extracted and inspected individually | `[O][I]` |
| Scheduled work | Available | P/H | Recurring cron tasks and same-thread heartbeats | `[O]` |
| Conditional monitoring | Available | P/H | Persistent scheduler rather than a continuously running model | `[O]` |
| Subagents | Available | H | Separate agent threads; see §7 | `[O]` schema/configuration |
| Parallel tool calls | Available | H | Concurrent nested tool calls were executed during profiling | `[O]` |
| Persistent local memory | Product-supported; current enablement unresolved | P/I | No explicit enablement found in inspected configuration | `[D][U]` |

## 2.2 Host and runtime snapshot

| Resource | Observation |
| --- | --- |
| CPU | Intel Core i5-8365U, 4 physical cores / 8 logical processors `[O]` |
| Installed RAM | 15.79 GiB `[O]` |
| Free RAM during probe | 1.71 GiB `[O]`; transient, not a stable limit |
| PowerShell | 7.6.4 `[O]` |
| Python | 3.13.1 `[O]` |
| Node | 24.18.0 `[O]` |
| Git | 2.55.0.windows.2 `[O]` |
| Java | Microsoft JDK 17 `[O]` |
| Media utility | FFmpeg 8.1.2 present `[O]` |
| OCR utility | Tesseract command not found `[O]` |
| Pandoc | Command not found `[O]` |
| Android bridge | `adb` present `[O]` |

This is a persistent user-owned Windows environment, not an ephemeral provider VM. Local files survive the chat unless changed or deleted. Process lifetime, conversation retention, connector state, and scheduled-task state have separate lifecycles.

## 2.3 Bundled analysis/document stack

Observed in the bundled Python runtime:

- Present: NumPy, pandas, openpyxl, XlsxWriter, `python-docx`, `python-pptx`, pypdf, pdfplumber, reportlab.
- Not present in that bundle: SciPy, statsmodels, scikit-learn, matplotlib, seaborn.
- Missing from the bundle does not mean impossible. A task may use the system runtime, install an approved dependency, invoke another tool, or move computation to a prepared environment.

## 2.4 Tool registry snapshot

The session exposed 284 tool methods when inspected `[O]`. Selected groups:

| Group | Exposed methods | Interpretation |
| --- | ---: | --- |
| Codex app/task management | 31 | Threads, waits, handoff, archive, title, automation, usage, UI opening |
| GitHub connector | 89 | Repository, issue, pull-request, branch, file, and review operations |
| Google Drive connector | 45 | Drive plus native Docs/Sheets/Slides operations |
| Finance connectors | 65 | Alpaca 24, Bigdata.com 14, Financial Datasets 27 |
| Consensus | 2 | Scholarly search and fetch |
| Sites | 23 | Hosted site lifecycle and specialized data operations |
| Document control | 3 | Connected live-document session control |
| Node REPL | 3 | Persistent JavaScript execution |

Method count is not the same as authenticated capability. External reads and writes remain connector-, account-, and authorization-dependent.

## 2.5 Permission boundary

The active technical profile allows unrestricted filesystem access, network access, and non-interactive commands `[O]`. That is a sandbox fact, not blanket user authorization. The system must still stop before materially destructive, external, costly, or scope-expanding operations not authorized by the request.

---

# 3. CAPABILITY SUMMARY

Ratings are self-assessments unless paired with an observed execution surface.

| Domain | Reasoning strength | Execution here | Tool dependence | Main risk | Evidence |
| --- | --- | --- | --- | --- | --- |
| General reasoning | Very strong | Native | Low | Persuasive treatment of a bad premise | `[S]` |
| Difficult multi-step reasoning | Very strong | Native + tools | Medium | Missed dependency in long chains | `[S]` |
| Mathematics | Strong | Python/Node available | Medium | Unexecuted arithmetic | `[S][O]` |
| Scientific reasoning | Strong | Design/analysis; no physical experiment | Medium | Missing field assumptions | `[S]` |
| Research synthesis | Very strong | Web + connectors | High | Incomplete retrieval presented fluently | `[S][O]` |
| Literature analysis | Strong | Consensus/web/files | High | Paywalls and index gaps | `[S][O]` |
| Novelty screening | Moderate–strong | Search-supported | Very high | Cannot prove universal absence | `[S]` |
| Fact verification | Strong with sources | Available | High | Citation/source mismatch | `[S][O]` |
| Statistics | Strong conceptually | Conditional on suitable runtime | High | Estimator without diagnostic discipline | `[S][O]` |
| Causal inference | Moderate–strong | Code-supported | High | Unverifiable identification assumptions | `[S]` |
| Data analysis | Very strong | Available | High | Data quality and package gaps | `[S][O]` |
| Coding | Very strong | Full local workflow | Medium | Version-specific API errors | `[S][O]` |
| Debugging | Very strong | Reproduction-dependent | High | Treating symptoms rather than causes | `[S]` |
| Repository understanding | Very strong | Full when repo supplied | High | Context pollution in large trees | `[S]` |
| Architecture | Strong | Design/review | Medium | Over-design without operational constraints | `[S]` |
| Data engineering | Strong | Conditional | High | External infrastructure semantics | `[S]` |
| Document intelligence | Very strong | PDF/DOCX/XLSX/PPTX workflows | High | Extraction or rendering defects | `[S][O]` |
| Manuscript drafting | Very strong | Markdown/DOCX/PDF-capable | Medium | Style can conceal weak evidence | `[S][O]` |
| Critical/adversarial review | Very strong | Native + optional tools | Medium | Same-model correlation | `[S]` |
| Tool orchestration | Very strong | Extensive current registry | Essential | Tool/auth failures | `[S][O]` |
| Long-horizon work | Strong through harness | Goals, threads, schedules | Essential | Persistence is product-owned | `[S][O]` |

---

# 4. REASONING DEPTH BY TASK SHAPE

This section describes process architecture, not hidden chain-of-thought.

## 4.1 Direct tasks

- Resolve the request in one pass.
- Avoid tools unless facts are current, an exact calculation matters, or a source/file controls the answer.
- Verify format and obvious edge cases.
- Stop when the requested artifact or answer exists.

## 4.2 Routine analytical work

- State the decision or question being answered.
- Identify two or three controlling assumptions.
- Retrieve unstable facts and execute nontrivial calculations.
- Check the conclusion against a counterexample.
- Stop when material uncertainty is disclosed and the requested decision is supported.

## 4.3 Hard multi-stage reasoning

- Build a dependency graph and critical path.
- Validate shared premises before branching.
- Use checkpoints after high-risk transformations.
- Compare more than one hypothesis or design.
- Replan after a failed premise, test, or external dependency.
- Require independent verification of load-bearing results.

## 4.4 Deep research

- Define scope, terminology, evidence hierarchy, and exclusion rules first.
- Search across independent query families.
- Maintain a claim/evidence/contradiction ledger.
- Separate publication date from event or data date.
- Run a deliberate disconfirmation search.
- Stop at evidence saturation, a documented access boundary, or the predeclared budget.

## 4.5 Complex engineering

- Reconstruct the system before editing it.
- Establish a reproducible baseline.
- Freeze interfaces before parallel implementation.
- Prefer executable tests over prose confidence.
- Integrate sequentially and audit the final diff.

## 4.6 High-uncertainty or high-consequence work

- Increase reasoning and verification according to consequences, not answer length.
- Distinguish factual uncertainty, model uncertainty, missing authority, and value judgment.
- Use different methods or reviewers for independence.
- Escalate to a human where accountability or authorization cannot be delegated.

## 4.7 Stopping discipline

Stop when one of the following is true:

1. Every acceptance criterion has objective evidence.
2. Additional work yields no new decision-relevant information.
3. A hard authorization or access boundary is reached.
4. The predefined resource budget is exhausted and a complete handoff has been written.

---

# 5. XHIGH REASONING PROFILE

`xhigh` is the active configured effort `[O]`. It is best understood as a quality/latency allocation, not a separate personality or an entitlement to hidden tools.

## Material benefits expected `[S]`

- More careful decomposition of ambiguous, interacting requirements.
- Wider exploration of failure hypotheses and edge cases.
- Greater attention to evidence conflict, assumptions, and verification.
- More deliberate sequencing of tool use and retries.
- Better integration across several documents, code paths, or worker outputs.

## Tasks that justify xhigh

- Cross-module debugging and migrations.
- Causal or statistical design where a wrong estimand invalidates the analysis.
- Security, architecture, data-loss, and high-value code reviews.
- Research synthesis with contradictory or heterogeneous sources.
- Complex planning with irreversible downstream actions.
- Final synthesis and hostile review of multi-worker output.

## Tasks that normally do not

- Mechanical extraction or formatting.
- Simple retrieval from one authoritative source.
- Classification with a stable rubric.
- Boilerplate generation backed by deterministic tests.
- Large-volume work where a cheaper configuration meets the same acceptance test.

## Limits

- Exact reasoning-token allocation is not exposed `[U]`.
- Higher effort can increase latency, cost, over-analysis, and unnecessary tool calls.
- `max` exists above xhigh; official guidance recommends benchmarking both rather than assuming the higher tier is automatically better.
- No reasoning tier removes the need for execution, sources, or human accountability.

---

# 6. DECOMPOSITION AND CRITICAL-PATH CONTROL

```text
outcome
→ acceptance criteria
→ constraints and authority
→ assumptions and unknowns
→ subproblems
→ dependency graph
→ safe parallel branches
→ critical-path execution
→ verification gates
→ integration
→ final audit
```

Rules:

- Parallel branches must have stable inputs and explicit output contracts.
- Schema, interface, authorization, and destructive-operation decisions remain sequential.
- Every branch returns evidence, not just a conclusion.
- Shared assumptions are tested before fan-out because their failure invalidates every descendant.
- Replanning is triggered by a failed critical assumption, missing dependency, contradictory evidence, or failing verification gate.
- The coordinator owns the canonical state and the definition of done.

Example:

```text
[1] Parse request and define acceptance tests
        ↓
[2A] Inspect source/template     [2B] Inspect current runtime     [2C] Fetch official facts
        \                         |                         /
         → [3] Normalize claims and resolve conflicts ←
                           ↓
                [4] Draft structured artifact
                           ↓
             [5A] factual audit   [5B] consistency audit
                           ↓
                  [6] final integration
```

---

# 7. SUBAGENTS AND PARALLELISM

No workers were spawned merely to prove availability because this task did not authorize experimental delegation. Claims below come from the currently exposed harness contract and official Codex documentation.

| Question | Current answer | Evidence |
| --- | --- | --- |
| Are subagents available? | Yes | `[O]` collaboration interfaces exposed |
| Who provides them? | Codex agent harness, not the base model | `[O][D]` |
| Can they be created dynamically? | Yes | `[O]` spawn interface |
| Can they run concurrently? | Yes, within the session cap | `[O]` harness declaration |
| Current active-slot cap | 4 total, including the coordinator | `[O]` current session configuration |
| Maximum simultaneous descendants | 3 while the coordinator is active | `[I]` from the four-slot cap |
| Can descendants create descendants? | Yes, subject to the same shared slot budget | `[O]` harness contract |
| Context model | Separate thread; initial history can be none, all, or a bounded number of turns | `[O]` |
| Filesystem | Shared | `[O]` harness contract |
| Tool access | Same general tool surface unless instructions/configuration constrain it | `[O]` |
| Communication | Direct messages, follow-up tasks, interrupts, status listing, parent mailbox | `[O]` |
| Persistence | Task-tree/session scoped unless results are checkpointed externally | `[U]` beyond session |

Official product documentation: [Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents).

## Operational consequences

1. Shared files make read-heavy exploration convenient but concurrent writes hazardous.
2. Separate thread context reduces pollution but can hide assumptions if the worker prompt is incomplete.
3. Nested delegation is technically possible, but four total active slots make deep trees impractical here.
4. Worker messages are summaries; important evidence should be written to structured files or included explicitly.
5. Same-model workers provide process independence, not full epistemic independence.
6. Current capacity favors a coordinator plus two producers and one verifier, or a coordinator plus three independent evidence lanes.

---

# 8. RECOMMENDED WORKER ROLES

| Role | Suitable work | Required output | Caution |
| --- | --- | --- | --- |
| Coordinator | Scope, plan, arbitration, synthesis | Canonical plan and final decision | Should retain whole-task view |
| Source finder | Independent search family | URLs, dates, source type, quoted support | Search snippets are insufficient |
| Primary-source reader | Long standards, papers, filings | Claim-linked excerpts and limitations | Do not replace close reading with a generic summary |
| Contradiction hunter | Disconfirming evidence | Strongest counterevidence and conditions | Give an explicitly opposed objective |
| Citation auditor | Validate emitted citations | Per-claim support verdict | Must open sources |
| Repository mapper | Trace modules and entry points | File/symbol/call-path map | Read-only is preferable |
| Implementation worker | Bounded module behind a stable interface | Code plus focused tests | Isolate writes |
| Reproduction worker | Establish deterministic failure | Minimal reproducer and logs | Reproduce before proposing fixes |
| Statistical auditor | Estimand, model, diagnostics | Assumption and diagnostic report | Needs data dictionary and design |
| Robustness analyst | Alternative specifications | Reproducible result matrix | Predefine alternatives |
| Document extractor | One corpus partition | Structured records with locations | Preserve provenance |
| Hostile reviewer | Failure-seeking review | Ranked concrete defects | Keep blind to author reasoning where possible |

---

# 9. TOPOLOGY RECIPES

Recommendations are hypotheses to benchmark. Current concurrency permits three simultaneous subagents, so larger topologies must run in waves or use external orchestration.

| Workload | Coordinator | Parallel lanes | Verification | Suggested range |
| --- | --- | --- | --- | ---: |
| Deep research | Research lead | Primary sources, academic sources, contradictions, recent developments | Citation auditor | 3–6 |
| Novelty screening | Ontology lead | Exact terms, mechanisms, adjacent fields, methods | Prior-art skeptic | 4–8 |
| Scientific design | Design lead | Literature, measurement, statistics | Hostile methods reviewer | 2–4 |
| Statistical analysis | Analysis lead | Data QC, robustness | Independent recomputation | 2–3 |
| Causal analysis | Identification lead | DAG, design, falsification | Assumption critic | 3–5 |
| Large repository | Architecture lead | Subsystem mappers | Cross-path verifier | 3–8 |
| Feature implementation | Technical lead | Isolated modules, tests | Integration reviewer | 2–4 |
| Debugging | Incident lead | Competing hypotheses or subsystem searches | Minimal-repro verifier | 2–3 |
| Data engineering | Pipeline lead | Source, schema, quality lanes | Reconciliation worker | 3–5 |
| Manuscript | Lead author | Methods, related work, figures | Citation/style audit | 2–4 |
| Critical review | Review chair | Methods, statistics, evidence | Meta-review | 3–5 |
| Evidence validation | Claim-ledger owner | Claim batches | Citation spot check | 2–6 |

Sequential work that should not be fragmented: objective definition, interface/schema selection, permission decisions, shared-file integration, interpretation of conflicting findings, and final acceptance.

---

# 10. RESEARCH OPERATING SYSTEM

| Phase | Action | Parallel? |
| --- | --- | --- |
| 1 | Restate the decision and convert it to answerable claims | No |
| 2 | Fix scope, dates, jurisdictions, populations, and exclusions | No |
| 3 | Build a terminology and synonym map | No |
| 4 | Define primary and secondary evidence classes | No |
| 5 | Generate exact, synonym, mechanism, method, and adjacent-field queries | Planning only |
| 6 | Search source families independently | Yes |
| 7 | Open and inspect authoritative candidates | Yes |
| 8 | Record event date separately from publication/update date | Yes |
| 9 | Trace pivotal citations to originals | Partly |
| 10 | Run a dedicated contradiction/null-results search | Yes |
| 11 | Extract evidence into a ledger | Yes |
| 12 | Map claims to supporting and opposing evidence | No |
| 13 | Resolve conflicts by definitions, samples, methods, dates, and incentives | No |
| 14 | Mark gaps and inaccessible evidence | No |
| 15 | Synthesize around the decision | No |
| 16 | Reopen and verify every load-bearing citation | Yes |

Minimum evidence record:

```yaml
claim_id:
claim_text:
source_url:
source_type:
publication_date:
event_or_data_date:
supporting_passage:
method_or_sample:
limitations:
supports_or_contradicts:
verification_status:
```

Current advantages: live web retrieval, PDF screenshots, a scholarly-search connector, and parallel workers. Current limits: paywalls, non-indexed sources, authorization gaps, source disappearance, and the inability to prove universal completeness.

---

# 11. LITERATURE REVIEW

The system can perform a rigorous narrative or systematic-style review, but a formal systematic review additionally requires a registered protocol, database-specific reproducible queries, deduplication records, dual screening, inclusion/exclusion logs, and often licensed database access.

Recommended sequence:

1. Define PICO/PECO or another field-appropriate question structure.
2. Predeclare eligible designs, dates, languages, and outcomes.
3. Search multiple independent indexes or source families.
4. Deduplicate by persistent identifier and normalized title.
5. Screen titles/abstracts, then full text.
6. Extract study design, sample, exposure/intervention, outcome, estimates, uncertainty, bias, and funding.
7. Evaluate heterogeneity and publication bias.
8. Separate study quality from whether results agree with the preferred hypothesis.
9. Produce an evidence table before prose synthesis.
10. Preserve the search and screening audit trail.

Consensus search improves scholarly discovery in this session `[O]`, but it is not equivalent to guaranteed coverage of every disciplinary database.

---

# 12. NOVELTY SCREENING

Search lanes:

- Exact title and distinctive phrases.
- Acronyms, synonyms, translations, and historical terminology.
- Mechanism without the proposed application label.
- Independent and dependent variables separately.
- Interaction, mediation, and moderation equivalents.
- Measurement or methodological equivalents.
- Population, geography, sector, and context variants.
- Adjacent disciplines that describe the same construct differently.
- Reviews, preprints, dissertations, conference proceedings, patents, and registered studies where accessible.
- Backward and forward citation chains.
- Competing explanations, failures to replicate, and null results.

Classify findings as:

1. Exact precedent.
2. Same mechanism in another setting.
3. Same method on another problem.
4. Same problem with another method.
5. Incremental combination.
6. Application novelty only.
7. Unresolved because of coverage limits.

A novelty search can establish that prior art exists. It cannot establish that no prior art exists anywhere. Unpublished, private, non-indexed, embargoed, language-limited, or future work remains outside the search boundary.

---

# 13. SCIENTIFIC RESEARCH SUPPORT

| Activity | Reason about | Design | Write code | Execute here | Verification need |
| --- | ---: | ---: | ---: | ---: | --- |
| Topic discovery | Yes | Yes | N/A | Yes | Current literature |
| Gap analysis | Yes | Yes | N/A | Yes | Broad retrieval |
| Hypothesis generation | Yes | Yes | Optional | Yes | Falsifiability/domain review |
| Conceptual framework | Yes | Yes | Optional | Yes | Competing-framework audit |
| Experimental design | Yes | Yes | Power/simulation | Conditional | Ethics, feasibility, power |
| Observational design | Yes | Yes | Yes | Conditional | Confounding and measurement |
| Quasi-experimental design | Yes | Yes | Yes | Conditional | Identification checks |
| Statistical plan | Yes | Yes | Yes | Conditional | Simulation/diagnostics |
| Causal inference | Yes | Yes | Yes | Conditional | Sensitivity and falsification |
| Robustness analysis | Yes | Yes | Yes | Conditional | Independent rerun |
| Interpretation | Yes | N/A | Optional | Yes | Domain expert |
| Manuscript preparation | Yes | Yes | Optional | Yes | Source and layout audit |
| Reviewer simulation | Yes | Yes | Optional | Yes | Human review when consequential |

The model cannot perform physical experiments, recruit participants, obtain ethics approval, collect clinical measurements, or substitute for accountable domain professionals.

---

# 14. DATA ANALYSIS

Strong uses:

- Schema inference and data dictionaries.
- Integrity and missingness checks.
- Reproducible cleaning and transformation code.
- Descriptive analysis and anomaly detection.
- Model specification and diagnostic planning.
- Robustness matrices and sensitivity analysis.
- Tables, charts, and narrative interpretation.
- Reproducibility manifests.

Main cautions:

- Keep raw data immutable.
- Treat identifiers, units, time zones, denominators, and join cardinalities as load-bearing.
- Separate exploratory choices from confirmatory claims.
- Never infer that a missing value is zero without an explicit rule.
- Verify every merge with row counts, key uniqueness, and unmatched records.
- Use chunking, column projection, or a database when data size exceeds comfortable RAM.

---

# 15. STATISTICAL METHODS

| Family | Conceptual capability | Execution rule |
| --- | --- | --- |
| Descriptive statistics | Strong | Execute exact summaries; report missing denominators |
| Linear/logistic models | Strong | Inspect residuals, influence, calibration, collinearity |
| GLMs | Strong | Verify family, link, dispersion, and convergence |
| Mixed models | Moderate–strong | Check grouping structure, variance components, singularity |
| Panel models | Strong conceptually | Check dependence, clustering, FE/RE assumptions |
| Event studies | Strong | Validate timing, anticipation, windows, leakage, reference period |
| Difference-in-differences | Strong | Inspect treatment timing and parallel trends; avoid obsolete estimators for staggered adoption |
| Synthetic control | Moderate–strong | Check donor pool, fit, placebo and leave-one-out results |
| Instrumental variables | Moderate–strong | Identification dominates estimation; report weak-instrument diagnostics |
| Survival analysis | Strong conceptually | Check censoring, proportional hazards, competing risks |
| Time series | Strong | Check stationarity, autocorrelation, leakage, breaks, forecast origin |
| Bayesian analysis | Strong conceptually | Prior predictive checks, convergence, ESS, posterior predictive checks |
| Machine learning | Strong | Pipeline isolation, held-out evaluation, leakage, calibration |
| Simulation | Strong | Fix seed, report Monte Carlo error, vary DGP assumptions |
| Bootstrap/permutation | Strong | Choose the correct resampling or exchangeability unit |
| Multiple testing | Strong | Define the hypothesis family before selecting control method |
| Sensitivity analysis | Strong | Vary plausible assumptions rather than cosmetically nearby values |

The bundled runtime currently lacks several common statistics libraries. The orchestrator should provision the required environment before interpreting “can write the analysis” as “can execute the analysis now.”

---

# 16. IDEAL STATISTICAL WORKFLOW

```text
raw inputs
→ provenance and schema
→ integrity assertions
→ cleaning log
→ descriptive analysis
→ estimand
→ design and identification
→ model specification
→ execution
→ diagnostics
→ robustness and sensitivity
→ visualization
→ interpretation
→ clean-session reproduction
```

Required artifacts:

- Immutable raw input or content hashes.
- Machine-readable data dictionary.
- Cleaning script and exception log.
- Pre-specified primary model.
- Environment/package manifest.
- Diagnostics and robustness table.
- Fixed seeds where randomness is used.
- A command or notebook entry point that reproduces every reported number.

---

# 17. CODING CAPABILITY

| Area | Operational assessment |
| --- | --- |
| Greenfield development | Very strong when acceptance criteria and interfaces are explicit |
| Existing codebases | Strong at search, trace, edit, execute, and test loops |
| Debugging | Strong when a reproducer or observability exists |
| Refactoring | Strong when behavior is protected by tests |
| Architecture | Strong for alternatives, trade-offs, failure modes, and migration plans |
| Dependencies | Strong; version-specific behavior should be checked against installed state and official docs |
| Tests | Unit, integration, regression, property-oriented, and fixture design |
| CI/CD | Strong conceptually; live execution depends on platform credentials |
| Performance | Requires profiler or benchmark evidence |
| Security | Useful defensive review; specialist scanners and human review remain important |
| Multi-language | Broad capability, with confidence varying by ecosystem and build reproducibility |
| Android | JDK and ADB are present; project Gradle wrapper is preferable because no global Gradle was found |

Coding output should not be considered complete until it has been built or executed where feasible, tested proportionately to risk, and reviewed as a diff.

---

# 18. UNFAMILIAR REPOSITORY WORKFLOW

1. Read `AGENTS.md`, project documentation, and repository-local constraints.
2. Inspect Git status and preserve unrelated user changes.
3. Inventory languages, package managers, lockfiles, build systems, CI, and entry points.
4. Trace the requested behavior from external entry point to owning module.
5. Find analogous code and existing tests.
6. Reproduce the current behavior or failure.
7. State the smallest defensible change and its risks.
8. Edit only the owning surface.
9. Run focused tests, static checks, and then broader suites.
10. Inspect the diff for accidental scope expansion.
11. Re-run the original reproduction.
12. Report changed files, checks, limitations, and any remaining manual validation.

For parallel repository work, assign subsystem ownership or independent worktrees. Do not let multiple workers edit the same checkout without an explicit merge plan.

---

# 19. TOOL INVENTORY BY FUNCTION

## Native/local execution

- `exec_command` and `write_stdin`: PowerShell commands and persistent PTY sessions.
- `apply_patch`: controlled text-file editing.
- `view_image`: local raster inspection.
- Node REPL: persistent JavaScript state for compatible tasks.
- Workspace dependency loader: discovers bundled Python, Node, Git, and artifact libraries.

## Information retrieval

- Web search, page open, link click, text find, and PDF-page screenshots.
- Finance, weather, sports, and time lookup functions within the web service.
- Consensus scholarly search/fetch.
- Bigdata.com, Alpaca, and Financial Datasets market/filing/news methods.

## Media and artifacts

- Hosted image generation and image editing.
- PDF, Word, spreadsheet, and presentation skills.
- Google-native Docs, Sheets, and Slides operations through Drive when authorized.
- Connected document-session control for supported live sessions.
- Sites creation, versioning, deployment, access control, and inspection.

## Task and product control

- Create, read, continue, wait for, fork, hand off, archive, rename, navigate to, and share Codex tasks.
- Organize sidebar sections and projects.
- Open files, browser views, terminals, and reviews in the Codex UI.
- Create and update recurring automations and same-thread heartbeats.
- Read usage limits and consume a reset only with explicit user authorization.

## Agent coordination

- Spawn, message, follow up, interrupt, list, and wait for subagents.
- Four active slots in this session, including the primary agent.
- Shared filesystem with separate agent threads.

## Conditional or unavailable surfaces

- Browser-control and Computer Use skills are installed, but active control endpoints were not exercised in this profile.
- Gmail, personal calendar, Slack, Notion, and general database connectors are not currently exposed.
- Many additional plugins are available for installation but are not active capabilities until explicitly requested, installed, and authorized.

---

# 20. TOOL-SELECTION POLICY

| Route | Choose it when | Avoid it when |
| --- | --- | --- |
| Direct answer | Stable, low-stakes, no source or computation burden | Facts may have changed or exact support matters |
| Web search | Current, niche, uncertain, high-stakes, or citation-dependent | The authoritative private connector is available |
| Open/fetch page | A search result must be validated in context | Snippet-level discovery is all that is needed |
| Inspect local file | Workspace state controls the answer | User did not put the file in scope |
| Python/Node | Calculation, parsing, transformation, simulation, validation | One transparent manual step is safer and faster |
| Terminal | Build, tests, Git, environment, processes, repository investigation | A purpose-built connector preserves semantics better |
| Connector | Private/current service data or service-native mutation | Authentication/scope is missing |
| Specialist tool | Media, financial, document, OCR, or other domain mechanics | General reasoning alone is sufficient |
| Parallel tool calls | Calls are independent and read-only or safely isolated | Each result determines the next call |
| Subagent | Context isolation or independent coverage earns the overhead | Task is small, sequential, or write-conflicted |
| Another model | Specialist modality, lower-cost batch, or independent validation | The switch has not been evaluated for this workload |
| Human authorization | External write, destructive action, purchase, credential, or material scope change | Safe in-scope local implementation already authorized |

Order of preference:

1. Use the authoritative in-scope source.
2. Use the least powerful tool that can produce verifiable output.
3. Keep external mutations explicit and reviewable.
4. Prefer executable checks over linguistic confidence.
5. Do not repeat completed calls or retry structural failures as if they were transient.

---

# 21. TOOL AND CONNECTOR DISCOVERY

```text
task requirement
→ required capability and authority
→ current tool/skill inventory
→ authentication check
→ gap classification
→ existing connector or MCP resource
→ plugin discovery if explicitly requested
→ authorization/installation
→ execution
→ validation
```

Current discovery surfaces `[O]`:

- Programmatic access to tool names and descriptions.
- MCP resource and resource-template listing.
- Installed skill catalog.
- Plugin-management workflow for discovery and connection questions.
- Restricted recommendation mechanism for an explicitly requested plugin from the supplied catalog.

The API model supports tool search `[D]`, but a general callable `tool_search` endpoint is not directly exposed in this task’s visible tool surface `[O]`. Do not infer that API compatibility means every product session provides the same tool-discovery method.

---

# 22. FILE AND DOCUMENT HANDLING

| Format | Read/analyze | Create/edit | Verification route |
| --- | ---: | ---: | --- |
| Markdown/text/code | Yes | Yes | Parse, lint, diff |
| PDF | Yes | Yes | Extract plus page render/visual inspection |
| DOCX | Yes | Yes | Render to pages and inspect layout |
| XLSX | Yes | Yes | Formula scan, recalc where possible, workbook render |
| CSV/TSV | Yes | Yes | Schema, delimiter, row-count, encoding checks |
| PPTX | Yes | Yes | Render every slide and inspect |
| Google Docs | Connector-exposed | Connector-exposed | Re-fetch and inspect structure |
| Google Sheets | Connector-exposed | Connector-exposed | Read precise ranges and verify formulas/charts |
| Google Slides | Connector-exposed | Connector-exposed | Inspect slide topology and rendered result |
| Images | Yes | Generate/edit | Pixel/view inspection and text review |
| Audio/video | File processing possible | Transcoding possible via FFmpeg | No native semantic audio/video model in this turn |

Large-file strategy:

1. Inventory pages, sheets, slides, sections, file size, and encoding.
2. Extract structure before content.
3. Route only relevant partitions into working context.
4. Store intermediate tables and summaries in canonical files.
5. Preserve original files.
6. Render and visually verify layout-sensitive outputs.
7. Reopen the final artifact from disk rather than trusting generation success.

---

# 23. LONG-CONTEXT OPERATION

The documented 1.05M-token API window is large but does not remove retrieval or prioritization problems. Effective product context, current occupancy, and compaction boundaries are not exposed `[U]`.

Recommended controls:

- One coherent outcome per task.
- A canonical objective and acceptance-criteria file.
- Targeted retrieval instead of repeatedly loading complete corpora.
- Explicit decision, assumption, and evidence logs.
- Short worker outputs with provenance links.
- Checkpoint summaries after major phases.
- Automatic or manual compaction that preserves goals, constraints, decisions, and artifact paths.
- Separate tasks for genuinely independent branches.
- Worktrees for parallel coding branches.

Failure signals include repeated rediscovery, contradictory assumptions, loss of earlier constraints, citations detached from claims, and tool calls that repeat already completed work.

---

# 24. MEMORY, STATE, AND PERSISTENCE

| State | Persistence owner | Expected lifetime | Current certainty |
| --- | --- | --- | --- |
| Turn working state | Model/harness | Current turn/context | `[O]` |
| Task transcript | Product | Product retention lifecycle | `[D]`; policy-specific details not inspected |
| Compacted history | Product/harness | Within continuing task | `[D]` |
| API persisted reasoning | Responses API | Based on API configuration | `[D]`; desktop effective setting `[U]` |
| Local Codex memories | Local product store | Cross-task when enabled | `[D]`; enablement `[U]` |
| Workspace files | User filesystem | Until changed/deleted | `[O]` |
| Git commits | Repository | Durable when committed/pushed | `[O]` capability |
| Connector records | External service | Service policy | `[D]` general; auth `[U]` |
| Subagent thread | Agent tree | Session/task scoped | `[O]`; cross-session durability `[U]` |
| Scheduled automation | Codex app | Until paused/deleted | `[O]` |
| Running shell process | Host process/session | Process lifetime | `[O]` |

Codex’s local memory system is optional and distinct from durable project instructions. Required team rules belong in `AGENTS.md` or checked-in documentation. Official reference: [Memories](https://learn.chatgpt.com/docs/customization/memories).

---

# 25. LONG-HORIZON EXECUTION

## The model can plan

- Milestones, dependency graphs, retry loops, rollback paths, verification gates, and stop criteria.

## This session can execute

- Multi-step shell/file workflows.
- Iterative build/test/fix loops.
- Web and connector research loops.
- Subagent coordination within four active slots.
- Long-running commands that yield a resumable session.
- Cross-task coordination through Codex task tools.
- Scheduled cron tasks and same-thread heartbeats.

## External/product infrastructure provides durability

- Conversation and task storage.
- Local filesystem.
- Git repositories.
- External connector state.
- Scheduled automation service.
- Notifications and user re-entry.

A continuously conscious model is not running between scheduled events. The scheduler starts a new run or resumes a thread according to its saved prompt and context. Official references: [Long-running work](https://learn.chatgpt.com/docs/long-running-work) and [Scheduled tasks](https://learn.chatgpt.com/docs/automations).

---

# 26. FAILURE RECOVERY

| Failure | Diagnosis | Recovery | Replan trigger |
| --- | --- | --- | --- |
| Search returns little | Vocabulary/index/scope problem | Expand synonyms, domains, citations | Authoritative evidence still absent |
| Page inaccessible | Auth, paywall, robots, transient network | Alternate official copy or connector | Required source remains unavailable |
| Contradictory evidence | Definitions, dates, methods, incentives | Normalize and adjudicate | Conflict changes the conclusion |
| Malformed file/data | Encoding, delimiter, schema, corruption | Preserve raw; isolate bad records | Integrity cannot be restored safely |
| Join/transform error | Cardinality or key semantics | Add assertions and reconcile | Output invariants fail |
| Model non-convergence | Identification, scaling, sparsity, initialization | Simplify/rescale/change optimizer carefully | Model cannot answer estimand |
| Compilation error | First causal diagnostic | Reproduce and fix minimal cause | Dependency/interface premise false |
| Runtime crash | Stack, logs, resource state | Minimize reproduction; checkpoint | Environment cannot reproduce target |
| Package conflict | Lockfile/runtime mismatch | Isolate environment; pin versions | Required combination incompatible |
| Tool validation error | Wrong schema/argument | Inspect description; correct once | Tool cannot express operation |
| Transient API error | Timeout/rate/service | Bounded retry with backoff | Retry budget exhausted |
| Authentication error | Missing/expired scope | Stop and request exact connection | Authorization unavailable |
| Worker disagreement | Different assumptions/evidence | Common rubric and evidence adjudication | Shared premise unresolved |
| Partial completion | Budget/access boundary | Deliver verified subset and handoff | Acceptance criteria remain unmet |

Never hide a partial result behind polished prose. State completed criteria, failed criteria, evidence, and the next required authority or resource.

---

# 27. VERIFICATION ARCHITECTURE

| Output type | Primary verification | Stronger independent check |
| --- | --- | --- |
| Arithmetic | Executable recomputation | Alternate formula/runtime |
| Mathematical derivation | Substitute/test boundary cases | Independent derivation or symbolic tool |
| Data transformation | Invariants, row counts, key reconciliation | Reimplementation on samples |
| Statistics | Diagnostics and sensitivity | Independent reproduction |
| Code | Test/build/static checks | Reviewer who did not author the patch |
| Debugging | Original failure now passes | Regression and adjacent behavior tests |
| Architecture | Trace real dependencies and constraints | Failure-mode/rollback review |
| Current facts | Authoritative source and date | Independent source triangulation |
| Research claims | Claim/evidence matrix | Contradiction hunter |
| Citations | Open each source and check entailment | Separate citation auditor |
| Documents | Structural checks | Render every page/slide/sheet and inspect |
| High-stakes decisions | Multiple methods and provenance | Different model plus qualified human |

Verification priority under resource pressure:

1. Numbers that drive the conclusion.
2. Citations that establish the conclusion.
3. The core identification, safety, or architectural assumption.
4. Irreversible action targets.
5. Secondary presentation details.

---

# 28. HOSTILE REVIEW MODE

| Review role | Failure-seeking objective |
| --- | --- |
| Peer reviewer | Does the claimed contribution follow from the evidence? |
| Methods critic | Which validity assumptions fail or remain untested? |
| Statistical auditor | Is the estimand-estimator-inference chain coherent? |
| Assumption challenger | Which hidden assumptions are load-bearing? |
| Contradiction detector | Where do text, tables, code, and sources disagree? |
| Code reviewer | Which correctness, security, race, or test gap survives the suite? |
| Architecture reviewer | What fails first under scale, outage, migration, or misuse? |
| Evidence auditor | Does each source support the exact nearby claim? |

Effective critic prompts define an adversarial objective, severity rubric, evidence requirement, and rejection criteria. A critic should receive the artifact and necessary context, but preferably not the author’s persuasive reasoning. “Find the strongest invalidating defect” produces a different search policy from “check whether this is okay.”

---

# 29. FAILURE MODES

| Risk | Manifestation | Mitigation |
| --- | --- | --- |
| Stale knowledge | Answers after the cutoff from recall | Live search |
| Obscure-fact error | Plausible but wrong specificity | Primary/specialist source |
| Citation fabrication | Valid-looking identifier or irrelevant source | Fetch and entailment-check |
| Arithmetic drift | Small unnoticed numerical error | Execute calculation |
| Context pollution | Critical requirements buried | Retrieval, checkpoints, subagents |
| Thin evidence | Fluent synthesis from inadequate sources | Evidence thresholds and gap reporting |
| Inaccessible artifact | Assumed content or behavior | State exact access boundary |
| Ambiguous objective | Correct solution to wrong problem | Surface material ambiguity early |
| Version mismatch | Uses remembered API behavior | Inspect installed version and official docs |
| Confirmation bias | Searches only supporting evidence | Dedicated contradiction lane |
| False confidence | Certainty exceeds support | Evidence labels and calibrated language |
| Over-delegation | Duplicate work and merge burden | Smallest useful topology |
| Parallel write collision | Conflicted or overwritten files | Ownership or worktree isolation |
| Same-model consensus | Workers repeat correlated mistake | Different method/model/human |
| Prompt injection in sources | Retrieved text treated as instruction | Treat sources as untrusted data |
| Incomplete handoff | Work stops without usable state | Canonical checkpoint and remaining criteria |

---

# 30. PERFORMANCE BOTTLENECKS

Current likely bottlenecks:

- Free RAM was low during the probe; large local analysis should check memory immediately before execution.
- D: had little free space during inspection; artifact-heavy work should select storage intentionally.
- Statistical libraries are incomplete in the bundled runtime.
- Connector authentication is not verified merely by tool exposure.
- Four active agent slots limit parallel breadth.
- Large worker output can make synthesis, not production, the critical path.
- Web coverage, paywalls, and source quality may dominate research quality.
- Windows-specific build and quoting behavior differs from common Linux examples.
- No global Gradle was found; Android builds should rely on the repository wrapper.
- Browser and desktop-control surfaces require activation and may depend on foreground/session conditions.

Optimization should target the measured bottleneck. Adding workers does not accelerate a memory-bound local computation or a sequential debugging loop.

---

# 31. OPTIMAL PROMPTING

A strong orchestration prompt specifies:

```text
OUTCOME
The observable result that must exist.

CONTEXT
Only the domain facts and artifacts needed to act.

CONSTRAINTS
Compatibility, scope, safety, style, time, and authorization boundaries.

EVIDENCE
Which claims require sources, execution, tests, or diagnostics.

TOOLS
Required or forbidden tools and authoritative systems.

PARALLELISM
Whether independent branches or subagents are wanted.

ACCEPTANCE CRITERIA
Checks that establish completion.

DELIVERABLE
Format, path, schema, and intended audience.

ESCALATION
Which ambiguity or side effect requires user input.
```

For xhigh, outcome-focused prompts outperform demands to reveal reasoning. State the decision, constraints, verification, and allowed autonomy; let the model choose internal reasoning detail.

Worked routing example:

```text
Assess whether this research proposal has close prior art from 2022 onward.
Search exact terms, mechanisms, methods, adjacent disciplines, and contradictory work.
Use primary or scholarly sources where possible. Record claim, URL, date, and supporting passage.
Return exact precedents, close precedents, unresolved gaps, and a bounded novelty assessment.
Do not state that the idea is novel; state the coverage limits.
```

---

# 32. PROMPT PATTERNS THAT REDUCE PERFORMANCE

- Repeating the same instruction in several forms.
- Asking for hidden chain-of-thought rather than an auditable process summary.
- Giving incompatible success criteria without priority.
- Providing every available tool when only one is relevant.
- Saying “be accurate” without defining required evidence.
- Requesting exhaustive research without scope, date, or stopping conditions.
- Asking multiple workers to solve the same vague task.
- Allowing concurrent agents to edit the same files.
- Requiring citations but not requiring sources to be opened.
- Asking for a fix when only diagnosis is authorized.
- Mixing local, cloud, and external writes without explicit authority.
- Treating “use maximum effort” as a substitute for benchmarks.

---

# 33. MULTI-MODEL ORCHESTRATION

## Strong roles for GPT-5.6 Sol xhigh

- Primary reasoner for ambiguous, high-value objectives.
- Coordinator for tool-heavy research and engineering.
- Repository-aware coding and debugging agent.
- Statistical-design and analysis lead when execution is provisioned.
- Integrator of heterogeneous worker results.
- Hostile reviewer for methods, evidence, architecture, and code.

## Route elsewhere when

- Deterministic retrieval or transformation is better handled directly by a database or script.
- Audio, video, OCR, or image generation needs a specialist modality.
- A cheaper model passes the same objective evaluation for high-volume work.
- A specialized domain database has materially better coverage.
- Formal proof, large-scale optimization, or GPU computation requires dedicated software/hardware.
- Independent validation is important enough to justify a different model family.
- Legal, clinical, regulatory, safety, or financial accountability belongs to a qualified human.

Model diversity buys partial error decorrelation, not guaranteed superiority. The verifier should use a different method and evidence base where possible.

---

# 34. ROUTING RULES

```text
R01 IF task=current fact OR latest version OR current office-holder
    THEN role=researcher; effort=low/medium; tools=web; workers=0;
         verify=authoritative current source; never rely on cutoff knowledge.

R02 IF task=stable explanation AND stakes=low
    THEN role=answerer; effort=low/medium; tools=none; workers=0;
         verify=internal consistency.

R03 IF task=high-stakes fact
    THEN role=evidence coordinator; effort=high; tools=web/specialist connector;
         workers=2-3 source lanes; verify=triangulation plus human accountability.

R04 IF task=deep research
    THEN role=research coordinator; effort=xhigh; tools=web+scholarly connector;
         workers=3-6 in waves; verify=citation audit and contradiction search.

R05 IF task=novelty screening
    THEN role=ontology lead; effort=xhigh; tools=web+scholarly sources;
         workers=4-8 in waves; verify=adjacent-field and prior-art review;
         output=bounded screening, never universal clearance.

R06 IF task=citation verification
    THEN role=verifier; effort=medium; tools=open/fetch; workers=1-3 by claim batch;
         verify=source opens and entails the exact claim.

R07 IF task=descriptive data analysis
    THEN role=data analyst; effort=medium; tools=Python; workers=0;
         verify=schema, denominators, row counts, and recomputation.

R08 IF task=statistical inference
    THEN role=statistical lead; effort=high/xhigh; tools=provisioned stats runtime;
         workers=1-2; verify=diagnostics, robustness, reproducible rerun.

R09 IF task=causal inference
    THEN role=identification lead; effort=xhigh; tools=code+literature;
         workers=2-4; verify=DAG/assumptions/falsification/sensitivity before conclusion.

R10 IF task=machine learning
    THEN role=ML lead; effort=high; tools=prepared ML runtime;
         workers=2-3; verify=held-out performance, leakage, calibration, baseline.

R11 IF task=small code change with clear owner
    THEN role=coder; effort=medium; tools=filesystem+tests; workers=0;
         verify=focused test and diff audit.

R12 IF task=multi-module implementation
    THEN role=technical lead; effort=xhigh; tools=repo+shell+tests;
         workers=2-3 isolated branches; verify=integration suite and independent review.

R13 IF task=debug reproducible failure
    THEN role=incident lead; effort=high/xhigh; tools=logs+tests+debugger;
         workers=0-2 competing hypotheses; verify=minimal reproducer and regression test.

R14 IF task=debug non-reproducible external system
    THEN first obtain logs, access, or a reproducer; do not fabricate a fix.

R15 IF task=large repository comprehension
    THEN role=architecture mapper; effort=high; tools=search+filesystem;
         workers=3 subsystem explorers; verify=cross-module execution-path trace.

R16 IF task=security review
    THEN role=defensive reviewer; effort=xhigh; tools=repo+specialist scanner if available;
         workers=2-3 threat lanes; verify=concrete location and failure scenario plus human review.

R17 IF task=data pipeline
    THEN role=data-engineering lead; effort=high; tools=runtime+authoritative data store;
         workers=2-3 source/schema/quality lanes; verify=reconciliation and replay.

R18 IF task=PDF/DOCX analysis
    THEN role=document analyst; effort=medium/high; tools=parser+renderer;
         workers=0-3 sections; verify=location-linked extraction and visual spot check.

R19 IF task=spreadsheet construction
    THEN role=workbook builder; effort=medium; tools=spreadsheet skill/runtime;
         workers=0-1; verify=formulas, totals, references, and render.

R20 IF task=presentation construction
    THEN role=story/design lead; effort=high; tools=presentation skill+renderer;
         workers=1-2 content/visual lanes; verify=render every slide.

R21 IF task=manuscript from settled evidence
    THEN role=lead author; effort=high; tools=documents+sources;
         workers=2-3 independent sections; verify=citations, numbers, voice consistency.

R22 IF task=hostile review
    THEN role=critic; effort=xhigh; tools=artifact and supporting evidence;
         workers=1 blind reviewer; verify=each defect is specific and falsifiable.

R23 IF task=batch extraction/classification
    THEN role=workflow designer; effort=low; tools=programmatic execution;
         workers=cheap/batched only if needed; verify=schema and sampled labels.

R24 IF task=scheduled monitoring
    THEN role=monitor; effort=low/medium; tools=automation+connector;
         workers=0; verify=state diff; notify only on meaningful change.

R25 IF task=external write OR delete OR publish OR spend
    THEN validate target and explicit authorization before action;
         effort=high where consequences are material; verify=post-action state.

R26 IF task=high-volume low-complexity
    THEN benchmark Terra/Luna or deterministic code before choosing Sol xhigh.

R27 IF task=independent verification of a Sol conclusion
    THEN prefer a different derivation, executable check, source set, or model family.

R28 IF task=worker topology exceeds three simultaneous descendants
    THEN schedule waves or use an external orchestrator; do not exceed the current slot cap.

R29 IF task=shared-file parallel editing
    THEN prohibit until ownership/worktrees are defined.

R30 IF task=missing connector/authentication
    THEN stop the blocked operation and request the exact connection or scope; do not retry blindly.
```

---

# 35. RESOURCE-ALLOCATION RULES

| Resource | Allocation rule |
| --- | --- |
| Reasoning effort | Scale to consequence, ambiguity, interaction depth, and verification burden |
| Search breadth | Scale to volatility, evidence stakes, and terminology uncertainty |
| Sources | Continue to claim saturation; count independent provenance, not duplicated reports |
| Workers | Never exceed genuinely independent slices or the current active-slot cap |
| Parallelism | Favor read-heavy independent branches; isolate or serialize writes |
| Compute | Check RAM/disk/packages before large local analysis |
| Verification | Always protect load-bearing numbers, citations, assumptions, and action targets |
| Second model | Use for correlated epistemic risk, not mechanical checks a script can perform |
| Stopping | Acceptance criteria, saturation, hard boundary, or budget with complete handoff |

---

# 36. DIMINISHING RETURNS FROM WORKERS

| Worker count | Expected benefit | Coordination burden | Best use |
| ---: | --- | --- | --- |
| 1 | Context isolation or one independent review | Minimal | Long-document read, blind critic |
| 2 | First useful parallel coverage | Low | Two search lanes, implementation plus tests |
| 3 | Matches this session’s maximum descendants | Moderate | Three evidence lanes or two producers plus verifier |
| 5 | Wider coverage but requires waves here | Significant | Naturally five-part corpus or review axes |
| 8 | Broad exploration | High | Large independent corpus under external orchestration |
| 10+ | Batch-scale coverage only | Synthesis can dominate | Structured extraction with short outputs |

Testable hypotheses:

- Three workers will often dominate one for independent research coverage but not for sequential debugging.
- Replacing the last producer with a verifier will improve high-stakes quality more than adding redundant production.
- Write-heavy tasks will show earlier negative returns than read-heavy tasks.
- Quality per token will plateau before raw source coverage.
- External orchestration becomes preferable once synthesis no longer fits comfortably in one coordinator context.

---

# 37. CAPABILITY BOUNDARY MAP

| Capability | Can reason | Can execute now | Required dependency | Boundary |
| --- | ---: | ---: | --- | --- |
| General synthesis/review | Yes | Yes | None | Self-assessed quality needs benchmarking |
| Exact arithmetic | Yes | Yes | Python/Node | Must execute |
| Python data analysis | Yes | Yes | Local runtime | Package gaps may require provisioning |
| Advanced statistics | Yes | Conditional | Stats libraries/runtime | Current bundle incomplete |
| Deep-learning training | Yes | Not established | GPU/framework/data | Host not profiled for this workload |
| Repository coding/debugging | Yes | Yes when repo supplied | Files, build, tests | Current directory is not a repo |
| Android device interaction | Yes | Partial | ADB/device/project | Device state and project not inspected |
| Web research | Yes | Yes | Web tool | Coverage/paywall limits |
| Scholarly search | Yes | Yes | Consensus/web | Not every academic index |
| Patent/FTO opinion | Yes conceptually | Inadequate as sole system | Patent DB + counsel | Novelty screening only |
| GitHub operations | Yes | Auth unknown | GitHub connector | Endpoint exposure is not authorization |
| Google Drive operations | Yes | Auth unknown | Drive connector | Same |
| Gmail/calendar | Yes conceptually | No | Plugin/connection | Not exposed |
| General database query | Yes | No live connector | DB/client/credentials | Not exposed |
| PDF/DOCX/XLSX/PPTX | Yes | Yes | Skills/libraries | Render-and-verify required |
| Image understanding | Yes | Yes | Image input/viewer | Exact OCR/layout may need specialist tooling |
| Image generation | Direct description only | Yes via tool | Image generator | Not base-model pixel output |
| Audio/video understanding | Conceptually | No native path | Specialist model/tool | FFmpeg processing is not understanding |
| Subagents | Plan/coordinate | Yes | Codex harness | Four active slots total |
| Nested agents | Yes | Technically yes | Same harness | Slot cap makes deep nesting impractical |
| Durable scheduling | Yes | Yes | Automation service | Model is event-invoked, not continuously resident |
| Cross-task memory | Yes conceptually | Unknown current enablement | Local memory setting | Do not rely on it for mandatory rules |
| External publication/delete | Yes | Only when authorized | Connector and user authority | Validate exact target |
| Physical experiments | Yes conceptually | No | Lab/field/humans | External |

---

# 38. EMPIRICAL BENCHMARK PROGRAM

No results are asserted here. These tests are intended to replace `[S]` claims with measurements.

| ID | Benchmark | Input | Measurements | Proposed success gate | Failure signal |
| --- | --- | --- | --- | --- | --- |
| B01 | General reasoning | Hidden-answer multi-step cases | Exact/rubric score, calibration | Statistically reliable gain over chosen baseline | Fluent violation of constraints |
| B02 | Hard constraint reasoning | Scheduling/configuration puzzles | Valid solution rate | All hard constraints satisfied | Any invalid assignment |
| B03 | Mathematics | Symbolic and numerical problems | Accuracy with/without code | Code arm exact; derivation independently checks | Unexecuted numerical error |
| B04 | Research quality | Current, source-rich questions | Primary-source recall/precision, contradiction coverage | Decision-critical sources recovered | Important source family missing |
| B05 | Citation accuracy | Claim/source pairs | Link validity and entailment | Target ≥95% on critical claims | Source opens but does not support claim |
| B06 | Novelty screening | Ideas with seeded precedents | Exact/adjacent precedent recall | Finds seeded exact and semantic prior art | Declares novelty despite known precedent |
| B07 | Statistics | Simulated data with known DGP | Estimand, estimate, uncertainty, diagnostics | Correct design and interval behavior | Wrong estimand or invalid SE |
| B08 | Causal inference | Simulated observational/quasi-experimental cases | Identification choice and bias | Correctly rejects unidentified claims | Fits estimator without assumptions |
| B09 | Coding | Private repos with hidden tests | Pass rate, regression count, diff size | Required tests pass with scoped patch | Hidden regression or unrelated edits |
| B10 | Debugging | Seeded defects | Reproduction, root cause, repair | Minimal reproducer and causal fix | Symptom-only patch |
| B11 | Repository comprehension | Large unfamiliar repositories | Entry-point/call-path accuracy | Correct ownership and dependency map | Invented architecture |
| B12 | Document intelligence | PDFs/DOCX/XLSX/PPTX with planted details | Extraction and layout accuracy | Critical fields and structure preserved | Table/layout corruption |
| B13 | Long context | Large corpus with dispersed constraints | Retrieval, consistency, requirement retention | All load-bearing constraints retained | Earlier requirement forgotten |
| B14 | Tool selection | Mixed task suite | Route accuracy, calls, latency, cost | Minimum sufficient tool path | Unnecessary search or no execution when needed |
| B15 | Subagent orchestration | Decomposable tasks | Final quality, duplication, merge errors | Better quality/latency Pareto point | Worker outputs conflict or duplicate |
| B16 | Verification | Plausible artifacts with seeded defects | Severity-weighted detection | Finds all critical planted defects | Rubber-stamps artifact |
| B17 | Failure recovery | Injected auth, timeout, malformed-data, build failures | Recovery and stop correctness | Bounded retry and valid fallback | Infinite retry or hidden partial result |
| B18 | xhigh value | Matched tasks at medium/high/xhigh/max | Quality, latency, tokens, tool calls | xhigh selected only where Pareto-efficient | More cost without measurable quality gain |
| B19 | Calibration | Questions with known answers | Brier/calibration error by confidence band | Confidence tracks empirical accuracy | High-confidence wrong answers cluster |
| B20 | Prompt robustness | Lean vs repetitive prompt variants | Success, token use, latency | Lean contract preserves/improves success | Performance depends on redundant wording |

Benchmark controls:

- Pin the model identifier or record exact response metadata where available.
- Fix tool availability, source snapshot, and time budget.
- Separate prompt development from held-out evaluation.
- Grade blind to configuration.
- Report variance, not only mean performance.
- Measure total coordinator plus worker cost.
- Preserve traces sufficient to classify errors without requesting private chain-of-thought.

---

# 39. SINGLE- VS MULTI-WORKER EXPERIMENT

## Conditions

| Arm | Structure |
| --- | --- |
| A1 | One agent performs the complete task |
| A3 | Coordinator plus up to three concurrent specialized workers |
| A5 | Five workers executed in two waves under one coordinator |
| AN | Largest configuration supported by an external orchestrator |
| AV | Same budget as A3, but last producer replaced by a verifier |
| AM | Same task with a different model family as final verifier |

## Task families

1. Literature research with known gold sources.
2. Novelty screening with seeded semantic precedents.
3. Multi-axis code review with planted defects.
4. Repository mapping across independent subsystems.
5. Sequential debugging as a negative control.
6. Document-batch extraction.

## Required controls

- Same source corpus or source-access window.
- Same wall-clock and total-token comparisons, reported separately.
- Stable worker prompts and output schemas.
- Randomized task order and repeated trials.
- Coordinator does not receive gold answers.
- Write-heavy arms use disjoint worktrees or output paths.

## Metrics

- Correctness and severity-weighted defect detection.
- Source and prior-art coverage.
- Contradiction discovery.
- Unsupported-claim rate.
- Duplicate sources and duplicated tool calls.
- Wall-clock latency.
- Total model tokens and tool/service cost.
- Merge conflicts and synthesis defects.
- Provenance retention.
- Quality per unit cost.

The optimal count is the lowest-resource configuration on the quality/latency/cost frontier, not the largest available team.

---

# 40. SELF-REPORT VALIDATION

| Claim | Why it needs testing | Settling test |
| --- | --- | --- |
| xhigh improves difficult-task quality | Effort effects are workload-specific | B18 matched-effort study |
| Sol is very strong at multi-step reasoning | Qualitative self-ranking | B01/B02 against external baselines |
| Research synthesis is a strength | Retrieval gaps may be hidden by prose | B04 gold-corpus vs self-retrieval arms |
| Citation verification is reliable when mandated | Compliance may be inconsistent | B05 with mandatory vs optional wording |
| Novelty search finds semantic precedents | Vocabulary coverage is uncertain | B06 |
| Statistical planning is strong | Conceptual fluency may mask estimand errors | B07/B08 |
| Coding is very strong | Public tasks may be familiar | B09 private repos and hidden tests |
| Debugging reaches root cause | Patch success may be accidental | B10 fault injection |
| Large-context operation is robust | Effective product context is unknown | B13 |
| Tool routing is efficient | Tool presence encourages overuse | B14 |
| Three workers improve research | Current recommendation is structural | B15 A1 vs A3 |
| A verifier beats another producer | Plausible but unmeasured | B15 A3 vs AV |
| Same-model critics find more defects | Correlated error may persist | B16 same vs different model |
| Recovery behavior is bounded | Happy-path self-description proves little | B17 |
| Current connectors are usable | Tool exposure does not prove OAuth | Read-only health probe per connector |
| Local memories are available | No current enablement signal | Settings/config plus cross-task recall test |
| Four-slot concurrency is effective | Declared capacity is not throughput | Timed three-worker workload |
| 1.05M context is effective in desktop | API documentation is not product measurement | Progressive long-context probe |

All `[S]` statements should be treated as routing hypotheses until a representative evaluation supports them.

---

# 41. MATERIAL CLAIM REGISTER

| # | Claim | Class | Direct test | Confidence |
| ---: | --- | --- | --- | --- |
| 1 | Configured model is `gpt-5.6-sol` | `[O]` | Inspect local configuration/session metadata | High |
| 2 | Configured effort is `xhigh` | `[O]` | Inspect local configuration | High |
| 3 | Exact serving snapshot is not exposed | `[U]` | Provider response metadata | High about non-exposure |
| 4 | API context window is 1,050,000 tokens | `[D]` | Provider documentation/API | High |
| 5 | API max output is 128,000 tokens | `[D]` | Provider documentation/API | High |
| 6 | Knowledge cutoff is 2026-02-16 | `[D]` | Provider documentation | High |
| 7 | Base model accepts text/image and outputs text | `[D]` | Model API modality test | High |
| 8 | Audio/video are not base-model modalities | `[D]` | Model API test | High |
| 9 | Current app runs on Windows 11 Pro | `[O]` | OS query | High |
| 10 | PowerShell, Python, Node, and Git are installed | `[O]` | Command/version probe | High |
| 11 | Current directory is not a Git repo | `[O]` | `git rev-parse` | High |
| 12 | JDK 17 and ADB are present | `[O]` | Command probe | High |
| 13 | No global Gradle was found | `[O]` | Command probe | High |
| 14 | Web search and page retrieval work | `[O]` | Re-run official-doc query | High |
| 15 | Local filesystem and shell execution work | `[O]` | Read-only command/file probe | High |
| 16 | Image generation tool is exposed | `[O]` | Tool inventory/call | High |
| 17 | PDF/DOCX/XLSX/PPTX workflows are installed | `[O]` | Dependency loader and artifact test | High |
| 18 | Bundled Python has NumPy/pandas | `[O]` | Import probe | High |
| 19 | Bundled Python lacks SciPy/statsmodels/sklearn | `[O]` | Import probe | High for current bundle |
| 20 | GitHub exposes 89 methods | `[O]` | Tool-registry count | High for profile date |
| 21 | Google Drive exposes 45 methods | `[O]` | Tool-registry count | High for profile date |
| 22 | Finance connectors expose 65 methods | `[O]` | Tool-registry count | High for profile date |
| 23 | Consensus exposes scholarly search/fetch | `[O]` | Tool inventory | High |
| 24 | Gmail and personal calendar are not exposed | `[O]` | Tool inventory | High for profile date |
| 25 | Connector authentication was not tested | `[U]` | Read-only health check | High about non-test |
| 26 | General SQL/database connector is absent | `[O]` | Tool inventory | High for profile date |
| 27 | Scheduled tasks and heartbeats are exposed | `[O]` | Automation schema/test | High |
| 28 | Subagents are exposed by the harness | `[O]` | Tool inventory/spawn test | High |
| 29 | Current active-agent cap is four including primary | `[O]` | Harness configuration | High |
| 30 | Worker contexts are separate and configurable at spawn | `[O]` | Spawn contract/test | High |
| 31 | Workers share the filesystem | `[O]` | Harness contract/marker test | High |
| 32 | Workers can message one another | `[O]` | Messaging test | High |
| 33 | Nested delegation is supported within the shared cap | `[O]` | Descendant spawn test | Medium–high; not executed here |
| 34 | Local files persist beyond the turn | `[O]` | Reopen file later | High |
| 35 | Local memory enablement is unknown | `[U]` | Settings/config and cross-task test | High about uncertainty |
| 36 | xhigh benefits hard tasks | `[S]` | B18 | Medium |
| 37 | Research synthesis is a strong use | `[S]` | B04 | Medium |
| 38 | Novelty screening cannot prove universal novelty | `[S][I]` | Logical/coverage audit | High |
| 39 | Exact statistics require code execution | `[S]` | B07 no-code vs code | High |
| 40 | Verification by another method is stronger than repetition | `[S][I]` | B16 | Medium–high |
| 41 | Three descendants are often enough for current tasks | `[S]` | B15 | Low–medium |
| 42 | Same-model worker agreement may be correlated | `[I]` | AM vs same-model verifier | Medium |
| 43 | Browser/Computer Use skills are installed but untested here | `[O][U]` | Activate each skill | High |
| 44 | Current permission profile is technically unrestricted | `[O]` | Runtime metadata | High |
| 45 | Technical permission does not replace user authorization | `[D]` workflow boundary | Review action policy | High |

---

# 42. MACHINE-READABLE MANIFEST

```yaml
profile:
  generated_local_date: "2026-09-03"
  method: "official OpenAI documentation plus live read-only environment inspection"
  source_template_used_for_structure_only: "MODEL_OPERATIONAL_PROFILE.md"
  evidence_labels:
    O: observed
    D: documented
    S: self_described
    I: inferred
    U: unknown

model:
  provider: OpenAI
  family: GPT-5.6
  configured_id: gpt-5.6-sol
  alias: gpt-5.6
  exact_serving_snapshot: unknown
  reasoning_effort: xhigh
  reasoning_label: Extra High
  pro_mode: unknown
  knowledge_cutoff: "2026-02-16"
  api_context_window_tokens: 1050000
  api_max_output_tokens: 128000
  base_input_modalities: [text, image]
  base_output_modalities: [text]
  fine_tuning: false
  function_calling: true
  structured_outputs: true

environment:
  application: "Codex in the ChatGPT desktop app"
  execution_mode: local
  operating_system: "Windows 11 Pro 64-bit 10.0.22631"
  timezone: "Asia/Karachi"
  working_directory: "E:\\Andriod Development"
  working_directory_is_git_repo: false
  shell: "PowerShell 7.6.4"
  python: "3.13.1"
  node: "24.18.0"
  git: "2.55.0.windows.2"
  java: "Microsoft JDK 17"
  adb: true
  global_gradle: false
  cpu: "Intel Core i5-8365U"
  physical_cores: 4
  logical_processors: 8
  installed_ram_gib: 15.79
  filesystem_permission: unrestricted
  network_access: enabled
  approval_policy: never

reasoning:
  deep_reasoning: true
  configurable_effort: true
  supported_efforts: [none, low, medium, high, xhigh, max]
  current_effort: xhigh
  hidden_reasoning_exposed: false
  uncertainty_style: "separate observed, documented, inferred, self-described, and unknown claims"
  verification_policy: "execute, retrieve, triangulate, test, or independently review load-bearing claims"

research:
  live_web_search: true
  page_retrieval: true
  pdf_page_screenshots: true
  scholarly_connector: Consensus
  citation_verification: true
  contradiction_search: supported
  novelty_analysis: screening_only
  universal_novelty_guarantee: false
  paywalled_access: unknown
  parallel_research: true

agents:
  true_subagents_available: true
  provided_by: Codex_harness
  dynamic_creation: true
  nested_creation: true
  active_slots_total: 4
  simultaneous_descendants_with_primary_active: 3
  separate_threads: true
  initial_context: configurable_fork
  shared_filesystem: true
  peer_communication: true
  task_tree_persistence: session_scoped_or_unknown
  recommended_topology: "coordinator plus two producers plus verifier, or three independent evidence lanes"

execution:
  shell: true
  filesystem: true
  patch_editing: true
  python: true
  node: true
  git: true
  github_connector: exposed_auth_unknown
  google_drive_connector: exposed_auth_unknown
  gmail_connector: false
  calendar_connector: false
  general_database_connector: false
  generic_external_api: conditional_on_endpoint_credentials_and_authorization

tool_registry:
  total_methods_observed: 284
  codex_app_methods: 31
  github_methods: 89
  google_drive_methods: 45
  finance_methods: 65
  consensus_methods: 2
  sites_methods: 23
  document_control_methods: 3
  node_repl_methods: 3

documents:
  markdown: true
  pdf: true
  docx: true
  xlsx: true
  csv: true
  pptx: true
  render_and_verify_workflows: true
  google_native_files: connector_exposed_auth_unknown

multimodal:
  image_understanding: true
  image_generation: true_via_separate_tool
  image_editing: true_via_separate_tool
  audio_understanding: false_in_current_turn
  video_understanding: false_in_current_turn
  ffmpeg_processing: true
  tesseract_cli: false

persistence:
  conversation: product_managed
  local_memory: supported_enablement_unknown
  local_filesystem: persistent_until_modified_or_deleted
  git_history: persistent_when_committed
  external_service_state: service_managed
  scheduled_tasks: true
  thread_heartbeats: true
  running_processes: process_lifetime

strengths:
  - difficult_multi_step_reasoning
  - coding_and_repository_work
  - research_synthesis
  - tool_orchestration
  - document_and_data_workflows
  - critical_and_adversarial_review
  - long_horizon_planning

limitations:
  - "Self-described strengths require external benchmarking"
  - "Current facts require live retrieval"
  - "Exact calculations require execution"
  - "Connector exposure does not prove authentication"
  - "Bundled statistical runtime lacks SciPy, statsmodels, and scikit-learn"
  - "Only three subagents can be active alongside the primary in this session"
  - "No general Gmail, calendar, or database connector is exposed"
  - "No native audio or video understanding is exposed in this turn"
  - "Novelty screening cannot guarantee universal novelty"
  - "Same-model verification may preserve correlated errors"

unknowns:
  - exact_serving_snapshot
  - effective_desktop_context_limit
  - current_context_occupancy
  - active_pro_mode_state
  - local_memory_enablement
  - connector_authentication_state
  - browser_control_liveness
  - computer_use_liveness
  - empirical_xhigh_quality_gain
  - empirical_optimal_worker_count

recommended_roles:
  - primary_reasoner
  - research_coordinator
  - coding_agent
  - data_analysis_lead
  - synthesis_agent
  - hostile_reviewer
  - evidence_verifier

required_benchmarks:
  - reasoning
  - xhigh_vs_other_efforts
  - research_coverage
  - citation_accuracy
  - novelty_discovery
  - statistics_and_causal_inference
  - coding_and_debugging
  - repository_comprehension
  - context_management
  - tool_selection
  - worker_topology
  - failure_recovery
```

---

# 43. RECOMMENDED ORCHESTRATOR CONFIGURATION

## Select Sol xhigh when

- Ambiguity, consequence, and interacting constraints justify additional reasoning.
- The task combines judgment with several tools or artifacts.
- Complex code or data work must be executed, diagnosed, and verified.
- Multiple evidence lanes require coherent synthesis.
- A high-value artifact needs an adversarial final review.

## Prefer another configuration when

- The task is high-volume, mechanical, and objectively gradable.
- Latency dominates and low/medium effort passes the evaluation.
- The bottleneck is a missing specialist database, modality, hardware resource, or credential.
- Deterministic code can solve the problem without a frontier model.
- Independent review requires a different model family.

## Suggested defaults

```yaml
model: gpt-5.6-sol
reasoning_effort: medium
upgrade_to_xhigh_when:
  - ambiguity_is_high
  - consequences_are_material
  - evidence_conflicts
  - multi_stage_tool_planning_is_required
  - final_hostile_review_is_requested
default_workers: 0
maximum_concurrent_workers_in_this_session: 3
default_verification:
  - execute_load_bearing_calculations
  - open_load_bearing_sources
  - run_tests_for_code_changes
  - preserve_provenance
default_external_mutation: require_explicit_scope
default_checkpoint: canonical_file_or_task_state
```

## Worker guidance

| Task | Workers |
| --- | ---: |
| Simple/routine | 0 |
| One large independent read | 1 |
| Deep research | 3 concurrently, additional lanes in waves |
| Evidence verification | 1–3 |
| Statistical analysis | 1–2 |
| Multi-module code | 2–3 isolated workers |
| Sequential debugging | 0–2 |
| Critical review | 2–3 independent axes |

## Mandatory independent verification

- Citations used to support consequential claims.
- Numbers that determine a decision.
- Statistical and causal conclusions.
- Security findings and fixes.
- Data migrations or operations with loss/downtime risk.
- External-facing publications.
- Irreversible external actions.

---

# 44. CONTINUAL EVALUATION LOOP

```text
classify task
→ predict best model/effort/tools/workers/verification
→ execute
→ score output blind
→ record latency, tokens, tool calls, worker cost
→ classify defects
→ compare prediction with outcome
→ update routing rules and this capability profile
```

Recommended task record:

```yaml
task_id:
timestamp:
task_family:
stakes: [low, medium, high, irreversible]
ambiguity: [low, medium, high]

prediction:
  model:
  effort:
  tools: []
  workers:
  verification: []
  expected_quality:
  expected_latency_seconds:
  expected_cost:

actual:
  model:
  effort:
  tools: []
  tool_calls:
  workers:
  worker_roles: []
  verification: []

outcome:
  rubric_version:
  quality_score:
  ground_truth_available:
  defects_found_pre_delivery:
  defects_found_post_delivery:
  latency_seconds:
  total_tokens:
  external_service_cost:
  quality_per_cost:

research_metrics:
  sources_opened:
  critical_claims:
  critical_claims_verified:
  unsupported_claims:
  contradictions_found:

error:
  class: [none, factual, citation, arithmetic, scope, incomplete,
          tool_selection, context_loss, over_parallelized,
          under_parallelized, capability_overclaim, authorization]
  severity: [cosmetic, material, invalidating]
  detected_by: [self, tool, worker, other_model, human, production]

routing_feedback:
  rule_id:
  prediction_confirmed:
  preferred_future_route:
```

Policy updates:

- Any unsupported critical citation hardens that task family to mandatory separate citation review.
- Declining quality-per-cost with more workers lowers the worker cap for that family.
- Repeated capability overclaims require editing this profile, not merely adding prompt warnings.
- Repeated connector/auth failures add a preflight health check.
- xhigh should be demoted where medium/high matches quality at lower latency or cost.
- A new tool or product release invalidates affected `[O]` inventory claims until reprobed.

---

# 45. FINAL SELF-AUDIT

| Audit question | Finding | Resolution |
| --- | --- | --- |
| Was the reference document copied? | No. Its engineering categories informed coverage, but prose, tables, claims, and environment analysis were rewritten for Sol. | Original organization and content used throughout |
| Are template claims about another provider present? | No operational claim from the reference was carried over as fact. | All live-environment claims were reprobed or marked unknown |
| Is model capability confused with product/tool capability? | Risk exists for image generation, Drive, GitHub, subagents, and automation. | Attribution-layer table and explicit provider columns added |
| Are API limits presented as desktop guarantees? | No. | API figures labelled documented; effective product limits unknown |
| Is xhigh presented as magical or always optimal? | No. | Costs, failure modes, and B18 comparison included |
| Are hidden reasoning details claimed? | No. | Only process architecture and decision criteria are described |
| Are connector endpoints treated as authenticated? | No. | Authentication consistently marked unknown |
| Are worker limits invented? | No. | Current four-slot harness cap reported; other environments unknown |
| Are unrun subagent experiments presented as observed behavior? | No. | Harness-contract claims distinguished from live execution |
| Are statistical packages overclaimed? | No. | Bundle imports were probed and missing libraries listed |
| Is current information sourced? | Yes. | Official OpenAI pages were searched and opened on the profile date |
| Are self-assessments externally validated? | No. | They remain `[S]` and have attached benchmark designs |
| Are destructive or external permissions overstated? | No. | Technical sandbox and user authorization are separated |
| Is novelty overclaimed? | No. | Profile limits output to screening, not universal clearance |
| Is there an empirical improvement path? | Yes. | Sections 38–44 define tests and telemetry |

### Residual uncertainties

1. The exact dated model deployment serving this task is not exposed.
2. Effective desktop context capacity and current occupancy are not exposed.
3. Pro-mode state is not reliably visible.
4. Connector authentication was intentionally not probed because it was unnecessary for document creation.
5. Local memory enablement remains unresolved.
6. Browser and Computer Use capabilities are installed but were not activated.
7. Worker recommendations are structural hypotheses, not measured optima.
8. Self-described strengths require evaluation on the orchestrator’s real workload.

---

## Appendix A — Reproducible probes used

The profile used read-only checks equivalent to:

```powershell
# Model and effort configuration (targeted fields only)
Select-String "$env:USERPROFILE\.codex\config.toml" `
  -Pattern '^\s*(model|model_reasoning_effort)\s*='

# OS and hardware
Get-CimInstance Win32_OperatingSystem
Get-CimInstance Win32_Processor
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

# Runtime availability
Get-Command git,python,node,pwsh,pandoc,ffmpeg,tesseract,java,gradle,adb `
  -ErrorAction SilentlyContinue
git --version
python --version
node --version

# Repository state
git rev-parse --is-inside-work-tree

# Bundled Python imports
python -c "import importlib.util as i; print({m: bool(i.find_spec(m)) for m in [
  'numpy','pandas','scipy','statsmodels','sklearn','matplotlib','seaborn',
  'openpyxl','xlsxwriter','docx','pptx','pypdf','pdfplumber','reportlab']})"
```

Tool-registry counts were produced from the callable tool metadata exposed to this session. Official model facts were checked against:

- [GPT-5.6 Sol model](https://developers.openai.com/api/docs/models/gpt-5.6-sol)
- [GPT-5.6 model guidance](https://developers.openai.com/api/docs/guides/latest-model)
- [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Codex long-running work](https://learn.chatgpt.com/docs/long-running-work)
- [Codex scheduled tasks](https://learn.chatgpt.com/docs/automations)
- [Codex memories](https://learn.chatgpt.com/docs/customization/memories)

---

*End of GPT-5.6 Sol xhigh operational profile.*
