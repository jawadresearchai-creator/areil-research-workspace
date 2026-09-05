# AREIL QUICKSTART

1. Install AREIL into a **research-only workspace**.
2. Run `scripts/Invoke-AreilPreflight.ps1` and read `research/system/PREFLIGHT.json`.
3. Run `scripts/Invoke-AreilSelfTest.ps1`.
4. Create a project with `scripts/New-AreilProject.ps1`.
5. Open Antigravity at that project root.
6. Paste `FIRST_RUN_PROMPT.md` once.
7. Tell Gemini the research goal, target journal (if known), available data, and constraints.
8. AREIL must create/refresh the research question and search protocol before broad discovery.
9. Do not draft the final paper until the evidence/analysis gates relevant to the requested sections pass.
10. Before submission run:

```powershell
python .\scripts\Validate-AreilLedgers.py
python .\scripts\Audit-Citations.py
python .\scripts\Verify-ManuscriptConsistency.py
python .\scripts\Create-ReproducibilityManifest.py
```

For public-omics work also load `profiles/public-omics.md`.
