--crm_cust_info
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result

SELECT
cust_info.cst_id
FROM
	DataWarehouse.silver.crm_cust_info cust_info
GROUP BY cust_info.cst_id
HAVING COUNT(cust_info.cst_id)>1 AND cust_info.cst_id IS NULL;

--Check for unwanted spaces
--Expectation: No Result

SELECT 
	cust_info.cst_firstname,
	cust_info.cst_lastname
FROM
	DataWarehouse.silver.crm_cust_info cust_info
WHERE 
	TRIM(cust_info.cst_firstname) != cust_info.cst_firstname
OR
	TRIM(cust_info.cst_lastname) != cust_info.cst_lastname;


--Data Standardization and Consistency 
SELECT 
	DISTINCT(cust_info.cst_marital_status)
FROM
	DataWarehouse.silver.crm_cust_info cust_info;

SELECT 
	DISTINCT(cust_info.cst_gndr)
FROM
	DataWarehouse.silver.crm_cust_info cust_info;

SELECT
*
FROM 
DataWarehouse.silver.crm_cust_info;

----------------------------------------------------------------------------------------------------

--crm_prd_info
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result
SELECT
	prd_info.prd_id
FROM
	DataWarehouse.silver.crm_prd_info prd_info
GROUP BY prd_info.prd_id
HAVING COUNT(prd_info.prd_id)>1 or prd_info.prd_id IS NULL;

--Check for unwanted spaces
--Expectation: No Result
select prd_nm
from
	DataWarehouse.silver.crm_prd_info
where TRIM(prd_nm)!=prd_nm;

--Check of Invalid Date Orders
--Expectation: No Result	
SELECT
	*
FROM
	DataWarehouse.silver.crm_prd_info prd_info
WHERE
	prd_info.prd_end_dt<prd_info.prd_start_dt;

--Data Standardization and Consistency 
SELECT 
	DISTINCT(prd_info.prd_line)
FROM
	DataWarehouse.silver.crm_prd_info prd_info;

--True Date Data
--Expectation: No Result	
SELECT
*
FROM 
	DataWarehouse.silver.crm_prd_info prd_info
WHERE
prd_info.prd_end_dt<prd_info.prd_start_dt;

----------------------------------------------------------------------------------------------------

--crm_sales_details
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result
SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	TRIM(sal_det.sls_ord_num) != sal_det.sls_ord_num;

--Check Data Matching
--Expectation: No Result
SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_prd_key NOT IN (SELECT prd_info.prd_key FROM DataWarehouse.silver.crm_prd_info prd_info);

SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_cust_id NOT IN (SELECT cust_info.cst_id FROM DataWarehouse.silver.crm_cust_info cust_info);

--Find Into Bronze for Invalide Date

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_order_dt<=0 
	OR LEN(sal_det.sls_order_dt) != 8
	OR sal_det.sls_order_dt >20500101
	OR sal_det.sls_order_dt <19000101;

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_ship_dt<=0 
	OR LEN(sal_det.sls_ship_dt) != 8
	OR sal_det.sls_ship_dt >20500101
	OR sal_det.sls_ship_dt <19000101;

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_due_dt<=0 
	OR LEN(sal_det.sls_due_dt) != 8
	OR sal_det.sls_due_dt >20500101
	OR sal_det.sls_due_dt <19000101;

--Check Invalide Values
--Expectation: No Result
SELECT 
	sal_det.sls_sales,
	sal_det.sls_quantity,
	sal_det.sls_price
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_sales<=0
	OR sal_det.sls_sales IS NULL
	OR sal_det.sls_quantity <=0
	OR sal_det.sls_quantity IS NULL
	OR sal_det.sls_price <=0
	OR sal_det.sls_price IS NULL
	OR sal_det.sls_sales != sal_det.sls_quantity * sal_det.sls_price;


--crm_cust_info
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result

SELECT
cust_info.cst_id
FROM
	DataWarehouse.silver.crm_cust_info cust_info
GROUP BY cust_info.cst_id
HAVING COUNT(cust_info.cst_id)>1 AND cust_info.cst_id IS NULL;

--Check for unwanted spaces
--Expectation: No Result

SELECT 
	cust_info.cst_firstname,
	cust_info.cst_lastname
FROM
	DataWarehouse.silver.crm_cust_info cust_info
