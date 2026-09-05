import os, sys, json, yaml, subprocess
from pathlib import Path

def test_remote_handoff_consistency():
    workspace = Path(r"E:\Agriculture\Antigravity Research")
    areil_dir = workspace / "AREIL"
    reports_dir = workspace / "reports"
    
    current_areil_version = "0.2.3"
    certified_distribution = "AREIL_v0.2.3-bound.zip"
    expected_status = "CERTIFIED_FOR_RESEARCH_ASSISTANCE"
    expected_drive_root_id = "1bnltIQ2iGslIHbgoVlWIy23L8tAXkM5J"
    expected_next_phase = "REAL_RESEARCH_USE"
    expected_benchmark_count = 12
    
    print("=== RUNNING REMOTE HANDOFF CONSISTENCY REGRESSION TESTS ===")
    
    # 1. Test RESUME_HANDOFF.md version
    resume_path = workspace / "RESUME_HANDOFF.md"
    assert resume_path.exists(), "RESUME_HANDOFF.md missing"
    resume_text = resume_path.read_text(encoding="utf-8")
    assert f"AREIL v{current_areil_version}" in resume_text, f"RESUME_HANDOFF.md does not contain v{current_areil_version}"
    assert "AREIL v0.2.1" not in resume_text, "RESUME_HANDOFF.md contains stale v0.2.1 text"
    assert "AREIL v0.2.2" not in resume_text, "RESUME_HANDOFF.md contains stale v0.2.2 text"
    assert "finish v0.2.1 certification" not in resume_text, "RESUME_HANDOFF.md contains stale instructions"
    print("[TEST 1] RESUME_HANDOFF.md version and content check... PASS")
    
    # 2. Test HANDOFF.yaml current distribution & status
    handoff_yaml_path = areil_dir / "research" / "HANDOFF.yaml"
    assert handoff_yaml_path.exists(), "AREIL/research/HANDOFF.yaml missing"
    with open(handoff_yaml_path, "r", encoding="utf-8") as f:
        hy = yaml.safe_load(f)
    assert hy.get("areil", {}).get("version") == current_areil_version, f"HANDOFF.yaml version mismatch: {hy.get('areil', {}).get('version')}"
    assert hy.get("areil", {}).get("distribution_filename") == certified_distribution, f"HANDOFF.yaml distribution mismatch: {hy.get('areil', {}).get('distribution_filename')}"
    assert hy.get("status") == expected_status, f"HANDOFF.yaml status mismatch: {hy.get('status')}"
    assert hy.get("current_phase", {}).get("name") == expected_next_phase, f"HANDOFF.yaml next phase mismatch: {hy.get('current_phase', {}).get('name')}"
    assert hy.get("google_drive", {}).get("root_folder_id") == expected_drive_root_id, f"HANDOFF.yaml root_folder_id mismatch: {hy.get('google_drive', {}).get('root_folder_id')}"
    print("[TEST 2] HANDOFF.yaml distribution, status, and root_folder_id check... PASS")
    
    # 3. Test LATEST_HANDOFF.yaml version & next_phase
    latest_yaml_path = workspace / "LATEST_HANDOFF.yaml"
    assert latest_yaml_path.exists(), "LATEST_HANDOFF.yaml missing"
    with open(latest_yaml_path, "r", encoding="utf-8") as f:
        ly = yaml.safe_load(f)
    assert ly.get("areil_version") == current_areil_version, f"LATEST_HANDOFF.yaml version mismatch: {ly.get('areil_version')}"
    assert ly.get("status") == expected_status, f"LATEST_HANDOFF.yaml status mismatch: {ly.get('status')}"
    assert ly.get("next_phase") == expected_next_phase, f"LATEST_HANDOFF.yaml next_phase mismatch: {ly.get('next_phase')}"
    assert ly.get("drive_root_folder_id") == expected_drive_root_id, f"LATEST_HANDOFF.yaml drive_root_folder_id mismatch: {ly.get('drive_root_folder_id')}"
    print("[TEST 3] LATEST_HANDOFF.yaml version, status, and next_phase check... PASS")
    
    # 4. Test Benchmark Count & Provenance Audit
    prov_path = reports_dir / "BENCHMARK_PROVENANCE_AUDIT.yaml"
    assert prov_path.exists(), "BENCHMARK_PROVENANCE_AUDIT.yaml missing"
    with open(prov_path, "r", encoding="utf-8") as f:
        prov = yaml.safe_load(f)
    assert len(prov) == expected_benchmark_count, f"Benchmark count mismatch: {len(prov)} != {expected_benchmark_count}"
    assert all(c.get("classification") == "MODEL_EXECUTION_VERIFIED_SUBAGENT" for c in prov), "Unverified benchmark cells present"
    print("[TEST 4] Benchmark cell count (12/12) and verification check... PASS")
    
    # 5. Test Certification Report alignment
    cert_rep_path = reports_dir / "FINAL_CERTIFICATION_REPORT.md"
    assert cert_rep_path.exists(), "FINAL_CERTIFICATION_REPORT.md missing"
    cert_text = cert_rep_path.read_text(encoding="utf-8")
    assert expected_status in cert_text, "FINAL_CERTIFICATION_REPORT.md status mismatch"
    assert certified_distribution in cert_text, "FINAL_CERTIFICATION_REPORT.md distribution mismatch"
    print("[TEST 5] FINAL_CERTIFICATION_REPORT.md alignment check... PASS")
    
    # 6. Test Drive Index alignment
    idx_path = workspace / "reports" / "REMOTE_WORKSPACE_INDEX.json"
    assert idx_path.exists(), "REMOTE_WORKSPACE_INDEX.json missing"
    idx = json.loads(idx_path.read_text(encoding="utf-8"))
    assert idx.get("version") == current_areil_version, "REMOTE_WORKSPACE_INDEX.json version mismatch"
    assert idx.get("status") == expected_status, "REMOTE_WORKSPACE_INDEX.json status mismatch"
    assert idx.get("next_phase") == expected_next_phase, "REMOTE_WORKSPACE_INDEX.json next_phase mismatch"
    assert idx.get("google_drive_workspace", {}).get("root_folder_id") == expected_drive_root_id, "REMOTE_WORKSPACE_INDEX.json drive root mismatch"
    print("[TEST 6] REMOTE_WORKSPACE_INDEX.json alignment check... PASS")
    
    print("\nALL REMOTE HANDOFF CONSISTENCY TESTS PASSED.")

if __name__ == "__main__":
    test_remote_handoff_consistency()
