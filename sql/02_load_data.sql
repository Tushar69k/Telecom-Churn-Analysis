-- =============================================================
-- 02_load_data.sql
-- Step 1 : Load CSV into stg_Churn
-- Step 2 : Explore the staging data
-- Step 3 : Check for NULLs
-- Step 4 : Insert clean data into prod_Churn
-- Database: db_Churn
-- =============================================================

USE db_Churn;
GO

-- =============================================================
-- STEP 1 — LOAD CSV INTO STAGING TABLE
-- Update the file path below to match the location of
-- telecom_customers.csv on your machine before running.
-- =============================================================

BULK INSERT dbo.stg_Churn
FROM 'C:\YOUR_PATH\telecom_customers.csv'   -- <-- UPDATE THIS PATH
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '\n',
    FIRSTROW        = 2,          -- Skip header row
    TABLOCK
);
GO

PRINT 'CSV loaded into stg_Churn successfully.';
GO


-- =============================================================
-- STEP 2 — DATA EXPLORATION: CHECK DISTINCT VALUES
-- Run these individually to understand the data distribution.
-- =============================================================

-- Gender distribution
SELECT
    Gender,
    COUNT(Gender)                                              AS TotalCount,
    COUNT(Gender) * 1.0 / (SELECT COUNT(*) FROM stg_Churn)   AS Percentage
FROM stg_Churn
GROUP BY Gender;

-- Contract type distribution
SELECT
    Contract,
    COUNT(Contract)                                            AS TotalCount,
    COUNT(Contract) * 1.0 / (SELECT COUNT(*) FROM stg_Churn) AS Percentage
FROM stg_Churn
GROUP BY Contract;

-- Customer status + revenue breakdown
SELECT
    Customer_Status,
    COUNT(Customer_Status)                                             AS TotalCount,
    SUM(Total_Revenue)                                                 AS TotalRev,
    SUM(Total_Revenue) / (SELECT SUM(Total_Revenue) FROM stg_Churn) * 100 AS RevPercentage
FROM stg_Churn
GROUP BY Customer_Status;

-- State distribution (sorted by highest share)
SELECT
    State,
    COUNT(State)                                               AS TotalCount,
    COUNT(State) * 1.0 / (SELECT COUNT(*) FROM stg_Churn)     AS Percentage
FROM stg_Churn
GROUP BY State
ORDER BY Percentage DESC;


-- =============================================================
-- STEP 3 — DATA EXPLORATION: CHECK FOR NULLs IN ALL COLUMNS
-- =============================================================

