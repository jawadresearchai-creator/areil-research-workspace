# AREIL PORTABILITY SYNTHESIS: MODEL-INDEPENDENT EXECUTION PATTERNS

This synthesis codifies operational patterns extracted from high-effort frontier systems (GPT-5.6 Sol Extra High, Claude Opus 5 Max, and Google Antigravity Gemini 3.8 Flash High). AREIL externalizes these capabilities into durable files, explicit ledgers, deterministic tools, and specialist subagent workflows to compensate for the context retention and reasoning limitations of Gemini 3.8 Flash High.

---

## 1. CORE ARCHITECTURAL COMPARISON & MAPPING

| Dimension | GPT-5.6 Sol (xhigh) | Claude Opus 5 (max) | Gemini 3.8 Flash High (Native) | AREIL Compensatory Architecture |
|---|---|---|---|---|
| **Context Retention** | Heavy internal working memory across turns | Long-context buffer with deep semantic recall | 1M window but fast decay on fine details | Canonical files (`CURRENT_STATE.md`, `HANDOFF.yaml`) on local disk |
| **Claim Precision** | Self-checking claim boundaries | Disciplined claim scoping to fetched text | Tendency to synthesize plausibly sounding prose | Structured `CLAIM_LEDGER.jsonl` with strict state transitions |
| **Contradiction Detection** | Spontaneous inverted hypothesis testing | First-class contradictory evidence checks | Confirmatory bias toward user premise | Dedicated `areil-contradiction-hunter` agent + disconfirming query protocol |
| **Citation Rigor** | Checks metadata against internal index | Demands fetched primary evidence for claims | Hallucinates plausible citations/DOIs | Crossref REST + Retraction Watch + local PDF verification |
| **Statistical Execution** | Structured estimand definition | Code-driven arithmetic validation | Plausible prose math without verification | Executable R / Python scripts; values frozen before manuscript drafting |
| **Adversarial Review** | Strong critical self-correction | Explicit adversarial review posture | Sycophantic agreement with preliminary draft | Blind `areil-hostile-reviewer` simulating hostile peer review |

---

## 2. DETAILED TRANSFERABLE PATTERN CATALOG

### Pattern 1: Claim-Sized Research Decomposition
- **Source Manual(s)**: GPT-5.6 Sol xhigh, Claude Opus 5 Max.
- **Original Context**: Handling sprawling, multi-component research questions where simultaneous synthesis causes loss of granular causality and source confusion.
- **Transferable Principle**: Deconstruct every major research question into atomic, falsifiable claim units before executing search or literature retrieval.
- **Antigravity Implementation**: Research coordinator breaks prompt into discrete claims; each claim receives a distinct ID (`CLM-001`, `CLM-002`).
- **AREIL Component**: `templates/RESEARCH_QUESTION.md`, `schemas/claim.schema.json`, `ledgers/CLAIM_LEDGER.jsonl`.
- **Verification Method**: `Validate-AreilLedgers.py` asserts that all load-bearing claims are registered and mapped.
- **Limitations**: Increases decomposition overhead on simple questions.

### Pattern 2: Independent Contradiction & Null-Result Search
- **Source Manual(s)**: Claude Opus 5 Max (`CLAUDE_OPUS5_MAX_OPERATING_MANUAL.md`), GPT-5.6 Sol xhigh.
- **Original Context**: Overcoming confirmation bias where literature search only queries supporting mechanisms.
- **Transferable Principle**: For every positive hypothesis, execute explicit queries for negative results, failed replications, alternative mechanisms, and retractions.
- **Antigravity Implementation**: An isolated subagent (`areil-contradiction-hunter`) is spawned with an inverted query mandate.
- **AREIL Component**: `workflows/literature-review.md`, `.agents/agents/areil-contradiction-hunter/agent.md`, `ledgers/CONTRADICTION_LEDGER.jsonl`.
- **Verification Method**: Hostile review checks whether disconfirming evidence exists in the literature for all `approved` claims.
- **Limitations**: Negative results are notoriously under-reported in published literature (publication bias).

