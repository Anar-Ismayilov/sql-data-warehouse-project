USE DataWarehouse;
GO

SELECT
	ci.cst_id customer_id,
	ci.cst_key customer_key,
	ci.cst_firstname first_name,
	ci.cst_lastname last_name,
	lo.cntry country,
	ci.cst_marital_status marital_status,
	CASE 
		WHEN ci.cst_gndr !='n/a'  THEN ci.cst_gndr
		WHEN ci.cst_gndr ='n/a' AND ca.gen !='n/a' AND ca.gen IS NOT NULL THEN ca.gen
		ELSE ci.cst_gndr
		END gender,	
		ca.bdate birthdate,
	ci.cst_create_date create_date
FROM
	DataWarehouse.silver.crm_cust_info ci
LEFT JOIN DataWarehouse.silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN DataWarehouse.silver.erp_loc_a101 lo
ON ci.cst_key = lo.cid