WHERE 
	TRIM(cust_info.cst_firstname) != cust_info.cst_firstname
OR
	TRIM(cust_info.cst_lastname) != cust_info.cst_lastname;


--Data Standardization and Consistency 
SELECT 
	DISTINCT(cust_info.cst_marital_status)
FROM
	DataWarehouse.silver.crm_cust_info cust_info;

SELECT 
	DISTINCT(cust_info.cst_gndr)
FROM
	DataWarehouse.silver.crm_cust_info cust_info;

SELECT
*
FROM 
DataWarehouse.silver.crm_cust_info;

----------------------------------------------------------------------------------------------------

--crm_prd_info
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result
SELECT
	prd_info.prd_id
FROM
	DataWarehouse.silver.crm_prd_info prd_info
GROUP BY prd_info.prd_id
HAVING COUNT(prd_info.prd_id)>1 or prd_info.prd_id IS NULL;

--Check for unwanted spaces
--Expectation: No Result
select prd_nm
from
	DataWarehouse.silver.crm_prd_info
where TRIM(prd_nm)!=prd_nm;

--Check of Invalid Date Orders
--Expectation: No Result	
SELECT
	*
FROM
	DataWarehouse.silver.crm_prd_info prd_info
WHERE
	prd_info.prd_end_dt<prd_info.prd_start_dt;

--Data Standardization and Consistency 
SELECT 
	DISTINCT(prd_info.prd_line)
FROM
	DataWarehouse.silver.crm_prd_info prd_info;

--True Date Data
--Expectation: No Result	
SELECT
*
FROM 
	DataWarehouse.silver.crm_prd_info prd_info
WHERE
prd_info.prd_end_dt<prd_info.prd_start_dt;

----------------------------------------------------------------------------------------------------

--crm_sales_details
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result
SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	TRIM(sal_det.sls_ord_num) != sal_det.sls_ord_num;

--Check Data Matching
--Expectation: No Result
SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_prd_key NOT IN (SELECT prd_info.prd_key FROM DataWarehouse.silver.crm_prd_info prd_info);

SELECT
	*
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_cust_id NOT IN (SELECT cust_info.cst_id FROM DataWarehouse.silver.crm_cust_info cust_info);

--Find Into Bronze for Invalide Date

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_order_dt<=0 
	OR LEN(sal_det.sls_order_dt) != 8
	OR sal_det.sls_order_dt >20500101
	OR sal_det.sls_order_dt <19000101;

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_ship_dt<=0 
	OR LEN(sal_det.sls_ship_dt) != 8
	OR sal_det.sls_ship_dt >20500101
	OR sal_det.sls_ship_dt <19000101;

SELECT
*
FROM
	DataWarehouse.bronze.crm_sales_details sal_det
WHERE 
	   sal_det.sls_due_dt<=0 
	OR LEN(sal_det.sls_due_dt) != 8
	OR sal_det.sls_due_dt >20500101
	OR sal_det.sls_due_dt <19000101;

--Check Invalide Values
--Expectation: No Result
SELECT 
	sal_det.sls_sales,
	sal_det.sls_quantity,
	sal_det.sls_price
FROM
	DataWarehouse.silver.crm_sales_details sal_det
WHERE 
	sal_det.sls_sales<=0
	OR sal_det.sls_sales IS NULL
	OR sal_det.sls_quantity <=0
	OR sal_det.sls_quantity IS NULL
	OR sal_det.sls_price <=0
	OR sal_det.sls_price IS NULL
	OR sal_det.sls_sales != sal_det.sls_quantity * sal_det.sls_price;


--=================================================================================================================
--erp_cust_az12
--Check Data Matching	
--Expectation: No Result
SELECT
	*
FROM
	DataWarehouse.silver.erp_cust_az12 AS cust_az
WHERE cust_az.CID  NOT IN (SELECT cust_in.cst_key FROM DataWarehouse.silver.crm_cust_info cust_in);

--Check for Invalide Date
--Expectation: No Result
SELECT
*
FROM
	DataWarehouse.silver.erp_cust_az12 cust_az
WHERE cust_az.BDATE<'1916-01-01' OR cust_az.BDATE>GETDATE();

--Data Standardization and Consistency 
SELECT 
	DISTINCT(cust_az.GEN)
FROM
	DataWarehouse.silver.erp_cust_az12 cust_az;








	





