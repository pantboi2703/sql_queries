-- Combining Data (Joins and Set Operators) 
/* 
   Join's is used to combine columns. Types => Inner, Full, Left, Right.
   Set operatoes is used to combine rows. Types => Union, Union All, Except, Intersect.
   Requirement for the join the table is 'key column'.
   Requirement for the set operators is 'Same no. of column' 
*/

/* 
  Basic Joins:
  No Join: Return data from table without combining them
  Inner Join: Returns only matching rows from both tables.
  Left Join: Returns all rows from the left table and only matching from right.
  Right Join: Returns all rows from Right and only Matching from left.
  Full Join: Returns All Rows from Both tables.
*/

-- No Join
-- Task: Return all data from customers and orders in two different results.
SELECT *
FROM customers;

SELECT *
FROM orders;

-- Inner Join
-- Task: Get all customers along with their orders, but only for customers who have placed an order.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- Left Join: Order of Table is important.
-- Task: Get all customers along with their orders, including those without orders.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers as c 
LEFT JOIN orders as o
ON c.id = o.customer_id

-- Right Join
-- Task: Get all customers along with their orders, including orders without matching customers.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers as c
RIGHT JOIN orders as o 
ON c.id = o.customer_id

-- Task: Same above task using LEFT JOIN.
SELECT 
	id,
	first_name,
	order_id,
	sales
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id

-- Full Join
-- Task: Get all customers and all orders, even if there's no match.
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id
	
-- Advanced Joins 
/*  
	Left Anti Join: Returns row from left that has no match in right.
	Right Anti Join: Returns Row from Right that has no match in Left.
	Full Anti Join: Returns only rows that don't match in either tables. Only unmatching data.
*/

-- Left Anti Join: There is no Left Anti Join in SQL. Have to use where clause as a filter and take the
-- Key from the right table and make this null.

-- Task: Get all customers who haven't placed any order.
SELECT *
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

-- Right Anti Join:
-- Task: Get all orders without matching customers 
SELECT *
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NULL

-- Solve same task without using the right join.
SELECT * 
from orders as o
LEFT JOIN customers as c 
ON c.id = o.customer_id
WHERE c.id IS NULL

-- Full Anti Join: 
-- Task: Find customers without orders and orders without customers
SELECT * 
FROM orders as o
FULL JOIN customers as c
ON c.id = o.customer_id
WHERE c.id IS NULL
          OR
      o.customer_id IS NULL

-- Task: Get all customers along with their orders, but only for customers who have placed an order.
-- Note: Solve without using Inner Join.
SELECT *
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

-- One Crazy Join is Cross Join and it is totally different from the other join.

/* 
   Cross Join: Combines every row from left with every row from right. All Possible combinations.
   also called Cartesian Join 
*/

-- Task: Generate all possible combinations of customers and orders.
SELECT * 
FROM customers
CROSS JOIN orders

/* 
  Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, and employee
  details, for each order, display:
  Order ID, Customer's name, Product name, Sales, Price, Sales person's name.
*/ 

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName as CustomerFirstName,
	c.LastName as CustomerLastName,
	p.Product as ProductName,
	p.Price,
	e.FirstName as EmployeeFirstName,
	e.LastName as EmployeeLastName
FROM Sales.Orders as o
LEFT JOIN Sales.Customers as c
ON o.CUSTOMERID = c.CUSTOMERID
LEFT JOIN Sales.Products as p
ON o.PRODUCTID = p.PRODUCTID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID



-- Now combining data using set operators => combining rows
/* 
   Rules of the set operators
   Rule 1: SQL CLAUSES => Set operator can be used almost in all the clauses 
           Example: WHERE, JOIN, GROUP BY, HAVING
		   Exception: ORDER BY is allowed only once at the end of the query.
   Rule 2: The number of columns in each query must be the same.
   Rule 3: Data Types of columns in each query must be compatible.
   Rule 4: The order of the columns in each query must be the same.
   Rule 5: The column names in the result set are determined by the column names specified in the first query.
   Rule 6: Even if all rules are met and SQL shows no errors, the result may be incorrect.
           Incorrect column selection leads to inaccurate results.

*/
/*  
	Union: Returns all rows from both queries except duplicates it removes duplicates
	Union All: Return all rows from both queries, including duplicates.
	Except: Return all distinct rows from the first query that are not found in the second query.
	        It is the only one where the order of queries affects the final result.
	Intersect: Returns only the rows that are common in both queries.
*/

-- Union 
/* 
In this case data type is compatible FirstName and LastName in Sales.Customers table is a varchar and 
also the column FirstName and LastName is a varchar in Sales. If in Sales.customers i choose CustomerID
and the LastName and in the second one i have FirstName and LastName so we get the error.

Note: In the result table the column names depend on the first query.
*/

SELECT 
FirstName AS first_name,
LastName AS last_name
FROM Sales.Customers

UNION

SELECT 
FirstName,
LastName
FROM Sales.Employees

-- Union: Combines both table and remove duplicate data.
-- Returns all distinct rows from both queries.
-- Remove duplicates rows from the result
-- Task: Combine the data from employees and customers into one table, not including duplicates
SELECT 
	FirstName,
	LastName
FROM Sales.customers
UNION
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

-- Union All:
/* Note: Union All is generally faster than Union. Because Union All doesn't perform duplicates steps removing
         duplicates.
		 If you are confident there are no duplicates, use Union All.
		 Use Union All to find duplicates and quality issue.
*/

-- Task: Combine the data from employees and customers in one table, including duplicates.
SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION ALL
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

-- Except: 
-- Task: Find the employees who are not customers at the same time.
SELECT 
	FirstName,
	LastName
FROM Sales.Employees
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Customers

-- Task: Find the customers who are not employees at the same time. This is incorrect and gives different result
SELECT 
	FirstName,
	LastName
FROM Sales.Customers
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Employees


-- Intersect: Order not matter.
-- Task: Find employees who are also customers
SELECT 
	FirstName,
	LastName
FROM Sales.Customers
INTERSECT
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

-- Task: Orders data are stored in seperate tables (Orders and OrdersArchive)
-- Combine all orders data into one report without duplicates.
SELECT 
'Orders' as SourceTable,
[OrderID],
[ProductID],
[CustomerID],
[SalesPersonID],
[OrderDate],
[ShipDate],
[OrderStatus],
[ShipAddress],
[BillAddress],
[Quantity],
[Sales],
[CreationTime]
FROM Sales.Orders
UNION
SELECT 
'OrdersArchive' as SourceTable,
[OrderID],
[ProductID],
[CustomerID],
[SalesPersonID],
[OrderDate],
[ShipDate],
[OrderStatus],
[ShipAddress],
[BillAddress],
[Quantity],
[Sales],
[CreationTime]
FROM Sales.OrdersArchive
ORDER BY ORDERID












