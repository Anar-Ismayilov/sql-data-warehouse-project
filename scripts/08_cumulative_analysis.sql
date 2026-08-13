--Cumulative Analysis
SELECT
t.order_date,
t.total_sales,
SUM(total_sales) OVER (PARTITION BY YEAR(order_date)  ORDER BY t.order_date) running_total_sales,
AVG(total_sales) OVER (PARTITION BY YEAR(order_date)  ORDER BY t.order_date) running_average_price
FROM(
SELECT
	CAST(CAST(YEAR(f_sales.order_date) AS NVARCHAR) + '-'+ CAST(MONTH(f_sales.order_date) AS NVARCHAR)+'-' + '01' AS DATE) order_date,
	SUM(f_sales.sales_amount) total_sales,
	AVG(f_sales.price) avg_price
FROM
	DataWarehouse.gold.fact_sales f_sales
WHERE 
	f_sales.order_date IS NOT NULL
GROUP BY YEAR(f_sales.order_date),MONTH(f_sales.order_date)
) t
