# 📊 Tech Layoffs & Hiring Trends — Data Analysis Project

A complete end-to-end data analysis pipeline on tech industry layoffs and hiring trends (2024–2026), with Python-based ETL, SQL analytics, and Looker Studio dashboards.

---

## 📁 Project Structure

```
tech-layoffs-analysis/
│
├── data/
│   ├── raw/                        # Original CSV dataset (do not modify)
│   ├── processed/                  # Cleaned & transformed data
│   └── exports/                    # Final CSVs ready for Looker / BigQuery
│
├── notebooks/
│   ├── 01_exploration.ipynb        # EDA — distributions, nulls, correlations
│   ├── 02_cleaning.ipynb           # Cleaning & feature engineering
│   └── 03_analysis.ipynb           # Business insights & visualisations
│
├── sql/
│   ├── create_tables.sql           # DDL for BigQuery / DuckDB
│   ├── layoffs_by_industry.sql     # Layoffs aggregated by industry
│   ├── hiring_trends.sql           # Hiring trend analysis
│   ├── ai_impact.sql               # AI automation & replacement risk
│   └── market_conditions.sql       # Market condition breakdowns
│
├── src/
│   ├── ingestion/
│   │   └── load_data.py            # Load & validate raw CSV
│   ├── transformation/
│   │   └── clean_transform.py      # Cleaning, typing, feature engineering
│   └── analysis/
│       └── metrics.py              # KPI computation helpers
│
├── looker/
│   ├── models/
│   │   └── tech_layoffs.model.lkml
│   ├── views/
│   │   └── tech_layoffs.view.lkml
│   ├── explores/
│   │   └── layoffs_explore.lkml
│   └── dashboards/
│       └── executive_overview.dashboard.lookml
│
├── docs/
│   ├── data_dictionary.md          # Column descriptions & types
│   └── looker_setup.md             # How to connect Looker to this project
│
├── .github/
│   └── workflows/
│       └── ci.yml                  # Linting + tests on push
│
├── requirements.txt
├── .gitignore
└── README.md
```

---

## 🗂️ Dataset

**File:** `data/raw/tech_layoffs_hiring_trends.csv`  
**Rows:** 12 000 | **Columns:** 23  
**Period:** January 2024 – 2026

| Column | Type | Description |
|---|---|---|
| `record_id` | str | Unique identifier |
| `company_name` | str | Company name |
| `industry` | str | AI, FinTech, Cloud, Gaming, etc. |
| `country` | str | Country of the layoff event |
| `company_size` | str | Startup / Mid-size / Big Tech / Enterprise |
| `month` | str | Month of the event |
| `year` | int | Year of the event |
| `layoffs_count` | int | Number of employees laid off |
| `layoff_percentage` | float | % of workforce laid off |
| `reason_for_layoffs` | str | AI Automation / Cost Cutting / etc. |
| `ai_automation_impact` | float | Score 0–10 |
| `ai_replacement_risk` | float | Score 0–10 |
| `open_roles` | int | Number of open positions |
| `hiring_trend` | str | Aggressive Hiring / Moderate / Freeze / Downsizing |
| `remote_jobs_percentage` | float | % of roles that are remote |
| `top_hiring_role` | str | Most sought-after role |
| `stock_growth_percent` | float | Stock change % |
| `revenue_growth_percent` | float | Revenue change % |
| `salary_budget_change` | float | Salary budget change % |
| `ai_adoption_level` | float | Score 0–10 |
| `employee_sentiment` | float | Score 0–10 |
| `job_security_score` | float | Score 0–10 |
| `market_condition` | str | Bull Market / Recession / Stable |

---

## 🚀 Quick Start

### 1. Clone the repo
```bash
git clone https://github.com/<your-username>/tech-layoffs-analysis.git
cd tech-layoffs-analysis
```

### 2. Create a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate        # Mac/Linux
.venv\Scripts\activate           # Windows
```

### 3. Install dependencies
```bash
pip install -r requirements.txt
```

### 4. Run the pipeline
```bash
# Clean & transform
python src/transformation/clean_transform.py

# Generate exports for Looker
python src/analysis/metrics.py
```

### 5. Explore notebooks
```bash
jupyter lab
```

---

## 📊 Looker Studio Setup

See [`docs/looker_setup.md`](docs/looker_setup.md) for full instructions to connect Looker Studio to the exported CSV or BigQuery table.

**Key dashboards:**
- 📌 Executive Overview — total layoffs, hiring trends, market conditions
- 🤖 AI Impact — automation score, replacement risk by industry
- 🌍 Geographic Analysis — layoffs by country & company size
- 📈 Financial Signals — stock/revenue growth vs. layoffs

---

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| Language | Python 3.11 |
| Data manipulation | pandas, numpy |
| Visualisation (local) | matplotlib, seaborn, plotly |
| SQL analytics | DuckDB (local) / BigQuery (cloud) |
| BI / Dashboards | Looker Studio |
| CI | GitHub Actions |

---

## 📄 License

MIT — free to use, fork, and adapt.
