"""
clean_transform.py
------------------
Clean the raw dataset and engineer new features.
Outputs a processed CSV ready for analysis and Looker export.
"""

import logging
from pathlib import Path

import pandas as pd
import numpy as np

from src.ingestion.load_data import load_raw

logging.basicConfig(level=logging.INFO, format="%(levelname)s | %(message)s")
log = logging.getLogger(__name__)

PROCESSED_PATH = Path(__file__).parents[2] / "data" / "processed" / "layoffs_clean.csv"
EXPORT_PATH    = Path(__file__).parents[2] / "data" / "exports"  / "layoffs_looker.csv"

MONTH_ORDER = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
]


def clean(df: pd.DataFrame) -> pd.DataFrame:
    log.info("Cleaning data …")

    df = df.copy()

    # Standardise string columns
    str_cols = df.select_dtypes("object").columns
    df[str_cols] = df[str_cols].apply(lambda s: s.str.strip())

    # Build a proper date column
    df["month_num"] = pd.Categorical(df["month"], categories=MONTH_ORDER, ordered=True).codes + 1
    df["date"] = pd.to_datetime(
        df["year"].astype(str) + "-" + df["month_num"].astype(str).str.zfill(2) + "-01"
    )

    # Clip scores to [0, 10]
    score_cols = [
        "ai_automation_impact", "ai_replacement_risk", "ai_adoption_level",
        "employee_sentiment", "job_security_score",
    ]
    df[score_cols] = df[score_cols].clip(0, 10)

    # Clip percentages to [0, 100]
    pct_cols = ["layoff_percentage", "remote_jobs_percentage"]
    df[pct_cols] = df[pct_cols].clip(0, 100)

    log.info("Cleaning done ✓")
    return df


def feature_engineering(df: pd.DataFrame) -> pd.DataFrame:
    log.info("Engineering features …")

    df = df.copy()

    # Net hiring signal: open_roles normalised by layoffs_count
    df["net_hiring_ratio"] = np.where(
        df["layoffs_count"] > 0,
        df["open_roles"] / df["layoffs_count"].replace(0, np.nan),
        np.nan,
    )

    # Risk tier based on ai_replacement_risk
    bins   = [0, 3, 6, 10]
    labels = ["Low Risk", "Medium Risk", "High Risk"]
    df["ai_risk_tier"] = pd.cut(df["ai_replacement_risk"], bins=bins, labels=labels)

    # Financial health score: composite of stock + revenue growth
    df["financial_health"] = (
        df["stock_growth_percent"] * 0.4 + df["revenue_growth_percent"] * 0.6
    ).round(2)

    # Quarter
    df["quarter"] = "Q" + df["date"].dt.quarter.astype(str)
    df["year_quarter"] = df["year"].astype(str) + " " + df["quarter"]

    # Binary: is the company hiring?
    df["is_hiring"] = df["hiring_trend"].isin(
        ["Aggressive Hiring", "Moderate Hiring"]
    ).astype(int)

    log.info("Feature engineering done ✓")
    return df


def save(df: pd.DataFrame) -> None:
    PROCESSED_PATH.parent.mkdir(parents=True, exist_ok=True)
    EXPORT_PATH.parent.mkdir(parents=True, exist_ok=True)

    df.to_csv(PROCESSED_PATH, index=False)
    log.info(f"Saved processed data → {PROCESSED_PATH}")

    # Looker export: drop internal columns
    export_cols = [c for c in df.columns if c not in ["month_num"]]
    df[export_cols].to_csv(EXPORT_PATH, index=False)
    log.info(f"Saved Looker export    → {EXPORT_PATH}")


def run_pipeline() -> pd.DataFrame:
    df = load_raw()
    df = clean(df)
    df = feature_engineering(df)
    save(df)
    log.info(f"Pipeline complete — {len(df):,} rows ready.")
    return df


if __name__ == "__main__":
    run_pipeline()