### Pattern 3: Fresh Blind Adversarial (Hostile) Review
- **Source Manual(s)**: Claude Opus 5 Max, GPT-5.6 Sol xhigh.
- **Original Context**: Models evaluating their own generated manuscripts suffer from high self-consistency bias and overlook gaps in causal logic.
- **Transferable Principle**: Instantiate a separate reviewer role instructed to assume the manuscript is fatally flawed and search for rejection-worthy defects.
- **Antigravity Implementation**: Run `areil-hostile-reviewer` in a sanitized subagent context without access to intermediate coordinator reasoning.
- **AREIL Component**: `.agents/agents/areil-hostile-reviewer/agent.md`, `workflows/hostile-review.md`, `reviews/hostile_review.md`.
- **Verification Method**: Review findings scored on a 4-point severity ladder (Fatal, Major, Minor, Informational); fatal/major require mandatory resolution.
- **Limitations**: Can flag pedantic or out-of-scope issues if journal constraints are not clearly defined.

### Pattern 4: Externalized Long-Horizon Project State & Handoff
- **Source Manual(s)**: GPT-5.6 Sol xhigh (`HANDOFF.yaml` / persistent state), Claude Opus 5 Max.
- **Original Context**: Long-running research spans multiple sessions or agent contexts; conversation memory compresses or resets.
- **Transferable Principle**: State must live in the filesystem as structured YAML/Markdown, not in ephemeral conversation tokens.
- **Antigravity Implementation**: Write `PROJECT_STATE.yaml` and `CURRENT_HANDOFF.yaml` to the project directory after every stage transition.
- **AREIL Component**: `research/CURRENT_STATE.md`, `research/HANDOFF.yaml`, `templates/HANDOFF.yaml`.
- **Verification Method**: Session reconstruction test: initialize a blank context and resume the workflow purely from `CURRENT_HANDOFF.yaml`.
- **Limitations**: Requires disciplined discipline to update state files at each stage.

### Pattern 5: Claims Frozen Before Citation Verification
- **Source Manual(s)**: GPT-5.6 Sol xhigh, Claude Opus 5 Max.
- **Original Context**: Models modify claims on the fly to match whatever vague snippet they locate, eroding precision.
- **Transferable Principle**: Freeze the intended claim statement and its required evidence thresholds before assigning citations.
- **Antigravity Implementation**: Claims in `CLAIM_LEDGER.jsonl` are set to `drafted` -> `frozen` before `Audit-Citations.py` and verifier run.
- **AREIL Component**: `ledgers/CLAIM_LEDGER.jsonl`, `scripts/Audit-Citations.py`, `scripts/Validate-AreilLedgers.py`.
- **Verification Method**: Script verifies that no claim text changes occur during citation resolution without status being reset to `re-evaluating`.
- **Limitations**: May require backtracking if the literature fundamentally disproves an essential premise.

### Pattern 6: Separation of Discovery Search vs. Full-Source Evidence Verification
- **Source Manual(s)**: Claude Opus 5 Max, GPT-5.6 Sol xhigh.
- **Original Context**: Search engine snippets and abstracts frequently overstate conclusions or omit crucial experimental limitations.
- **Transferable Principle**: Treat search engine and database hits strictly as candidate discovery; load-bearing evidence requires retrieving and inspecting the full primary text or data.
- **Antigravity Implementation**: `areil-literature-scout` queries APIs/search and registers candidate DOIs in `SOURCE_REGISTRY.jsonl`; `areil-source-verifier` fetches full texts/PDFs and extracts granular quantitative findings into `EVIDENCE_LEDGER.jsonl`.
- **AREIL Component**: `.agents/agents/areil-literature-scout/agent.md`, `.agents/agents/areil-source-verifier/agent.md`, `ledgers/SOURCE_REGISTRY.jsonl`, `ledgers/EVIDENCE_LEDGER.jsonl`.
- **Verification Method**: Audit script checks that all `approved` claims link to evidence with explicit `source_location` (page, figure, table).
- **Limitations**: Paywalls or closed-access papers may prevent full-text retrieval, requiring fallback to open-access preprints or explicit limitation tagging.

### Pattern 7: Independent Worker Fan-Out Strictly on Disjoint Tasks
- **Source Manual(s)**: GPT-5.6 Sol xhigh, Claude Opus 5 Max.
- **Original Context**: Spawning multiple agents on interdependent writing tasks results in contradictory claims, stylistic dissonance, and race conditions.
- **Transferable Principle**: Parallelize only independent read-only discovery routes or partitioned verification; maintain single-thread synthesis for drafting.
- **Antigravity Implementation**: Coordinator uses native subagents (`invoke_subagent`) only for separate literature families, distinct database queries, or independent verification tasks.
- **AREIL Component**: `AGENTS.md`, `workflows/write-manuscript.md`, coordinator orchestration rules.
- **Verification Method**: Telemetry logs (`TASK_TELEMETRY.jsonl`) record worker assignments and confirm zero concurrent writes to ledgers.
- **Limitations**: Sequential drafting takes longer than naive parallel generation.

