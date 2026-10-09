# Task 3: Customer Demographic Analysis (Python)
**Growfinix Data Analytics Internship — Month 1**

## Objective
Load a CSV file containing tour enquiries and perform Exploratory Data Analysis (EDA) to find the most popular travel destinations and understand the customer base by age and income bracket.

## Tools Used
- Python
- Pandas
- Matplotlib

## Dataset
`tour_enquiries.csv` — 500 synthetic tour enquiry records with columns:
`Enquiry_ID, Customer_Name, Age, Income_Bracket, Destination, Enquiry_Date, Budget_INR, Family_Size`

## Steps Taken
1. **Load & inspect data** — checked shape and missing values (`Budget_INR` had 15 missing entries)
2. **Handled missing values** — filled missing `Budget_INR` with the column median
3. **Created Age Brackets** — binned raw `Age` into 5 groups (18-25, 26-35, 36-45, 46-55, 56-65) using `pd.cut`
4. **Found most popular destinations** — used `value_counts()` on `Destination`, visualized as a bar chart
5. **Grouped by Age Bracket** — enquiry counts and average budget/family size per age group
6. **Grouped by Income Bracket** — enquiry counts per income bracket
7. **Age distribution** — plotted a histogram of customer ages
8. **Cross-tab analysis** — destination popularity broken down by income bracket

## Key Findings
- **Goa, Manali, and Jaipur** are the top 3 most enquired destinations
- Enquiries are fairly evenly spread across age brackets, with **26-35 and 46-55** age groups slightly more active
- Majority of enquiries fall in the **Medium (5-10L)** income bracket

## Files in this Repo
| File | Description |
|---|---|
| `tour_enquiries.csv` | Raw dataset |
| `tour_enquiries_eda.py` | Python script performing the full EDA |
| `chart_popular_destinations.png` | Bar chart — most popular destinations |
| `chart_age_bracket.png` | Bar chart — enquiries by age bracket |
| `chart_income_bracket.png` | Bar chart — enquiries by income bracket |
| `chart_age_histogram.png` | Histogram — age distribution |
| `summary_by_age_bracket.csv` | Avg budget & family size per age bracket |
| `destination_by_income_crosstab.csv` | Destination popularity by income bracket |

## How to Run
```bash
pip install pandas matplotlib
python tour_enquiries_eda.py
```

---
*Submitted as part of the Growfinix Technology Data Analytics Internship — Month 1, Task 3.*
