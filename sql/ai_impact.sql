-- ai_impact.sql
-- AI automation impact and replacement risk by industry and company size.

-- 1. AI risk tiers by industry
SELECT
    industry,
    ai_risk_tier,
    COUNT(*)                                AS event_count,
    SUM(layoffs_count)                      AS total_layoffs,
    ROUND(AVG(ai_automation_impact), 2)     AS avg_automation_impact,
    ROUND(AVG(ai_replacement_risk), 2)      AS avg_replacement_risk,
    ROUND(AVG(ai_adoption_level), 2)        AS avg_adoption_level,
    ROUND(AVG(job_security_score), 2)       AS avg_job_security
FROM layoffs_events
GROUP BY industry, ai_risk_tier
ORDER BY industry, avg_replacement_risk DESC;

-- 2. Correlation proxy: AI adoption vs. layoffs
SELECT
    CASE
        WHEN ai_adoption_level < 3  THEN 'Low Adoption (0-3)'
        WHEN ai_adoption_level < 7  THEN 'Medium Adoption (3-7)'
        ELSE                             'High Adoption (7-10)'
    END                                     AS adoption_bucket,
    COUNT(*)                                AS event_count,
    ROUND(AVG(layoffs_count), 0)            AS avg_layoffs,
    ROUND(AVG(layoff_percentage), 2)        AS avg_layoff_pct,
    ROUND(AVG(open_roles), 0)               AS avg_open_roles,
    ROUND(AVG(employee_sentiment), 2)       AS avg_sentiment
FROM layoffs_events
GROUP BY adoption_bucket
ORDER BY adoption_bucket;