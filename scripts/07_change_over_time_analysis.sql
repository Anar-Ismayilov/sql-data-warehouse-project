USE DataWarehouse;
GO

--Trends: Change over time
SELECT
	YEAR(f_sales.order_date) order_year,
	MONTH(f_sales.order_date) order_month,
	SUM(f_sales.sales_amount) total_sales,
	COUNT(DISTINCT(f_sales.customer_key)) total_customers,
	SUM(f_sales.quantity) total_quantity
FROM 
	DataWarehouse.gold.fact_sales f_sales
WHERE 
	f_sales.order_date IS NOT NULL
	GROUP BY YEAR(f_sales.order_date),MONTH(f_sales.order_date)
ORDER BY 
	YEAR(f_sales.order_date),MONTH(f_sales.order_date);
