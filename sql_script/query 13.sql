WITH
freight_table AS
(
SELECT
	a.order_id,
    a.order_item_id,
	a.product_id,
    c.product_category_name_english AS product_category,
    a.freight_value,
    PERCENT_RANK() OVER (
    PARTITION BY c.product_category_name_english
    ORDER BY freight_value ASC
    ) AS freight_cost_ranking,
    a.price
FROM olist_order_items a
LEFT JOIN olist_products b ON a.product_id = b.product_id
LEFT JOIN product_category_name_translation c ON b.product_category_name = c.product_category_name
),
median_table1 AS
(
SELECT 
	a.product_category,
    MIN(a.freight_value) as median
FROM freight_table a
WHERE a.freight_cost_ranking >=0.5
GROUP BY a.product_category
),
median_table2 AS
(
SELECT 
	a.product_category,
    MAX(a.freight_value) as median
FROM freight_table a
WHERE a.freight_cost_ranking <=0.5
GROUP BY a.product_category
)
SELECT 
	a.product_category,
    SUM(CASE WHEN order_item_id = 1 THEN 1 ELSE 0 END) AS total_orders_delivered,
    COUNT(a.product_category) AS total_items_delivered,
	ROUND((AVG(b.median)+AVG(c.median))/2,2) AS median_freight_value,
    ROUND(AVG(a.freight_value),2) AS avg_freight_value,
	ROUND(AVG(a.price),2) AS avg_price,
    ROUND(AVG(a.freight_value)/AVG(a.price), 2) AS avg_freight_to_price_ratio
FROM freight_table a
LEFT JOIN median_table1 b ON a.product_category = b.product_category
LEFT JOIN median_table2 c ON a.product_category = c.product_category
GROUP BY product_category
ORDER BY total_items_delivered DESC;
