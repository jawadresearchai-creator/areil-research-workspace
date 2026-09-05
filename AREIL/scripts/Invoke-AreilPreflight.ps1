param([string]$Workspace=(Get-Location).Path)
$ErrorActionPreference="SilentlyContinue"
function Cmd($n){ $c=Get-Command $n -ErrorAction SilentlyContinue; if($c){$c.Source}else{$null} }
$report=[ordered]@{
 timestamp=(Get-Date).ToString("o"); workspace=$Workspace;
 commands=[ordered]@{
  python=(Cmd "python"); git=(Cmd "git"); graphify=(Cmd "graphify"); quarto=(Cmd "quarto"); pandoc=(Cmd "pandoc"); Rscript=(Cmd "Rscript"); docker=(Cmd "docker"); wsl=(Cmd "wsl"); java=(Cmd "java")
 };
 zotero_local_api=$false; notes=@()
}
try { $x=Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 -Uri "http://127.0.0.1:23119/api/"; if($x.StatusCode -ge 200){$report.zotero_local_api=$true} } catch {}
$dir=Join-Path $Workspace "research\system"; New-Item -ItemType Directory -Force -Path $dir|Out-Null
$path=Join-Path $dir "PREFLIGHT.json"; $report|ConvertTo-Json -Depth 8|Set-Content -Encoding UTF8 $path
$report|ConvertTo-Json -Depth 8
