param(
    [string]$Workspace = ""
)
$ErrorActionPreference = "Stop"
$root = if ([string]::IsNullOrWhiteSpace($Workspace)) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { [IO.Path]::GetFullPath($Workspace) }

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                 AREIL v0.2: Integrity & Update Sync             " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$pyExe = Join-Path $root ".venv\Scripts\python.exe"
if (-not (Test-Path $pyExe)) {
    $pyExe = "python"
}

Write-Host "Validating system schemas and ledgers..." -ForegroundColor Yellow
$valScript = Join-Path $root "scripts\Validate-AreilLedgers.py"
if (Test-Path $valScript) {
    & $pyExe $valScript --root $root | Out-Host
}

Write-Host "`nChecking project reproducibility manifests..." -ForegroundColor Yellow
$projectsDir = Join-Path $root "projects"
if (Test-Path $projectsDir) {
    $projects = Get-ChildItem -Directory $projectsDir
    foreach ($p in $projects) {
        Write-Host "  Checking $($p.Name)..."
        $repScript = Join-Path $root "scripts\Create-ReproducibilityManifest.py"
        if (Test-Path $repScript) {
            & $pyExe $repScript --root $p.FullName | Out-Null
        }
    }
}

Write-Host "`nAREIL environment update and validation completed successfully." -ForegroundColor Green
