# PUBLIC OMICS PROFILE

## Decision tree
1. Identify accession and technology.
2. Retrieve series/study + sample metadata from official repository.
3. Determine raw data availability and whether reprocessing is necessary for the paper question.
4. Freeze sample inclusion/group mapping before differential testing.
5. Use platform-appropriate pipeline.

### Microarray
CEL/raw if available → platform/QC → normalization (e.g. RMA when appropriate) → probe annotation → design matrix → limma → multiplicity → sensitivity.

### RNA-seq count matrix available
Verify count definition/sample mapping → filtering → normalization/model (DESeq2/edgeR as appropriate) → design/contrasts → diagnostics → FDR.

### Raw RNA-seq only
FASTQ acquisition → integrity/QC → trimming only if justified → quantification (Salmon/kallisto) or alignment/counting when needed → gene-level summarization → differential model.

Batch correction is not automatic. Model known batch factors when identified; do not erase biological variation blindly.
