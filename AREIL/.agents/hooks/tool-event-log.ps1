$ErrorActionPreference = "SilentlyContinue"
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { "{}"; exit 0 }
$p = $raw | ConvertFrom-Json
$workspace = $null
if ($p.workspacePaths -and $p.workspacePaths.Count -gt 0) { $workspace=[string]$p.workspacePaths[0] }
if ($workspace -and (Test-Path $workspace)) {
  $dir=Join-Path $workspace "research\system"; New-Item -ItemType Directory -Force -Path $dir|Out-Null
  $record=[ordered]@{timestamp=(Get-Date).ToString("o");conversationId=$p.conversationId;modelName=$p.modelName;stepIdx=$p.stepIdx;tool=$p.toolCall.name;args=$p.toolCall.args;error=$p.error}
  ($record|ConvertTo-Json -Depth 30 -Compress)|Add-Content -Encoding UTF8 (Join-Path $dir "tool-events.jsonl")
}
"{}"
