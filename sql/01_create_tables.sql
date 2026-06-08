-- =============================================================
-- 01_create_tables.sql
-- Creates the staging and production tables for Churn Analysis
-- Database: db_Churn
-- =============================================================

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'db_Churn')
BEGIN
    CREATE DATABASE db_Churn;
END
GO

USE db_Churn;
GO

-- =============================================================
-- STAGING TABLE
-- Raw data is loaded into this table first (via CSV import)
-- =============================================================

IF OBJECT_ID('dbo.stg_Churn', 'U') IS NOT NULL
    DROP TABLE dbo.stg_Churn;
GO

CREATE TABLE dbo.stg_Churn (
    Customer_ID                  VARCHAR(20),
    Gender                       VARCHAR(10),
    Age                          INT,
    Married                      VARCHAR(5),
    State                        VARCHAR(50),
    Number_of_Referrals          INT,
    Tenure_in_Months             INT,
    Value_Deal                   VARCHAR(50),
    Phone_Service                VARCHAR(5),
    Multiple_Lines               VARCHAR(5),
    Internet_Service             VARCHAR(5),
    Internet_Type                VARCHAR(20),
    Online_Security              VARCHAR(5),
    Online_Backup                VARCHAR(5),
    Device_Protection_Plan       VARCHAR(5),
    Premium_Support              VARCHAR(5),
    Streaming_TV                 VARCHAR(5),
    Streaming_Movies             VARCHAR(5),
    Streaming_Music              VARCHAR(5),
    Unlimited_Data               VARCHAR(5),
    Contract                     VARCHAR(20),
    Paperless_Billing            VARCHAR(5),
    Payment_Method               VARCHAR(50),
    Monthly_Charge               FLOAT,
    Total_Charges                FLOAT,
    Total_Refunds                FLOAT,
    Total_Extra_Data_Charges     FLOAT,
    Total_Long_Distance_Charges  FLOAT,
    Total_Revenue                FLOAT,
    Customer_Status              VARCHAR(20),
    Churn_Category               VARCHAR(50),
    Churn_Reason                 VARCHAR(100)
);
GO

-- =============================================================
-- PRODUCTION TABLE
-- Clean data (nulls handled) is inserted here from staging
-- This table is used by Power BI via views
-- =============================================================

IF OBJECT_ID('dbo.prod_Churn', 'U') IS NOT NULL
    DROP TABLE dbo.prod_Churn;
GO

CREATE TABLE dbo.prod_Churn (
    Customer_ID                  VARCHAR(20),
    Gender                       VARCHAR(10),
    Age                          INT,
    Married                      VARCHAR(5),
    State                        VARCHAR(50),
    Number_of_Referrals          INT,
    Tenure_in_Months             INT,
    Value_Deal                   VARCHAR(50),
    Phone_Service                VARCHAR(5),
    Multiple_Lines               VARCHAR(5),
    Internet_Service             VARCHAR(5),
    Internet_Type                VARCHAR(20),
    Online_Security              VARCHAR(5),
    Online_Backup                VARCHAR(5),
    Device_Protection_Plan       VARCHAR(5),
    Premium_Support              VARCHAR(5),
    Streaming_TV                 VARCHAR(5),
    Streaming_Movies             VARCHAR(5),
    Streaming_Music              VARCHAR(5),
    Unlimited_Data               VARCHAR(5),
    Contract                     VARCHAR(20),
    Paperless_Billing            VARCHAR(5),
    Payment_Method               VARCHAR(50),
    Monthly_Charge               FLOAT,
    Total_Charges                FLOAT,
    Total_Refunds                FLOAT,
    Total_Extra_Data_Charges     FLOAT,
    Total_Long_Distance_Charges  FLOAT,
    Total_Revenue                FLOAT,
    Customer_Status              VARCHAR(20),
    Churn_Category               VARCHAR(50),
    Churn_Reason                 VARCHAR(100)
);
GO

PRINT 'Tables stg_Churn and prod_Churn created successfully.';
GO
