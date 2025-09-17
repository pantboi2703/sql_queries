/*
	CTE (Common table Expression): Temporary, named result set (virtual table), that can be used 
	                               multiple times within your query to simplify and organize complex query.
								   It is dedicated to the only main query.

	When to use CTE?         
	                                 In Subquery                       CTE
	Step 4: Aggregations (Avg)       Main Query                
	                                    |
	Step 3: JOIN                     Sub Query                        JOIN           ->    CTE
	                                    |                               |
	Step 2: Aggregations (Sum)       Subquery                    AGGREGATIONS(SUM)   -> Main Query
	                                    |                               |
	Step 1: JOIN                     Subquery                    AGGREGATIONS(Avg)   -> Main Query

	Subquery: Follows Bottom to top approach and also have redundancy.
	CTE: Follows Top to Bottom and doesn't have redundancy.
	     Wrap join in CTE and used it in the main query.

		                      |-------------------------------|
							  |   -----------------------     |
							  |    | CTE_TOP_Customers |      |
							  |	 -----------------------      |
							  |	                              |
							  |	 -----------------------      |
							  |    | CTE_TOP_Customers |      |
							  |	 -----------------------      |
                              |                               |
							  |	 -----------------------      |
							  |    | CTE_TOP_Customers        |
							  |	 -----------------------      |
							  |                               |
							  |	 Main Query                   |
							  |-------------------------------|

		Advantages: Readability, Modularity, Reusability.

		-> CTE Types: 
		1. None-Recursive CTE (2 types): Standalone CTE, Nested CTE.
		2. Recursive CTE: 
*/

/*
	1. Standalone CTE: Define and used independently. Runs independently as it's self-contained and doesn't 
	                   rely on other CTEs or queries.

		DataBase <-> CTE -> Intermediate Result <-> Main Query -> Final Result.
		-> Syntax: WITH CTE_NAME AS    |
		           (				   |
				    SELECT...          |
					FROM...            |  ---> CTE Query (CTE Definition)
					WHERE...           |
				   )				   |
                 -----------------------
				 SELECT ...            |
				 FROM CTE_NAME		   |  ---> Main Query (CTE Usage)
				 WHERE ...			   |
        Note: Not to use Order By Clause inside the CTE.

	1.1 Multiple Standalone CTEs: 
			
			Database <->  CTE 1 -> Result <-> Main Query -> Final
			         <->  CTE 2 -> Result <-> Main Query -> Final
					 <->  CTE 3 -> Result <-> Main Query -> Final
					      
						  Final is same for all the three.

			-> Syntax: WITH CTE_NAME1 AS 
					   (
							SELECT ...
							FROM ...
							WHERE ...
					   )
			           , CTE_NAME2 AS 
					   (
							SELECT ...
							FROM ...
							WHERE ...
					   )
					   ----------------
					   SELECT ...
					   FROM CTE-Name1
					   JOIN CTE-Name2
					   WHERE ---

	2. Nested CTE: CTE inside another CTE. A nested CTE uses the result of another CTE, so it can't run 
	               independently.

		Database <-> CTE 1 -> Intermediate Result <-> CTE 2 -> Intermediate Result <-> Main Query -> Final.
		------------------    -----------------------------
		        |                        |
		 StandAlone CTE              Nested CTE 
		                           Depends on 1st

		  Syntax: WITH CTE_NAME1 AS 
					   (
							SELECT ...
							FROM ...
							WHERE ...
					   )
			           , CTE_NAME2 AS 
					   (
							SELECT ...
							FROM CTE_NAME1
							WHERE ...
					   )
					   SELECT ...
					   FROM CTE-Name2
					   WHERE ---
*/

-- Task: 
-- Step 1: Find the total Sales per customer
WITH CTE_Total_Sales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
-- Step 2: Find the last order date for each customer.
, CTE_Last_Order AS 
(
SELECT 
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
) 
-- Step 3: Rank Customers based on Total Sales per customer.
, CTE_Customer_Rank AS 
(
SELECT 
CustomerID,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC) CustomerRank 
FROM CTE_Total_Sales
)
-- Step 4: Segment customer based on their total sales (Nested CTE).
, CTE_Customer_Segments AS 
(
SELECT 
CustomerID,
CASE WHEN TotalSales > 100 THEN 'High'
     WHEN TotalSales > 80 THEN 'Medium'
	 ELSE 'Low'
END CustomerSegments 
FROM CTE_Total_Sales
)
-- Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ccr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_RANK ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID

/*
	-> Non-Recursive CTE: is executed only once without any repetition.
	-> Recurisve CTE: Self-referencing query that repeatedly processes data until a specific condition 
	                  is met. Keep looping until the condition is met.
	   Syntax Recursive CTE:  WITH CTE-NAME AS 
							  (
								SELECT ...      |
								FROM ...        |---> ANCHOR Query -> Responsible for 1st iteration.
								WHERE ...       |
                               --------------
								UNION ALL
                               --------------
								SELECT ...                |
								FROM CTE-NAME             |---> Recursive Query
								WHERE [Break Condition]   |
							  )

							  SELECT ...         |
							  FROM CTE-Name		 |---> Main Query
							  WHERE ...          |

*/
-- Task: Generate a sequence of numbers from 1 to 20.

WITH Series AS (
	-- Anchor Query
	SELECT 
	1 AS MyNumber
	UNION ALL
	-- Recursive Query
	SELECT 
	MyNumber + 1
	FROM Series
	WHERE MyNumber < 1000
)

SELECT * 
FROM Series
OPTION (MAXRECURSION 5000)

-- Task: Show the employee hierarchy by displaying each employee's level with the organization.
WITH CTE_Emp_Hierarchy AS 
(
    -- Anchor query
	SELECT 
		EmployeeID,
		FirstName,
		ManagerID,
		1 as Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
	UNION ALL 
	-- Recursive Query
	SELECT 
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level +1
	FROM Sales.Employees as e
	INNER JOIN CTE_EMP_Hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT 
*
FROM CTE_Emp_Hierarchy