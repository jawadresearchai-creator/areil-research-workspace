# AREIL PREFLIGHT & ENVIRONMENT VERIFICATION REPORT

**Report Date:** 2026-09-05 10:52:21 UTC  
**Target Environment:** Windows 11 Pro / Google Antigravity / Gemini 3.8 Flash High  
**Research Root:** E:\Agriculture\Antigravity Research\  
**Installation Status:** FULLY DEPLOYED & HARDENED

---

## 1. Executive Summary

AREIL v0.1 has been installed, configured, hardened, and verified against the live environment.
All Tier-1 tools, the Python scientific virtual environment, the R / Bioconductor omics stack, Quarto manuscript rendering pipeline, and 7 scholarly APIs have been end-to-end verified.

---

## 2. Host System Specifications

- **Operating System:** Windows 11 Pro (Build 22631)
- **Processor:** Intel Core i5-8365U @ 1.60GHz (4 Cores / 8 Threads)
- **Memory:** 15.79 GB Physical RAM (~4.2 GB Free)
- **Disk Storage:** E: (62.08 GB Free)
- **Orchestration Agent:** Google Antigravity 2.0 (Gemini 3.8 Flash High)

---

## 3. Tier-1 Toolchain Status

| Tool | Purpose | Version | Path | Status |
|---|---|---|---|---|
| **Python** | Analysis, Ledgers, APIs | 3.13.1 | E:\Agriculture\Antigravity Research\AREIL\.venv\Scripts\python.exe | **END_TO_END_TESTED** |
| **uv** | Fast Dependency Manager | 0.12.9 | C:\Users\ThinkPad\AppData\Local\Programs\Python\Python313\Scripts\uv.exe | **END_TO_END_TESTED** |
| **R** | Statistical & Omics Engine | 4.6.1 (ucrt) | C:\Program Files\R\R-4.6.1\bin\R.exe | **END_TO_END_TESTED** |
| **Rscript** | Executable R CLI | 4.6.1 (ucrt) | C:\Program Files\R\R-4.6.1\bin\Rscript.exe | **END_TO_END_TESTED** |
| **Quarto** | Reproducible Manuscript CLI | 1.10.18 | C:\Program Files\Quarto\bin\quarto.exe | **END_TO_END_TESTED** |
| **Pandoc** | Universal Document Converter | 3.10 | C:\Program Files\Quarto\bin\tools\pandoc.exe | **END_TO_END_TESTED** |
| **Graphify** | Corpus Knowledge Graph | 0.9.53 | C:\Users\ThinkPad\.local\bin\graphify.exe | **END_TO_END_TESTED** |
| **Zotero** | Canonical Reference Library | 10.0.1 | C:\Program Files\Zotero\zotero.exe | **END_TO_END_TESTED** |
| **Better BibTeX** | Citekey & BibTeX Bridge | 9.0.63 | ...\yp9w6lfm.default\extensions\better-bibtex@iris-advies.com.xpi | **END_TO_END_TESTED** |
| **Java (OpenJDK)**| Scholarly JVM Support | 17.0.20.8 | C:\Program Files\Microsoft\jdk-17.0.20.8-hotspot\bin\java.exe | **END_TO_END_TESTED** |
| **Git** | Version Control & Provenance | 2.44+ | C:\Users\ThinkPad\AppData\Local\OpenClaw\deps\portable-git\mingw64\bin\git.exe | **END_TO_END_TESTED** |

---

## 4. R & Bioconductor Omics Stack

Library Path: E:\Agriculture\Antigravity Research\tools\R-library  
Bioconductor Version: **3.23**

| Package | Classification | Version | Verification Status |
|---|---|---|---|
| lme4 | Mixed Models | 2.0.6 | **LOADED** |
| ggplot2 | Publication Graphics | 4.0.3 | **LOADED** |
| emmeans | Estimated Marginal Means | 2.0.4 | **LOADED** |
| gricolae | Agricultural Field Trials | 1.3.7 | **LOADED** |
| Biobase | Core Bioconductor Data | 2.72.0 | **LOADED** |
| limma | Linear Models for Microarrays/RNA-seq | 3.68.4 | **LOADED** |
| edgeR | Empirical Analysis of DGE | 4.10.1 | **LOADED** |
| SummarizedExperiment | Assay Container | 1.42.0 | **LOADED** |
| GEOquery | NCBI GEO Data Ingestion | 2.80.0 | **LOADED** |
| AnnotationDbi | Gene Annotation Databases | 1.74.0 | **LOADED** |
| DESeq2 | Differential Expression Analysis | 1.52.0 | **LOADED** |
| sva | Surrogate Variable Analysis | 3.56.0 | **LOADED** |
| gsea | Fast Gene Set Enrichment | 1.34.0 | **LOADED** |

---

## 5. Scholarly API Router

| Service | Scope / Feature | Status | Verification Detail |
|---|---|---|---|
| **Crossref REST** | DOI Identity, Updates, Retractions | **END_TO_END_TESTED** | Verified against Nature DOI with update filtering |
| **DataCite REST** | Dataset & Software DOIs | **END_TO_END_TESTED** | Verified against Dryad dataset DOI |
| **OpenCitations** | Citation Graph Expansion | **END_TO_END_TESTED** | Citation records retrieved via COCI API |
| **Semantic Scholar** | Citation Graph, Recommendations | **END_TO_END_TESTED** | Academic graph metadata retrieved |
| **Unpaywall** | Legal Open-Access PDFs | **END_TO_END_TESTED** | Validated OA status and direct PDF URLs |
| **Europe PMC** | Scholarly Literature Search | **END_TO_END_TESTED** | Full REST query confirmed with hit counts |
| **OpenAlex** | Scholarly Entity Resolution | **END_TO_END_TESTED** | Entity resolution verified |

---

## 6. Public Omics Toolchain Classification

Per Mandatory Correction 16, heavy aligners and tools are categorized to prevent RAM exhaustion:
- **Core (Installed & Tested):** R/Bioconductor (GEOquery, limma, edgeR, DESeq2, SummarizedExperiment, Biobase, AnnotationDbi).
- **Recommended (On Demand):** MultiQC, samtools, bedtools, pigz, aria2.
- **Dataset-Dependent (On Demand):** NCBI SRA Toolkit (prefetch, asterq-dump), fastp, Salmon, kallisto.
- **Heavy Optional / Deferred:** STAR, HISAT2 (require >30 GB RAM; impractical on 16 GB laptop).
- **GROBID:** DEFERRED (native Python parsers pdfplumber, pypdf, pymupdf utilized).