SELECT
    SUM(CASE WHEN Customer_ID                 IS NULL THEN 1 ELSE 0 END) AS Customer_ID_Null_Count,
    SUM(CASE WHEN Gender                      IS NULL THEN 1 ELSE 0 END) AS Gender_Null_Count,
    SUM(CASE WHEN Age                         IS NULL THEN 1 ELSE 0 END) AS Age_Null_Count,
    SUM(CASE WHEN Married                     IS NULL THEN 1 ELSE 0 END) AS Married_Null_Count,
    SUM(CASE WHEN State                       IS NULL THEN 1 ELSE 0 END) AS State_Null_Count,
    SUM(CASE WHEN Number_of_Referrals         IS NULL THEN 1 ELSE 0 END) AS Number_of_Referrals_Null_Count,
    SUM(CASE WHEN Tenure_in_Months            IS NULL THEN 1 ELSE 0 END) AS Tenure_in_Months_Null_Count,
    SUM(CASE WHEN Value_Deal                  IS NULL THEN 1 ELSE 0 END) AS Value_Deal_Null_Count,
    SUM(CASE WHEN Phone_Service               IS NULL THEN 1 ELSE 0 END) AS Phone_Service_Null_Count,
    SUM(CASE WHEN Multiple_Lines              IS NULL THEN 1 ELSE 0 END) AS Multiple_Lines_Null_Count,
    SUM(CASE WHEN Internet_Service            IS NULL THEN 1 ELSE 0 END) AS Internet_Service_Null_Count,
    SUM(CASE WHEN Internet_Type               IS NULL THEN 1 ELSE 0 END) AS Internet_Type_Null_Count,
    SUM(CASE WHEN Online_Security             IS NULL THEN 1 ELSE 0 END) AS Online_Security_Null_Count,
    SUM(CASE WHEN Online_Backup               IS NULL THEN 1 ELSE 0 END) AS Online_Backup_Null_Count,
    SUM(CASE WHEN Device_Protection_Plan      IS NULL THEN 1 ELSE 0 END) AS Device_Protection_Plan_Null_Count,
    SUM(CASE WHEN Premium_Support             IS NULL THEN 1 ELSE 0 END) AS Premium_Support_Null_Count,
    SUM(CASE WHEN Streaming_TV                IS NULL THEN 1 ELSE 0 END) AS Streaming_TV_Null_Count,
    SUM(CASE WHEN Streaming_Movies            IS NULL THEN 1 ELSE 0 END) AS Streaming_Movies_Null_Count,
    SUM(CASE WHEN Streaming_Music             IS NULL THEN 1 ELSE 0 END) AS Streaming_Music_Null_Count,
    SUM(CASE WHEN Unlimited_Data              IS NULL THEN 1 ELSE 0 END) AS Unlimited_Data_Null_Count,
    SUM(CASE WHEN Contract                    IS NULL THEN 1 ELSE 0 END) AS Contract_Null_Count,
    SUM(CASE WHEN Paperless_Billing           IS NULL THEN 1 ELSE 0 END) AS Paperless_Billing_Null_Count,
    SUM(CASE WHEN Payment_Method              IS NULL THEN 1 ELSE 0 END) AS Payment_Method_Null_Count,
    SUM(CASE WHEN Monthly_Charge              IS NULL THEN 1 ELSE 0 END) AS Monthly_Charge_Null_Count,
    SUM(CASE WHEN Total_Charges               IS NULL THEN 1 ELSE 0 END) AS Total_Charges_Null_Count,
    SUM(CASE WHEN Total_Refunds               IS NULL THEN 1 ELSE 0 END) AS Total_Refunds_Null_Count,
    SUM(CASE WHEN Total_Extra_Data_Charges    IS NULL THEN 1 ELSE 0 END) AS Total_Extra_Data_Charges_Null_Count,
    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Long_Distance_Charges_Null_Count,
    SUM(CASE WHEN Total_Revenue               IS NULL THEN 1 ELSE 0 END) AS Total_Revenue_Null_Count,
    SUM(CASE WHEN Customer_Status             IS NULL THEN 1 ELSE 0 END) AS Customer_Status_Null_Count,
    SUM(CASE WHEN Churn_Category              IS NULL THEN 1 ELSE 0 END) AS Churn_Category_Null_Count,
    SUM(CASE WHEN Churn_Reason                IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Null_Count
FROM stg_Churn;
GO


-- =============================================================
-- STEP 4 — CLEAN DATA AND INSERT INTO PRODUCTION TABLE
-- NULLs are replaced with sensible defaults before insert.
-- Run this only after reviewing the NULL counts above.
-- =============================================================

-- Clear prod table if re-running this script
TRUNCATE TABLE dbo.prod_Churn;
GO

INSERT INTO dbo.prod_Churn
SELECT
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'None')                  AS Value_Deal,
    Phone_Service,
    ISNULL(Multiple_Lines, 'No')                AS Multiple_Lines,
    Internet_Service,
    ISNULL(Internet_Type, 'None')               AS Internet_Type,
    ISNULL(Online_Security, 'No')               AS Online_Security,
    ISNULL(Online_Backup, 'No')                 AS Online_Backup,
    ISNULL(Device_Protection_Plan, 'No')        AS Device_Protection_Plan,
    ISNULL(Premium_Support, 'No')               AS Premium_Support,
    ISNULL(Streaming_TV, 'No')                  AS Streaming_TV,
    ISNULL(Streaming_Movies, 'No')              AS Streaming_Movies,
    ISNULL(Streaming_Music, 'No')               AS Streaming_Music,
    ISNULL(Unlimited_Data, 'No')                AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others')            AS Churn_Category,
    ISNULL(Churn_Reason, 'Others')              AS Churn_Reason
FROM dbo.stg_Churn;
GO

PRINT 'Clean data inserted into prod_Churn successfully.';
GO
