--Ranking

--Which 5 product generate the highest revenue?

SELECT TOP 5
	dim_prd.product_name,
	SUM(f_sales.sales_amount) total_revenue
FROM
	DataWarehouse.gold.fact_sales f_sales
LEFT JOIN
	DataWarehouse.gold.dim_products dim_prd
ON 
f_sales.product_key = dim_prd.product_key
GROUP BY 
	dim_prd.product_key,
	dim_prd.product_name
ORDER BY total_revenue desc;

--What are the 5 worth-performing products in terms of sales
SELECT TOP 5
	dim_prd.product_name,
	SUM(f_sales.sales_amount) total_revenue
FROM
	DataWarehouse.gold.fact_sales f_sales
LEFT JOIN
	DataWarehouse.gold.dim_products dim_prd
ON 
f_sales.product_key = dim_prd.product_key
GROUP BY 
	dim_prd.product_key,
	dim_prd.product_name
ORDER BY total_revenue ;
