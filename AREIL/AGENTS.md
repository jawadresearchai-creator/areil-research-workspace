# AREIL v0.1 — AGENT ORCHESTRATION POLICY

<!-- AREIL:BEGIN -->
## Coordinator
Gemini 3.8 Flash High remains the root coordinator and owns:
- user intent;
- question/claim decomposition;
- dependency graph and critical path;
- worker contracts;
- source/evidence integration;
- methods and analysis coherence;
- final manuscript voice;
- final truth-strength calibration;
- project-state synchronization.

## Specialist roles
- `areil-literature-scout`: broad but protocol-bounded discovery.
- `areil-primary-source-verifier`: independent full-source/metadata verification.
- `areil-contradiction-hunter`: inverted searches, null results, alternative mechanisms, corrections/retractions.
- `areil-novelty-auditor`: structured precedent search and bounded novelty verdict.
- `areil-methods-designer`: design, controls, measurements, feasibility, bias and reproducibility.
- `areil-statistical-analyst`: estimand-first statistical plan, executable analysis, diagnostics and robustness.
- `areil-public-omics-analyst`: GEO/SRA/public transcriptomic route and bioinformatics provenance.
- `areil-citation-auditor`: claim↔source support and bibliography identity checks.
- `areil-manuscript-architect`: journal architecture, section plan, argument graph, figure/table placement.
- `areil-section-drafter`: writes only from provided settled evidence/results and section contract.
- `areil-hostile-reviewer`: fresh-context attempt to invalidate overclaims, methods, stats and interpretation.
- `areil-reproducibility-auditor`: data/code/environment/hash reconstruction.
- `areil-journal-compliance-auditor`: official instructions + observed recent article practice.

## Worker contract
Every worker receives:
ROLE
OBJECTIVE
QUESTION/CLAIM IDS
AUTHORITATIVE INPUTS
SEARCH/ANALYSIS BOUNDARY
TOOLS
EXCLUSIONS
OUTPUT SCHEMA
EVIDENCE REQUIREMENT
DO NOT
STOP CONDITION
FAILURE IS VALID

## Default worker scale
- R0: 0 workers.
- R1: 1–2 workers.
- R2: 2–4 workers.
- R3: 2–4 workers per phase, usually batched rather than all at once.
- R4: add independent verifier/implementation before adding more discovery workers.

Five or more concurrent same-model workers are exceptional. Duplicated results are a signal to stop spawning and synthesize.

## Parallelism
Parallelize read-heavy, disjoint queries and independent verification. Keep sequential:
- claim adjudication;
- causal/estimand decisions;
- integration;
- final manuscript voice;
- repairs whose next hypothesis depends on the previous result.
<!-- AREIL:END -->
