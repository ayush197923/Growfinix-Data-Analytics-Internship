# Task 5: Healthcare Patient Admission Trends (EDA)
**Growfinix Data Analytics Internship - Month 1**

## Objective
Process a healthcare dataset that tracks hospital admissions. Identify seasonal trends in patient visits, calculate the average length of stay (LOS) per department, and handle outliers using a statistical method (the IQR rule).

## Tools Used
- Python
- Pandas
- Seaborn
- Matplotlib

## Dataset
`hospital_admissions.csv` - 1,500 synthetic patient admission records (year 2025) with columns:
`Patient_ID, Admission_Date, Department, Age, Gender, Admission_Type, Length_of_Stay_Days, Treatment_Cost_INR`

## Steps Taken
1. **Loaded and inspected** the data (shape, missing values, summary statistics). `Treatment_Cost_INR` had 20 missing values, which were filled with the median of the same department.
2. **Created date features:** month, month name and season (Winter, Summer, Monsoon, Post-Monsoon) from `Admission_Date`.
3. **Detected outliers with the IQR rule** on `Length_of_Stay_Days`:
   - Q1 = 3, Q3 = 7, IQR = 4
   - Lower bound = Q1 - 1.5 x IQR = -3, Upper bound = Q3 + 1.5 x IQR = 13
   - **39 records** had a stay longer than 13 days and were treated as outliers
4. **Removed the outliers** (1,500 rows down to 1,461) and compared boxplots before and after.
5. **Calculated the average LOS per department** on the cleaned data.
6. **Analyzed seasonality** with monthly admissions, admissions by season, and a department-by-month heatmap.

## Key Findings
- **Longest average stay:** Oncology (8.77 days), then Neurology (6.99) and Orthopedics (6.13).
- **Shortest average stay:** Emergency (2.57 days) and Pediatrics (3.53).
- **Seasonality:** admissions peak in **January, July-August and December**, and are lowest in **April-May**. By season, **Monsoon (529)** and **Winter (446)** are far busier than Summer (284) and Post-Monsoon (202).
- Without outlier removal, a few very long stays (up to 88 days) pulled the average LOS up (overall mean 5.81 days vs a median of 4), which is why the IQR rule was applied.

## Files in this Folder
| File | Description |
|---|---|
| `hospital_admissions.csv` | Raw dataset |
| `hospital_admissions_eda.py` | Full EDA script |
| `hospital_admissions_clean.csv` | Dataset after outlier removal |
| `outliers_removed.csv` | The 39 outlier records that were removed |
| `avg_los_per_department.csv` | Average and median LOS per department |
| `monthly_admissions.csv` | Admissions per month |
| `admissions_by_season.csv` | Admissions per season |
| `chart_los_boxplot_before.png` | Boxplot of LOS before outlier removal |
| `chart_los_boxplot_after.png` | Boxplot of LOS after outlier removal |
| `chart_avg_los_per_department.png` | Bar chart of average LOS per department |
| `chart_monthly_admissions.png` | Line chart of monthly admissions |
| `chart_admissions_by_season.png` | Bar chart of admissions by season |
| `chart_heatmap_dept_month.png` | Heatmap of department vs month |

## How to Run
```bash
pip install pandas seaborn matplotlib
python hospital_admissions_eda.py
```

---
*Submitted as part of the Growfinix Technology Data Analytics Internship - Month 1, Task 5.*
