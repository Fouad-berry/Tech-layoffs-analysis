# Data Dictionary

## Source: `tech_layoffs_hiring_trends.csv`

12 000 rows · 23 raw columns + 7 engineered columns

---

### Raw columns

| Column | Type | Values / Range | Description |
|---|---|---|---|
| `record_id` | str | T0 … T11999 | Unique row identifier |
| `company_name` | str | — | Name of the company |
| `industry` | str | AI, Cloud, Cybersecurity, E-Commerce, FinTech, Gaming, Social Media | Sector |
| `country` | str | Canada, India, Singapore, UK, USA, … | Country of layoff event |
| `company_size` | str | Startup, Mid-size, Big Tech, Enterprise | Size bucket |
| `month` | str | Jan … Dec | Month of event |
| `year` | int | 2024, 2025, 2026 | Year of event |
| `layoffs_count` | int | 0 – 19 999 | Absolute number of employees laid off |
| `layoff_percentage` | float | 0.0 – 100.0 | % of workforce laid off |
| `reason_for_layoffs` | str | AI Automation, Cost Cutting, Market Slowdown, Overhiring Correction, Restructuring | Primary reason given |
| `ai_automation_impact` | float | 0 – 10 | Score: extent of automation involvement |
| `ai_replacement_risk` | float | 0 – 10 | Score: risk of AI replacing these roles |
| `open_roles` | int | 0 – ~10 000 | Number of open positions at time of event |
| `hiring_trend` | str | Aggressive Hiring, Moderate Hiring, Hiring Freeze, Downsizing | Current hiring posture |
| `remote_jobs_percentage` | float | 0 – 100 | % of open roles that are remote |
| `top_hiring_role` | str | ML Engineer, Frontend Developer, … | Most in-demand role |
| `stock_growth_percent` | float | negative – positive | YoY stock growth % |
| `revenue_growth_percent` | float | negative – positive | YoY revenue growth % |
| `salary_budget_change` | float | negative – positive | Change in salary budget % |
| `ai_adoption_level` | float | 0 – 10 | Company-level AI adoption score |
| `employee_sentiment` | float | 0 – 10 | Internal sentiment score |
| `job_security_score` | float | 0 – 10 | Perceived job security score |
| `market_condition` | str | Bull Market, Recession, Stable | Macro market state |

---

### Engineered columns (added in `clean_transform.py`)

| Column | Type | Description |
|---|---|---|
| `date` | date | First day of the event month (YYYY-MM-01) |
| `month_num` | int | Month as integer (1–12) — dropped in export |
| `net_hiring_ratio` | float | `open_roles / layoffs_count` — hiring momentum proxy |
| `ai_risk_tier` | str | Low Risk (0–3) / Medium Risk (3–7) / High Risk (7–10) |
| `financial_health` | float | `stock_growth * 0.4 + revenue_growth * 0.6` |
| `quarter` | str | Q1 / Q2 / Q3 / Q4 |
| `year_quarter` | str | e.g. `2025 Q2` |
| `is_hiring` | int | 1 if `hiring_trend` ∈ {Aggressive, Moderate}, else 0 |