# Query-by-Query Results

Full SQL queries and their output for every business question in this analysis. See `README.md` for the plain-English summary of findings.

## Q1 — Overall Attrition Rate

```sql
SELECT Attrition, COUNT(*) AS count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_attrition), 2) AS attr_pct
FROM hr_attrition GROUP BY Attrition;
```

| Attrition | Count | % |
|---|---|---|
| No | 1,233 | 83.88% |
| Yes | 237 | 16.12% |

## Q2 — Attrition Rate by Department

```sql
SELECT Department, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attritions,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate_pct
FROM hr_attrition GROUP BY Department ORDER BY attrition_rate_pct DESC;
```

| Department | Total | Attritions | Rate |
|---|---|---|---|
| Sales | 446 | 92 | 20.63% |
| Human Resources | 63 | 12 | 19.05% |
| Research & Development | 961 | 133 | 13.84% |

## Q3 — Attrition Rate by Job Role

```sql
SELECT JobRole, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attritions,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate_pct
FROM hr_attrition GROUP BY JobRole ORDER BY attrition_rate_pct DESC;
```

| Job Role | Total | Attritions | Rate |
|---|---|---|---|
| Sales Representative | 83 | 33 | 39.76% |
| Laboratory Technician | 259 | 62 | 23.94% |
| Human Resources | 52 | 12 | 23.08% |
| Sales Executive | 326 | 57 | 17.48% |
| Research Scientist | 292 | 47 | 16.10% |
| Manufacturing Director | 145 | 10 | 6.90% |
| Healthcare Representative | 131 | 9 | 6.87% |
| Manager | 102 | 5 | 4.90% |
| Research Director | 80 | 2 | 2.50% |

## Q4 — Attrition Rate by Gender

| Gender | Total | Attritions | Rate |
|---|---|---|---|
| Male | 882 | 150 | 17.01% |
| Female | 588 | 87 | 14.80% |

## Q5 — Attrition Rate by Marital Status

| Marital Status | Total | Attritions | Rate |
|---|---|---|---|
| Single | 470 | 120 | 25.53% |
| Married | 673 | 84 | 12.48% |
| Divorced | 327 | 33 | 10.09% |

### Q5b — Interaction: Job Role × Marital Status

```sql
SELECT JobRole, MaritalStatus, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attritions,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate_pct
FROM hr_attrition GROUP BY JobRole, MaritalStatus ORDER BY attrition_rate_pct DESC;
```

| Job Role | Marital Status | Total | Attritions | Rate |
|---|---|---|---|---|
| Sales Representative | Single | 38 | 21 | 55.26% |
| Sales Representative | Divorced | 11 | 4 | 36.36% |
| Human Resources | Divorced | 14 | 5 | 35.71% |
| Laboratory Technician | Single | 88 | 31 | 35.23% |
| Sales Executive | Single | 106 | 31 | 29.25% |
| Research Scientist | Single | 108 | 29 | 26.85% |
| Sales Representative | Married | 34 | 8 | 23.53% |
| Laboratory Technician | Divorced | 55 | 12 | 21.82% |
| Human Resources | Married | 28 | 6 | 21.43% |
| Laboratory Technician | Married | 116 | 19 | 16.38% |
| Sales Executive | Married | 151 | 20 | 13.25% |
| Research Scientist | Married | 122 | 14 | 11.48% |
| Human Resources | Single | 10 | 1 | 10.00% |
| Healthcare Representative | Married | 61 | 6 | 9.84% |
| Manufacturing Director | Married | 67 | 6 | 8.96% |
| Sales Executive | Divorced | 69 | 6 | 8.70% |
| Manufacturing Director | Single | 42 | 3 | 7.14% |
| Manager | Married | 56 | 4 | 7.14% |
| Research Scientist | Divorced | 62 | 4 | 6.45% |
| Healthcare Representative | Single | 36 | 2 | 5.56% |
| Research Director | Single | 19 | 1 | 5.26% |
| Manager | Single | 23 | 1 | 4.35% |
| Healthcare Representative | Divorced | 34 | 1 | 2.94% |
| Manufacturing Director | Divorced | 36 | 1 | 2.78% |
| Research Director | Married | 38 | 1 | 2.63% |
| Manager | Divorced | 23 | 0 | 0.00% |
| Research Director | Divorced | 23 | 0 | 0.00% |

## Q6 — Attrition Rate by Business Travel

| Business Travel | Total | Attritions | Rate |
|---|---|---|---|
| Travel_Frequently | 277 | 69 | 24.91% |
| Travel_Rarely | 1,043 | 156 | 14.96% |
| Non-Travel | 150 | 12 | 8.00% |

## Q7 — Average Monthly Income: Left vs Stayed

| Attrition | Total | Avg Monthly Income |
|---|---|---|
| Yes | 237 | $4,787.09 |
| No | 1,233 | $6,832.74 |

## Q8 — Attrition Rate by Income Quartile

```sql
WITH income_bands AS (
  SELECT EmployeeNumber, Attrition, MonthlyIncome,
    NTILE(4) OVER (ORDER BY MonthlyIncome) AS income_quartile
  FROM hr_attrition
)
SELECT income_quartile, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attritions,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate_pct,
  MIN(MonthlyIncome) AS min_income, MAX(MonthlyIncome) AS max_income
FROM income_bands GROUP BY income_quartile ORDER BY income_quartile;
```

| Quartile | Total | Attritions | Rate | Income Range |
|---|---|---|---|---|
| Q1 (lowest) | 368 | 108 | 29.35% | $1,009 – $2,911 |
| Q2 | 368 | 52 | 14.13% | $2,911 – $4,930 |
| Q3 | 367 | 39 | 10.63% | $4,936 – $8,380 |
| Q4 (highest) | 367 | 38 | 10.35% | $8,381 – $19,999 |

