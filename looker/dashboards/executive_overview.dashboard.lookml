# executive_overview.dashboard.lookml
# Executive overview dashboard — 4 tiles covering key KPIs.

- dashboard: executive_overview
  title: "Tech Layoffs — Executive Overview"
  layout: newspaper
  preferred_viewer: dashboards-next

  filters:
    - name: year
      title: "Year"
      type: field_filter
      explore: tech_layoffs
      field: tech_layoffs.year
      default_value: ""
      allow_multiple_values: true

    - name: industry
      title: "Industry"
      type: field_filter
      explore: tech_layoffs
      field: tech_layoffs.industry
      default_value: ""
      allow_multiple_values: true

    - name: market_condition
      title: "Market Condition"
      type: field_filter
      explore: tech_layoffs
      field: tech_layoffs.market_condition
      default_value: ""

  elements:

    # ── Tile 1: Total layoffs by industry (bar chart) ────────────────────────
    - title: "Total Layoffs by Industry"
      name: layoffs_by_industry
      model: tech_layoffs
      explore: tech_layoffs
      type: looker_bar
      fields: [tech_layoffs.industry, tech_layoffs.total_layoffs]
      sorts: [tech_layoffs.total_layoffs desc]
      limit: 10
      row: 0
      col: 0
      width: 12
      height: 8

    # ── Tile 2: Hiring trend distribution (pie chart) ────────────────────────
    - title: "Hiring Trend Distribution"
      name: hiring_trend_pie
      model: tech_layoffs
      explore: tech_layoffs
      type: looker_pie
      fields: [tech_layoffs.hiring_trend, tech_layoffs.event_count]
      sorts: [tech_layoffs.event_count desc]
      limit: 10
      row: 0
      col: 12
      width: 12
      height: 8

    # ── Tile 3: Layoffs over time (line chart) ───────────────────────────────
    - title: "Layoffs Over Time (by Quarter)"
      name: layoffs_over_time
      model: tech_layoffs
      explore: tech_layoffs
      type: looker_line
      fields: [tech_layoffs.year_quarter, tech_layoffs.total_layoffs, tech_layoffs.total_open_roles]
      sorts: [tech_layoffs.year_quarter asc]
      limit: 20
      row: 8
      col: 0
      width: 24
      height: 8

    # ── Tile 4: AI risk vs layoffs (scatter) ─────────────────────────────────
    - title: "AI Replacement Risk vs. Avg Layoff %"
      name: ai_risk_scatter
      model: tech_layoffs
      explore: tech_layoffs
      type: looker_scatter
      fields: [tech_layoffs.industry, tech_layoffs.avg_ai_replacement_risk, tech_layoffs.avg_layoff_percentage]
      sorts: [tech_layoffs.avg_ai_replacement_risk desc]
      limit: 10
      row: 16
      col: 0
      width: 12
      height: 8

    # ── Tile 5: Employee sentiment by market condition ───────────────────────
    - title: "Employee Sentiment by Market Condition"
      name: sentiment_market
      model: tech_layoffs
      explore: tech_layoffs
      type: looker_column
      fields: [tech_layoffs.market_condition, tech_layoffs.avg_employee_sentiment, tech_layoffs.avg_job_security]
      sorts: [tech_layoffs.market_condition asc]
      limit: 10
      row: 16
      col: 12
      width: 12
      height: 8
