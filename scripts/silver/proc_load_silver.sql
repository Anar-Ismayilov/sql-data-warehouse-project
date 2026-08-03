USE DataWarehouse;
GO
TRUNCATE TABLE silver.crm_cust_info;

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

TRUNCATE TABLE silver.crm_prd_info;
GO

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

 
