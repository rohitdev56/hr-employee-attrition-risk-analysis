# HR Employee Attrition Risk Analysis

End-to-end SQL analysis of the IBM HR Analytics Employee Attrition dataset, extended into a custom, explainable risk-scoring model that flags employees by attrition risk — plus an Excel dashboard for stakeholder-facing reporting.

## What this project is about

Companies lose good employees every year, and replacing them is expensive — hiring, training, lost productivity. This project looks at a real HR dataset (IBM's HR Analytics dataset, 1,470 employees) and asks two simple questions:

1. **Why do employees leave?** — using SQL to find patterns.
2. **Can we predict who's likely to leave next?** — by building a simple scoring system that flags at-risk employees.

I did the analysis in MySQL and built a dashboard in Excel to present the findings the way a business team would actually want to see them.

## How I approached it

I started by setting up and validating the data in MySQL (checking for nulls, duplicates, and outliers), then worked through 18 business questions one at a time — department, pay, overtime, tenure, and more — to see which factors actually predicted attrition and which didn't. From there, I combined the strongest factors into a single weighted risk score, tested it against real outcomes to confirm it worked, and built an Excel dashboard so the findings are easy to browse without touching SQL.

- **Dataset**: [IBM HR Analytics Employee Attrition](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) (1,470 employees, 35 attributes)
- **Tools**: MySQL (CTEs, window functions, conditional aggregation), Excel (dashboard, KPI cards, charts)
- **Goal**: Identify the strongest drivers of employee attrition, then combine them into a single risk score that can flag at-risk employees before they leave.

## What I found

**The strongest single reasons people leave:**

| Factor | Who's at risk | Attrition rate |
|---|---|---|
| Works overtime | Yes vs. No | 30.5% vs 10.4% |
| Marital status | Single vs. Married/Divorced | 25.5% vs ~11% |
| Job role | Sales Representative | 39.8% |
| Pay | Bottom 25% earners | 29.4% vs ~10-14% for everyone else |
| Seniority | Entry-level employees | 26.3% vs 4.7-14.7% for senior levels |

**The most interesting finding — combinations matter more than single factors:**

- A **single Sales Representative** has a **55% chance of leaving** — more than 1 in 2. That's much higher than either "being single" or "being a Sales Rep" alone would suggest.
- Someone who works **overtime AND has a long commute** is nearly **3x more likely to leave** than someone with the same commute but no overtime.

This tells us something important: looking at one factor at a time hides the real risk. It's the *combination* of pressures that pushes someone out the door.

**Does giving someone a bigger raise help?** Surprisingly, no — the size of an employee's last raise made almost no difference to whether they stayed (15.10% vs 15.23% attrition, basically identical). What matters is their overall pay level, not how big their last raise was.

## The risk-scoring model, explained simply

Instead of building a complicated machine-learning model, I built something a manager could understand in one sentence: **every employee gets points for each risk factor they have, and the points add up to a score.**

- Big risk factors (like working overtime) = 3 points
- Medium risk factors (like being an entry-level employee) = 2 points
- Smaller risk factors (like low satisfaction scores) = 1 point

Add up someone's points, and they get sorted into:
- **High Risk** (score 8+)
- **Medium Risk** (score 4-7)
- **Low Risk** (score under 4)

**Did it actually work?** Yes — when I checked the scores against who really left the company:

| Risk Level | How many employees | How many actually left | Real attrition rate |
|---|---|---|---|
| High Risk | 294 (20% of everyone) | 126 | **42.9%** |
| Medium Risk | 490 | 74 | 15.1% |
| Low Risk | 686 | 37 | **5.4%** |

The High Risk group is only 1 in 5 employees, but they account for **over half of everyone who left (53%)**. So if a company wanted to focus its retention efforts — better pay, more flexibility, check-ins — on just the top 20% highest-risk people, they'd be tackling more than half the problem, instead of spreading a limited budget thin across everyone.

## Why I built it this way (not a "black box" model)

I could have used a machine learning model instead, but I chose a simple point system on purpose — anyone in HR can look at an employee's flag and immediately see *why* they were flagged, without needing to trust a black box. That transparency matters a lot when the output is going to influence real decisions about real people.

## What's in this repo

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

## Business Questions Answered

**Demographics**
1. What is the overall attrition rate?
2. How does attrition vary by Department?
3. How does attrition vary by Job Role?
4. How does attrition vary by Gender?
5. How does attrition vary by Marital Status? (+ interaction with Job Role)
6. How does attrition vary by Business Travel frequency?

**Compensation**

7. Do employees who leave earn less, on average, than those who stay?

8. Does attrition rate differ across income quartiles?
   
9. Does the size of an employee's last raise affect attrition?

**Work Conditions**

10. Does working overtime increase attrition risk?

11. Does Work-Life Balance score affect attrition?
  
12. Does Job Satisfaction score affect attrition?
    
13. Does Environment Satisfaction score affect attrition?

**Tenure & Career Growth**

14. Do employees who leave have shorter tenure, on average?

15. Does time since last promotion affect attrition?
    
16. Does seniority (Job Level) affect attrition?

**Commute**

17. Does distance from home affect attrition?
    
18. Does the combination of overtime and long commute compound the risk?

High Risk employees make up 20% of headcount but account for **53% of all attritions** — meaning a retention program targeting just this group would address over half of total attrition, an 8x more efficient use of retention budget than a blanket policy.

## Dashboard

The Excel dashboard turns all of this into something non-technical stakeholders can explore on their own:
- KPI cards (headcount, attrition rate, average pay, average tenure)
- Charts breaking down attrition by department, job role, overtime, and tenure
- Filters (slicers) so a viewer can drill into specific departments, roles, or genders
- A summary chart showing the High/Medium/Low risk groups side by side

## Author

Rohit Kataria — [GitHub](https://github.com/rohitdev56)
