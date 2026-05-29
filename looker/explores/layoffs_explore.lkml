# layoffs_explore.lkml
# Explores available in Looker for the tech layoffs dataset.

explore: tech_layoffs {
  label:       "Tech Layoffs & Hiring"
  description: "Explore layoffs, hiring trends, AI impact, and financial signals (2024–2026)"

  # Suggested fields shown by default in the field picker
  fields: [
    ALL_FIELDS*,
    -tech_layoffs.company_size_order
  ]
}
