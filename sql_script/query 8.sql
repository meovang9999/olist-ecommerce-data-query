WITH 
items AS(
	SELECT 
		a.order_id,
		a.order_item_id,
		b.product_category_name,
		a.price+a.freight_value AS total_price
	FROM 
		olist_order_items a
	LEFT JOIN olist_products b ON a.product_id = b.product_id)

SELECT
	a.product_category,
    ROUND(a.revenue) revenue,
    CONCAT(ROUND((a.revenue / (SUM(a.revenue) OVER() )) * 100,2),'%') AS total_revenue_percent,
    a.quantity,
    CONCAT(ROUND((a.quantity / (SUM(a.quantity) OVER() )) * 100,2),'%') AS total_quantity_percent,
    CONCAT(ROUND(( ((a.revenue / (SUM(a.revenue) OVER() )) * 100) - ((a.quantity / (SUM(a.quantity) OVER() )) * 100) ), 2),'%') AS price_to_volume_gap_pct
FROM
	(SELECT 
		REPLACE((CASE
			WHEN b.product_category_name_english IS NOT NULL then b.product_category_name_english
			ELSE a.product_category_name
		END),"_"," ") AS product_category,
		SUM(a.total_price) revenue,
		COUNT(a.order_item_id) quantity
	FROM
		items a
	LEFT JOIN product_category_name_translation b ON a.product_category_name = b.product_category_name
	GROUP BY product_category
	ORDER BY revenue DESC) a