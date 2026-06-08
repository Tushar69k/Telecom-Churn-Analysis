-- =============================================================
-- 03_create_views.sql
-- Creates views consumed by Power BI
-- Database: db_Churn
-- =============================================================

USE db_Churn;
GO

-- =============================================================
-- VIEW 1 — vw_ChurnData
-- Customers who have either Stayed or Churned.
-- Used for churn analysis and ML model training.
-- =============================================================

IF OBJECT_ID('dbo.vw_ChurnData', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ChurnData;
GO

CREATE VIEW dbo.vw_ChurnData AS
    SELECT *
    FROM dbo.prod_Churn
    WHERE Customer_Status IN ('Churned', 'Stayed');
GO

PRINT 'View vw_ChurnData created successfully.';
GO


-- =============================================================
-- VIEW 2 — vw_JoinData
-- Customers who recently joined.
-- Used for churn prediction on new customers.
-- =============================================================

IF OBJECT_ID('dbo.vw_JoinData', 'V') IS NOT NULL
    DROP VIEW dbo.vw_JoinData;
GO

CREATE VIEW dbo.vw_JoinData AS
    SELECT *
    FROM dbo.prod_Churn
    WHERE Customer_Status = 'Joined';
GO

PRINT 'View vw_JoinData created successfully.';
GO
