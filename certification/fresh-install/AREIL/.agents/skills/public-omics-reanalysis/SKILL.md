---
name: public-omics-reanalysis
description: Routes public microarray/RNA-seq work through acquisition, QC, normalization, differential analysis and reproducible annotation.
---
# Public Omics Reanalysis
Identify technology and raw/processed availability first. Preserve accession/sample metadata. Use technology-appropriate pipeline (microarray: GEOquery/limma; counts: DESeq2/edgeR; raw RNA-seq: QC→quantification/alignment→counts→model). Verify sample grouping and design before statistics.
