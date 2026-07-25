use DataWarehouse;

BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Asus2\Desktop\Sql_course\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
); 
GO

SELECT
*
FROM DataWarehouse.bronze.crm_cust_info
