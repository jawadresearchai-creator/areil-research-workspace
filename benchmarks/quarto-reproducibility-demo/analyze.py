import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import json

# 1. Load data
df = pd.read_csv('data.csv')

# 2. Compute statistics
ctrl = df[df['treatment'] == 'Control']['plant_height_cm']
trt = df[df['treatment'] == 'Treated']['plant_height_cm']

ctrl_mean, ctrl_sd = float(ctrl.mean()), float(ctrl.std())
trt_mean, trt_sd = float(trt.mean()), float(trt.std())
diff = trt_mean - ctrl_mean

t_stat, p_val = stats.ttest_ind(trt, ctrl)
# Pooled SD for Cohen's d
pooled_sd = np.sqrt(((len(ctrl)-1)*ctrl_sd**2 + (len(trt)-1)*trt_sd**2) / (len(ctrl) + len(trt) - 2))
cohens_d = float(diff / pooled_sd)

results = {
    'ctrl_mean': round(ctrl_mean, 2),
    'ctrl_sd': round(ctrl_sd, 2),
    'trt_mean': round(trt_mean, 2),
    'trt_sd': round(trt_sd, 2),
    'diff_cm': round(diff, 2),
    't_statistic': round(float(t_stat), 3),
    'p_value': round(float(p_val), 6),
    'cohens_d': round(cohens_d, 2)
}

with open('results.json', 'w') as f:
    json.dump(results, f, indent=2)

# 3. Generate figure
plt.figure(figsize=(5, 4), dpi=150)
means = [ctrl_mean, trt_mean]
errors = [ctrl_sd, trt_sd]
labels = ['Control', 'Treated']
bars = plt.bar(labels, means, yerr=errors, capsize=5, color=['#4A90E2', '#50E3C2'], edgecolor='black', alpha=0.85)
plt.ylabel('Plant Height (cm)')
plt.title('Treatment Effect on Plant Height (p < 0.001)')
plt.tight_layout()
plt.savefig('figure1.png')
plt.close()

print('Executed statistical analysis and generated figure1.png successfully.')
