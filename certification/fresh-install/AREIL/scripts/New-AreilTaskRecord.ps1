param([Parameter(Mandatory=$true)][string]$Task,[string]$Tier="R1",[string]$Workspace=(Get-Location).Path)
$dir=Join-Path $Workspace "research\system\tasks";New-Item -ItemType Directory -Force -Path $dir|Out-Null
$id="TASK-"+(Get-Date -Format "yyyyMMdd-HHmmss")
$o=[ordered]@{id=$id;created_at=(Get-Date).ToString("o");task=$Task;tier=$Tier;predicted_workers=@();predicted_tools=@();predicted_verification=@();expected_failure_modes=@();status="open"}
$p=Join-Path $dir ($id+".json");$o|ConvertTo-Json -Depth 8|Set-Content -Encoding UTF8 $p;Write-Output $p
