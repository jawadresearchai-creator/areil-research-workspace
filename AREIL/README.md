# AREIL v0.1 — Antigravity Research Evidence & Integrity Layer

AREIL is a **local research-control and manuscript-development layer for Google Antigravity running Gemini 3.8 Flash High**. It does not make Gemini become GPT-5.6 Sol or Claude Opus. It imports **portable execution patterns** from the supplied GPT/Claude/Antigravity operating manuals and turns them into persistent research state, specialist workers, explicit verification gates, scripts, and evidence contracts.

## Goal

Make a weaker fast model useful for difficult research by moving complexity out of one model turn and into a governed system:

```text
USER QUESTION / PAPER GOAL
        ↓
AREIL coordinator
        ↓
question decomposition + protocol + acceptance criteria
        ↓
parallel discovery workers (bounded, disjoint)
        ↓
primary-source retrieval + source registry
        ↓
claim-sized evidence extraction
        ↓
contradiction / null / retraction search
        ↓
claim ledger + evidence ledger + uncertainty
        ↓
methods / data / statistics / omics analysis
        ↓
figures & tables generated from authoritative results
        ↓
manuscript architecture → drafting
        ↓
independent citation audit + hostile peer review
        ↓
journal compliance + reproducibility audit
        ↓
submission-ready package
```

## Non-negotiable design principles

1. **The source is authoritative, not Gemini's recollection.** Search results and Graphify nodes are discovery/navigation aids only.
2. **A snippet is not evidence.** Load-bearing claims require an opened/fetched primary or authoritative source and a support location.
3. **No fabricated bibliographic details, quotations, datasets, sample sizes, results, p-values, DOIs, or methods.** Unknown stays unknown.
4. **Novelty is bounded by search coverage.** "Not found" never means "proven novel."
5. **Contradiction search is mandatory.** Search negative results, alternative mechanisms, failed replications, corrections, expressions of concern, and retractions.
6. **Analysis is executable.** Numbers reported in prose/figures/tables must come from saved result objects/scripts where feasible.
7. **One coordinator owns synthesis and voice.** Workers gather, verify, analyze, or critique; they do not independently redefine the paper.
8. **Persistent files beat context memory.** A fresh Antigravity conversation must be able to reconstruct the project from the project folder.
9. **Verification gets reserved budget.** Breadth is reduced before verification is sacrificed.
10. **Same-model subagents are process separation, not independent truth.** Independent source retrieval and executable checks remain decisive.

## Install

Use a dedicated research workspace (recommended), not an existing AppFusion/ALEIL application workspace.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\INSTALL_AREIL.ps1 -Workspace "E:\Research\MyProject"
```

Then open the installed workspace in Antigravity and paste `FIRST_RUN_PROMPT.md`.

## First project

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\New-AreilProject.ps1 -ProjectName "wheat-eatp"
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Invoke-AreilPreflight.ps1
```

## Graphify

AREIL assumes Graphify may already be installed. It uses Graphify for corpus structure, concept relationships, and navigation—not for scientific truth.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Invoke-AreilGraphify.ps1
```

Every important graph-derived path must be resolved back to the original file/source before it enters the evidence ledger.

## Recommended research stack

See `TOOLS_AND_REPOSITORIES.md`. AREIL can function with Antigravity's current scientific plugins plus Python, but its strongest local configuration adds Zotero/Better BibTeX, Quarto/Pandoc, Crossref/DataCite/OpenCitations/Unpaywall/Semantic Scholar routes, optional GROBID, R/Bioconductor, and an optional WSL2 bioinformatics toolchain.
