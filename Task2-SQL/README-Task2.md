# Task 2: Sports Analytics & Performance Metrics (SQL)
**Growfinix Data Analytics Internship — Month 1**

## Objective
Extract insights from an IPL match history database. Write SQL queries using JOIN, GROUP BY, and Window Functions to calculate Kolkata Knight Riders' (KKR) historical win rate and average run rate across different stadiums.

## Tools Used
- SQL (SQLite for local testing — syntax is standard and works with minor tweaks in MySQL/PostgreSQL)

## Dataset
`ipl_matches.db` / `ipl_matches.csv` — 280 synthetic IPL match records (2018–2024) with columns:
`match_id, season, match_date, team1, team2, stadium, toss_winner, winner, team1_runs, team2_runs, team1_overs, team2_overs`

## Queries Written (`kkr_analysis_queries.sql`)
1. **KKR Win Rate by Stadium** — GROUP BY + conditional aggregation (CASE + SUM)
2. **KKR Average Run Rate by Stadium** — GROUP BY + AVG on runs/overs
3. **Season-wise KKR Win Rate** — JOIN-style query grouping by season
4. **Running/Cumulative Win Rate Over Time** — Window Function (`SUM() OVER`, `ROW_NUMBER() OVER`)
5. **Stadium Ranking by Win Rate** — Window Function (`RANK() OVER`)

## Sample Results

**KKR Win Rate by Stadium (top rows):**
| Stadium | Matches Played | Matches Won | Win Rate % |
|---|---|---|---|
| Arun Jaitley Stadium | 5 | 4 | 80.00 |
| Wankhede Stadium | 10 | 5 | 50.00 |
| MA Chidambaram Stadium | 10 | 5 | 50.00 |

**KKR Average Run Rate by Stadium (top rows):**
| Stadium | Avg Run Rate |
|---|---|
| Arun Jaitley Stadium | 9.90 |
| Rajiv Gandhi Stadium | 9.16 |
| M. Chinnaswamy Stadium | 9.00 |

**Stadium Rank by Win Rate (Window Function output):**
| Stadium | Matches Played | Win Rate % | Rank |
|---|---|---|---|
| Arun Jaitley Stadium | 5 | 80.00 | 1 |
| MA Chidambaram Stadium | 10 | 50.00 | 2 |

## Key Findings
- KKR's **best stadium by win rate** is Arun Jaitley Stadium (80%)
- KKR's **highest scoring venue** (by run rate) is also Arun Jaitley Stadium
- **Eden Gardens**, despite being KKR's home ground, shows a comparatively lower win rate in this dataset — a useful (if surprising) EDA insight worth double-checking against real data

## Files in this Repo
| File | Description |
|---|---|
| `ipl_matches.db` | SQLite database file |
| `ipl_matches.csv` | Same data as CSV (for easy import into any SQL tool) |
| `kkr_analysis_queries.sql` | All 5 SQL queries with comments |
| `README.md` | This file |

## How to Run
Open `ipl_matches.db` in any SQLite browser (e.g. DB Browser for SQLite, or `sqlite3` CLI) and run the queries from `kkr_analysis_queries.sql`. To use in MySQL/PostgreSQL, import `ipl_matches.csv` into a `matches` table first.

---
*Submitted as part of the Growfinix Technology Data Analytics Internship — Month 1, Task 2.*
