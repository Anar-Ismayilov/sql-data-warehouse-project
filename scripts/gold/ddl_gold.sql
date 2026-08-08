USE DataWarehouse;
GO
CREATE VIEW gold.dim_customers AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY ci.cst_id ) AS customer_key, 
	ci.cst_id customer_id,
	ci.cst_key customer_number,
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
ON ci.cst_key = lo.cid;


CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) prd_key,
	pi.prd_id product_id,
	prd_key product_number,
	pc.cat category,
	pi.cat_id category_id,
	pc.subcat subcategory,
	pi.prd_nm product_name,
	pi.prd_cost cost,
	pi.prd_line produck_line,
	pc.maintenance maintenance,
	pi.prd_start_dt start_date
FROM
	DataWarehouse.silver.crm_prd_info pi
LEFT JOIN DataWarehouse.silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id
WHERE pi.prd_end_dt IS NULL

