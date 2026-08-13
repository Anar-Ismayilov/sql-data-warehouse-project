--Repording customers
CREATE VIEW gold.repord_customers AS
WITH base_query AS(
SELECT
	f_sales.order_number,
	f_sales.product_key,
	f_sales.order_date,
	f_sales.sales_amount,
	f_sales.quantity,
	dim_cust.customer_key,
	dim_cust.customer_number,
	dim_cust.first_name + ' ' +	dim_cust.last_name full_name,
	DATEDIFF(DAY,dim_cust.birthdate,GETDATE())/365 age
FROM
	DataWarehouse.gold.fact_sales f_sales
LEFT JOIN
	DataWarehouse.gold.dim_customers dim_cust
on 
	f_sales.customer_key = dim_cust.customer_key
WHERE
	order_date IS NOT NULL)
, 
	customer_aggregation AS(
SELECT
	customer_key,
	customer_number,
	full_name,
	age,
	COUNT(DISTINCT(base_query.order_number)) total_orders,
	SUM(base_query.sales_amount)  total_sales,
	SUM(base_query.quantity) total_quantity,
	COUNT(DISTINCT(base_query.product_key)) total_product,
	MAX(base_query.order_date) last_order_date,
	DATEDIFF(MONTH,MIN(base_query.order_date),MAX(base_query.order_date)) lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	full_name,
	age
	)

SELECT
	customer_key,
	customer_number,
	full_name,
	age,
	CASE
	WHEN customer_aggregation.age<20 THEN 'UNDER 20'
	WHEN customer_aggregation.age BETWEEN 20 AND 29 THEN 'BETWEEN 20-29'
	WHEN customer_aggregation.age BETWEEN 30 AND 39 THEN 'BETWEEN 30-39'
	WHEN customer_aggregation.age BETWEEN 40 AND 49 THEN 'BETWEEN 40-49'
	ELSE '50 AND ABOVE'
	END age_segment,
	CASE
		WHEN customer_aggregation.lifespan >=12 AND customer_aggregation.total_sales > 5000 THEN 'VIP'
		WHEN customer_aggregation.lifespan <=12 OR customer_aggregation.total_sales <= 5000 THEN 'REGULAR'
		ELSE 'NEW'
		END customer_segment,
	last_order_date,
	DATEDIFF(MONTH,customer_aggregation.last_order_date,GETDATE()) recency,
	total_orders,
	total_sales,
	total_quantity,
	total_product,
	--Compuate average order value (AOV)
	lifespan,
	CASE 
		WHEN customer_aggregation.total_orders = 0 THEN '0'
		ELSE customer_aggregation.total_sales/ customer_aggregation.total_orders 
		END avg_order_value,
	--Compuate average monthly spend
	CASE
		WHEN customer_aggregation.lifespan = 0 THEN 0
		ELSE customer_aggregation.total_sales/customer_aggregation.lifespan 
		END avg_monthly_spend
FROM
customer_aggregation;
