SELECT  
	d.customer_state state,
    d.customer_city city,
	ROUND(SUM(d.revenue)) revenue,
    CONCAT(ROUND((SUM(d.revenue)*100/(SUM(SUM(d.revenue)) OVER())),2),'%') AS revenue_pct
FROM
	(SELECT 
		a.*,
		c.customer_city,
		c.customer_state
	FROM
		(SELECT
			 a.order_id,
			 SUM(a.payment_value) AS revenue
		FROM 
			olist_order_payments a
		GROUP BY a.order_id
		ORDER BY revenue) AS a
	LEFT JOIN olist_orders b ON a.order_id = b.order_id
	LEFT JOIN olist_customers c ON b.customer_id = c.customer_id) AS d
GROUP BY state, city
ORDER BY revenue DESC;

