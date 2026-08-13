USE DataWarehouse;
GO

--Explore All Objects in the Database

SELECT
*
FROM
	INFORMATION_SCHEMA.TABLES;

--Explore All Calumns in the Database
SELECT
*
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
