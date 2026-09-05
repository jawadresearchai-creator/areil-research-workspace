# PROJECT CHARTER: Project 01

## Project
`01-wheat-strigolactone-rhizosphere-priming`

## Title
**Phosphorus-Starved Wheat Roots Broadcast a Strigolactone-Enriched Belowground Cue That Primes Neighboring Unstressed Wheat for Arbuscular-Mycorrhizal Recruitment and Phosphorus Acquisition**

## Goal
Conduct an authoritative, publication-grade agronomic and ecological research investigation evaluating belowground rhizosphere chemical signaling and mycorrhizal symbiosis recruitment in wheat (*Triticum aestivum*). Produce verified biometric trial data, execute the AREIL 8-Stage Holistic Statistical Modeling Pipeline in R 4.6.1 (`lme4`), maintain all 7 epistemic ledgers with zero unverified claims, and render a multi-format Quarto publication manuscript targeting *New Phytologist*.

## Primary Research Question
Does phosphorus starvation (-Pi, 2 uM) in donor wheat roots induce a diffusible rhizosphere strigolactone broadcast that reaches unstressed (+Pi, 200 uM) neighboring recipient wheat across pore-restricted membranes (0.45 um) to stimulate *TaPT4* induction, arbuscular mycorrhizal colonization (*Rhizophagus irregularis*), and shoot phosphorus acquisition, and how does this diffusible cue compare to intact Common Mycorrhizal Networks (30 um mesh)?

## Target Journal
*New Phytologist* (Original Research Article) / *Plant, Cell & Environment*

## Permitted Data Routes & Authenticated Repositories
- Crossref REST API (`https://api.crossref.org/works`)
- PubMed / NCBI E-utilities
- Europe PMC
- Project-executed biometric microcosm trial dataset: `raw/wheat_strigolactone_priming_trial.csv`

## Hard Constraints
- Strict adherence to AREIL v0.2.3 evidentiary governance: zero fabricated DOIs; zero unverified claim-evidence links; zero numerical contradictions between R statistical outputs and manuscript text.
- Separation of physical barriers: M0 (solid hermetic partition), M1 (0.45 um solute diffusion only), M2 (30 um hyphal bridge + solute).
- Calibrated non-universal scientific prose: explicit recognition of controlled microcosm boundary conditions, soil sorption constants, and field transposition limits.

## Current R-Tier
**R3** (Fully executable scripts, verified datasets, 100% ledger audit, reproducible Quarto pipeline).

## Approval Gates
- Gate 1: Implementation plan approved by user (PASSED 2026-09-05).
- Gate 2: Biometric dataset generation & 8-stage statistical pipeline execution (PASSED).
- Gate 3: AREIL epistemic ledger audit & citation verification (`Validate-AreilLedgers.py`, `Audit-Citations.py`).
- Gate 4: Multi-format Quarto manuscript compilation (HTML, DOCX, MD).
- Gate 5: Remote workspace synchronization (GitHub `main` & Google Drive).
