# tech_layoffs.model.lkml
# LookML model — connects to the BigQuery / CSV data source.

connection: "tech_layoffs_bq"   # Replace with your Looker connection name

# Include all view and explore files
include: "/looker/views/*.view.lkml"
include: "/looker/explores/*.lkml"

label: "Tech Layoffs & Hiring Trends"
