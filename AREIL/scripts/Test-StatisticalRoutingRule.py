import os, sys
from pathlib import Path

def test_statistical_routing():
    spec_path = Path(r"E:\Agriculture\Antigravity Research\AREIL\schemas\STATISTICAL_ROUTING_SPECIFICATION.md")
    if not spec_path.exists():
        print(f"FAILED: Specification not found at {spec_path}")
        sys.exit(1)
        
    spec_text = spec_path.read_text(encoding="utf-8")
    
    # Check 1: No universal Shapiro-Wilk LMM/GLMM rule
    if "Shapiro-Wilk W > 0.95 -> Gaussian LMM" in spec_text or "Shapiro-Wilk W <= 0.95 -> GLMM" in spec_text:
        print("FAILED: Found obsolete universal Shapiro-Wilk gate in specification!")
        sys.exit(1)
    print("[TEST 1] Universal Shapiro-Wilk gate absent... PASS")
    
    # Check 2: Design authority and independent vs clustered distinction
    if "Independent Observations / No Hierarchy" not in spec_text or "Ordinary Least Squares (LM)" not in spec_text:
        print("FAILED: Specification does not route unclustered Gaussian data to LM/GLS!")
        sys.exit(1)
    print("[TEST 2] Continuous Gaussian + independent -> LM/GLS routing... PASS")
    
    if "Blocking / Clustering / Hierarchy" not in spec_text or "Linear Mixed-Effects Model (LMM)" not in spec_text:
        print("FAILED: Specification does not route clustered Gaussian data to LMM!")
        sys.exit(1)
    print("[TEST 3] Continuous Gaussian + clustering -> LMM routing... PASS")
    
    if "determine whether random effects exist" not in spec_text or "ICC" not in spec_text:
        print("FAILED: Specification does not clarify ICC is diagnostic and design is authoritative!")
        sys.exit(1)
    print("[TEST 4] Design authority over ICC heuristic... PASS")

    print("ALL STATISTICAL ROUTING REGRESSION TESTS PASSED.")

if __name__ == "__main__":
    test_statistical_routing()
