-- hiring_trends.sql
-- Hiring trend distribution and open-roles analysis.

-- 1. Hiring trend counts by industry
SELECT
    industry,
    hiring_trend,
    COUNT(*)                            AS event_count,
    ROUND(AVG(open_roles), 0)           AS avg_open_roles,
    ROUND(AVG(remote_jobs_percentage), 2) AS avg_remote_pct,
    top_hiring_role
FROM layoffs_events
GROUP BY industry, hiring_trend, top_hiring_role
ORDER BY industry, event_count DESC;

-- 2. Monthly hiring momentum (rolling 3-month trend)
SELECT
    year_quarter,
    year,
    quarter,
    ROUND(AVG(open_roles), 0)           AS avg_open_roles,
    SUM(layoffs_count)                  AS total_layoffs,
    ROUND(
        100.0 * SUM(is_hiring) / COUNT(*), 2
    )                                   AS pct_hiring,
    ROUND(AVG(salary_budget_change), 2) AS avg_salary_change
FROM layoffs_events
GROUP BY year_quarter, year, quarter
ORDER BY year, quarter;