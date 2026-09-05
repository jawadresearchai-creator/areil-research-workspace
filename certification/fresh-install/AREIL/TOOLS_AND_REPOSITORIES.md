# TOOLS & REPOSITORIES TO ADD TO ANTIGRAVITY FOR RESEARCH

**Snapshot:** designed September 2026. Re-check current releases before installation.

AREIL separates three categories: already available in the supplied Antigravity profile, strongly recommended additions, and optional specialist stacks.

## A. Already present — use before installing duplicates

The supplied Antigravity manual reports Python 3.13, pip, Git, direct HTTPS, DuckDB, SciPy, persistent local storage, Graphify (user-confirmed), and a large scientific skill suite including PubMed, Europe PMC, OpenAlex, arXiv, bioRxiv, AlphaFold/PDB, Ensembl/GTEx, ClinVar, STRING, JASPAR, ChEMBL/PubChem, and ClinicalTrials routes. AREIL should **probe these live** each session/project and route to them when appropriate.

## B. Highest-priority additions

### 1. Zotero + Better BibTeX — canonical human-readable reference library
**Why:** stable bibliography management, PDF attachments, citation keys, local/Web API, auto-export to BibTeX/CSL JSON. Do not let the model own bibliography identity in prose.

Install:
- Zotero desktop.
- Better BibTeX extension for Zotero.
- Optional Python client: `pyzotero`.

AREIL use:
- Zotero = reference-library authority.
- Better BibTeX = stable citation-key/export bridge.
- Local Zotero API when desktop is running.

### 2. Quarto + Pandoc
**Why:** reproducible manuscripts where computations, figures, tables, cross-references and citations can be generated from source. Quarto can emit journal-oriented Word/LaTeX/HTML outputs; Pandoc provides robust conversion and citeproc.

Use manuscript source in `.qmd`/Markdown where practical, then produce DOCX/PDF for submission.

### 3. R + renv
**Why:** scientific statistics, mixed models, estimated marginal means, meta-analysis, experimental designs, and a huge publication ecosystem. `renv` freezes R dependencies per project.

Core R packages to consider:
`data.table`, `tidyverse`, `readxl`, `janitor`, `broom`, `lme4`, `nlme`, `emmeans`, `multcomp`, `car`, `sandwich`, `lmtest`, `effectsize`, `performance`, `parameters`, `metafor`, `clubSandwich`, `mice`, `patchwork`, `ggplot2`.

Plant/agronomy additions when needed:
`agricolae`, `lmerTest`, `vegan`, `FactoMineR`, `factoextra`.

### 4. Crossref REST + Retraction Watch integration
**Why:** DOI metadata identity, references, ORCID/ROR/funding metadata, post-publication updates, corrections and retractions. No model should guess DOI metadata.

AREIL includes `scripts/Audit-Citations.py` using Crossref public API.

### 5. DataCite REST
**Why:** DOI metadata for datasets/software and research objects not necessarily covered by Crossref. Useful for dataset provenance and data citation.

### 6. OpenCitations
**Why:** independent citation/reference graph route. Use it for forward/backward citation expansion and cross-checking citation relationships.

### 7. Semantic Scholar Academic Graph API
**Why:** broad scholarly discovery, citations/references, related-paper recommendations and SPECTER2-linked metadata. Use as complementary discovery, not sole authority.

### 8. Unpaywall API
**Why:** programmatically locate legal open-access versions for DOI-identified papers so the verifier can inspect fuller evidence rather than relying on snippets/abstracts.

## C. Strong local document-extraction additions

### GROBID
**Why:** turns scholarly PDFs into structured TEI XML including header, references, sections and citation markers. Very useful for a local paper corpus and evidence extraction.

**Caveat:** heavier Java/Docker service; optional on a 16 GB laptop. Prefer Docker/WSL and run only when needed. Keep the original PDF as authority.

### PyMuPDF + pypdf + pdfplumber
Use complementary PDF parsers. No single parser is reliable for every table, layout or scan.

### OCR
Install Tesseract plus required language packs only for scanned PDFs/images. OCR output must be labeled extracted text and visually spot-checked for important claims/numbers.

## D. Data-analysis additions

Python environment per project via `uv` or `venv`:

```text
numpy pandas scipy statsmodels scikit-learn matplotlib
polars pyarrow duckdb openpyxl xlsxwriter
pandera pydantic jupyterlab ipykernel
networkx sympy
```

Recommended reasoning aids:
- `statsmodels` for statistical models/diagnostics.
- `pandera` for data-schema assertions.
- `polars` + `pyarrow` + DuckDB for larger tabular data.
- `sympy` for symbolic checks.

Avoid adding libraries just because they exist. Every package increases reproducibility and environment burden.

## E. Public omics / gene-expression stack (optional, high value for your research)

### Windows-accessible core
- NCBI SRA Toolkit (`prefetch`, `fasterq-dump`).
- NCBI Entrez Direct where practical.
- R/Bioconductor.

Bioconductor packages:
- `GEOquery`
- `limma`
- `edgeR`
- `DESeq2`
- `SummarizedExperiment`
- `Biobase`
- `AnnotationDbi`
- organism/platform annotation packages as required
- `sva` for batch/confounding work when justified
- `fgsea` / `clusterProfiler` only when enrichment is actually part of the question

### Strong recommendation for heavier bioinformatics
Install **WSL2 Ubuntu** and let Antigravity call `wsl` for Linux-native tools. Candidate tools when the project requires them:
- `fastp`
- `FastQC`
- `MultiQC`
- `Salmon` or `kallisto`
- `STAR` (only when alignment is necessary and RAM permits)
- `samtools`
- `bedtools`
- `pigz`
- `aria2`

Do not install a full RNA-seq pipeline for a microarray-only paper. Route by actual dataset technology.

## F. Reproducibility / workflow tools

### Core
- Git for local scripts/manuscript source history.
- `renv` for R dependency lock.
- `uv.lock` / `requirements.lock` for Python.
- AREIL SHA-256 reproducibility manifest for raw data and outputs.

### Optional
- Snakemake for multi-stage computational pipelines.
- DVC when datasets are large enough that explicit data-version tracking materially helps.
- Docker Desktop / Podman for reproducible services such as GROBID.

## G. Identifier & metadata routes

Add API clients/adapters only when useful:
- ROR API — disambiguate institutions.
- ORCID public API — researcher identity when relevant.
- Crossref — scholarly DOI metadata.
- DataCite — dataset/software DOI metadata.

## H. Things NOT to treat as ground truth

- Graphify inferred edges.
- Google Scholar snippets.
- AI-generated summaries.
- citation counts as study quality.
- journal impact factor as evidence quality.
- preprints as equivalent to peer-reviewed results.
- a DOI resolver hit as proof that a claim is supported.

## I. Recommended installation order

1. Keep/use existing Antigravity science plugins + Graphify.
2. Zotero + Better BibTeX.
3. Quarto + Pandoc.
4. R + `renv` + core statistical packages.
5. Python project environment additions (`statsmodels`, `polars`, `pyarrow`, `pandera`, Jupyter).
6. Crossref/DataCite/OpenCitations/Semantic Scholar/Unpaywall adapters (mostly API, no heavy install).
7. GROBID only if you routinely ingest many PDFs.
8. WSL2 + SRA/Bioconductor/bioinformatics tools if public-omics work becomes routine.
9. Snakemake/DVC/containerization only when pipeline complexity justifies them.
