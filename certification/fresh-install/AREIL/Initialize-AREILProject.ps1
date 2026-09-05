param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [string]$Workspace = ""
)
$ErrorActionPreference = "Stop"
$root = if ([string]::IsNullOrWhiteSpace($Workspace)) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { [IO.Path]::GetFullPath($Workspace) }

$projectDir = Join-Path $root "projects\$ProjectName"
if (Test-Path $projectDir) {
    Write-Host "Project directory already exists: $projectDir" -ForegroundColor Yellow
} else {
    New-Item -ItemType Directory -Force -Path $projectDir | Out-Null
    Write-Host "Created project root: $projectDir" -ForegroundColor Green
}

$subdirs = @(
    "data\raw", "data\processed",
    "analysis\scripts", "analysis\results",
    "figures", "ledgers", "manuscript", "reviews", "audits"
)
foreach ($sd in $subdirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $projectDir $sd) | Out-Null
}

$ledgersDir = Join-Path $projectDir "ledgers"
$ledgerFiles = @(
    "CLAIM_LEDGER.jsonl", "EVIDENCE_LEDGER.jsonl", "SOURCE_REGISTRY.jsonl",
    "CONTRADICTION_LEDGER.jsonl", "NOVELTY_LEDGER.jsonl", "REVIEW_LEDGER.jsonl",
    "DATASET_REGISTRY.jsonl"
)
foreach ($lf in $ledgerFiles) {
    $fPath = Join-Path $ledgersDir $lf
    if (-not (Test-Path $fPath)) {
        New-Item -ItemType File -Force -Path $fPath | Out-Null
    }
}

# Create starter manuscript
$qmd = @"
---
title: "$ProjectName"
author: "AREIL Research Team"
date: "$(Get-Date -Format 'yyyy-MM-dd')"
format:
  html:
    toc: true
    math: mathjax
  docx:
    toc: true
bibliography: references.bib
---

# Introduction

This project is governed by AREIL v0.2. All claims are tracked in `ledgers/CLAIM_LEDGER.jsonl`
and validated against primary evidence in `ledgers/EVIDENCE_LEDGER.jsonl`.

# Results

All quantitative values are derived from executed analysis in `analysis/results/`.

# References
"@

$qmdPath = Join-Path $projectDir "manuscript\manuscript.qmd"
if (-not (Test-Path $qmdPath)) {
    [System.IO.File]::WriteAllText($qmdPath, $qmd, [System.Text.Encoding]::UTF8)
}

$bibPath = Join-Path $projectDir "manuscript\references.bib"
if (-not (Test-Path $bibPath)) {
    [System.IO.File]::WriteAllText($bibPath, "% BibTeX references will be populated by AREIL
", [System.Text.Encoding]::UTF8)
}

Write-Host "Project '$ProjectName' successfully initialized at $projectDir" -ForegroundColor Green
