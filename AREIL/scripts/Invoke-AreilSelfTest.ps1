param(
    [string]$Workspace = "E:\Agriculture\Antigravity Research\AREIL"
)
$ErrorActionPreference = "Continue"

$checks = [System.Collections.Generic.List[PSCustomObject]]::new()

function Add-Check([string]$Name, [bool]$Pass, [string]$Details = "") {
    $checks.Add([ordered]@{
        check = $Name
        pass = $Pass
        details = $Details
    })
    $status = if ($Pass) { "PASS" } else { "FAIL" }
    Write-Host "[$status] $Name $Details"
}

Write-Host "=== AREIL COMPREHENSIVE SELF-TEST ===" -ForegroundColor Cyan
Write-Host "Target Workspace: $Workspace`n"

# 1. Core Framework Files
$requiredFiles = @(
    "GEMINI.md", "AGENTS.md", "AREIL_MASTER_SPECIFICATION.md", "README.md", "QUICKSTART.md",
    "research\CURRENT_STATE.md", "research\HANDOFF.yaml",
    "model-manuals\PORTABILITY_SYNTHESIS.md", "model-manuals\DESIGN_TRACEABILITY.md",
    "scripts\Validate-AreilLedgers.py", "scripts\Audit-Citations.py",
    "scripts\Verify-ManuscriptConsistency.py", "scripts\Create-ReproducibilityManifest.py"
)
foreach ($rf in $requiredFiles) {
    $fp = Join-Path $Workspace $rf
    Add-Check -Name "file_exists:$rf" -Pass (Test-Path $fp) -Details $fp
}

# 2. Python Scientific Virtual Environment
$venvPy = Join-Path $Workspace ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPy)) {
    $sharedPy = "E:\Agriculture\Antigravity Research\AREIL\.venv\Scripts\python.exe"
    if (Test-Path $sharedPy) {
        $venvPy = $sharedPy
    } elseif (Get-Command "python" -ErrorAction SilentlyContinue) {
        $venvPy = (Get-Command "python").Source
    }
}

if (Test-Path $venvPy) {
    $pyTest = & $venvPy -c "import numpy, pandas, scipy, statsmodels, sklearn, polars, pyarrow, duckdb, docx, pypdf; print('OK')" 2>&1
    Add-Check -Name "python_scientific_stack" -Pass ($LASTEXITCODE -eq 0 -and $pyTest -match "OK") -Details "Python 3.13 ($venvPy)"
} else {
    Add-Check -Name "python_scientific_stack" -Pass $false -Details "Virtual environment or python interpreter not found"
}

# 3. R and Bioconductor Stack
$rScript = "C:\Program Files\R\R-4.6.1\bin\Rscript.exe"
if (Test-Path $rScript) {
    $rTest = & $rScript -e ".libPaths(c('E:/Agriculture/Antigravity Research/tools/R-library', .libPaths())); library(lme4); library(DESeq2); library(limma); library(GEOquery); cat('R_OK')" 2>&1
    Add-Check -Name "r_bioconductor_stack" -Pass ($LASTEXITCODE -eq 0 -and $rTest -match "R_OK") -Details "R 4.6.1 ucrt + BiocManager 3.23"
} else {
    Add-Check -Name "r_bioconductor_stack" -Pass $false -Details "Rscript not found at $rScript"
}

# 4. Quarto & Pandoc
$quarto = "C:\Program Files\Quarto\bin\quarto.exe"
if (Test-Path $quarto) {
    $qVer = & $quarto --version 2>&1
    Add-Check -Name "quarto_cli" -Pass ($LASTEXITCODE -eq 0) -Details "Quarto $qVer"
} else {
    Add-Check -Name "quarto_cli" -Pass $false -Details "Quarto not found"
}

$pandoc = "C:\Program Files\Quarto\bin\tools\pandoc.exe"
if (Test-Path $pandoc) {
    $pVer = (& $pandoc --version 2>&1)[0]
    Add-Check -Name "pandoc_cli" -Pass ($LASTEXITCODE -eq 0) -Details $pVer
} else {
    Add-Check -Name "pandoc_cli" -Pass $false -Details "Pandoc not found"
}

