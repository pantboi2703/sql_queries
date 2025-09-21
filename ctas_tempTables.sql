/*
	A table is a structured collection of data, similar to a spreadsheet or grid (Excel).
	Table Types: Permanent Table, Temporary Table

	1. Permanent Table: Classical way to create a table from scratch: CREATE / INSERT
	                    Other way is CTAS (Create Table as Select)

			-> CREATE/INSERT: Create | Define the structure the table.
							  Insert | Insert Data into the table.

							  Step 1: Define the structure. Create this will make a empty table.
							  Step 2: Insert the data via manually or from a file .csv or also get 
							          from an application.

			-> CTAS: Create a new table based on the result of an SQL query. 
			         Step 1: Write the query but this query needs a database table in order to execute the
					         query and the result of that query is used to make a new table. So this table data
							 comes from the result of the query.

			Note: Querying Views is slower than querying CTAS tables.

			  ASPECT            |            CTAS               |          VIEW 
		1. Query Attachment     |	Yes — query is used once to |  Yes — query is stored and reused
								|	create the table.			|  every time.
								|								|
		2. When Query Runs		|   Only at creation time.		|  Every time the view is queried.
								|								|
		3. Data 				|	Result is stored as a 	    |  No data stored — query runs dynamically.
		   Materialization	    |   physical table.             |
								|	               			    |
		4. Query Reusability	|	Not reusable — query is		|  Fully reusable — query is part of the view.
								|	discarded after creation.   |
								|								|
		5. Data Freshness		|	Static snapshot.			|  Always reflects latest data.
								|								|
		6. Note				    |	run the query once, save    |  save the query, run it fresh every time.
								|	the result.				    |
								
*/

/*
	1. CREATE / INSERT Syntax:
	                          CREATE TABLE Table-Name (
							   ID INT,
							   NAME VARCHAR(50)
							  )

							  INSERT INTO TABLE-NAME
							  VALUES(1, 'FRANK')

	2. CTAS Syntax:      
	                CREATE TABLE NAME AS 
					(
					  SELECT ...
					  FROM ...
					  WHERE ...
					)
*/

/*
	USECASE 1 of CTAS: 
	1. Optimize Performance: 
	   Views provide centralized logic that can be reused across queries, ensuring consistency. 
	   However, when multiple users access a view simultaneously, the underlying logic is executed 
	   repeatedly for each request, which can lead to performance bottlenecks—especially 
	   if the view involves complex joins or aggregations.

       To mitigate this, CTAS can be used to materialize the result of the view 
	   into a physical table. This table is computed once and stored, allowing end
	   users to query precomputed data directly, significantly improving performance 
	   and reducing compute overhead.
*/

-- Create Table using CTS:
SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	Count(OrderID) TotalOrders 
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

-- DROP the Table
DROP TABLE Sales.MonthlyOrders

-- How to update the Table Data ?
/*
	1st using DROP: First Drop the table and then update it.
	2nd using Transact-SQL: Use some programming to update it.
*/

-- Use T-SQL: 
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL 
	DROP TABLE Sales.MonthlyOrders;
GO
SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	Count(OrderID) TotalOrders 
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

/*
	Temporary Tables: Stores immediate results in temporary storage within the database during the session.
	                  The database will drop all temporary tables after the session ends.

					  Step 1: In temporary table we also have one query which interacts with the database 
							  table and it will creates the table but the differnce is In Ctas The table 
							  is lived permanently in the database and if the data is offline it lives 
							  there but the Temporary Tables drop after the session ends.

					  Syntax: SELECT...
							  INTO #New-Table
							  FROM...
							  WHERE...
*/

/*
	Task make the temporary table of the Sales.Orders -> Orders. And this table is shown in Databases -> 
	System Databases -> tempdb -> Tables -> Temporary tables -> dbo.#Orders
*/

-- Step 1: Load data from table to temp table
SELECT 
*
INTO #Orders
FROM Sales.Orders

SELECT * FROM #Orders

-- Step 2: Transform Data in Temp table.
DELETE FROM #Orders 
WHERE OrderStatus = 'Delivered'

SELECT 
*
FROM #Orders

-- Step 3: Load Temp table into Permanent Table.
SELECT
*
INTO Sales.OrdersTest
FROM #Orders

SELECT
*
FROM Sales.OrdersTest

-- Note: If you close the SSMS without saving so temp table is deleted (clean from the database) but the Sales.OrdersTest remain
-- in the server.