## Q9 — Average Salary Hike %: Left vs Stayed

| Attrition | Total | Avg Salary Hike % |
|---|---|---|
| Yes | 237 | 15.10% |
| No | 1,233 | 15.23% |

## Q10 — Attrition Rate by OverTime

| OverTime | Total | Attritions | Rate |
|---|---|---|---|
| Yes | 416 | 127 | 30.53% |
| No | 1,054 | 110 | 10.44% |

## Q11 — Attrition Rate by Work-Life Balance

| Score (1=Bad, 4=Best) | Total | Attritions | Rate |
|---|---|---|---|
| 1 | 80 | 25 | 31.25% |
| 2 | 344 | 58 | 16.86% |
| 3 | 893 | 127 | 14.22% |
| 4 | 153 | 27 | 17.65% |

## Q12 — Attrition Rate by Job Satisfaction

| Score (1=Low, 4=Very High) | Total | Attritions | Rate |
|---|---|---|---|
| 1 | 289 | 66 | 22.84% |
| 2 | 280 | 46 | 16.43% |
| 3 | 442 | 73 | 16.52% |
| 4 | 459 | 52 | 11.33% |

## Q13 — Attrition Rate by Environment Satisfaction

| Score (1=Low, 4=Very High) | Total | Attritions | Rate |
|---|---|---|---|
| 1 | 284 | 72 | 25.35% |
| 2 | 287 | 43 | 14.98% |
| 3 | 453 | 62 | 13.69% |
| 4 | 446 | 60 | 13.45% |

## Q14 — Average Years at Company: Left vs Stayed

| Attrition | Total | Avg Years at Company |
|---|---|---|
| Yes | 237 | 5.13 |
| No | 1,233 | 7.37 |

## Q15 — Attrition Rate by Years Since Last Promotion

| Years Since Promotion | Total | Attritions | Rate |
|---|---|---|---|
| 0 | 581 | 110 | 18.93% |
| 1 | 357 | 49 | 13.73% |
| 2 | 159 | 27 | 16.98% |
| 3 | 52 | 9 | 17.31% |
| 4 | 61 | 5 | 8.20% |
| 5 | 45 | 2 | 4.44% |
| 6 | 32 | 6 | 18.75% |
| 7 | 76 | 16 | 21.05% |
| 8 | 18 | 0 | 0.00% |
| 9 | 17 | 4 | 23.53% |
| 10 | 6 | 1 | 16.67% |
| 11 | 24 | 2 | 8.33% |
| 12 | 10 | 0 | 0.00% |
| 13 | 10 | 2 | 20.00% |
| 14 | 9 | 1 | 11.11% |
| 15 | 13 | 3 | 23.08% |

> Note: samples beyond ~5 years get small (under 50 people), so treat later rows as directional rather than statistically solid.

## Q16 — Attrition Rate by Job Level

| Job Level (1=Entry, 5=Senior) | Total | Attritions | Rate |
|---|---|---|---|
| 1 | 543 | 143 | 26.34% |
| 2 | 534 | 52 | 9.74% |
| 3 | 218 | 32 | 14.68% |
| 4 | 106 | 5 | 4.72% |
| 5 | 69 | 5 | 7.25% |

## Q17 — Attrition Rate by Distance From Home

```sql
WITH distance_bands AS (
  SELECT EmployeeNumber, Attrition, DistanceFromHome,
    CASE WHEN DistanceFromHome <= 5 THEN '1. 0-5 (Near)'
         WHEN DistanceFromHome <= 10 THEN '2. 6-10 (Moderate)'
         WHEN DistanceFromHome <= 20 THEN '3. 11-20 (Far)'
         ELSE '4. 21+ (Very Far)' END AS distance_band
  FROM hr_attrition
)
SELECT distance_band, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attritions,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS attrition_rate_pct,
  ROUND(AVG(DistanceFromHome),2) AS avg_distance_in_band
FROM distance_bands GROUP BY distance_band ORDER BY distance_band;
```

| Distance Band | Total | Attritions | Rate | Avg Distance |
|---|---|---|---|---|
| 0-5 (Near) | 632 | 87 | 13.77% | 2.31 |
| 6-10 (Moderate) | 394 | 57 | 14.47% | 8.14 |
| 11-20 (Far) | 240 | 48 | 20.00% | 15.53 |
| 21+ (Very Far) | 204 | 45 | 22.06% | 25.07 |

## Q18 — Distance Band × OverTime Interaction

| Distance Band | OverTime | Total | Attritions | Rate |
|---|---|---|---|---|
| 0-5 (Near) | Yes | 172 | 46 | 26.74% |
| 0-5 (Near) | No | 460 | 41 | 8.91% |
| 6-10 (Moderate) | Yes | 107 | 26 | 24.30% |
| 6-10 (Moderate) | No | 287 | 31 | 10.80% |
| 11-20 (Far) | Yes | 76 | 29 | 38.16% |
| 11-20 (Far) | No | 164 | 19 | 11.59% |
| 21+ (Very Far) | Yes | 61 | 26 | 42.62% |
| 21+ (Very Far) | No | 143 | 19 | 13.29% |

## Risk Model Validation

| Risk Flag | Total | Actual Attritions | Actual Rate |
|---|---|---|---|
| High Risk | 294 | 126 | 42.86% |
| Medium Risk | 490 | 74 | 15.10% |
| Low Risk | 686 | 37 | 5.39% |
