param([ValidateSet("core","omics","all")][string]$Profile="core")
Write-Output "AREIL intentionally does not silently install research software. Review commands before running them."
Write-Output "CORE suggested: Zotero desktop; Better BibTeX XPI; Quarto; Pandoc; R; Python packages statsmodels polars pyarrow pandera jupyterlab pyzotero."
if($Profile -in @("omics","all")){Write-Output "OMICS suggested: WSL2 Ubuntu; NCBI SRA Toolkit; FastQC; MultiQC; fastp; Salmon/kallisto; samtools; bedtools; R Bioconductor GEOquery limma edgeR DESeq2."}
Write-Output "Run scripts/Invoke-AreilPreflight.ps1 after installations to refresh detected capabilities."
