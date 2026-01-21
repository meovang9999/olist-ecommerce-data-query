-- Customer by state
SELECT
	a.customer_state AS state,
    COUNT(DISTINCT a.customer_unique_id) AS total_customers,
    CONCAT(ROUND((COUNT(DISTINCT a.customer_unique_id) * 100/(SUM(COUNT(DISTINCT a.customer_unique_id)) OVER())),2),'%') AS total_customers_pct
FROM olist_customers a
GROUP BY a.customer_state
ORDER BY total_customers DESC;

-- Customer by city (There can be cities with the same name but they're in different states)
SELECT
	a.customer_state AS state,
    a.customer_city AS city,
    COUNT(DISTINCT a.customer_unique_id) AS total_customers,
    CONCAT(ROUND((COUNT(DISTINCT a.customer_unique_id) * 100/(SUM(COUNT(DISTINCT a.customer_unique_id)) OVER())),2),'%') AS total_customers_pct
FROM olist_customers a
GROUP BY a.customer_state, a.customer_city
ORDER BY total_customers DESC;


