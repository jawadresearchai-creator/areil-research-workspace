param([Parameter(Mandatory=$true)][string]$ProjectName,[string]$Workspace=(Get-Location).Path)
$ErrorActionPreference="Stop"
$safe=($ProjectName -replace '[^A-Za-z0-9._-]','-').Trim('-')
$proj=Join-Path $Workspace ("projects\"+$safe)
if(Test-Path $proj){throw "Project already exists: $proj"}
New-Item -ItemType Directory -Force -Path $proj|Out-Null
foreach($d in @("raw","derived","analysis","analysis\results","manuscript","manuscript\figures","manuscript\tables","sources","ledgers","audits","system")){New-Item -ItemType Directory -Force -Path (Join-Path $proj $d)|Out-Null}
Copy-Item (Join-Path $Workspace "templates\PROJECT_CHARTER.md") (Join-Path $proj "PROJECT_CHARTER.md")
Copy-Item (Join-Path $Workspace "templates\RESEARCH_QUESTION.md") (Join-Path $proj "RESEARCH_QUESTION.md")
Copy-Item (Join-Path $Workspace "templates\SEARCH_PROTOCOL.md") (Join-Path $proj "SEARCH_PROTOCOL.md")
Copy-Item (Join-Path $Workspace "templates\ANALYSIS_PLAN.md") (Join-Path $proj "ANALYSIS_PLAN.md")
Copy-Item (Join-Path $Workspace "templates\MANUSCRIPT_PLAN.md") (Join-Path $proj "MANUSCRIPT_PLAN.md")
Copy-Item (Join-Path $Workspace "templates\JOURNAL_PROFILE.md") (Join-Path $proj "JOURNAL_PROFILE.md")
Copy-Item (Join-Path $Workspace "templates\HANDOFF.yaml") (Join-Path $proj "HANDOFF.yaml")
Copy-Item (Join-Path $Workspace "templates\README_PROJECT.md") (Join-Path $proj "README.md")
foreach($f in @("SOURCE_REGISTRY.jsonl","EVIDENCE_LEDGER.jsonl","CLAIM_LEDGER.jsonl","CONTRADICTION_LEDGER.jsonl","NOVELTY_LEDGER.jsonl","DATASET_REGISTRY.jsonl","REVIEW_LEDGER.jsonl","TASK_TELEMETRY.jsonl")){New-Item -ItemType File -Force -Path (Join-Path $proj ("ledgers\"+$f))|Out-Null}
@"\n# AREIL CURRENT STATE\n\nStatus: ACTIVE\nCurrent project: $safe\nProject path: projects/$safe\nCurrent stage: framing\nLast verified: $(Get-Date -Format o)\n"@|Set-Content -Encoding UTF8 (Join-Path $Workspace "research\CURRENT_STATE.md")
Write-Output $proj
