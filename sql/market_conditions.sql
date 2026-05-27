-- market_conditions.sql
-- Layoff and hiring behaviour broken down by market condition.

SELECT
    market_condition,
    company_size,
    COUNT(*)                                AS event_count,
    SUM(layoffs_count)                      AS total_layoffs,
    ROUND(AVG(layoff_percentage), 2)        AS avg_layoff_pct,
    ROUND(AVG(stock_growth_percent), 2)     AS avg_stock_growth,
    ROUND(AVG(revenue_growth_percent), 2)   AS avg_revenue_growth,
    ROUND(AVG(financial_health), 2)         AS avg_financial_health,
    ROUND(AVG(employee_sentiment), 2)       AS avg_sentiment,
    ROUND(AVG(job_security_score), 2)       AS avg_job_security,
    ROUND(
        100.0 * SUM(is_hiring) / COUNT(*), 2
    )                                       AS pct_hiring
FROM layoffs_events
GROUP BY market_condition, company_size
ORDER BY market_condition, company_size;