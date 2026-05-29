# tech_layoffs.view.lkml
# LookML view — maps all columns from the processed dataset.

view: tech_layoffs {
  sql_table_name: `your_project.your_dataset.layoffs_events` ;;
  # For CSV/DuckDB: sql_table_name: layoffs_events ;;

  # ─── Dimensions ───────────────────────────────────────────────────────────

  dimension: record_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.record_id ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: company_size {
    type: string
    sql: ${TABLE}.company_size ;;
    order_by_field: company_size_order
  }

  dimension: company_size_order {
    type: number
    hidden: yes
    sql: CASE ${TABLE}.company_size
           WHEN 'Startup'    THEN 1
           WHEN 'Mid-size'   THEN 2
           WHEN 'Big Tech'   THEN 3
           WHEN 'Enterprise' THEN 4
         END ;;
  }

  dimension_group: event {
    type: time
    timeframes: [date, month, quarter, year]
    sql: ${TABLE}.date ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: quarter {
    type: string
    sql: ${TABLE}.quarter ;;
  }

  dimension: year_quarter {
    type: string
    sql: ${TABLE}.year_quarter ;;
  }

  dimension: reason_for_layoffs {
    type: string
    sql: ${TABLE}.reason_for_layoffs ;;
  }

  dimension: hiring_trend {
    type: string
    sql: ${TABLE}.hiring_trend ;;
  }

  dimension: top_hiring_role {
    type: string
    sql: ${TABLE}.top_hiring_role ;;
  }

  dimension: market_condition {
    type: string
    sql: ${TABLE}.market_condition ;;
  }

  dimension: ai_risk_tier {
    type: string
    sql: ${TABLE}.ai_risk_tier ;;
  }

  dimension: is_hiring {
    type: yesno
    sql: ${TABLE}.is_hiring = 1 ;;
  }

  # ─── Numeric dimensions ───────────────────────────────────────────────────

  dimension: layoff_percentage {
    type: number
    sql: ${TABLE}.layoff_percentage ;;
    value_format_name: decimal_2
  }

  dimension: remote_jobs_percentage {
    type: number
    sql: ${TABLE}.remote_jobs_percentage ;;
    value_format_name: decimal_1
  }

  dimension: ai_replacement_risk {
    type: number
    sql: ${TABLE}.ai_replacement_risk ;;
    value_format_name: decimal_1
  }

  dimension: ai_adoption_level {
    type: number
    sql: ${TABLE}.ai_adoption_level ;;
    value_format_name: decimal_1
  }

  dimension: financial_health {
    type: number
    sql: ${TABLE}.financial_health ;;
    value_format_name: decimal_2
  }

  # ─── Measures ─────────────────────────────────────────────────────────────

  measure: total_layoffs {
    type: sum
    sql: ${TABLE}.layoffs_count ;;
    value_format_name: decimal_0
    drill_fields: [company_name, industry, country, layoffs_count]
  }

  measure: avg_layoff_percentage {
    type: average
    sql: ${TABLE}.layoff_percentage ;;
    value_format: "0.00\"%\""
  }

  measure: total_open_roles {
    type: sum
    sql: ${TABLE}.open_roles ;;
    value_format_name: decimal_0
  }

  measure: avg_open_roles {
    type: average
    sql: ${TABLE}.open_roles ;;
    value_format_name: decimal_0
  }

  measure: avg_ai_replacement_risk {
    type: average
    sql: ${TABLE}.ai_replacement_risk ;;
    value_format_name: decimal_2
  }

  measure: avg_ai_adoption {
    type: average
    sql: ${TABLE}.ai_adoption_level ;;
    value_format_name: decimal_2
  }

  measure: avg_employee_sentiment {
    type: average
    sql: ${TABLE}.employee_sentiment ;;
    value_format_name: decimal_2
  }

  measure: avg_job_security {
    type: average
    sql: ${TABLE}.job_security_score ;;
    value_format_name: decimal_2
  }

  measure: avg_stock_growth {
    type: average
    sql: ${TABLE}.stock_growth_percent ;;
    value_format: "0.0\"%\""
  }

  measure: avg_revenue_growth {
    type: average
    sql: ${TABLE}.revenue_growth_percent ;;
    value_format: "0.0\"%\""
  }

  measure: pct_companies_hiring {
    type: average
    sql: ${TABLE}.is_hiring ;;
    value_format: "0.0\"%\""
  }

  measure: event_count {
    type: count
    label: "Number of Events"
  }
}
