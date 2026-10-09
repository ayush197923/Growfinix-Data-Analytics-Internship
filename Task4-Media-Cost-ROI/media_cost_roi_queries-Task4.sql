-- ============================================================
-- Task 4: Media Production Cost Tracking (SQL & Spreadsheets)
-- Growfinix Data Analytics Internship - Month 1
-- Database: media_production.db (SQLite); standard SQL, works in MySQL/PostgreSQL
-- ============================================================
-- Table: media_assets(asset_id, asset_name, media_type, category, production_date,
--        equipment_cost, labor_cost, software_cost, post_production_cost,
--        revenue_generated, hours_spent)


-- ------------------------------------------------------------
-- Query 1: Total production cost per asset (derived column)
-- ------------------------------------------------------------
SELECT
    asset_id,
    asset_name,
    media_type,
    equipment_cost + labor_cost + software_cost + post_production_cost AS total_cost,
    revenue_generated,
    revenue_generated - (equipment_cost + labor_cost + software_cost + post_production_cost) AS profit
FROM media_assets
ORDER BY profit DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 2: Expense categorization - DSLR Portraits vs Cinematic Animation Videos
-- Shows where the money goes for each of the two formats
-- ------------------------------------------------------------
SELECT
    media_type,
    COUNT(*)                              AS assets_produced,
    ROUND(AVG(equipment_cost), 0)         AS avg_equipment,
    ROUND(AVG(labor_cost), 0)             AS avg_labor,
    ROUND(AVG(software_cost), 0)          AS avg_software,
    ROUND(AVG(post_production_cost), 0)   AS avg_post_production,
    ROUND(AVG(equipment_cost + labor_cost + software_cost + post_production_cost), 0) AS avg_total_cost
FROM media_assets
WHERE media_type IN ('DSLR Portrait', 'Cinematic Animation Video')
GROUP BY media_type;


-- ------------------------------------------------------------
-- Query 3: Expense share (%) by cost type for each media format
-- ------------------------------------------------------------
SELECT
    media_type,
    ROUND(100.0 * SUM(equipment_cost)       / SUM(equipment_cost + labor_cost + software_cost + post_production_cost), 1) AS equipment_pct,
    ROUND(100.0 * SUM(labor_cost)           / SUM(equipment_cost + labor_cost + software_cost + post_production_cost), 1) AS labor_pct,
    ROUND(100.0 * SUM(software_cost)        / SUM(equipment_cost + labor_cost + software_cost + post_production_cost), 1) AS software_pct,
    ROUND(100.0 * SUM(post_production_cost) / SUM(equipment_cost + labor_cost + software_cost + post_production_cost), 1) AS post_pct
FROM media_assets
GROUP BY media_type
ORDER BY media_type;


-- ------------------------------------------------------------
-- Query 4: ROI per media format
-- ROI % = (Revenue - Cost) / Cost * 100
-- ------------------------------------------------------------
SELECT
    media_type,
    SUM(equipment_cost + labor_cost + software_cost + post_production_cost) AS total_cost,
    SUM(revenue_generated)                                                   AS total_revenue,
    ROUND(100.0 * (SUM(revenue_generated) - SUM(equipment_cost + labor_cost + software_cost + post_production_cost))
          / SUM(equipment_cost + labor_cost + software_cost + post_production_cost), 2) AS roi_pct
FROM media_assets
GROUP BY media_type
ORDER BY roi_pct DESC;


-- ------------------------------------------------------------
-- Query 5: WINDOW FUNCTION - Rank media formats by ROI
-- ------------------------------------------------------------
WITH format_roi AS (
    SELECT
        media_type,
        category,
        SUM(equipment_cost + labor_cost + software_cost + post_production_cost) AS total_cost,
        SUM(revenue_generated) AS total_revenue
    FROM media_assets
    GROUP BY media_type, category
)
SELECT
    media_type,
    category,
    total_cost,
    total_revenue,
    ROUND(100.0 * (total_revenue - total_cost) / total_cost, 2) AS roi_pct,
    RANK() OVER (ORDER BY (total_revenue - total_cost) * 1.0 / total_cost DESC) AS roi_rank
FROM format_roi
ORDER BY roi_rank;


-- ------------------------------------------------------------
-- Query 6: WINDOW FUNCTION - Best asset within each media format (by ROI)
-- ------------------------------------------------------------
WITH asset_roi AS (
    SELECT
        asset_name,
        media_type,
        ROUND(100.0 * (revenue_generated - (equipment_cost + labor_cost + software_cost + post_production_cost))
              / (equipment_cost + labor_cost + software_cost + post_production_cost), 2) AS roi_pct
    FROM media_assets
)
SELECT media_type, asset_name, roi_pct
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY media_type ORDER BY roi_pct DESC) AS rn
    FROM asset_roi
)
WHERE rn = 1
ORDER BY roi_pct DESC;
