"""
Task 3: Customer Demographic Analysis (Python)
Growfinix Data Analytics Internship — Month 1

Goal: Load tour enquiry data, perform EDA to find popular destinations,
and group customers by age bracket and income bracket.
"""

import pandas as pd
import matplotlib.pyplot as plt

# ---------- 1. Load Data ----------
df = pd.read_csv("tour_enquiries.csv", parse_dates=["Enquiry_Date"])

print("Shape:", df.shape)
print("\nMissing values per column:\n", df.isnull().sum())

# Handle missing Budget values -> fill with median (simple, defensible EDA approach)
df["Budget_INR"] = df["Budget_INR"].fillna(df["Budget_INR"].median())

# ---------- 2. Create Age Brackets ----------
bins = [18, 25, 35, 45, 55, 65]
labels = ["18-25", "26-35", "36-45", "46-55", "56-65"]
df["Age_Bracket"] = pd.cut(df["Age"], bins=bins, labels=labels, include_lowest=True)

# ---------- 3. Most Popular Destinations ----------
dest_counts = df["Destination"].value_counts()
print("\nTop destinations:\n", dest_counts.head())

plt.figure(figsize=(9, 5))
dest_counts.plot(kind="bar", color="#2F5496")
plt.title("Most Popular Travel Destinations (Tour Enquiries)")
plt.xlabel("Destination")
plt.ylabel("Number of Enquiries")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("chart_popular_destinations.png", dpi=150)
plt.close()

# ---------- 4. Enquiries by Age Bracket ----------
age_counts = df["Age_Bracket"].value_counts().sort_index()

plt.figure(figsize=(7, 5))
age_counts.plot(kind="bar", color="#548235")
plt.title("Tour Enquiries by Age Bracket")
plt.xlabel("Age Bracket")
plt.ylabel("Number of Enquiries")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("chart_age_bracket.png", dpi=150)
plt.close()

# ---------- 5. Enquiries by Income Bracket ----------
income_order = ["Low (<5L)", "Medium (5-10L)", "High (10-20L)", "Premium (>20L)"]
income_counts = df["Income_Bracket"].value_counts().reindex(income_order)

plt.figure(figsize=(7, 5))
income_counts.plot(kind="bar", color="#C55A11")
plt.title("Tour Enquiries by Income Bracket")
plt.xlabel("Income Bracket")
plt.ylabel("Number of Enquiries")
plt.xticks(rotation=15)
plt.tight_layout()
plt.savefig("chart_income_bracket.png", dpi=150)
plt.close()

# ---------- 6. Age Distribution Histogram ----------
plt.figure(figsize=(7, 5))
df["Age"].plot(kind="hist", bins=15, color="#7030A0", edgecolor="white")
plt.title("Age Distribution of Enquiring Customers")
plt.xlabel("Age")
plt.ylabel("Frequency")
plt.tight_layout()
plt.savefig("chart_age_histogram.png", dpi=150)
plt.close()

# ---------- 7. Cross-tab: Destination popularity by Income Bracket ----------
cross = pd.crosstab(df["Destination"], df["Income_Bracket"])
cross.to_csv("destination_by_income_crosstab.csv")

# ---------- 8. Summary stats ----------
summary = df.groupby("Age_Bracket", observed=True).agg(
    Avg_Budget=("Budget_INR", "mean"),
    Avg_Family_Size=("Family_Size", "mean"),
    Total_Enquiries=("Enquiry_ID", "count")
).round(0)
summary.to_csv("summary_by_age_bracket.csv")
print("\nSummary by age bracket:\n", summary)

print("\nDone. Charts and summary CSVs saved in current folder.")
