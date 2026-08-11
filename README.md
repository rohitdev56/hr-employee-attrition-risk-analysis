# HR Employee Attrition Risk Analysis

End-to-end SQL analysis of the IBM HR Analytics Employee Attrition dataset, extended into a custom, explainable risk-scoring model that flags employees by attrition risk — plus an Excel dashboard for stakeholder-facing reporting.

## Overview

- **Dataset**: [IBM HR Analytics Employee Attrition](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) (1,470 employees, 35 attributes)
- **Tools**: MySQL (CTEs, window functions, conditional aggregation), Excel (dashboard, KPI cards, charts)
- **Goal**: Identify the strongest drivers of employee attrition, then combine them into a single risk score that can flag at-risk employees before they leave.

## Project Structure
sql/
01_schema_and_load.sql -- table schema + CSV import
02_data_validation.sql -- null/duplicate/range checks
03_business_questions.sql -- 18 business questions across
demographics, compensation,
work conditions, and tenure
04_risk_scoring_model.sql -- CTE-based weighted risk model
+ validation against real outcomes
dashboard/
HR_Attrition_Dashboard.xlsx -- KPI cards, driver charts, risk summary

## Questions

Batch 1 — Demographics
What is the overall attrition rate?
How does attrition vary by Department?
How does attrition vary by Job Role?
How does attrition vary by Gender?
How does attrition vary by Marital Status? (+ interaction with Job Role)
How does attrition vary by Business Travel frequency?

Batch 2 — Compensation
7. Do employees who leave earn less, on average, than those who stay?
8. Does attrition rate differ across income quartiles?
9. Does the size of an employee's last raise affect attrition?

Batch 3 — Work Conditions
10. Does working overtime increase attrition risk?
11. Does Work-Life Balance score affect attrition?
12. Does Job Satisfaction score affect attrition?
13. Does Environment Satisfaction score affect attrition?

Batch 4 — Tenure & Career Growth
14. Do employees who leave have shorter tenure, on average?
15. Does time since last promotion affect attrition?
16. Does seniority (Job Level) affect attrition?

Batch 5 — Commute
17. Does distance from home affect attrition?
18. Does the combination of overtime + long commute compound the risk?

## Key Findings

**Strongest individual drivers of attrition:**

| Driver | Highest-risk group | Attrition rate |
|---|---|---|
| OverTime | Works overtime | 30.5% vs 10.4% (no overtime) |
| Marital Status | Single | 25.5% vs ~11% (married/divorced) |
| Job Role | Sales Representative | 39.8% |
| Income | Bottom quartile (<$2,911/mo) | 29.4% vs ~10-14% (all other quartiles) |
| Job Level | Entry-level (Level 1) | 26.3% vs 4.7-14.7% (Levels 2-5) |

**Compounding-risk segments** (interaction effects, not visible in single-variable analysis):

- **Single Sales Representatives**: 55.3% attrition — the single highest-risk segment in the dataset
- **OverTime × long commute (21+ distance units)**: 42.6% attrition, vs 13.3% for the same distance band without overtime — the effect of overtime nearly triples with commute distance

**Risk-scoring model** — a transparent, rule-based score (not a black-box ML model) combining 10 weighted factors, validated against actual outcomes:

| Risk Flag | Employees | Actual Attritions | Attrition Rate |
|---|---|---|---|
| High Risk | 294 (20%) | 126 | **42.9%** |
| Medium Risk | 490 (33%) | 74 | 15.1% |
| Low Risk | 686 (47%) | 37 | **5.4%** |

High Risk employees make up 20% of headcount but account for **53% of all attritions** — meaning a retention program targeting just this group would address over half of total attrition, an 8x more efficient use of retention budget than a blanket policy.

## Methodology Notes

- Income and commute-distance effects are **threshold effects, not linear** — attrition risk jumps sharply past a cutoff (e.g., bottom income quartile, 10+ distance units) rather than climbing smoothly.
- `PercentSalaryHike` showed **no meaningful effect** on attrition (15.10% vs 15.23% avg) — it's the *absolute* pay level that matters, not the size of recent raises.
- The risk model intentionally uses simple, explainable weighted rules rather than a trained classifier, so HR stakeholders can see exactly why an employee is flagged — a deliberate trade-off favoring transparency over marginal accuracy gains.

## Dashboard

The Excel dashboard includes:
- KPI summary cards (headcount, attrition rate, avg income, avg tenure)
- Attrition rate breakdowns by Department, Job Role, OverTime, and Years at Company
- Interactive slicers (Department, JobRole, Gender, MaritalStatus, OverTime)
- Risk segment summary chart (High/Medium/Low risk vs. actual attrition rate)

## Author

Rohit Kataria — [GitHub](https://github.com/rohitdev56)