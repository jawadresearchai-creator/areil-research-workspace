#!/usr/bin/env python3
"""Create-ReproducibilityManifest.py: Computes deterministic cryptographic SHA-256
hashes of all research project components (data, code, outputs, manuscripts)
along with host runtime environment metadata.
"""
from pathlib import Path
import argparse, hashlib, json, datetime, sys, platform, subprocess

parser = argparse.ArgumentParser(description="AREIL Reproducibility Manifest Generator")
parser.add_argument('--root', default='.', help="AREIL root")
parser.add_argument('--project', default=None, help="Project name")
args = parser.parse_args()

root = Path(args.root)
base = (root / 'projects' / args.project) if args.project else root

def get_sha256(filepath):
    h = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()

skip_dirs = {'.git', '.venv', '__pycache__', 'graphify-out', 'node_modules', '.cache'}
skip_files = {'reproducibility_manifest.json', 'SHA256SUMS.txt'}

file_records = []
for p in sorted(base.rglob('*')):
    if not p.is_file():
        continue
    if any(part in skip_dirs for part in p.parts):
        continue
    if p.name in skip_files:
        continue
    
    rel = str(p.relative_to(base)).replace('\\', '/')
    file_records.append({
        'path': rel,
        'bytes': p.stat().st_size,
        'sha256': get_sha256(p)
    })

# Gather runtime versions
env_info = {
    'platform': platform.platform(),
    'python_version': platform.python_version(),
    'processor': platform.processor()
}

out_dir = base / 'audits' if (base / 'audits').exists() else base / 'research' / 'audits'
out_dir.mkdir(parents=True, exist_ok=True)
manifest_file = out_dir / 'reproducibility_manifest.json'

manifest_data = {
    'created_at': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'project_root': str(base),
    'environment': env_info,
    'total_files_hashed': len(file_records),
    'files': file_records
}

manifest_file.write_text(json.dumps(manifest_data, indent=2), encoding='utf-8')
print(json.dumps({
    'manifest_path': str(manifest_file),
    'files_hashed': len(file_records),
    'ok': True
}, indent=2))