### Pattern 8: Executable Arithmetic & Statistical Modeling (Estimand-First)
- **Source Manual(s)**: GPT-5.6 Sol xhigh, Claude Opus 5 Max.
- **Original Context**: LLMs frequently fail at mental arithmetic, ANOVA degrees of freedom, mixed-model standard errors, and p-value corrections.
- **Transferable Principle**: Never compute or adjust statistics in prose. Define the estimand, run executable R/Python code, save output objects, and inject exact numbers into the manuscript.
- **Antigravity Implementation**: Analysis scripts in `analysis/scripts/` execute via Python (`scipy`, `statsmodels`) or R (`lme4`, `emmeans`), writing JSON/CSV results to `analysis/results/`.
- **AREIL Component**: `profiles/plant-science.md`, `templates/ANALYSIS_PLAN.md`, `scripts/Verify-ManuscriptConsistency.py`.
- **Verification Method**: Script checks that every quantitative figure/p-value in the manuscript matches executed output objects within tolerance.
- **Limitations**: Requires clean, structured tabular data input.

### Pattern 9: Acceptance Criteria Instead of Prose Completion
- **Source Manual(s)**: GPT-5.6 Sol xhigh, ALEIL v1.1.
- **Original Context**: Models declare a stage "finished" when they generate a summary paragraph, regardless of missing controls or unresolved contradictions.
- **Transferable Principle**: Stage transitions are gated by explicit, deterministic acceptance criteria (e.g., all claim statuses resolved, citation audit zero failures, hash manifest created).
- **Antigravity Implementation**: Stage gate scripts validate schemas and exit non-zero if requirements are unmet.
- **AREIL Component**: `scripts/Validate-AreilLedgers.py`, `scripts/Invoke-AreilSelfTest.ps1`, `workflows/submission-readiness.md`.
- **Verification Method**: Pre-submission gate enforces zero unresolved fatal errors.
- **Limitations**: Strict gating can slow rapid iterative drafting if criteria are overly rigid.

### Pattern 10: Novelty as a Coverage-Bounded Screening Problem
- **Source Manual(s)**: Claude Opus 5 Max, GPT-5.6 Sol xhigh.
- **Original Context**: LLMs declare an idea "novel" simply because it does not match a top-3 search hit.
- **Transferable Principle**: Novelty is never an ontological absence; it is strictly bounded by the query space, databases consulted, and terminology variations explored.
- **Antigravity Implementation**: Novelty ledger requires recording explicit search terms, mesh headings, taxonomy scope, and negative hit logs across at least 3 databases.
- **AREIL Component**: `ledgers/NOVELTY_LEDGER.jsonl`, `workflows/novelty-assessment.md`, `.agents/agents/areil-novelty-auditor/agent.md`.
- **Verification Method**: Auditor checks that manuscript claims say "To our knowledge and within the scope of [searched databases]..." rather than unbounded "This has never been studied."
- **Limitations**: Cannot prove absolute novelty across non-indexed literature, grey literature, or private industry work.

### Pattern 11: Graphify and Extraction Tools as Navigation, Never Truth
- **Source Manual(s)**: Antigravity Operating Manual, GPT-5.6 Sol xhigh.
- **Original Context**: Relying on knowledge graph edges or OCR text as authoritative fact introduces hallucination and compounding extraction errors.
- **Transferable Principle**: Graph edges and OCR representations are navigational clues that point to primary sources. The primary source document remains the sole ground truth.
- **Antigravity Implementation**: Graphify corpus queries generate candidate relationships, but every relationship must be resolved to a specific page/paragraph in the source PDF before entering evidence ledgers.
- **AREIL Component**: `scripts/Invoke-AreilGraphify.ps1`, `skills/graphify-corpus/`, evidence validation protocols.
- **Verification Method**: Empirical source resolution testing measuring edge-to-source precision.
- **Limitations**: Ingestion and graph building incur initial compute overhead.
