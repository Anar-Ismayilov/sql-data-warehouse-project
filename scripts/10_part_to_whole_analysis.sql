--Part to Whole
--which category cotribute the most	to overall sales
WITH category_for_sales AS(
SELECT
dim_prd.category,
SUM(f_sales.sales_amount) sum_of_sales

FROM
	DataWarehouse.gold.fact_sales f_sales
LEFT JOIN
	DataWarehouse.gold.dim_products dim_prd
ON
	f_sales.product_key = dim_prd.product_key
GROUP BY 
	dim_prd.category)	

SELECT
	category_for_sales.category,
	CONCAT(ROUND(CAST(category_for_sales.sum_of_sales AS FLOAT)*100 /CAST(SUM(category_for_sales.sum_of_sales) OVER() AS FLOAT) ,2),'%')  percentage_of_float
FROM
	category_for_sales
ORDER BY
	category_for_sales.sum_of_sales DESC;
