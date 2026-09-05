param(
    [string]$Workspace = ""
)
$ErrorActionPreference = "Stop"
$root = if ([string]::IsNullOrWhiteSpace($Workspace)) { Split-Path -Parent $MyInvocation.MyCommand.Path } else { [IO.Path]::GetFullPath($Workspace) }

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "             AREIL v0.2: Verification & Self-Test Suite         " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Workspace: $root`n"

$selfTest = Join-Path $root "scripts\Invoke-AreilSelfTest.ps1"
if (Test-Path $selfTest) {
    & $selfTest -Workspace $root | Out-Host
} else {
    Write-Host "ERROR: Could not find scripts\Invoke-AreilSelfTest.ps1" -ForegroundColor Red
}

$apisTest = Join-Path $root "state\SCHOLARLY_APIS_TEST_RESULTS.json"
if (Test-Path $apisTest) {
    $apis = Get-Content $apisTest -Raw | ConvertFrom-Json
    Write-Host "`nScholarly APIs Integration Status:" -ForegroundColor Yellow
    foreach ($api in $apis.results.PSObject.Properties) {
        $status = if ($api.Value.status -eq "UP") { "OK [UP]" } else { "FAIL [" + $api.Value.status + "]" }
        $color = if ($api.Value.status -eq "UP") { "Green" } else { "Red" }
        Write-Host "  - $($api.Name): $status ($($api.Value.latency_ms) ms)" -ForegroundColor $color
    }
}

Write-Host "`nAll verification checks executed. See research\system\SELF_TEST.json for full logs." -ForegroundColor Green
