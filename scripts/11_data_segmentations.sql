--Data Segmentation
/*
Segment products into cost ranges and count 
how many product fall into each segment
*/
	WITH range_of_cost AS(
	SELECT
		dim_prd.product_key,
		dim_prd.product_name,
		dim_prd.cost,
		CASE 
			WHEN dim_prd.cost <100 THEN 'Below 100'
			WHEN dim_prd.cost BETWEEN 100 AND 500 THEN 'Between 100-500'
			WHEN dim_prd.cost BETWEEN 500 AND 1000 THEN 'Between 500-1000'
		ELSE 'ABOVE 1000' 
		END cost_range
	FROM
		DataWarehouse.gold.dim_products dim_prd)

	SELECT 
		DISTINCT
		range_of_cost.cost_range,
		COUNT(range_of_cost.product_key) OVER (PARTITION BY range_of_cost.cost_range) total_product
	FROM
		range_of_cost
		ORDER BY total_product DESC;
