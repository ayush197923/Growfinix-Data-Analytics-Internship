"""
Task 5: Healthcare Patient Admission Trends (EDA)
Growfinix Data Analytics Internship - Month 1

Goals:
  1. Identify seasonal trends in patient visits
  2. Calculate the average length of stay (LOS) per department
  3. Handle outliers in the dataset using the IQR rule
"""

import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid")

# ---------- 1. Load and inspect ----------
df = pd.read_csv("hospital_admissions.csv", parse_dates=["Admission_Date"])
print("Shape:", df.shape)
print("\nMissing values:\n", df.isnull().sum())
print("\nLOS summary (before outlier handling):\n", df["Length_of_Stay_Days"].describe())

# Missing treatment cost -> fill with the median of the same department
df["Treatment_Cost_INR"] = df.groupby("Department")["Treatment_Cost_INR"].transform(
    lambda s: s.fillna(s.median())
)

# ---------- 2. Date features for seasonality ----------
df["Month"] = df["Admission_Date"].dt.month
df["Month_Name"] = df["Admission_Date"].dt.strftime("%b")

def season(m):
    if m in (12, 1, 2):
        return "Winter"
    if m in (3, 4, 5):
        return "Summer"
    if m in (6, 7, 8, 9):
        return "Monsoon"
    return "Post-Monsoon"

df["Season"] = df["Month"].apply(season)

# ---------- 3. Outlier detection using the IQR rule ----------
col = "Length_of_Stay_Days"
Q1 = df[col].quantile(0.25)
Q3 = df[col].quantile(0.75)
IQR = Q3 - Q1
lower = Q1 - 1.5 * IQR
upper = Q3 + 1.5 * IQR
print(f"\nIQR rule -> Q1={Q1}, Q3={Q3}, IQR={IQR}, lower={lower}, upper={upper}")

df["Is_Outlier"] = (df[col] < lower) | (df[col] > upper)
print("Outliers found:", int(df["Is_Outlier"].sum()), "of", len(df))

# Boxplot BEFORE removal
plt.figure(figsize=(9, 5))
sns.boxplot(data=df, x="Department", y=col, color="#9DC3E6")
plt.title("Length of Stay by Department (before outlier removal)")
plt.xticks(rotation=40, ha="right")
plt.tight_layout()
plt.savefig("chart_los_boxplot_before.png", dpi=150)
plt.close()

clean = df[~df["Is_Outlier"]].copy()
print("Rows after removing outliers:", len(clean))

# Boxplot AFTER removal
plt.figure(figsize=(9, 5))
sns.boxplot(data=clean, x="Department", y=col, color="#A9D18E")
plt.title("Length of Stay by Department (after IQR outlier removal)")
plt.xticks(rotation=40, ha="right")
plt.tight_layout()
plt.savefig("chart_los_boxplot_after.png", dpi=150)
plt.close()

df[df["Is_Outlier"]].to_csv("outliers_removed.csv", index=False)
clean.to_csv("hospital_admissions_clean.csv", index=False)

# ---------- 4. Average LOS per department ----------
avg_los = (
    clean.groupby("Department")[col]
    .agg(Patients="count", Avg_LOS_Days="mean", Median_LOS_Days="median")
    .round(2)
    .sort_values("Avg_LOS_Days", ascending=False)
)
avg_los.to_csv("avg_los_per_department.csv")
print("\nAverage LOS per department:\n", avg_los)

plt.figure(figsize=(9, 5))
sns.barplot(x=avg_los.index, y=avg_los["Avg_LOS_Days"], color="#2F5496")
plt.title("Average Length of Stay per Department (outliers removed)")
plt.ylabel("Average LOS (days)")
plt.xlabel("Department")
plt.xticks(rotation=40, ha="right")
plt.tight_layout()
plt.savefig("chart_avg_los_per_department.png", dpi=150)
plt.close()

# ---------- 5. Seasonal trend: admissions per month ----------
month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
monthly = clean["Month_Name"].value_counts().reindex(month_order)
monthly.to_csv("monthly_admissions.csv", header=["Admissions"])

plt.figure(figsize=(9, 5))
sns.lineplot(x=monthly.index, y=monthly.values, marker="o", color="#C55A11")
plt.title("Monthly Patient Admissions (Seasonal Trend)")
plt.ylabel("Number of admissions")
plt.xlabel("Month")
plt.tight_layout()
plt.savefig("chart_monthly_admissions.png", dpi=150)
plt.close()

# ---------- 6. Admissions by season ----------
season_order = ["Winter", "Summer", "Monsoon", "Post-Monsoon"]
by_season = clean["Season"].value_counts().reindex(season_order)
by_season.to_csv("admissions_by_season.csv", header=["Admissions"])

plt.figure(figsize=(7, 5))
sns.barplot(x=by_season.index, y=by_season.values, color="#7030A0")
plt.title("Admissions by Season")
plt.ylabel("Number of admissions")
plt.tight_layout()
plt.savefig("chart_admissions_by_season.png", dpi=150)
plt.close()

# ---------- 7. Heatmap: department x month ----------
pivot = pd.crosstab(clean["Department"], clean["Month_Name"]).reindex(columns=month_order)
plt.figure(figsize=(11, 5))
sns.heatmap(pivot, annot=True, fmt="d", cmap="YlOrRd")
plt.title("Admissions: Department vs Month")
plt.tight_layout()
plt.savefig("chart_heatmap_dept_month.png", dpi=150)
plt.close()

print("\nMonthly admissions:\n", monthly)
print("\nBy season:\n", by_season)
print("\nDone. Charts and CSV summaries saved.")
