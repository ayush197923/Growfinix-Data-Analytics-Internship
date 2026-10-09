# Task 4: Media Production Cost Tracking (SQL & Spreadsheets)
**Growfinix Data Analytics Internship - Month 1**

## Objective
Analyze a dataset of production costs for digital media assets. Categorize expenses for ultra-realistic DSLR portraits versus cinematic animation videos, and calculate the ROI for different media formats.

## Tools Used
- SQL (SQLite for local testing; the queries are standard SQL and work in MySQL/PostgreSQL)
- Google Sheets / Excel (formulas: SUMIF, AVERAGEIF, COUNTIF, INDEX/MATCH)

## Dataset
`media_production_costs.csv` / `media_production.db` - 120 synthetic media assets across 5 formats
(DSLR Portrait, Cinematic Animation Video, Product Photo, Short Reel, Infographic) with columns:
`asset_id, asset_name, media_type, category, production_date, equipment_cost, labor_cost, software_cost, post_production_cost, revenue_generated, hours_spent`

## Approach
1. Calculated **Total Cost** = equipment + labor + software + post-production for every asset
2. **Categorized expenses** for DSLR Portraits vs Cinematic Animation Videos (average cost per category and percentage share)
3. Calculated **ROI %** = (Revenue - Cost) / Cost x 100 for every media format
4. Used **window functions** (`RANK()` and `ROW_NUMBER() ... PARTITION BY`) to rank formats by ROI and find the best asset in each format
5. Rebuilt the same analysis in a spreadsheet with live formulas to cross-check the SQL results

## Queries (`media_cost_roi_queries.sql`)
| # | Query | Technique |
|---|---|---|
| 1 | Top 10 assets by profit | Derived columns |
| 2 | Average cost breakdown: DSLR Portrait vs Cinematic Animation | GROUP BY, AVG |
| 3 | Expense share (%) per cost type, per format | SUM ratios |
| 4 | ROI per media format | GROUP BY, aggregate math |
| 5 | Rank formats by ROI | Window function `RANK()` |
| 6 | Best asset inside each format | Window function `ROW_NUMBER() OVER (PARTITION BY ...)` |

## Results

**Expense breakdown (average per asset):**
| Media Type | Equipment | Labor | Software | Post-Production | Total |
|---|---|---|---|---|---|
| DSLR Portrait | 1,587 | 2,535 | 242 | 849 | 5,214 |
| Cinematic Animation Video | 1,105 | 12,596 | 1,507 | 5,337 | 20,545 |

**ROI by media format:**
| Rank | Media Type | Total Cost | Total Revenue | ROI % |
|---|---|---|---|---|
| 1 | Short Reel | 99,629 | 260,723 | 161.69 |
| 2 | Product Photo | 72,944 | 179,367 | 145.90 |
| 3 | DSLR Portrait | 125,129 | 303,355 | 142.43 |
| 4 | Infographic | 39,197 | 89,334 | 127.91 |
| 5 | Cinematic Animation Video | 493,091 | 900,893 | 82.70 |

## Key Findings
- **Labor is the biggest cost driver** for both formats, but it is far heavier for animation (about 61% of cost) than for DSLR portraits (about 49%).
- DSLR portraits spend a much larger share on **equipment** (about 30%) than animation videos (about 5%).
- A cinematic animation video costs roughly **4x more** than a DSLR portrait on average.
- Animation videos earn the highest total profit but have the **lowest ROI (82.7%)**, so high spend does not mean high return per rupee.
- **Short Reels** give the best ROI (161.69%), followed by Product Photos and DSLR Portraits.

## Files in this Folder
| File | Description |
|---|---|
| `media_production_costs.csv` | Dataset (CSV) |
| `media_production.db` | Same data as a SQLite database |
| `media_cost_roi_queries.sql` | All 6 SQL queries with comments |
| `Media_Cost_ROI_Tracker.xlsx` | Spreadsheet with live formulas (open in Google Sheets or Excel) |
| `README.md` | This file |

## How to Run
- **SQL:** open `media_production.db` in DB Browser for SQLite and run the queries from the `.sql` file.
- **Google Sheets:** upload `Media_Cost_ROI_Tracker.xlsx` to Google Drive and open it with Google Sheets. The `ROI_Summary` sheet calculates everything from the `Asset_Data` sheet.

---
*Submitted as part of the Growfinix Technology Data Analytics Internship - Month 1, Task 4.*
