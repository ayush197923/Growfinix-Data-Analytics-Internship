-- ============================================================
-- Task 2: Sports Analytics & Performance Metrics (SQL)
-- Growfinix Data Analytics Internship — Month 1
-- Database: ipl_matches.db (SQLite) / works in MySQL & PostgreSQL with minor syntax tweaks
-- ============================================================

-- Table structure:
-- matches(match_id, season, match_date, team1, team2, stadium,
--         toss_winner, winner, team1_runs, team2_runs, team1_overs, team2_overs)


-- ------------------------------------------------------------
-- Query 1: KKR's Historical Win Rate Across Different Stadiums
-- Uses: JOIN-free self logic via UNION + GROUP BY
-- ------------------------------------------------------------
WITH kkr_matches AS (
    SELECT match_id, stadium,
           CASE WHEN winner = 'Kolkata Knight Riders' THEN 1 ELSE 0 END AS is_win
    FROM matches
    WHERE team1 = 'Kolkata Knight Riders' OR team2 = 'Kolkata Knight Riders'
)
SELECT
    stadium,
    COUNT(*) AS matches_played,
    SUM(is_win) AS matches_won,
    ROUND(100.0 * SUM(is_win) / COUNT(*), 2) AS win_rate_pct
FROM kkr_matches
GROUP BY stadium
ORDER BY win_rate_pct DESC;


-- ------------------------------------------------------------
-- Query 2: KKR's Average Run Rate Across Different Stadiums
-- (runs scored by KKR per match, whether team1 or team2)
-- ------------------------------------------------------------
SELECT
    stadium,
    ROUND(AVG(
        CASE
            WHEN team1 = 'Kolkata Knight Riders' THEN team1_runs * 1.0 / team1_overs
            WHEN team2 = 'Kolkata Knight Riders' THEN team2_runs * 1.0 / team2_overs
        END
    ), 2) AS avg_run_rate
FROM matches
WHERE team1 = 'Kolkata Knight Riders' OR team2 = 'Kolkata Knight Riders'
GROUP BY stadium
ORDER BY avg_run_rate DESC;


-- ------------------------------------------------------------
-- Query 3: Season-wise KKR Win Rate (JOIN example with a seasons lookup)
-- Demonstrates JOIN even though season is already in matches table,
-- by joining against a small reference table of season labels.
-- ------------------------------------------------------------
-- (Optional reference table, included for JOIN demonstration)
-- CREATE TABLE season_labels (season INTEGER PRIMARY KEY, era_label TEXT);

SELECT
    m.season,
    COUNT(*) AS matches_played,
    SUM(CASE WHEN m.winner = 'Kolkata Knight Riders' THEN 1 ELSE 0 END) AS matches_won,
    ROUND(100.0 * SUM(CASE WHEN m.winner = 'Kolkata Knight Riders' THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_rate_pct
FROM matches m
WHERE m.team1 = 'Kolkata Knight Riders' OR m.team2 = 'Kolkata Knight Riders'
GROUP BY m.season
ORDER BY m.season;


-- ------------------------------------------------------------
-- Query 4: WINDOW FUNCTION — Running (cumulative) win rate of KKR
-- over time, match by match, using a window frame
-- ------------------------------------------------------------
WITH kkr_matches AS (
    SELECT
        match_id,
        match_date,
        stadium,
        CASE WHEN winner = 'Kolkata Knight Riders' THEN 1 ELSE 0 END AS is_win
    FROM matches
    WHERE team1 = 'Kolkata Knight Riders' OR team2 = 'Kolkata Knight Riders'
)
SELECT
    match_id,
    match_date,
    stadium,
    is_win,
    SUM(is_win) OVER (ORDER BY match_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_wins,
    ROUND(100.0 * SUM(is_win) OVER (ORDER BY match_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
          / ROW_NUMBER() OVER (ORDER BY match_date), 2) AS running_win_rate_pct
FROM kkr_matches
ORDER BY match_date;


-- ------------------------------------------------------------
-- Query 5: WINDOW FUNCTION — Rank stadiums by KKR win rate
-- using RANK()
-- ------------------------------------------------------------
WITH kkr_matches AS (
    SELECT stadium,
           CASE WHEN winner = 'Kolkata Knight Riders' THEN 1 ELSE 0 END AS is_win
    FROM matches
    WHERE team1 = 'Kolkata Knight Riders' OR team2 = 'Kolkata Knight Riders'
),
stadium_stats AS (
    SELECT
        stadium,
        COUNT(*) AS matches_played,
        ROUND(100.0 * SUM(is_win) / COUNT(*), 2) AS win_rate_pct
    FROM kkr_matches
    GROUP BY stadium
)
SELECT
    stadium,
    matches_played,
    win_rate_pct,
    RANK() OVER (ORDER BY win_rate_pct DESC) AS win_rate_rank
FROM stadium_stats
ORDER BY win_rate_rank;
