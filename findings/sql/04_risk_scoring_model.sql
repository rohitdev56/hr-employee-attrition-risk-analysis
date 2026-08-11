-- ============================================================
-- HR Employee Attrition Analysis
-- 04: CTE-based weighted risk-scoring model
--
-- Combines the 10 strongest attrition drivers identified in
-- 03_business_questions.sql into a single explainable risk
-- score per employee, then buckets employees into
-- High / Medium / Low risk flags.
--
-- Weights are based on the relative strength of each driver's
-- observed attrition rate gap (see README for full findings):
--   3 pts: OverTime=Yes, MaritalStatus=Single,
--          JobRole=Sales Representative, bottom income quartile
--   2 pts: JobLevel=1, BusinessTravel=Frequent
--   1 pt : Low JobSatisfaction / EnvironmentSatisfaction /
--          WorkLifeBalance (score=1), YearsAtCompany <= 2
-- ============================================================

USE hr_db;

WITH risk_scores AS (
    SELECT
        EmployeeNumber,
        JobRole,
        Department,
        MaritalStatus,
        OverTime,
        MonthlyIncome,
        JobLevel,
        BusinessTravel,
        JobSatisfaction,
        EnvironmentSatisfaction,
        WorkLifeBalance,
        YearsAtCompany,
        Attrition,
        (
            CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END +
            CASE WHEN MaritalStatus = 'Single' THEN 3 ELSE 0 END +
            CASE WHEN JobRole = 'Sales Representative' THEN 3 ELSE 0 END +
            CASE WHEN MonthlyIncome < 2911 THEN 3 ELSE 0 END +
            CASE WHEN JobLevel = 1 THEN 2 ELSE 0 END +
            CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 ELSE 0 END +
            CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END +
            CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END +
            CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END +
            CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END
        ) AS risk_score
    FROM hr_attrition
),
flagged AS (
    SELECT
        *,
        CASE
            WHEN risk_score >= 8 THEN 'High Risk'
            WHEN risk_score >= 4 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_flag
    FROM risk_scores
)
SELECT * FROM flagged
ORDER BY risk_score DESC;


-- ------------------------------------------------------------
-- Validation: does the risk flag actually separate real
-- attrition outcomes?
-- ------------------------------------------------------------

WITH risk_scores AS (
    SELECT
        EmployeeNumber,
        Attrition,
        (
            CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END +
            CASE WHEN MaritalStatus = 'Single' THEN 3 ELSE 0 END +
            CASE WHEN JobRole = 'Sales Representative' THEN 3 ELSE 0 END +
            CASE WHEN MonthlyIncome < 2911 THEN 3 ELSE 0 END +
            CASE WHEN JobLevel = 1 THEN 2 ELSE 0 END +
            CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 ELSE 0 END +
            CASE WHEN JobSatisfaction = 1 THEN 1 ELSE 0 END +
            CASE WHEN EnvironmentSatisfaction = 1 THEN 1 ELSE 0 END +
            CASE WHEN WorkLifeBalance = 1 THEN 1 ELSE 0 END +
            CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END
        ) AS risk_score
    FROM hr_attrition
),
flagged AS (
    SELECT *,
        CASE
            WHEN risk_score >= 8 THEN 'High Risk'
            WHEN risk_score >= 4 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_flag
    FROM risk_scores
)
SELECT
    risk_flag,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS actual_attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS actual_attrition_rate
FROM flagged
GROUP BY risk_flag
ORDER BY actual_attrition_rate DESC;

-- Result:
--   High Risk    | 294 employees | 126 attritions | 42.86%
--   Medium Risk  | 490 employees |  74 attritions | 15.10%
--   Low Risk     | 686 employees |  37 attritions |  5.39%
--
-- High Risk employees are 20% of headcount but account for
-- 53% of all attritions (126 of 237) — an 8x spread between
-- the highest and lowest risk tiers.