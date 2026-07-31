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

--crm_prd_info
--Check For Nulls or Dublicates in Primary Key
--Expectation: No Result
SELECT
	prd_info.prd_id
FROM
	DataWarehouse.silver.crm_prd_info prd_info
GROUP BY prd_info.prd_id
HAVING COUNT(prd_info.prd_id)>1 or prd_info.prd_id IS NULL

--Check for unwanted spaces
--Expectation: No Result
select prd_nm
from
	DataWarehouse.silver.crm_prd_info
where TRIM(prd_nm)!=prd_nm

--Check of Invalid Date Orders
--Expectation: No Result	
SELECT
	*
FROM
	DataWarehouse.silver.crm_prd_info prd_info
WHERE
	prd_info.prd_end_dt<prd_info.prd_start_dt
