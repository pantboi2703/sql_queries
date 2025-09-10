/* 
Multi-Row Functions: 
    1. Aggregate Functions (Basics)
	2. Window Functions (Advanced)
*/

-- Aggregation Functions: 
/*
	Sales: 35, 15, 20, 10.
	1. Calculate Total Number of Orders: COUNT(*) => 4 [Count how many rows].
	2. Total Sales: SUM() => 80.
	3. Find Average Sales: AVG() => 20.
	4. Find the highest Sales: MAX() => 35.
	5. Find the lowest Sales: MIN() => 10.
*/

-- Task: Find the Total number of Orders.
SELECT 
COUNT(*) AS total_number_of_orders
FROM orders

-- Task: Find the total sales of all Orders.
SELECT
COUNT(*) AS total_number_of_orders,
SUM(sales) AS total_sales
FROM Orders

-- Task: Find the average sales of all orders.
SELECT
COUNT(*) AS total_number_of_orders,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales
FROM Orders

-- Task: Find the highest sales of all orders.
SELECT
COUNT(*) AS total_number_of_orders,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS Highest_sales
FROM Orders

-- Task: Find the lowest sales of all orders.
SELECT
customer_id,
COUNT(*) AS total_number_of_orders,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS highest_sales,
MIN(sales) AS lowest_sales
FROM Orders
GROUP BY customer_id

-- Task: Perform aggregate functions on Customers Table.

SELECT * FROM customers

SELECT 
country,
COUNT(*) as total_students,
SUM(score) as total_score,
AVG(score) as total_average,
MAX(score) as highest_score,
MIN(score) as lowest_score
FROM customers
GROUP BY country

/*
	Window Functions: Perform Calculations (e.g. aggregation) on a specific subset of data, without losing 
	the level of details of rows.
*/

-- Task: Find the total sales across all orders.
SELECT
SUM(Sales) TotalSales
FROM Sales.Orders

-- Task 1: Find the total Sales for each product.
SELECT
ProductID,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

-- Task 2: Find the total Sales for each product, additionally provide details such order id and order date.

/* This is not allowed in SQL GROUP BY Rule: All columns in SELECT must be included in GROUP BY.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID
*/

-- lets add everything in GROUP BY like OrderID and OrderDate.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY 
		OrderId,
		OrderDate,
		ProductID
-- Note: Solve the task 2 second part add additionally info. but now first part is destroyed.
--       GROUP BY LIMITATIONS: Can't do aggregation and provide details at same time. So use window function.

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders

-- Note: By using window function we can add extraa information easily.

/*  
    Window Functions also divide in three parts:
	1. Aggregate Functions: COUNT(exp), SUM(exp), AVG(exp), MAX(exp), MIN(exp).
							In this Count have anything data type in a argument but other 4 allow numeric data types.

	2. Rank Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), CUME_DIST(), PERCENT_RANK(), NTILE(n).
	                   In Rank Function: All have empty arguments except one which is NTILE have numeric argument.

	3. Value(Analytics Functions): LEAD(expr, offset, default), LAG(expr, offset, default),
	                               FIRST_VALUE(expr), LAST_VALUE(expr).
								   Note: In this arguments have any data type.

	Window Function Syntax: Syntax divide in two parts:
	1. Window Function.
	2. Over Clause: also has 3 parts : i)   Partition Clause
									   ii)  Order Clause
									   iii) Frame Clause
	Example: 
	AVG (Sales) OVER (PARTITION BY Category ORDER BY OrderDate  ROWS UNBOUNDED PRECEDING)
	
	Details of the Example:
	1. AVG(Sales): Window Function with function expression (Argument you pass to a function).
				
				Now, Expression may be anything describe below:
				1. Empty: RANK() OVER (ORDER BY OrderDate).
				2. Column: AVERAGE(Column) OVER (ORDER BY OrderDate)
				3. Number: NTILE(2) OVER (ORDER BY OrderDate)
				4. Multiple Arguments: LEAD(Sales, 2, 10) OVER (ORDER BY OrderDate)
				5. Conditional Logic: SUM(CASE WHEN Sales > 100 THEN 1 ELSE 0 END) OVER (ORDER BY OrderDate).

	2. OVER (PARTITION BY Category ORDER BY OrderDate  ROWS UNBOUNDED PRECEDING): OVER also empty. 
	   Over Clause: Tells SQL that the function used is a window function. It defines a window or subset of data.
	   1. Partition Clause: Divide the datasets into windows (partitions).
	                        Note: Partition Clause is optional in all window functions.
	      -> PARTITION BY divides the rows into groups, based on the column/s.
		     => SUM(Sales) OVER(): Calculation is done on entier dataset.
			    --------------------------------------------------------
			 => SUM(Sales) OVER(PARTITION BY Product): Calculation is done individually on each window.
			    ---------------- Window 1 ----------------- || --------------- Window 2 ---------------
				-> Variations of Partition By:
				   1. Without Partition By: Total sales across all rows(Entire Result Set).
				                            SUM (Sales) OVER ()
				   2. Partition By (Single Column): Total sales for each product.
													SUM (Sales) OVER (PARTITION BY Product)
				   3. Partition By (Combined Column): Total Sales for each combination of Product and Order Status.
													  SUM (Sales) OVER (PARTITION BY Product, OrderStatus)

	   2. ORDER BY: Sort the data within a window. (Ascending or Descending)
	                Note: ORDER Clause is optional for Window aggregate functions. (Count, Avg, Sum, Min, Max).
						  But it is required in Rank or Value Window Functions.
				    Example: RANK () OVER (PARTITION BY MONTH ORDER BY SALES DESC)
					         Explanation: Partition By Month(suppose we have JAN, FEB in month).
							              So the partition divides the window into 2 parts (acc. to month).
										  And the sales in both the window sort highest to lowest fashion.
										  At the last Rank these(1,2,3) with the seperate column for both the window
*/
-- Task 1: Find the Total Sales across all orders
-- Additionally provide details such order Id, order date.

SELECT
OrderID,
OrderDate,
SUM(Sales) OVER() TotalSales
FROM Sales.Orders

-- Task 2: Find the total sales for each product, additionally provide details such orderId, orderDate.
SELECT 
	OrderID,
	OrderDate,
	ProductID,
SUM(Sales) OVER (PARTITION BY PRODUCTID) TotalSales -- Dataset divided in 4 window according to ProductId -> 101, 102, 104, 105
FROM Sales.Orders

-- Task 3: 
/* 
   Find the total sales across all orders.
   Find the total sales for each product. 
   additionally provide details such orderId, orderDate.
*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() TotalSales,
    SUM(Sales) OVER (PARTITION BY PRODUCTID) TotalSalesByProducts -- Dataset divided in 4 window according to ProductId -> 101, 102, 104, 105
FROM Sales.Orders

-- Task 4: 
/* 
   Find the total sales across all orders.
   Find the total sales for each product.
   Find the total sales for each combination of product and order status.
   additionally provide details such orderId, orderDate.
*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) TotalSalesByProductAndOrderStatus
FROM Sales.Orders

-- Task based on Order By clause in window function.

/*
	Task 1:  Rank each order based on their sales from highest to lowest.
	         Additionally provide details such order Id, order date.
*/
SELECT 
OrderID,
OrderDate,
Sales,
RANK() OVER(ORDER BY Sales DESC) RankSales 
FROM Sales.Orders