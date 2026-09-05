# AREIL Project 01: Wheat Rhizosphere Strigolactone Priming

**Full Title:** Phosphorus-Starved Wheat Roots Broadcast a Strigolactone-Enriched Belowground Cue That Primes Neighboring Unstressed Wheat for Arbuscular-Mycorrhizal Recruitment and Phosphorus Acquisition  
**System:** *Triticum aestivum* (cv. Bobwhite WT vs. *Tad14* mutant) + *Rhizophagus irregularis*  
**Framework:** AREIL v0.2.3 (`REAL_RESEARCH_USE`)  
**Status:** COMPLETE (Analysis executed, Ledgers validated, Manuscript compiled)

## Directory Structure
- `PROJECT_CHARTER.md`: Foundational project governance.
- `RESEARCH_QUESTION.md`: PICO scientific specification.
- `SEARCH_PROTOCOL.md`: Crossref/PubMed retrieval protocol.
- `ANALYSIS_PLAN.md`: 8-Stage Holistic Statistical Modeling Pipeline.
- `JOURNAL_PROFILE.md`: *New Phytologist* formatting constraints.
- `MANUSCRIPT_PLAN.md`: Conceptual argument graph and section contracts.
- `raw/`: Biometric microcosm trial data (`wheat_strigolactone_priming_trial.csv`, N=432).
- `derived/`: Aggregated treatment summary tables.
- `analysis/`: Executable R script (`scripts/run_wheat_priming_lmm.R`) and exported JSON results (`results/priming_lmm_results.json`).
- `ledgers/`: All 7 canonical AREIL epistemic ledgers.
- `audits/`: Citation audit and SHA-256 reproducibility manifest.
- `manuscript/`: Master Quarto source (`manuscript.qmd`), BibTeX bibliography (`references.bib`), compiled formats (HTML, DOCX, MD), and publication figures.
