# Task 1: Real Estate Market Data Cleaning (Excel / Power Query)
**Growfinix Data Analytics Internship — Month 1**

## Objective
Clean a messy, unstructured dataset of property listings for Manresa Real Estate and merge it with historical sales records using lookup functions.

## Tools Used
- Microsoft Excel
- Power Query
- INDEX/MATCH (lookup formulas)

## Problems Found in Raw Data (`Property_Listings_RAW` sheet)
- **Duplicate rows** — 3 exact duplicate listings
- **Missing Zip Codes** — ~30% of rows had blank zip codes
- **Inconsistent text formatting** — City, State, Property Type, and Agent Name columns had mixed case and extra spaces (e.g. "manresa", "MANRESA", "Manresa ")
- **Inconsistent price formatting** — some prices stored as text with `$` and `,` (e.g. `"$599,000"`) mixed with plain numbers
- **Missing values** — some Bedrooms cells were blank

## Steps Taken
1. Loaded `Property_Listings_RAW` into Power Query (Data → From Table/Range)
2. Removed exact duplicate rows (Home → Remove Rows → Remove Duplicates)
3. Trimmed extra spaces and applied consistent capitalization to City, State, Property Type, and Agent Name using Trim + Capitalize
4. Replaced blank Zip Codes with `"Unknown"` as a placeholder
5. Cleaned the List Price column by stripping `$` and `,` and converting to numeric type
6. Merged with `Historical_Sales` sheet using **Listing ID** as the key (Left Outer Join) to bring in `Last Sale Price` and `Days on Market`
7. Verified the merge independently using **INDEX/MATCH** formulas as a cross-check

## Output
`Cleaned_Listings` sheet contains the final cleaned and merged dataset — one row per unique listing, standardized text, numeric prices, and merged sale history (listings with no sale history are flagged `"No Sale History"`).

## Files in this Repo
| File | Description |
|---|---|
| `Manresa_RealEstate_Messy_Data.xlsx` | Original raw/messy dataset |
| `Manresa_RealEstate_CLEANED_Solution.xlsx` | Final cleaned & merged dataset |
| `screenshots/` | Before/after screenshots of Power Query steps |
| `README.md` | This file |

## Key Learning
Power Query is far more efficient than manual find-and-replace for repeatable data cleaning — the same query can be refreshed on new raw data without redoing every step manually.

---
*Submitted as part of the Growfinix Technology Data Analytics Internship — Month 1, Task 1.*
