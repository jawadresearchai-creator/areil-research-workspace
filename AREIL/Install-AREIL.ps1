param(
    [string]$Workspace = "",
    [switch]$Force,
    [switch]$SkipVenv
)
$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $MyInvocation.MyCommand.Path

if ([string]::IsNullOrWhiteSpace($Workspace)) {
    $dst = $src
} else {
    $dst = [IO.Path]::GetFullPath($Workspace)
}

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   AREIL v0.2: Antigravity Research Evidence & Integrity Layer   " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Target Installation Workspace: $dst"

New-Item -ItemType Directory -Force -Path $dst | Out-Null

if ((Test-Path (Join-Path $dst "ALEIL_MASTER_SPECIFICATION.md")) -and -not $Force) {
    throw "Detected an ALEIL application workspace. Use a dedicated research workspace or pass -Force."
}

# Core folders to sync
$coreFolders = @(".agents", "schemas", "templates", "profiles", "scripts", "model-manuals", "state")
foreach ($folder in $coreFolders) {
    $srcPath = Join-Path $src $folder
    $dstPath = Join-Path $dst $folder
    if (Test-Path $srcPath) {
        if ($srcPath -ne $dstPath) {
            Copy-Item -Recurse -Force $srcPath $dstPath
        }
    }
}

# Core documents to sync
$coreDocs = @(
    "README.md", "QUICKSTART.md", "START_HERE.md", "CHANGELOG.md",
    "AREIL_MASTER_SPECIFICATION.md", "GEMINI.md", "AGENTS.md",
    "FIRST_RUN_PROMPT.md", "TOOLS_AND_REPOSITORIES.md"
)
foreach ($doc in $coreDocs) {
    $srcFile = Join-Path $src $doc
    $dstFile = Join-Path $dst $doc
    if (Test-Path $srcFile) {
        if ($srcFile -ne $dstFile) {
            Copy-Item -Force $srcFile $dstFile
        }
    }
}

# Initialize research directory and ledgers
$researchDir = Join-Path $dst "research"
$ledgersDir = Join-Path $researchDir "ledgers"
New-Item -ItemType Directory -Force -Path $ledgersDir | Out-Null

$ledgerFiles = @(
    "CLAIM_LEDGER.jsonl", "EVIDENCE_LEDGER.jsonl", "SOURCE_REGISTRY.jsonl",
    "CONTRADICTION_LEDGER.jsonl", "NOVELTY_LEDGER.jsonl", "REVIEW_LEDGER.jsonl",
    "DATASET_REGISTRY.jsonl"
)
foreach ($lf in $ledgerFiles) {
    $targetLf = Join-Path $ledgersDir $lf
    if (-not (Test-Path $targetLf)) {
        New-Item -ItemType File -Force -Path $targetLf | Out-Null
    }
}

# Setup Python virtual environment
$dstVenv = Join-Path $dst ".venv"
if (-not (Test-Path $dstVenv)) {
    $sharedVenv = "E:\Agriculture\Antigravity Research\AREIL\.venv"
    if ((Test-Path $sharedVenv) -and ((Get-Item $sharedVenv).FullName -ne (Join-Path $dst ".venv"))) {
        Write-Host "Configuring Python virtual environment via shared junction..." -ForegroundColor Cyan
        cmd /c mklink /J "$dstVenv" "$sharedVenv" | Out-Null
    } elseif (Get-Command "uv" -ErrorAction SilentlyContinue) {
        Write-Host "Creating isolated Python virtual environment via uv..." -ForegroundColor Cyan
        & uv venv "$dstVenv" | Out-Null
        $req = Join-Path $dst "requirements.lock"
        if (Test-Path $req) {
            & (Join-Path $dstVenv "Scripts\python.exe") -m pip install -r $req | Out-Null
        }
    }
}

Write-Host "`n[1/3] Executing AREIL Preflight..." -ForegroundColor Yellow
$preflightScript = Join-Path $dst "scripts\Invoke-AreilPreflight.ps1"
if (Test-Path $preflightScript) {
    & $preflightScript -Workspace $dst | Out-Host
}

Write-Host "`n[2/3] Checking Tier-1 R & Python Toolchain..." -ForegroundColor Yellow
$rPath = "C:\Program Files\R\R-4.6.1\bin\Rscript.exe"
if (Test-Path $rPath) {
    Write-Host "  R 4.6.1 found: $rPath" -ForegroundColor Green
} else {
    Write-Host "  Rscript not at standard path. Ensure R is installed and in PATH." -ForegroundColor Yellow
}

$quartoPath = "C:\Program Files\Quarto\bin\quarto.exe"
if (Test-Path $quartoPath) {
    Write-Host "  Quarto found: $quartoPath" -ForegroundColor Green
} else {
    Write-Host "  Quarto not at standard path. Ensure Quarto is installed." -ForegroundColor Yellow
}

Write-Host "`n[3/3] Installation Complete!" -ForegroundColor Green
Write-Host "Run .\Test-AREIL.ps1 to execute the 23-point verification suite." -ForegroundColor Cyan
