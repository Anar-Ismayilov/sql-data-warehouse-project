/*
===============================================================================
Stored Procedure: Load Silver Layer (Source -> Silver)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'silver' schema from external CSV files. 
    It performs the following actions:
    - Truncates the silver tables before loading data.
    - Uses the `Insert Into` command to load data from bronze schema tables to silver tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @total_start DATETIME ,@total_end DATETIME
	BEGIN TRY

		SET @total_start  = GETDATE()
		PRINT '========================================================='
		PRINT 'LOADING SILVER LAYER'
		PRINT '========================================================='

		PRINT '---------------------------------------------------------'
		PRINT 'LOADING CRM TABLES'
		PRINT '---------------------------------------------------------'
		PRINT '>> Truncate Table silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;
		SET @start_time=GETDATE()
		PRINT '>> Insert Data Into: silver.crm_cust_info'
		INSERT INTO DataWarehouse.silver.crm_cust_info
		(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)

		SELECT
			cst_info.cst_id,
			cst_info.cst_key,
			TRIM(cst_info.cst_firstname) cst_firstname ,
			TRIM(cst_info.cst_lastname) cst_lastname,
			CASE WHEN UPPER(TRIM(cst_info.cst_marital_status))='S' THEN 'Single'
					WHEN UPPER(TRIM(cst_info.cst_marital_status))='M' THEN 'Merried'
					ELSE 'n/a'
					END cst_marital_status,
	
			CASE WHEN UPPER(TRIM(cst_info.cst_gndr))='F' THEN 'Female'
					WHEN UPPER(TRIM(cst_info.cst_gndr))='M' THEN 'Male'
					ELSE 'n/a'
					END cst_gndr,
			cst_info.cst_create_date
		FROM(
			SELECT
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY	cst_create_date DESC) flag 
			FROM
				DataWarehouse.bronze.crm_cust_info
		) cst_info
		WHERE flag=1;
		SET @end_time=GETDATE()
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'

		
		PRINT '>> Truncate Table silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;
		
		SET @start_time = GETDATE()
		PRINT '>> Insert Data Into: silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info
		(
			prd_id			 , 
			cat_id		,	
			prd_key		,	
			prd_nm		,	
			prd_cost	,	    
			prd_line	,
			prd_start_dt	,
			prd_end_dt	  
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_info.prd_key,1,5),'-','_')  cat_id,
			SUBSTRING(prd_info.prd_key,7,LEN(prd_info.prd_key))prd_key,
			prd_nm,
			ISNULL(prd_cost,0) prd_cost,
			ISNULL(prd_line,'n/a'),
			CAST(prd_info.prd_start_dt AS DATE),
			DATEADD(DAY,-1,CAST(LEAD(prd_info.prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE)) prd_end_date
			FROM DataWarehouse.bronze.crm_prd_info prd_info
			;
 		SET @end_time=GETDATE()
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'
		
		PRINT '>> Truncate Table silver.crm_sales_details'
		TRUNCATE TABLE DataWarehouse.silver.crm_sales_details;
		SET @start_time=GETDATE()
		PRINT '>> Insert Data Into: silver.crm_sales_details'
		INSERT INTO DataWarehouse.silver.crm_sales_details
		(
		sls_ord_num		,
			sls_prd_key	,
			sls_cust_id	,           
			sls_order_dt,            
			sls_ship_dt	,         
			sls_due_dt,            
			sls_sales,           
			sls_quantity,            
			sls_price	
		)
		SELECT 
			sal_det.sls_ord_num,
			sal_det.sls_prd_key,
			sal_det.sls_cust_id,
			CASE
				WHEN sal_det.sls_order_dt<=0 OR LEN(sal_det.sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sal_det.sls_order_dt AS VARCHAR) AS DATE) 
			END sls_order_dt,

			CASE
				WHEN sal_det.sls_ship_dt<=0 OR LEN(sal_det.sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sal_det.sls_ship_dt AS VARCHAR) AS DATE) 
			END sls_ship_dt,

			CASE
				WHEN sal_det.sls_due_dt<=0 OR LEN(sal_det.sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sal_det.sls_due_dt AS VARCHAR) AS DATE)
			END sls_due_dt,

			CASE 
				WHEN sal_det.sls_sales <=0 OR sal_det.sls_sales IS NULL OR sal_det.sls_sales != sal_det.sls_quantity* ABS(sal_det.sls_price) 
				THEN sal_det.sls_quantity*sal_det.sls_price
				ELSE sal_det.sls_sales
			END sls_sales,

			sal_det.sls_quantity,

			CASE 
				WHEN sal_det.sls_price <=0 OR sal_det.sls_price IS NULL  
				THEN ABS(sal_det.sls_sales)/sal_det.sls_quantity
				ELSE sal_det.sls_price
			END sls_price
	
		FROM
			DataWarehouse.bronze.crm_sales_details sal_det;
		SET @end_time=GETDATE()
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'
		
		PRINT '---------------------------------------------------------'
		PRINT 'LOADING ERP TABLES'
		PRINT '---------------------------------------------------------'
		SET @start_time = GETDATE()
		PRINT '>> Truncate Table silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12  ;
		PRINT '>> Insert Data Into: silver.erp_cust_az12'

		INSERT INTO DataWarehouse.silver.erp_cust_az12
		(
		cid,
		bdate,
		gen
		)
		SELECT
			CASE
				WHEN cust_az.CID LIKE 'NAS%' THEN SUBSTRING(cust_az.CID,4,LEN(cust_az.CID))
				ELSE cust_az.CID
			END CID,

			CASE
				WHEN cust_az.BDATE>GETDATE() THEN NULL
				ELSE cust_az.BDATE
			END,
	
			CASE 
				WHEN cust_az.GEN LIKE 'F%' THEN 'Female'
				WHEN cust_az.GEN LIKE 'M%' THEN 'Male'
				ELSE 'n/a'
			END
		FROM
			DataWarehouse.bronze.erp_cust_az12 AS cust_az
		WHERE cust_az.BDATE>'1916-01-01'; 
				SET @end_time=GETDATE()
				PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'

		SET @start_time = GETDATE()
		PRINT '>> Truncate Table silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Insert Data Into: silver.erp_loc_a101'

		INSERT INTO DataWarehouse.silver.erp_loc_a101
		(
		cid,
		cntry
		)

		SELECT 
			REPLACE(b_loc_a101.CID,'-',''),
			CASE 
				WHEN b_loc_a101.CNTRY IN ('US','USA') THEN 'United States'
				WHEN b_loc_a101.CNTRY ='DE' THEN 'Germany'
				WHEN TRIM(b_loc_a101.CNTRY) ='' OR b_loc_a101.CNTRY IS NULL THEN 'n/a'
				ELSE TRIM(b_loc_a101.CNTRY)
				END cntry
		FROM 
			DataWarehouse.bronze.erp_loc_a101 b_loc_a101;
		SET @end_time=GETDATE()
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'

		SET @start_time = GETDATE()
		PRINT '>> Truncate Table silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Insert Data Into: silver.erp_px_cat_g1v2'

		INSERT INTO DataWarehouse.silver.erp_px_cat_g1v2
		(
		id,
		cat,
		subcat,
		maintenance
		)
		SELECT
			b_cat_g1v2.İD,
			b_cat_g1v2.CAT,
			b_cat_g1v2.SUBCAT,
			b_cat_g1v2.MAINTENANCE
		FROM
			DataWarehouse.bronze.erp_px_cat_g1v2 b_cat_g1v2;
		SET @end_time=GETDATE()
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) as varchar) + 'seconds'
		END TRY
		BEGIN CATCH
		PRINT '====================================================================='
			PRINT 'ERROC OCCURED DURING LOADING SILVER LAYER'
			PRINT 'ERROR MESSAGE IS '+ ERROR_MESSAGE()	
			PRINT 'ERROR MESSAGE IS '+ ERROR_NUMBER()
 			PRINT '====================================================================='
	END CATCH
END
