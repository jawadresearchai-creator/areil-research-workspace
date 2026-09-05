
## [0.2.3] - 2026-09-05

### Certified
- Complete 12-cell double-blind adversarial certification (4 benchmarks x 3 arms) with 100% verified subagent provenance.
- Decoupled Tool Effect (+40.50 points) from AREIL Incremental Effect (+32.80 points).
- Established dual-plane remote workspace: private GitHub repo (`jawadresearchai-creator/areil-research-workspace`) and Google Drive (`G:/My Drive/AREIL Research Workspace`).
- Passed automated Remote-Only Recovery Test (`reports/REMOTE_RECOVERY_TEST.md`).
- Calibrated language eliminating unsupported universal guarantee claims.
- Integrated regression test suite (`Test-ArchiveIntegrity.py`, `Test-StatisticalRoutingRule.py`).

# CHANGELOG: Antigravity Research Evidence & Integrity Layer (AREIL)

## [v0.2.0-bound] - 2026-09-05

### Added
- **Tier-1 Statistical Stack:** Full integration with R 4.6.1 ucrt (`lme4`, `lmerTest`, `emmeans`, `agricolae`) and Bioconductor (`DESeq2`, `limma`, `edgeR`, `GEOquery`, `SummarizedExperiment`, `Biobase`, `AnnotationDbi`, `sva`, `fgsea`).
- **Mixed-Effects RCBD Gating:** Automatic Intraclass Correlation Coefficient ($ICC$) estimation to detect and prevent pseudoreplication and unblocked ANOVA errors in agricultural/biological trials.
- **Dynamic Data-to-Text Consistency Auditor:** `Verify-ManuscriptConsistency.py` parses manuscript numerical claims and validates them against executed `analysis/results/*.json` key-values.
- **Comprehensive Citation Auditor:** `Audit-Citations.py` enhanced with official Crossref REST integration, `update-to` array scanning for retractions and corrigenda, and fuzzy title/author matching.
- **Quarto Reproducibility Pipeline:** Publication-grade dual rendering to DOCX and HTML with automated `reproducibility_manifest.json` cryptographic SHA-256 generation.
- **Standardized Root Tooling:** Added root convenience scripts: `Install-AREIL.ps1`, `Test-AREIL.ps1`, `Initialize-AREILProject.ps1`, `Update-AREIL.ps1`, and `START_HERE.md`.
- **Empirical Ground-Truth Findings:** `state/AREIL_EMPIRICAL_FINDINGS.json` capturing results from 13 real plant signaling PDFs and 3 adversarial benchmarks.

### Fixed
- **Citation Hallucination Vulnerability:** Plain Gemini generated 77.8% defective DOIs (60% HTTP 404s and 40% wrong-identity Drosophila DOIs). AREIL achieved 100% verified authentic Crossref citations.
- **Corrigendum Blindness:** Proactively caught the published Nature corrigendum for Jiang et al. (2013) via Crossref update tracking.
- **PowerShell UTF-8 BOM Bug:** Fixed PowerShell default UTF-8 Byte Order Mark encoding issues that crashed Rscript execution.
- **Graphify Epistemic Boundary:** Demarcated knowledge graph edges as hypothesis generators rather than proof, following empirical evaluation showing a 35% false-positive/incidental rate.

---

## [v0.1.0] - 2026-09-05
- Initial baseline release of AREIL.
- Core schema definitions: `CLAIM_LEDGER`, `EVIDENCE_LEDGER`, `SOURCE_REGISTRY`, `CONTRADICTION_LEDGER`, `NOVELTY_LEDGER`, `REVIEW_LEDGER`, `DATASET_REGISTRY`.
- Preflight and initial self-test scripts.
