param([Parameter(Mandatory=$true)][string]$Workspace,[switch]$Force)
$ErrorActionPreference="Stop"
$src=Split-Path -Parent $MyInvocation.MyCommand.Path
$dst=[IO.Path]::GetFullPath($Workspace)
New-Item -ItemType Directory -Force -Path $dst|Out-Null
if((Test-Path (Join-Path $dst "ALEIL_MASTER_SPECIFICATION.md")) -and -not $Force){throw "This looks like an ALEIL application workspace. Use a dedicated research workspace or pass -Force only if you intentionally want both systems."}
$stamp=Get-Date -Format "yyyyMMdd-HHmmss";$backup=Join-Path $dst (".areil-backup-"+$stamp)
foreach($f in @("GEMINI.md","AGENTS.md")){ $p=Join-Path $dst $f; if(Test-Path $p){New-Item -ItemType Directory -Force -Path $backup|Out-Null;Copy-Item $p (Join-Path $backup $f)} }
foreach($name in @(".agents","schemas","templates","profiles","scripts","model-manuals")){ Copy-Item -Recurse -Force (Join-Path $src $name) (Join-Path $dst $name) }
foreach($name in @("README.md","QUICKSTART.md","AREIL_MASTER_SPECIFICATION.md","GEMINI.md","AGENTS.md","FIRST_RUN_PROMPT.md","TOOLS_AND_REPOSITORIES.md")){Copy-Item -Force (Join-Path $src $name) (Join-Path $dst $name)}
$research=Join-Path $dst "research"; if(-not (Test-Path $research)){Copy-Item -Recurse -Force (Join-Path $src "research") $research}
& (Join-Path $dst "scripts\Invoke-AreilPreflight.ps1") -Workspace $dst | Out-Host
Write-Output "AREIL installed at $dst. Next: run Invoke-AreilSelfTest.ps1, then paste FIRST_RUN_PROMPT.md into Antigravity."
