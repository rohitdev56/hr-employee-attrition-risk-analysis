-- ============================================================
-- HR Employee Attrition Analysis
-- 01: Database setup, schema creation, and data load
-- Dataset: IBM HR Analytics Employee Attrition (Kaggle)
-- ============================================================

CREATE DATABASE IF NOT EXISTS hr_db;
USE hr_db;

CREATE TABLE hr_attrition (
    Age INT,
    Attrition VARCHAR(5),
    BusinessTravel VARCHAR(30),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'file path'
INTO TABLE hr_attrition
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows FROM hr_attrition;