-- ============================================================
-- HR Employee Attrition Analysis
-- 03: Business questions — attrition drivers across demographics,
--     compensation, work conditions, and tenure
-- ============================================================

USE hr_db;

-- ------------------------------------------------------------
-- Batch 1: Overall attrition & basic breakdowns
-- ------------------------------------------------------------

-- Q1: Overall attrition rate
SELECT
    Attrition,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_attrition), 2) AS attr_pct
FROM hr_attrition
GROUP BY Attrition;

-- Q2: Attrition rate by Department
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- Q3: Attrition rate by JobRole
SELECT
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- Q4: Attrition rate by Gender
SELECT
    Gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY Gender
ORDER BY attrition_rate_pct DESC;

-- Q5: Attrition rate by MaritalStatus
SELECT
    MaritalStatus,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;

-- Q5b: Interaction — JobRole x MaritalStatus (deep dive on compounding risk)
SELECT
    JobRole,
    MaritalStatus,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobRole, MaritalStatus
ORDER BY attrition_rate_pct DESC;

-- Q6: Attrition rate by BusinessTravel
SELECT
    BusinessTravel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY BusinessTravel
ORDER BY attrition_rate_pct DESC;

-- ------------------------------------------------------------
-- Batch 2: Compensation & attrition
-- ------------------------------------------------------------

-- Q7: Average MonthlyIncome — left vs stayed
SELECT
    Attrition,
    COUNT(*) AS total_employees,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_attrition
GROUP BY Attrition;

-- Q8: Attrition rate by income quartile
WITH income_bands AS (
    SELECT
        EmployeeNumber,
        Attrition,
        MonthlyIncome,
        NTILE(4) OVER (ORDER BY MonthlyIncome) AS income_quartile
    FROM hr_attrition
)
SELECT
    income_quartile,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    MIN(MonthlyIncome) AS min_income,
    MAX(MonthlyIncome) AS max_income
FROM income_bands
GROUP BY income_quartile
ORDER BY income_quartile;

-- Q9: PercentSalaryHike vs attrition
SELECT
    Attrition,
    COUNT(*) AS total_employees,
    ROUND(AVG(PercentSalaryHike), 2) AS avg_salary_hike_pct
FROM hr_attrition
GROUP BY Attrition;

-- ------------------------------------------------------------
-- Batch 3: Work conditions & satisfaction
-- ------------------------------------------------------------

-- Q10: Attrition rate — OverTime Yes vs No
SELECT
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY OverTime
ORDER BY attrition_rate_pct DESC;

-- Q11: Attrition rate by WorkLifeBalance score
SELECT
    WorkLifeBalance,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- Q12: Attrition rate by JobSatisfaction score
SELECT
    JobSatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Q13: Attrition rate by EnvironmentSatisfaction score
SELECT
    EnvironmentSatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- ------------------------------------------------------------
-- Batch 4: Tenure & career growth
-- ------------------------------------------------------------

-- Q14: Average YearsAtCompany — left vs stayed
SELECT
    Attrition,
    COUNT(*) AS total_employees,
    ROUND(AVG(YearsAtCompany), 2) AS avg_years_at_company
FROM hr_attrition
GROUP BY Attrition;

-- Q15: YearsSinceLastPromotion vs attrition
SELECT
    YearsSinceLastPromotion,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

-- Q16: Attrition rate by JobLevel
SELECT
    JobLevel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY JobLevel
ORDER BY JobLevel;

-- ------------------------------------------------------------
-- Batch 5: Commute distance & interaction with OverTime
-- ------------------------------------------------------------

-- Q17: Attrition rate by DistanceFromHome band
WITH distance_bands AS (
    SELECT
        EmployeeNumber,
        Attrition,
        DistanceFromHome,
        CASE
            WHEN DistanceFromHome <= 5 THEN '1. 0-5 (Near)'
            WHEN DistanceFromHome <= 10 THEN '2. 6-10 (Moderate)'
            WHEN DistanceFromHome <= 20 THEN '3. 11-20 (Far)'
            ELSE '4. 21+ (Very Far)'
        END AS distance_band
    FROM hr_attrition
)
SELECT
    distance_band,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(DistanceFromHome), 2) AS avg_distance_in_band
FROM distance_bands
GROUP BY distance_band
ORDER BY distance_band;

-- Q18: DistanceFromHome band x OverTime interaction
WITH distance_bands AS (
    SELECT
        EmployeeNumber,
        Attrition,
        OverTime,
        CASE
            WHEN DistanceFromHome <= 5 THEN '1. 0-5 (Near)'
            WHEN DistanceFromHome <= 10 THEN '2. 6-10 (Moderate)'
            WHEN DistanceFromHome <= 20 THEN '3. 11-20 (Far)'
            ELSE '4. 21+ (Very Far)'
        END AS distance_band
    FROM hr_attrition
)
SELECT
    distance_band,
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM distance_bands
GROUP BY distance_band, OverTime
ORDER BY distance_band, OverTime DESC;