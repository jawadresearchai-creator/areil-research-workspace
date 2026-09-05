$ErrorActionPreference = "Stop"
try {
  $raw = [Console]::In.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($raw)) { @{decision="allow";reason="AREIL: empty hook payload, no destructive command observed."}|ConvertTo-Json -Compress; exit 0 }
  $p = $raw | ConvertFrom-Json
  $cmd = ""
  if ($p.toolCall.args.CommandLine) { $cmd = [string]$p.toolCall.args.CommandLine }
  $c = $cmd.ToLowerInvariant()
  $protected = @("research\\raw", "research/raw", "evidence_ledger.jsonl", "claim_ledger.jsonl", "source_registry.jsonl")
  $destructive = ($c -match '(remove-item|\bdel\b|\berase\b|\brm\b|git\s+clean)')
  if ($destructive) {
    foreach ($token in $protected) {
      if ($c.Contains($token)) {
        @{decision="deny";reason="AREIL: destructive command targets canonical raw/evidence state. Preserve or version it instead."}|ConvertTo-Json -Compress
        exit 0
      }
    }
  }
  @{decision="allow";reason="AREIL integrity guard passed."}|ConvertTo-Json -Compress
} catch {
  @{decision="allow";reason=("AREIL guard parse failure; allowing command but logging should capture event: " + $_.Exception.Message)}|ConvertTo-Json -Compress
}