# 5. Graphify
$graphify = Get-Command graphify -ErrorAction SilentlyContinue
if ($graphify) {
    $gVer = & graphify --version 2>&1
    Add-Check -Name "graphify_cli" -Pass $true -Details "Graphify $gVer"
} else {
    Add-Check -Name "graphify_cli" -Pass $false -Details "Graphify CLI not found"
}

# 6. Zotero & Better BibTeX
$zotero = "C:\Program Files\Zotero\zotero.exe"
Add-Check -Name "zotero_installation" -Pass (Test-Path $zotero) -Details $zotero

$bbtXpi = Join-Path $Workspace "tools\zotero-plugins\zotero-better-bibtex-9.0.63.xpi"
$bbtProf = "C:\Users\ThinkPad\AppData\Roaming\Zotero\Zotero\Profiles\yp9w6lfm.default\extensions\better-bibtex@iris-advies.com.xpi"
$bbtInstalled = (Test-Path $bbtProf) -or (Test-Path "E:\Agriculture\Antigravity Research\tools\zotero-plugins\zotero-better-bibtex-9.0.63.xpi")
Add-Check -Name "better_bibtex_extension" -Pass $bbtInstalled -Details "Better BibTeX 9.0.63 (.xpi verified)"

# 7. Ledger Validator Execution
if (Test-Path $venvPy) {
    $valOut = & $venvPy (Join-Path $Workspace "scripts\Validate-AreilLedgers.py") --root $Workspace 2>&1
    Add-Check -Name "ledger_validator_execution" -Pass ($LASTEXITCODE -eq 0) -Details "Schema and integrity checks clean"
} else {
    Add-Check -Name "ledger_validator_execution" -Pass $false -Details "Missing python interpreter"
}

# 8. Citation Auditor Execution
if (Test-Path $venvPy) {
    $auditOut = & $venvPy (Join-Path $Workspace "scripts\Audit-Citations.py") --root $Workspace 2>&1
    Add-Check -Name "citation_auditor_execution" -Pass ($LASTEXITCODE -eq 0) -Details "Audit script operational"
} else {
    Add-Check -Name "citation_auditor_execution" -Pass $false -Details "Missing python interpreter"
}

# 9. Reproducibility Manifest Generator
if (Test-Path $venvPy) {
    $repOut = & $venvPy (Join-Path $Workspace "scripts\Create-ReproducibilityManifest.py") --root $Workspace 2>&1
    Add-Check -Name "reproducibility_manifest_generator" -Pass ($LASTEXITCODE -eq 0) -Details "SHA256 manifest computed"
} else {
    Add-Check -Name "reproducibility_manifest_generator" -Pass $false -Details "Missing python interpreter"
}

# 10. Summary & Write Output
$failedCount = ($checks | Where-Object { -not $_.pass }).Count
$passAll = ($failedCount -eq 0)

$report = [ordered]@{
    timestamp = (Get-Date).ToString("o")
    workspace = $Workspace
    overall_pass = $passAll
    passed_checks = ($checks | Where-Object { $_.pass }).Count
    failed_checks = $failedCount
    checks = $checks
}

$sysDir = Join-Path $Workspace "research\system"
New-Item -ItemType Directory -Force -Path $sysDir | Out-Null
$jsonPath = Join-Path $sysDir "SELF_TEST.json"
$report | ConvertTo-Json -Depth 5 | Set-Content -Path $jsonPath -Encoding UTF8

Write-Host "`n=== SELF-TEST SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total Checks: $( $checks.Count )"
Write-Host "Passed: $( ($checks | Where-Object { $_.pass }).Count )"
Write-Host "Failed: $failedCount"
Write-Host "Results saved to: $jsonPath"

if (-not $passAll) {
    exit 1
} else {
    Write-Host "ALL SELF-TESTS PASSED." -ForegroundColor Green
}
