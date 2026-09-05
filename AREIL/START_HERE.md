# START HERE: AREIL v0.2 (Antigravity Research Evidence & Integrity Layer)

Welcome to **AREIL v0.2**, the formal scientific integrity and evidence governance layer built specifically for **Google Antigravity** using **Gemini 3.8 Flash High**.

AREIL eliminates the primary vulnerability of LLMs in academic research—**hallucinated citations, unchecked contradictions, and fabricated statistical numbers**—by implementing an adversarial, ledger-gated execution pipeline.

---

## 1. Quick Start (5 Minutes)

To verify the installation and initialize your first research project:

```powershell
# 1. Run the comprehensive self-test suite (23 checks)
.\Test-AREIL.ps1

# 2. Initialize a new research project
.\Initialize-AREILProject.ps1 -ProjectName "MyPlantResearch"

# 3. View preflight status and installed packages
.\scripts\Invoke-AreilPreflight.ps1
```

---

## 2. Core Scientific Workflow

Every research inquiry in AREIL follows a strict 6-stage lifecycle:

```
[ Research Question ]
         │
         ▼
[ 1. Claim Decomposition ]  ──►  CLAIM_LEDGER.jsonl (Atomic, falsifiable claims)
         │
         ▼
[ 2. Evidence Retrieval ]   ──►  SOURCE_REGISTRY.jsonl & EVIDENCE_LEDGER.jsonl
         │                       (7 APIs: Crossref, Europe PMC, DataCite, etc.)
         ▼
[ 3. Contradiction Hunt ]   ──►  CONTRADICTION_LEDGER.jsonl (Biphasic kinetics, epistasis)
         │
         ▼
[ 4. Statistical Modeling ] ──►  R lme4/lmerTest/emmeans (RCBD, mixed models, ICC)
         │
         ▼
[ 5. Manuscript Binding ]   ──►  Verify-ManuscriptConsistency.py (Regex audit against results)
         │
         ▼
[ 6. Reproducible Render ]  ──►  Quarto -> HTML & DOCX + reproducibility_manifest.json
```

---

## 3. Directory Layout

```
AREIL/
├── .agents/                 # Specialized Antigravity subagent profiles
├── .venv/                   # Python virtual environment (60 locked scientific packages)
├── analysis/                # Data processing and statistics
├── audits/                  # Cryptographic SHA-256 reproducibility manifests
├── benchmarks/              # Empirical A/B evaluation suite and ground truth
├── corpora/                 # Evaluated document corpora and extracted texts
├── ledgers/                 # Formal evidence, claim, and contradiction ledgers
├── model-manuals/           # Portability synthesis (Gemini, Opus, GPT)
├── projects/                # Isolated research project workspaces
├── schemas/                 # JSON schema definitions for all ledgers
├── scripts/                 # Core automation and verification scripts
├── state/                   # Empirical findings, preflight manifests, and API logs
├── templates/               # Quarto templates, BIB files, and ledger templates
├── Install-AREIL.ps1        # Standard installation script
├── Test-AREIL.ps1           # Standard self-test runner
├── Initialize-AREILProject.ps1 # New project generator
├── Update-AREIL.ps1         # System sync and manifest validator
└── START_HERE.md            # This document
```

---

## 4. Key CLI Commands & Tools

| Script | Purpose | Example |
| :--- | :--- | :--- |
| `.\Test-AREIL.ps1` | Runs 23 automated self-tests across Python, R, Quarto, and APIs | `.\Test-AREIL.ps1` |
| `.\Initialize-AREILProject.ps1` | Scaffolds a new research project with ledgers and Quarto manuscript | `.\Initialize-AREILProject.ps1 -ProjectName "RiceDrought"` |
| `scripts\Audit-Citations.py` | Verifies DOIs against Crossref, DataCite, and checks errata | `python scripts\Audit-Citations.py --root .` |
| `scripts\Verify-ManuscriptConsistency.py` | Cross-checks manuscript numbers against executed JSON data | `python scripts\Verify-ManuscriptConsistency.py --manuscript manuscript\manuscript.qmd --results analysis\results` |
| `scripts\Create-ReproducibilityManifest.py` | Generates SHA-256 manifest of all project files | `python scripts\Create-ReproducibilityManifest.py --root .` |

---

## 5. Toolchain & Dependencies

* **Python:** 3.12+ in dedicated virtual environment (`.venv`).
* **R:** 4.6.1 ucrt with `lme4`, `lmerTest`, `emmeans`, `agricolae`, and Bioconductor (`DESeq2`, `limma`, `edgeR`, `GEOquery`).
* **Quarto & Pandoc:** Quarto 1.10.18 + Pandoc 3.10 for publication-grade Word (`.docx`) and HTML rendering.
* **Bibliographic APIs:** Crossref, DataCite, OpenCitations, Semantic Scholar, Unpaywall, Europe PMC, and OpenAlex.
* **Reference Management:** Zotero 10.0 + Better BibTeX 9.0 integration.

For full architectural details, see `AREIL_MASTER_SPECIFICATION.md`.
