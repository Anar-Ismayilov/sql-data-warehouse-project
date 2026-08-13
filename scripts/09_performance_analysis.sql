--Performance Analysis
/*
Analysis the yearly performance of products by comparing their	sales 
to both average sales performance of the product and the	previous year's sales
*/
SELECT
	t.order_date,
	t.product_name,
	t.current_sales,
	AVG(current_sales) OVER(PARTITION BY t.product_name ) avg_sales	,
	current_sales-AVG(current_sales) OVER(PARTITION BY t.product_name ) diff_avg,
	CASE
		WHEN current_sales-AVG(current_sales) OVER(PARTITION BY t.product_name ) >0 THEN 'Above Avg'
		WHEN current_sales-AVG(current_sales) OVER(PARTITION BY t.product_name ) <0 THEN 'Belove Avg'
		ELSE 'Avg'
		END,
	LAG(current_sales) OVER(PARTITION BY t.product_name ORDER BY t.order_date),
	current_sales-LAG(current_sales) OVER(PARTITION BY t.product_name ORDER BY t.order_date) diff_per_year,
	CASE
		WHEN current_sales-LAG(current_sales) OVER(PARTITION BY t.product_name ORDER BY t.order_date)>0 THEN 'Increase'
		WHEN current_sales-LAG(current_sales) OVER(PARTITION BY t.product_name ORDER BY t.order_date)<0 THEN 'Decrease'
		ELSE 'No Change'
		END
FROM(
	SELECT
		YEAR(f_sales.order_date) order_date,
		dim_prd.product_name product_name,
		SUM(f_sales.sales_amount) current_sales
	FROM
		DataWarehouse.gold.fact_sales f_sales
	LEFT JOIN
		DataWarehouse.gold.dim_products dim_prd
	ON f_sales.product_key = dim_prD.product_key
	WHERE 
		f_sales.order_date IS NOT NULL
	GROUP BY YEAR(f_sales.order_date),dim_prd.product_name
) t;
