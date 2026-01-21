WITH
order_2016 AS
(
SELECT
MONTH(order_purchase_timestamp) AS order_month,
COUNT(order_id) AS '2016'
FROM
olist_orders
WHERE YEAR(order_purchase_timestamp) = 2016 AND order_approved_at IS NOT NULL
GROUP BY order_month
ORDER BY order_month ASC
),

order_2018 AS
(
SELECT
MONTH(order_purchase_timestamp) AS order_month,
COUNT(order_id) AS '2018'
FROM
olist_orders
WHERE YEAR(order_purchase_timestamp) = 2018 AND order_approved_at IS NOT NULL
GROUP BY order_month
ORDER BY order_month ASC
),

order_2017 AS
(
SELECT
MONTH(order_purchase_timestamp) AS order_month,
COUNT(order_id) AS '2017'
FROM
olist_orders
WHERE YEAR(order_purchase_timestamp) = 2017 AND order_approved_at IS NOT NULL
GROUP BY order_month
ORDER BY order_month ASC
)

SELECT
	CASE 
    WHEN b.order_month = 1  THEN 'Jan'
    WHEN b.order_month = 2  THEN 'Feb'
    WHEN b.order_month = 3  THEN 'Mar'
    WHEN b.order_month = 4  THEN 'Apr'
    WHEN b.order_month = 5  THEN 'May'
    WHEN b.order_month = 6  THEN 'Jun'
    WHEN b.order_month = 7  THEN 'Jul'
    WHEN b.order_month = 8  THEN 'Aug'
    WHEN b.order_month = 9  THEN 'Sep'
    WHEN b.order_month = 10 THEN 'Oct'
    WHEN b.order_month = 11 THEN 'Nov'
    WHEN b.order_month = 12 THEN 'Dec'
	END AS month,
    COALESCE(a.`2016`,0) AS '2016',
    COALESCE(b.`2017`,0) AS '2017',
    COALESCE(c.`2018`,0) AS '2018'
FROM order_2016 a
RIGHT JOIN order_2017 b ON a.order_month = b.order_month
LEFT JOIN order_2018 c ON b.order_month = c.order_month


