--Explore All Countries our customers come from.
SELECT
DISTINCT(dim_cust.country)
FROM DataWarehouse.gold.dim_customers dim_cust
WHERE dim_cust.country !='n/a';

--Explore All Categories 'The major Divisions'
SELECT
	DISTINCT dim_prd.category,dim_prd.subcategory,dim_prd.product_name
FROM
	DataWarehouse.gold.dim_products dim_prd;
