WITH
rating AS
	(WITH 
	reviewscore AS
	(
	SELECT DISTINCT
	a.order_id,b.product_id,c.product_category_name,d.product_category_name_english,a.review_score,a.review_creation_date
	FROM olist_order_reviews a
	LEFT JOIN olist_order_items b on a.order_id = b.order_id
	LEFT JOIN olist_products c on b.product_id = c.product_id
	LEFT JOIN product_category_name_translation d on c.product_category_name = d.product_category_name)
	SELECT 
		a.*,
		ROW_NUMBER() OVER (
		PARTITION BY a.order_id, a.product_id 
		ORDER BY a.review_creation_date DESC) AS date_order
	FROM 
		reviewscore a
	)

SELECT
	REPLACE(a.product_category_name_english,'_'," ") AS product_category,
    COUNT(a.review_score) AS total_review,
	ROUND(AVG(a.review_score),2) AS avg_review_score,
    CONCAT(ROUND((SUM(IF(a.review_score=5,1,0))/COUNT(a.review_score)) * 100,2),"%") AS '5/5',
    CONCAT(ROUND((SUM(IF(a.review_score=4,1,0))/COUNT(a.review_score)) * 100,2),"%") AS '4/5',
    CONCAT(ROUND((SUM(IF(a.review_score=3,1,0))/COUNT(a.review_score)) * 100,2),"%") AS '3/5',
    CONCAT(ROUND((SUM(IF(a.review_score=2,1,0))/COUNT(a.review_score)) * 100,2),"%") AS '2/5',
    CONCAT(ROUND((SUM(IF(a.review_score=1,1,0))/COUNT(a.review_score)) * 100,2),"%") AS '1/5'
FROM
	rating a
WHERE a.date_order = 1
GROUP BY product_category 
ORDER BY total_review DESC;
    
