/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- Create Dimension: gold.dim_customers
USE DataWarehouse;
GO

IF OBJECT_ID('gold.dim_customers ','V') IS NOT NULL
	DROP VIEW gold.dim_customers ;
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

GO
IF OBJECT_ID('gold.dim_products ','V') IS NOT NULL
	DROP VIEW gold.dim_products ;
GO

-- Create Dimension: gold.dim_products
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
	pi.prd_line product_line,
	pc.maintenance maintenance,
	pi.prd_start_dt start_date
FROM
	DataWarehouse.silver.crm_prd_info pi
LEFT JOIN DataWarehouse.silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id
WHERE pi.prd_end_dt IS NULL;
GO


-- Create Fact Table: gold.fact_sales

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.prd_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
