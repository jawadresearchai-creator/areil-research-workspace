param([Parameter(Mandatory=$true)][string]$Path,[string[]]$ActualTools=@(),[string[]]$ActualWorkers=@(),[string[]]$Verification=@(),[string[]]$Failures=@())
$ErrorActionPreference="Stop";$o=Get-Content -Raw $Path|ConvertFrom-Json
$o|Add-Member -Force NoteProperty completed_at (Get-Date).ToString("o")
$o|Add-Member -Force NoteProperty actual_tools $ActualTools
$o|Add-Member -Force NoteProperty actual_workers $ActualWorkers
$o|Add-Member -Force NoteProperty verification $Verification
$o|Add-Member -Force NoteProperty failures $Failures
$o.status="complete";$o|ConvertTo-Json -Depth 12|Set-Content -Encoding UTF8 $Path
