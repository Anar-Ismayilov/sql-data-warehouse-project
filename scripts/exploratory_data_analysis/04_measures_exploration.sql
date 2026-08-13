--Find the total sales
SELECT
	'Total Sales' as measure_name,
	SUM(f_sales.sales_amount) measure_value
	FROM
	DataWarehouse.gold.fact_sales f_sales
UNION ALL
--Find how many items are sold
SELECT
	'Total Quantity' measure_name,
	SUM(f_sales.quantity) measure_value
FROM
	DataWarehouse.gold.fact_sales f_sales
UNION ALL
--Find the average selling price
SELECT
	'Average Price' measure_name,
	AVG(f_sales.price) measure_value
FROM
	DataWarehouse.gold.fact_sales f_sales
UNION ALL
--Find the total number of orders 
SELECT
	'Total Orders' measure_name	,
	COUNT(f_sales.order_number) measure_value
FROM
	DataWarehouse.gold.fact_sales f_sales
UNION ALL

--Find the total number of product
SELECT
	'Total Product' measure_name,
	COUNT(dim_prd.product_key) measure_value
FROM 
	DataWarehouse.gold.dim_products dim_prd
UNION ALL
--Find the total number of customers
SELECT
	'Total Customers' measure_name,
	COUNT(dim_cust.customer_id) measure_value
FROM
	DataWarehouse.gold.dim_customers dim_cust
UNION ALL
--Find the total number of customers that has places an order
SELECT
	'Total Places an Order Customers' measure_name,
COUNT(DISTINCT(f_sales.customer_key)) measure_value
FROM
	DataWarehouse.gold.fact_sales f_sales;
