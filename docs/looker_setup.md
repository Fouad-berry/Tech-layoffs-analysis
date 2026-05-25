# Looker Studio Setup Guide

Two options depending on your stack:

---

## Option A — Looker Studio (free, via Google)

The quickest path: connect directly to the exported CSV via Google Sheets.

### Steps

1. **Run the pipeline** to generate the export:
   ```bash
   python src/transformation/clean_transform.py
   python src/analysis/metrics.py
   ```

2. **Upload to Google Sheets**  
   Upload `data/exports/layoffs_looker.csv` (the full clean dataset) and the aggregated files (`agg_*.csv`) to a Google Drive folder.

3. **Open Looker Studio** → [lookerstudio.google.com](https://lookerstudio.google.com)

4. **Create a new report** → Add data source → **Google Sheets** → select your file.

5. **Repeat for each aggregated file** as additional data sources.

6. **Build charts** — suggested pages:
   | Page | Primary data source | Charts |
   |---|---|---|
   | Executive Overview | `layoffs_looker.csv` | Scorecard KPIs, bar by industry, time series |
   | AI Impact | `agg_ai_impact.csv` | Scatter (risk vs layoffs), heatmap by tier |
   | Geographic | `layoffs_looker.csv` | Geo map (country), stacked bar (company size) |
   | Financial Signals | `layoffs_looker.csv` | Combo chart (stock + revenue), bubble chart |
   | Hiring Trends | `agg_quarter.csv` | Line (open roles over time), pie (hiring_trend) |

---

## Option B — Looker (enterprise) via BigQuery

### 1. Load data into BigQuery

```bash
pip install google-cloud-bigquery db-dtypes
```

```python
from google.cloud import bigquery
import pandas as pd

client = bigquery.Client(project="your-project")
df = pd.read_csv("data/processed/layoffs_clean.csv", parse_dates=["date"])

job = client.load_table_from_dataframe(
    df,
    "your-project.tech_layoffs.layoffs_events",
    job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE"),
)
job.result()
print("Loaded", job.output_rows, "rows")
```

### 2. Run DDL
```bash
bq query --use_legacy_sql=false < sql/create_tables.sql
```

### 3. Connect Looker
- In Looker Admin → **Connections** → New Connection → BigQuery
- Add your project credentials (service account JSON)
- Set connection name to `tech_layoffs_bq` (matches `tech_layoffs.model.lkml`)

### 4. Deploy LookML
- Copy the `looker/` folder into your Looker project repository
- Validate & deploy from the Looker IDE

---

## Key Metrics to Build in Looker Studio

| Metric | Formula |
|---|---|
| Total layoffs | SUM(layoffs_count) |
| Avg layoff % | AVG(layoff_percentage) |
| % companies hiring | AVG(is_hiring) × 100 |
| AI risk score | AVG(ai_replacement_risk) |
| Financial health | AVG(financial_health) |
| Net hiring ratio | AVG(net_hiring_ratio) |
