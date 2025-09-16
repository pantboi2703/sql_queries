-- Subquery: A query inside another query.
/*
	When to use:
	                                     Outer Query
									   --------------
	Step 4: Aggregations               | Main Query |
	             |                     |            |
	Step 3: Transformations            | Subquery   |
				 |                     |            |
	Step 2: Filtering                  | Subquery   |
				 |                     |            |
	Step 1: Join Tables                | Subquery   |
	                                   --------------
*/

/*
	Categorization of Subquery: 
	1. Based on Dependancy: Non-correlated Subquery, Correlated Subquery
	2. Based on Result type: Scalar SubQuery (Returns one single value), Row SubQuery (Returns multiple rows and single
	                         column), Table SubQuery (Multiple rows as well as multiple columns)
	3. Based on Loaction and Clauses: Select, From, Join, WHERE -> Comparison Operators, Logical Operators.

*/

/*
	1. Based on Result type: 
	-> Scalar SubQuery: Return only one value.
	   Example: SELECT AVG(Sales) FROM Sales.Orders

	-> Row SubQuery: Return Multiple rows and single columns.
	   Example: SELECT CustomerID FROM Sales.Orders

	-> Table SubQuery: Return Multiple Rows and Multiple columns.
	   Example: SELECT * FROM Sales.Orders or SELECT OrderID, OrderDate From Sales.Orders
*/

/*
	2. Based on Location Clause: 
	-> FROM: Used as a temporary table for the main query.
	   Syntax: SELECT column1, column2, ...
	           FROM (SELECT column FROM table1 WHERE condition) AS alias

	-> SELECT: Used to aggregate data side by side with the main query data, allowing for direct comparison.
	   Syntax: SELECT 
	             Column1,
				 (SELECT column FROM table1 WHERE condition) AS alias
			   FROM table1

			   Note: Only scalar subqueries are allowed to used.

	-> JOIN: Used to prepare the data (filtering or aggregation) before joining it with other tables. 

	-> WHERE: Used for complex filtering logic and makes query more flexible and dynamic.
	   => 2 groups of operators used: Comparison Operators, Logical Operators.
	   1. Comparison Operators: Used to filter data by comparing two values.
	      = , != or <>, >, <, >=, <=
	      
		  -> Syntax of Subquery inside where clause using comparison operators.
		     SELECT column1, column2,...
			 FROM table1
			 WHERE column = (SELECT column FROM table 2 WHERE condition)
			 
			 Note: Only Scalar subqueries are allowed to be used.

		2. Logical Operators: 
		   -> IN: Checks whether the value matches any value from a list.
		      Syntax:  SELECT column1, column2,...
			           FROM table1 
					   WHERE column IN/NOT IN (SELECT column FROM table 2 WHERE condition)
		   
		   -> ANY: Checks if a value matches ANY value within a list.
		           Used to check if a value is true for AT LEAST one of the values in a list.
			  Syntax:  SELECT column1, column2,...
			           FROM table1 
					   WHERE column < ANY/ALL (SELECT column FROM table 2 WHERE condition)

		   -> All Operator: Checks if a value matches ALL values within a list.
*/

-- Task related to SubQuery based on location(FROM): Find the products that have a price higher than the avearge price of all products.
-- MainQuery
SELECT 
*
FROM 
    -- SubQuery
	(SELECT 
	ProductID,
	Product,
	Price,
	AVG(Price) OVER() AveragePrice
	FROM Sales.Products
) t WHERE AveragePrice < Price

-- Task related to SubQuery based on Location(From): Rank the customers based on their total amount of sales.
-- Mainquery
SELECT 
*,
RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
FROM 
    -- Subquery
	(SELECT 
	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
)t

/*
	Task related to subquery based on location (Select): 
	Task 1: Show the product IDs, product names, prices, and the total number of orders.
*/
-- MainQuery
SELECT 
	ProductID,
	Product,
	Price,
	-- SubQuery
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders  -- Scalar Subquery
FROM Sales.Products

/*
	Task related to subquery based on location (JOIN): 
	Task 1: Show all customers details and find the total orders of each customer.
*/

SELECT 
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
	SELECT 
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

/*
	Task related to subquery based on location (WHERE -> Comparison Operator): 
	Task 1: Find the products that have a price higher than the avearge price of all products.
*/

SELECT 
ProductID,
Price,
(SELECT AVG(Price) FROM Sales.Products) AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

/*
	Task related to subquery based on location (WHERE -> Logical Operator [IN]): 
	Task 1: Show the details of orders made by customers in Germany.
*/
SELECT 
* 
FROM Sales.Orders
WHERE CustomerID IN 
                 (Select 
                 CustomerID 
				 FROM Sales.Customers
                 WHERE Country = 'Germany')

/*
	Task related to subquery based on location (WHERE -> Logical Operator [ANY]): 
	Task 1: Find female employees whose salaries are greater than the salaries of any male employees.
*/

SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

/*
	Task related to subquery based on location (WHERE -> Logical Operator [ALL]): 
	Task 2: Find female employees whose salaries are greater than the salaries of all male employees.
*/

SELECT 
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

/*
	Dependancy: Non-Correlated and Corelated Subquery.
	1. Non-Correlated Subquery: A Subquery that can run independently from the Main Query.
	2. Correlated Subquery: A Subquery that relays on values from the Main Query.

	-> Difference between Non-Correlated and Correlated Subquery:

	                     Non-Correlated Subquery               Correlated Subquery:
	1. Definition       Subquery is independent of the        Subquery is dependent of the main query.
                    	main query.

	2. Execution        Executed once and its result is       Executed for each row processed by the main
						used by the main query. Can be        query. Can't be executed on its own.
						executed on its own.

	3. Easy to use      Easier to read                        Harder to read and more complex.

	4. Performance      Executed only once leads to           Executed multiple times leads to bad 
						better performance.                   performance.

	5. Usage			Static compariosons, filtering		  Row-by-Row Comparisons, Dynamic Filtering.
	                    with constraints
	           
*/

-- Task: Show all customer details and find the total orders of each customer.
SELECT 
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c

SELECT * FROM Sales.Orders

/*
   Correlated Subquery: Exists in Logical operators with WHERE cluase (Based on location).
   -> Exists: Check if a subquery returns any rows.

   -> Syntax of Correlated subquery in WHERE clause EXISTS Operator.

      SELECT column1, column2,...
	  FROM Table2 
	  WHERE EXISTS ( SELECT 1
					 FROM Table1
					 WHERE Table1.ID = Table2.ID )
*/

-- Task: Show the details of orders made by customers in Germany.
SELECT
*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1
			  FROM Sales.Customers c
			  WHERE Country = 'Germany'
			  AND o.CustomerID = c.CustomerID)

-- Task: Show the details of orders made by customers not in Germany.
SELECT 
* 
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT 1
				 FROM Sales.Customers c
				 WHERE Country = 'Germany'
				 AND o.customerID = c.CustomerID)
