-- Retrieve all customers data
SELECT * FROM customers

-- Retrieve all ordres data
SELECT * FROM orders

-- Retrieve each customer name, country and score
SELECT 
	first_name,
	country,
	score
FROM customers

-- Retrieve customers with a score not equal to 0. Not equal (!= or <>)
SELECT * 
FROM customers 
WHERE score <> 0

-- Retrieve customers from Germany.
SELECT * 
FROM customers
WHERE country = 'Germany'

/* Sort data using Order By take 2 argument Column which you want to sort and the second
is mechanism means ASC or DESC or bu default it is ASC */

-- Retrieve all customers and sort the results by the highest score first.
SELECT * 
FROM customers
ORDER BY score DESC

-- Exact opposite of above one by the lowest to highest.
SELECT * 
FROM customers
ORDER BY score ASC

-- Nested sorted (Insert another column for the clearity and only makes sense if we have
--  repetition in the column)
-- Retrieve all customers and sort the results by the country and then by the highest score
SELECT * 
FROM customers
ORDER BY country ASC, score DESC

-- Group By Combines rows with same value aggregates a column by another column.
-- Find the total score of each country => Here use alias because by using aggregation 
-- there is no column_name on which aggregation is perform here is score so its just
-- change the column name for that query.
SELECT 
	country, SUM(score) AS total_score
FROM customers
GROUP BY country 
ORDER BY total_score DESC

-- Find the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) as total_score,
	COUNT(id) as total_customers
FROM customers
GROUP BY country

-- Having By Filters data after aggregation we can use Having after using the group by

/* Note: With the group by we are using the country column where we are grouping the data
   by its value but with the having we are using the aggregated column SUM(SCORE) */

/* Where cluase is used to filter the data before aggregation and after the aggregation
   we used Having By  */ 

/* Question: Find the average score for each country cosidering only customers with a 
   score not equal to 0. And return only those countries with an avearge score greater 
   than 430.*/
SELECT 
	country,
	AVG(score) as avg_score
FROM customers
WHERE score <> 0
GROUP BY country
HAVING AVG(score) > 430  

-- Distinct => Remove Duplicates (Repeated values) each value appears once
-- Task on Distinct:- Return Unique List of all countries
SELECT DISTINCT
	country
FROM customers

-- Top Query => Limit your data
/* Restricted the number of rows returned */
-- Task: Retrive only three customers
SELECT TOP 3 *
FROM customers

-- Task: Retrive the top 3 customers with the Highest score
SELECT TOP 3 * 
FROM customers 
ORDER BY score DESC

-- Task: Retrieve Lowest 2 customers based on the score
SELECT TOP 2 *
FROM customers 
ORDER BY score ASC

--Task: Get the two most recent orders in the order table.
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC
