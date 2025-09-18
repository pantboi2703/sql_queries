-- Find the third highest score (DataBase -> MyDataBase).
SELECT 
* 
FROM (
	SELECT 
		first_name,
		score,
		DENSE_RANK() OVER(ORDER BY score DESC) as Rank_Scores  
	FROM customers 
)t WHERE Rank_Scores = 3

SELECT * FROM customers

UPDATE customers 
SET score = 900
WHERE id = 3