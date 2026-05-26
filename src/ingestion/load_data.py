"""
load_data.py
------------
Load and validate the raw tech layoffs CSV.
"""

import logging
from pathlib import Path

import pandas as pd

logging.basicConfig(level=logging.INFO, format="%(levelname)s | %(message)s")
log = logging.getLogger(__name__)

RAW_PATH = Path(__file__).parents[2] / "data" / "raw" / "tech_layoffs_hiring_trends.csv"

EXPECTED_COLUMNS = [
    "record_id", "company_name", "industry", "country", "company_size",
    "month", "year", "layoffs_count", "layoff_percentage", "reason_for_layoffs",
    "ai_automation_impact", "ai_replacement_risk", "open_roles", "hiring_trend",
    "remote_jobs_percentage", "top_hiring_role", "stock_growth_percent",
    "revenue_growth_percent", "salary_budget_change", "ai_adoption_level",
    "employee_sentiment", "job_security_score", "market_condition",
]

DTYPES = {
    "record_id": str,
    "company_name": str,
    "industry": str,
    "country": str,
    "company_size": str,
    "month": str,
    "year": int,
    "layoffs_count": int,
    "layoff_percentage": float,
    "reason_for_layoffs": str,
    "ai_automation_impact": float,
    "ai_replacement_risk": float,
    "open_roles": int,
    "hiring_trend": str,
    "remote_jobs_percentage": float,
    "top_hiring_role": str,
    "stock_growth_percent": float,
    "revenue_growth_percent": float,
    "salary_budget_change": float,
    "ai_adoption_level": float,
    "employee_sentiment": float,
    "job_security_score": float,
    "market_condition": str,
}


def load_raw(path: Path = RAW_PATH) -> pd.DataFrame:
    """Load the raw CSV and run basic validation."""
    log.info(f"Loading data from {path}")
    df = pd.read_csv(path, dtype=str)  # load all as str first for safety

    # --- Column check ---
    missing = set(EXPECTED_COLUMNS) - set(df.columns)
    if missing:
        raise ValueError(f"Missing expected columns: {missing}")
    df = df[EXPECTED_COLUMNS]

    # --- Cast types ---
    for col, dtype in DTYPES.items():
        try:
            df[col] = df[col].astype(dtype)
        except Exception as e:
            log.warning(f"Could not cast '{col}' to {dtype}: {e}")

    log.info(f"Loaded {len(df):,} rows × {len(df.columns)} columns")
    _validate(df)
    return df


def _validate(df: pd.DataFrame) -> None:
    """Raise warnings for data quality issues."""
    null_counts = df.isnull().sum()
    nulls = null_counts[null_counts > 0]
    if not nulls.empty:
        log.warning(f"Null values detected:\n{nulls}")

    dupes = df["record_id"].duplicated().sum()
    if dupes:
        log.warning(f"{dupes} duplicate record_ids found")

    neg_layoffs = (df["layoffs_count"] < 0).sum()
    if neg_layoffs:
        log.warning(f"{neg_layoffs} rows with negative layoffs_count")

    log.info("Validation complete ✓")


if __name__ == "__main__":
    df = load_raw()
    print(df.head())
    print(df.dtypes)