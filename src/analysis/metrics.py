"""
metrics.py
----------
Compute business KPIs and aggregated tables for Looker.
"""

import logging
from pathlib import Path

import pandas as pd
import numpy as np

logging.basicConfig(level=logging.INFO, format="%(levelname)s | %(message)s")
log = logging.getLogger(__name__)

PROCESSED_PATH = Path(__file__).parents[2] / "data" / "processed" / "layoffs_clean.csv"
EXPORTS_DIR    = Path(__file__).parents[2] / "data" / "exports"


def load_processed() -> pd.DataFrame:
    df = pd.read_csv(PROCESSED_PATH, parse_dates=["date"])
    return df


# ─── KPI helpers ──────────────────────────────────────────────────────────────

def total_layoffs(df: pd.DataFrame) -> int:
    return int(df["layoffs_count"].sum())


def avg_layoff_pct(df: pd.DataFrame) -> float:
    return round(df["layoff_percentage"].mean(), 2)


def hiring_rate(df: pd.DataFrame) -> float:
    """% of records where the company is hiring (aggressive or moderate)."""
    return round(df["is_hiring"].mean() * 100, 2)


def top_industries_by_layoffs(df: pd.DataFrame, n: int = 5) -> pd.DataFrame:
    return (
        df.groupby("industry")["layoffs_count"]
        .sum()
        .sort_values(ascending=False)
        .head(n)
        .reset_index()
        .rename(columns={"layoffs_count": "total_layoffs"})
    )


# ─── Aggregated export tables ─────────────────────────────────────────────────

def agg_by_industry(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby("industry")
        .agg(
            total_layoffs=("layoffs_count", "sum"),
            avg_layoff_pct=("layoff_percentage", "mean"),
            avg_ai_risk=("ai_replacement_risk", "mean"),
            avg_ai_adoption=("ai_adoption_level", "mean"),
            avg_open_roles=("open_roles", "mean"),
            pct_hiring=("is_hiring", "mean"),
            records=("record_id", "count"),
        )
        .round(2)
        .reset_index()
    )


def agg_by_country(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby("country")
        .agg(
            total_layoffs=("layoffs_count", "sum"),
            avg_job_security=("job_security_score", "mean"),
            avg_employee_sentiment=("employee_sentiment", "mean"),
            avg_remote_pct=("remote_jobs_percentage", "mean"),
            records=("record_id", "count"),
        )
        .round(2)
        .reset_index()
    )


def agg_by_quarter(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby(["year", "quarter", "year_quarter"])
        .agg(
            total_layoffs=("layoffs_count", "sum"),
            avg_layoff_pct=("layoff_percentage", "mean"),
            avg_open_roles=("open_roles", "mean"),
            avg_stock_growth=("stock_growth_percent", "mean"),
            avg_revenue_growth=("revenue_growth_percent", "mean"),
            pct_hiring=("is_hiring", "mean"),
        )
        .round(2)
        .reset_index()
        .sort_values(["year", "quarter"])
    )


def agg_by_market(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby("market_condition")
        .agg(
            total_layoffs=("layoffs_count", "sum"),
            avg_layoff_pct=("layoff_percentage", "mean"),
            avg_ai_risk=("ai_replacement_risk", "mean"),
            avg_sentiment=("employee_sentiment", "mean"),
            pct_hiring=("is_hiring", "mean"),
        )
        .round(2)
        .reset_index()
    )


def agg_ai_impact(df: pd.DataFrame) -> pd.DataFrame:
    return (
        df.groupby(["industry", "ai_risk_tier"])
        .agg(
            total_layoffs=("layoffs_count", "sum"),
            avg_ai_automation=("ai_automation_impact", "mean"),
            avg_ai_replacement=("ai_replacement_risk", "mean"),
            avg_adoption=("ai_adoption_level", "mean"),
            records=("record_id", "count"),
        )
        .round(2)
        .reset_index()
    )


# ─── Main ─────────────────────────────────────────────────────────────────────

def run_all():
    EXPORTS_DIR.mkdir(parents=True, exist_ok=True)
    df = load_processed()

    tables = {
        "agg_industry.csv":  agg_by_industry(df),
        "agg_country.csv":   agg_by_country(df),
        "agg_quarter.csv":   agg_by_quarter(df),
        "agg_market.csv":    agg_by_market(df),
        "agg_ai_impact.csv": agg_ai_impact(df),
    }

    for filename, table in tables.items():
        path = EXPORTS_DIR / filename
        table.to_csv(path, index=False)
        log.info(f"Exported {filename} ({len(table)} rows) → {path}")

    # Print summary KPIs
    print("\n" + "=" * 40)
    print("📊  KEY METRICS SUMMARY")
    print("=" * 40)
    print(f"Total layoffs:     {total_layoffs(df):>12,}")
    print(f"Avg layoff %:      {avg_layoff_pct(df):>11.2f}%")
    print(f"Companies hiring:  {hiring_rate(df):>11.2f}%")
    print("\nTop 5 industries by layoffs:")
    print(top_industries_by_layoffs(df).to_string(index=False))


if __name__ == "__main__":
    run_all()