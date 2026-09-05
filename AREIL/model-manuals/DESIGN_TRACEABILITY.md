# AREIL ARCHITECTURAL DESIGN TRACEABILITY MATRIX

This matrix traces every major AREIL rule, workflow, and script back to its source operational manuals and architectural origins.

| AREIL Mechanism / Rule | Source Manual(s) | Original Pattern | Antigravity Native Capability | ALEIL v1.1 Origin | Measurable Validation Metric |
|---|---|---|---|---|---|
| **Persistent Project State** (`PROJECT_STATE.yaml`, `HANDOFF.yaml`) | GPT-5.6 Sol xhigh, Claude Opus 5 | Long-horizon state handoff / context management | Windows NTFS Filesystem (`E:\...`) | `CURRENT_STATE.md`, `HANDOFF.yaml` | Session resumption test without context loss |
| **Claim-Sized Decomposition** (`CLAIM_LEDGER.jsonl`) | GPT-5.6 Sol xhigh, Claude Opus 5 | Granular claim isolation & falsifiability | Structured JSON Lines + native schemas | Task decomposition / backlog | Zero claims containing >1 independent causal hypothesis |
| **Source & Evidence Ledgers** (`SOURCE_REGISTRY`, `EVIDENCE_LEDGER`) | Claude Opus 5, GPT-5.6 Sol xhigh | Primary source retrieval vs claim support | Antigravity Science Skills (PubMed, Europe PMC, etc.) | Verification gates | 100% of load-bearing claims backed by retrieved sources |
| **Dedicated Contradiction Worker** (`areil-contradiction-hunter`) | Claude Opus 5 Max, GPT-5.6 Sol | First-class inverted/disconfirming search | Native Subagents (`invoke_subagent`, `self`) | Hostile Reviewer | Contradiction coverage ratio (>0 on controversial claims) |
| **Bounded Novelty Calibration** (`NOVELTY_LEDGER.jsonl`) | Claude Opus 5, GPT-5.6 Sol | Absence of evidence != evidence of absence | Scholarly APIs + multi-database queries | Empirical routing | Zero instances of absolute novelty overclaiming |
| **Estimand-Driven Statistics** (`analysis/scripts/`) | GPT-5.6 Sol xhigh, Claude Opus 5 | Executable computation > prose arithmetic | Python 3.13 (`scipy`, `statsmodels`), R 4.x | Automated build/test execution | Script output vs manuscript numerical match = 100% |
| **Deterministic Citation Audit** (`Audit-Citations.py`) | GPT-5.6 Sol xhigh, Claude Opus 5 | Verification budget before breadth | Direct HTTPS + Crossref REST API | Test engineer / CI gate | Zero hallucinated DOIs; retraction status flagged |
| **Blind Hostile Peer Review** (`areil-hostile-reviewer`) | Claude Opus 5 Max, GPT-5.6 Sol | Independent critic mode / zero sycophancy | Subagent role isolation | Hostile diff reviewer | Pre-submission fatal defect identification rate |
| **Graphify Grounding Boundary** (`Invoke-AreilGraphify.ps1`) | Antigravity Gemini 3.8 Manual | Graph is navigation, never ground truth | Graphify CLI (`graphify.exe`) | Repo knowledge graph | Edge-to-source verified precision >= 90% |
| **Reproducibility Manifest** (`Create-ReproducibilityManifest.py`) | GPT-5.6 Sol xhigh, ALEIL v1.1 | Cryptographic audit of all project assets | Python `hashlib` (SHA-256) | Build artifact hashing | 100% of pipeline artifacts hashed and verifiable |
| **Stage-Gated Acceptance** (`Validate-AreilLedgers.py`) | GPT-5.6 Sol xhigh, ALEIL v1.1 | Explicit gating criteria before drafting | Python JSON schema validation | Release gates | Zero unresolved schema errors at manuscript freeze |
