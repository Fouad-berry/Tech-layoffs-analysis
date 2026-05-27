-- create_tables.sql
-- DDL for DuckDB (local) or BigQuery.
-- DuckDB: run with `duckdb layoffs.duckdb < sql/create_tables.sql`
-- BigQuery: replace CREATE TABLE with `CREATE OR REPLACE TABLE project.dataset.table`

-- ─── Raw events table ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS layoffs_events (
    record_id              VARCHAR,
    company_name           VARCHAR,
    industry               VARCHAR,
    country                VARCHAR,
    company_size           VARCHAR,
    month                  VARCHAR,
    year                   INTEGER,
    layoffs_count          INTEGER,
    layoff_percentage      DOUBLE,
    reason_for_layoffs     VARCHAR,
    ai_automation_impact   DOUBLE,
    ai_replacement_risk    DOUBLE,
    open_roles             INTEGER,
    hiring_trend           VARCHAR,
    remote_jobs_percentage DOUBLE,
    top_hiring_role        VARCHAR,
    stock_growth_percent   DOUBLE,
    revenue_growth_percent DOUBLE,
    salary_budget_change   DOUBLE,
    ai_adoption_level      DOUBLE,
    employee_sentiment     DOUBLE,
    job_security_score     DOUBLE,
    market_condition       VARCHAR,
    -- Engineered columns
    date                   DATE,
    net_hiring_ratio       DOUBLE,
    ai_risk_tier           VARCHAR,
    financial_health       DOUBLE,
    quarter                VARCHAR,
    year_quarter           VARCHAR,
    is_hiring              INTEGER,
    PRIMARY KEY (record_id)
);

-- Load from processed CSV (DuckDB syntax)
-- COPY layoffs_events FROM 'data/processed/layoffs_clean.csv' (HEADER TRUE);