SELECT 
    a.seller_state state,
    COUNT(a.seller_id) sellers,
    CONCAT(ROUND((COUNT(a.seller_id)*100/(SUM(COUNT(a.seller_id)) OVER())),2),'%') AS sellers_pct
FROM olist_sellers a
GROUP BY state
ORDER BY sellers DESC;

SELECT 
    a.seller_state state,
    a.seller_city city,
    COUNT(a.seller_id) sellers,
    CONCAT(ROUND((COUNT(a.seller_id)*100/(SUM(COUNT(a.seller_id)) OVER())),2),'%') AS sellers_pct
FROM olist_sellers a
GROUP BY state, city
ORDER BY sellers DESC;