--Find the First and Last Order 
SELECT
	MIN(fact_sales.order_date) first_order_date,
	MAX(fact_sales.order_date) last_order_date,
	DATEDIFF(YEAR,MIN(fact_sales.order_date) ,MAX(fact_sales.order_date)) order_range_years
FROM
DataWarehouse.gold.fact_sales fact_sales;

--Find Youngest and oldest customer
SELECT
	DATEDIFF(DAY,MAX(dim_cust.birthdate),GETDATE())/365 youngest_customer_age,
	DATEDIFF(DAY,MIN(dim_cust.birthdate),GETDATE())/365 oldest_customer_age
FROM
DataWarehouse.gold.dim_customers dim_cust;
