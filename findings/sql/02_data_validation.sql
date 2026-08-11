-- ============================================================
-- HR Employee Attrition Analysis
-- 02: Data validation — nulls, duplicates, categorical integrity,
--     and numeric range checks
-- ============================================================

USE hr_db;

-- 1. Null / blank-string check across all columns
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_nulls,
    SUM(CASE WHEN Attrition IS NULL OR Attrition = '' THEN 1 ELSE 0 END) AS Attrition_nulls,
    SUM(CASE WHEN BusinessTravel IS NULL OR BusinessTravel = '' THEN 1 ELSE 0 END) AS BusinessTravel_nulls,
    SUM(CASE WHEN DailyRate IS NULL THEN 1 ELSE 0 END) AS DailyRate_nulls,
    SUM(CASE WHEN Department IS NULL OR Department = '' THEN 1 ELSE 0 END) AS Department_nulls,
    SUM(CASE WHEN DistanceFromHome IS NULL THEN 1 ELSE 0 END) AS DistanceFromHome_nulls,
    SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS Education_nulls,
    SUM(CASE WHEN EducationField IS NULL OR EducationField = '' THEN 1 ELSE 0 END) AS EducationField_nulls,
    SUM(CASE WHEN EmployeeCount IS NULL THEN 1 ELSE 0 END) AS EmployeeCount_nulls,
    SUM(CASE WHEN EmployeeNumber IS NULL THEN 1 ELSE 0 END) AS EmployeeNumber_nulls,
    SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS EnvironmentSatisfaction_nulls,
    SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Gender_nulls,
    SUM(CASE WHEN HourlyRate IS NULL THEN 1 ELSE 0 END) AS HourlyRate_nulls,
    SUM(CASE WHEN JobInvolvement IS NULL THEN 1 ELSE 0 END) AS JobInvolvement_nulls,
    SUM(CASE WHEN JobLevel IS NULL THEN 1 ELSE 0 END) AS JobLevel_nulls,
    SUM(CASE WHEN JobRole IS NULL OR JobRole = '' THEN 1 ELSE 0 END) AS JobRole_nulls,
    SUM(CASE WHEN JobSatisfaction IS NULL THEN 1 ELSE 0 END) AS JobSatisfaction_nulls,
    SUM(CASE WHEN MaritalStatus IS NULL OR MaritalStatus = '' THEN 1 ELSE 0 END) AS MaritalStatus_nulls,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_nulls,
    SUM(CASE WHEN MonthlyRate IS NULL THEN 1 ELSE 0 END) AS MonthlyRate_nulls,
    SUM(CASE WHEN NumCompaniesWorked IS NULL THEN 1 ELSE 0 END) AS NumCompaniesWorked_nulls,
    SUM(CASE WHEN Over18 IS NULL OR Over18 = '' THEN 1 ELSE 0 END) AS Over18_nulls,
    SUM(CASE WHEN OverTime IS NULL OR OverTime = '' THEN 1 ELSE 0 END) AS OverTime_nulls,
    SUM(CASE WHEN PercentSalaryHike IS NULL THEN 1 ELSE 0 END) AS PercentSalaryHike_nulls,
    SUM(CASE WHEN PerformanceRating IS NULL THEN 1 ELSE 0 END) AS PerformanceRating_nulls,
    SUM(CASE WHEN RelationshipSatisfaction IS NULL THEN 1 ELSE 0 END) AS RelationshipSatisfaction_nulls,
    SUM(CASE WHEN StandardHours IS NULL THEN 1 ELSE 0 END) AS StandardHours_nulls,
    SUM(CASE WHEN StockOptionLevel IS NULL THEN 1 ELSE 0 END) AS StockOptionLevel_nulls,
    SUM(CASE WHEN TotalWorkingYears IS NULL THEN 1 ELSE 0 END) AS TotalWorkingYears_nulls,
    SUM(CASE WHEN TrainingTimesLastYear IS NULL THEN 1 ELSE 0 END) AS TrainingTimesLastYear_nulls,
    SUM(CASE WHEN WorkLifeBalance IS NULL THEN 1 ELSE 0 END) AS WorkLifeBalance_nulls,
    SUM(CASE WHEN YearsAtCompany IS NULL THEN 1 ELSE 0 END) AS YearsAtCompany_nulls,
    SUM(CASE WHEN YearsInCurrentRole IS NULL THEN 1 ELSE 0 END) AS YearsInCurrentRole_nulls,
    SUM(CASE WHEN YearsSinceLastPromotion IS NULL THEN 1 ELSE 0 END) AS YearsSinceLastPromotion_nulls,
    SUM(CASE WHEN YearsWithCurrManager IS NULL THEN 1 ELSE 0 END) AS YearsWithCurrManager_nulls
FROM hr_attrition;

-- 2. Duplicate check on primary key
SELECT EmployeeNumber, COUNT(*)
FROM hr_attrition
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- 3. Categorical value consistency checks
SELECT DISTINCT Attrition FROM hr_attrition;
SELECT DISTINCT BusinessTravel FROM hr_attrition;
SELECT DISTINCT Department FROM hr_attrition;
SELECT DISTINCT EducationField FROM hr_attrition;
SELECT DISTINCT Gender FROM hr_attrition;
SELECT DISTINCT JobRole FROM hr_attrition;
SELECT DISTINCT MaritalStatus FROM hr_attrition;
SELECT DISTINCT OverTime FROM hr_attrition;
SELECT DISTINCT Over18 FROM hr_attrition;

-- 4. Numeric range checks
SELECT
    MIN(Age) AS min_age, MAX(Age) AS max_age,
    MIN(MonthlyIncome) AS min_income, MAX(MonthlyIncome) AS max_income,
    MIN(YearsAtCompany) AS min_years, MAX(YearsAtCompany) AS max_years,
    MIN(JobSatisfaction) AS min_jobsat, MAX(JobSatisfaction) AS max_jobsat,
    MIN(EnvironmentSatisfaction) AS min_envsat, MAX(EnvironmentSatisfaction) AS max_envsat,
    MIN(WorkLifeBalance) AS min_wlb, MAX(WorkLifeBalance) AS max_wlb
FROM hr_attrition;