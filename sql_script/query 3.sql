WITH 
payment_2016 AS
(
SELECT 
	table2016.month, 
	(SUM(table2016.payment_value)/COUNT(table2016.order_id)) AS average_order_value
FROM
	(SELECT 
	a.order_id, 
	MONTH(b.order_purchase_timestamp) month,
	SUM(a.payment_value) payment_value
	FROM olist_order_payments a
	LEFT JOIN olist_orders b ON a.order_id = b.order_id
	WHERE YEAR(b.order_purchase_timestamp) = 2016
	GROUP BY a.order_id
    HAVING SUM(a.payment_value) > 0 OR SUM(a.payment_type = 'voucher')) AS table2016
GROUP BY table2016.month
),

payment_2017 AS
(
SELECT 
	table2017.month, 
	(SUM(table2017.payment_value)/COUNT(table2017.order_id)) AS average_order_value
FROM
	(SELECT 
	a.order_id, 
	MONTH(b.order_purchase_timestamp) month,
	SUM(a.payment_value) payment_value
	FROM olist_order_payments a
	LEFT JOIN olist_orders b ON a.order_id = b.order_id
	WHERE YEAR(b.order_purchase_timestamp) = 2017
	GROUP BY a.order_id
    HAVING SUM(a.payment_value) > 0 OR SUM(a.payment_type = 'voucher')) AS table2017
GROUP BY table2017.month
),

payment_2018 AS
(
SELECT 
	table2018.month, 
	(SUM(table2018.payment_value)/COUNT(table2018.order_id)) AS average_order_value
FROM
	(SELECT 
	a.order_id, 
	MONTH(b.order_purchase_timestamp) month,
	SUM(a.payment_value) payment_value
	FROM olist_order_payments a
	LEFT JOIN olist_orders b ON a.order_id = b.order_id
	WHERE YEAR(b.order_purchase_timestamp) = 2018 
	GROUP BY a.order_id
    HAVING SUM(a.payment_value) > 0 OR SUM(a.payment_type = 'voucher')) AS table2018
GROUP BY table2018.month
)

SELECT 
CASE
	WHEN b.month = 1 then 'Jan'
    WHEN b.month = 2 then 'Feb'
    WHEN b.month = 3 then 'Mar'
    WHEN b.month = 4 then 'Apr'
    WHEN b.month = 5 then 'May'
    WHEN b.month = 6 then 'Jun'
    WHEN b.month = 7 then 'Jul'
    WHEN b.month = 8 then 'Aug'
    WHEN b.month = 9 then 'Sep'
    WHEN b.month = 10 then 'Oct'
    WHEN b.month = 11 then 'Nov'
    WHEN b.month = 12 then 'Dec'
END AS Month,
COALESCE(ROUND(a.average_order_value,2),0) AS '2016',
COALESCE(ROUND(b.average_order_value,2),0) AS '2017',
COALESCE(ROUND(c.average_order_value,2),0) AS '2018'
FROM payment_2016 a
RIGHT JOIN payment_2017 b ON a.month = b.month
LEFT JOIN payment_2018 c ON b.month = c.month
ORDER BY b.month ASC;