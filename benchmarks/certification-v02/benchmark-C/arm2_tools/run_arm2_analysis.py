import pandas as pd
import scipy.stats as stats

df = pd.read_csv(r"E:\Agriculture\Antigravity Research\benchmarks\certification-v02\benchmark-C\root_growth_trial_data.csv")

# Standard One-Way ANOVA (ignoring block clustering)
g_ctrl = df[df['treatment'] == 'Control']['root_length_mm']
g_imp = df[df['treatment'] == 'Impedance']['root_length_mm']
g_res = df[df['treatment'] == 'Impedance_Apyrase']['root_length_mm']

f_stat, p_val = stats.f_oneway(g_ctrl, g_imp, g_res)
print(f"One-Way ANOVA: F = {f_stat:.2f}, p = {p_val:.6f}")
print("Means:")
print(df.groupby('treatment')['root_length_mm'].agg(['mean', 'std', 'count']))
