import os, sys, json, hashlib
from pathlib import Path

def test_archive_integrity():
    workspace = Path(r"E:\Agriculture\Antigravity Research")
    audit_file = workspace / "reports" / "ARCHIVE_INTEGRITY_AUDIT.json"
    
    if not audit_file.exists():
        print(f"FAILED: {audit_file} does not exist.")
        sys.exit(1)
        
    data = json.loads(audit_file.read_text(encoding="utf-8"))
    records = data.get("verified_archives", data) if isinstance(data, dict) else data
    
    for r in records:
        fname = r.get("filename") or Path(r.get("path", "")).name
        arch_path = workspace / fname
        if not arch_path.exists():
            print(f"FAILED: Archive file does not exist: {arch_path}")
            sys.exit(1)
            
        file_bytes = arch_path.read_bytes()
        actual_size = len(file_bytes)
        actual_sha = hashlib.sha256(file_bytes).hexdigest().upper()
        
        if actual_size != r["size_bytes"]:
            print(f"FAILED: Size mismatch for {arch_path.name}: reported {r['size_bytes']} != actual {actual_size}")
            sys.exit(1)
            
        if actual_sha != r["sha256"]:
            print(f"FAILED: SHA256 mismatch for {arch_path.name}: reported {r['sha256']} != actual {actual_sha}")
            sys.exit(1)
            
        print(f"PASS: {arch_path.name} verified ({actual_size:,} bytes, {actual_sha})")
        
    print("ALL ARCHIVE INTEGRITY REGRESSION TESTS PASSED.")

if __name__ == "__main__":
    test_archive_integrity()
