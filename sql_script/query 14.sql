SELECT
	a.payment_type,
    COUNT(a.payment_type) AS payment_count,
	ROUND(SUM(a.payment_value)) AS total_payment_value,
    CONCAT(ROUND((SUM(a.payment_value)/SUM(SUM(a.payment_value)) OVER()) * 100,2),'%') AS payment_value_pct
FROM olist_order_payments a
WHERE a.payment_type != 'not_defined'
GROUP BY a.payment_type
ORDER BY payment_count DESC;
