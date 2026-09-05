param([string]$Target=(Get-Location).Path)
$ErrorActionPreference="Stop"
$g=Get-Command graphify -ErrorAction SilentlyContinue
if(-not $g){throw "Graphify command not found. It is optional but expected if already installed."}
& graphify $Target
if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
Write-Output "Graphify completed. Remember: graph output is navigation, not evidence; resolve claims to original sources."
