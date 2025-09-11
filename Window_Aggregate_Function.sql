/*
	1. Window Aggregate Function: 
	   Suppose you have Month and Sales and you apply any aggregate function in SQL. SQL gone through the all
	   rows of the window or the entire data and start aggregating the data and in the result SQL give you one
	   single value for the window.

	   Example: AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales)
				-> Sales: Expression is required (only Numeric value).
				-> PARTITION BY is optional.
				-> ORDER BY is optional.
	   
	   Aggregate Functions: 
	   1. COUNT(expression): expression can be all data type. Partition, Order, Frame Clause are optional.
	   2. SUM(expression): expression must be a numerical values. Partition, Order, Frame are optional.
	   3. AVG(expression): expression must be a numerical values. Partition, Order, Frame are optional.
	   4. MIN(expression): expression must be a numerical values. Partition, Order, Frame are optional.
	   5. MAX(expression): expression must be a numerical values. Partition, Order, Frame are optional.
*/

/*
	1. COUNT(expression): Returns the number of rows within a window.
	                      Syntax: COUNT(*) OVER (PARTITION BY Product).

						  Example: Find the total number of orders for each product.
						           COUNT(*) also count NULL.
						  Product        Sales        Count
						  Caps             20           3
						  Caps             10           3
						  Caps              5           3
						  Gloves           30           3
						  Gloves           70           3
						  Gloves          NULL          3

						  Example: Find the total number of sales for each product.
						           COUNT(Sales) OVER (PARTITION BY Product).
								   Note: COUNT(column) not counyt NULL.

                          Product        Sales        Count
						  Caps             20           2
						  Caps             10           2
						  Caps              5           2
						  Gloves           30           2
						  Gloves           70           2
						  Gloves          NULL          2

	2. SUM(expression): Returns the sum of values in a window.
						  Syntax: SUM(Sales) OVER (PARTITION BY Product).
						  Note: SUM() accept only numeric values.
						  Example: Find the total sales for each product.
						       
						  Product        Sales        Count
						  Caps             20           35
						  Caps             10           35
						  Caps              5           35
						  Gloves           30           100
						  Gloves           70           100
						  Gloves          NULL          100


	3. AVG(expression): Returns the average of values in a window.
						  Syntax: AVG(Sales) OVER (PARTITION BY PRODUCT).
						  Example: Find the average sales for each product.
						       
						  Product        Sales        Average
						  Caps             20           11
						  Caps             10           11
						  Caps              5           11
						  Gloves           30           50
						  Gloves           70           50
						  Gloves          NULL          50

						  Note: For the Gloves Product One row sales NULL and it is skip 
						  So use COALESCE(Sales, 0) function which replace null to 0.

						  -> So Ouery is: AVG(COALESCE(Sales,0)) OVER (PARTITION BY PRODUCT).
						  Product        Sales        Average
						  Caps             20           11
						  Caps             10           11
						  Caps              5           11
						  Gloves           30           33
						  Gloves           70           33
						  Gloves          NULL          33

	4. MIN(expression): Returns the minimum value in a window.
						  Syntax: MIN(Sales) OVER (PARTITION BY PRODUCT).
						  Example: 
						  Product        Sales        Average
						  Caps             20            5
						  Caps             10            5
						  Caps              5            5
						  Gloves           30           30
						  Gloves           70           30
						  Gloves          NULL          30

    5. MAX(expression): Returns the maximum value in a window.
						  Syntax: MAX(Sales) OVER (PARTITION BY PRODUCT).
						  Example: 
						  Product        Sales        Average
						  Caps             20           20
						  Caps             10           20
						  Caps              5           20
						  Gloves           30           70
						  Gloves           70           70
						  Gloves          NULL          70
*/

-- Task related to Count:
-- Task: Find the total number of orders.
SELECT 
COUNT(*) TotalOrders 
FROM Sales.Orders

-- Task: Find the total number of orders additionally provide details such order id and order date.
SELECT
OrderID,
OrderDate,
COUNT(*) OVER () TotalOrders 
FROM Sales.Orders

/*
	Task: Find the total number of orders
	      Find the total number of orders for each customers
		  Additionally provide details such order id, order date.
*/
SELECT 
OrderID,
OrderDate,
CustomerID,
COUNT(*) OVER () TotalOrders,
COUNT(*) OVER (PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders

/*
	Task: Find the total number of customers.
	      Additionally provide all customers details.
*/
SELECT 
*,
COUNT(*) OVER() [No. of Customers]
FROM Sales.Customers

/*
	Task: Find the total number of scores for the customers
		  
*/
SELECT
*,
COUNT(*) OVER() TotalCustomers,
COUNT(Score) OVER() TotalScores,
COUNT(Country) OVER(PARTITION BY Country) TotalCountries
FROM Sales.Customers

/*
	Important use case of Window function Count: 
	-> Data Quality Issue: Duplicate leads to inaccuracies in analysis.
	   COUNT() can be used to identify duplicates.
	-> Some other use case: Overall Analysis, Category Analysis, Quality Checks: Identify Nulls and Duplicates. 
*/

-- Task: Check whether the table 'orders' contains any duplicate rows.
-- Note: In the order table usually Primary key is unique but in data analysis we have to check
SELECT 
OrderId,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders

-- Task: Check whether the table 'orders archive' contains any duplicate rows. 
--       And show only duplicate rows 
SELECT 
*
FROM (
	SELECT 
	OrderId,
	COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
)t WHERE CheckPK > 1

/*
	Task related to Sum: Find the total sales across all orders.
						 and the total sales for each product.
						 Additionally, provide details such as order ID and the order date.
*/

-- SELECT * FROM Sales.Orders
SELECT 
OrderID,
OrderDate,
Sales,
ProductID,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesForEachProduct
FROM Sales.Orders

/*
	Interesting Use Case of Aggreagte function not only for SUM() for all the aggregate functions.
	1. Comparison Analysis: Compare the current value and aggregated value of window functions.
							Example:  
							Month        Sales
							 Jan           20
							 Feb           10
		-> Current Row	     Mar           30   -> Total      Highest Value   Lowest Value   Average
							 Apr            5       175(Sum)     70(MAX)        5(MIN)       29(AVG)
							 Jun           70
							 Jul           40

		1. Part-to-Whole Analysis: Compare current sales to total sales.
		2. Compare to Extreme Analysis: Compare current sales to the highest or lowest sales.
		3. Compare to Average Analysis: Help to evaluate whether a value is above or below the avearge.

*/

-- Task: Find the percentage contribution of each product's sales to the total sales.
SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,
ROUND(CAST (Sales AS Float) / SUM(Sales) OVER() * 100, 2) PercentageOfTotal
FROM Sales.Orders

/*
	Task 1 related to Average: Find the average sales across all orders.
	                           And find the average sales for each product.
							   Additionally provide details such as order id, order date.
*/
SELECT 
OrderID,
OrderDate,
Sales,
ProductID,
AVG(Sales) OVER () AvgSales,
AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesForEachProduct
FROM Sales.Orders

/*
	Task 2 related to Average: Find the average scores of customers
							   Additionally provide details such CustomerID and LastName.
*/
SELECT 
	CustomerID,
	LastName,
	Score,
	AVG(Score) OVER() AverageScoreWithNull,
	AVG(COALESCE(Score, 0)) OVER() AverageScoreWithoutNull
FROM Sales.Customers

/*
	Task 3 related to Average: Find all orders where sales are higher than the average sales 
							   across all orders.

*/
SELECT 
* 
FROM(
	SELECT 
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER () AvgSales
	FROM Sales.Orders
) t WHERE Sales > AvgSales

/*
	Task 1 related to MIN/MAX: Find the highest and lowest sales across all orders.
							   and the highest and lowest sales for each product.
							   Additionally, provide the detils such as orderID and orderDate.
*/
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProducts,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProducts
FROM Sales.Orders

-- Task: Show the employees who have the highest salaries.
SELECT
*
FROM (
	SELECT
	*,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
) t WHERE Salary = HighestSalary

-- Task: Find the deviation of each sales from the minimum and maximum sales amounts.
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSalary,
	MIN(Sales) OVER() LowestSalary,
	Sales - MIN(Sales) OVER() DeviationFromMin,
	MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders

/*
	-> Analytical Use Case: Running and Rolling Total (Used for Data Analyzing and reporting)
	1. Tracking: Tracking Current Sales with Target Sales.
	2. Trend Analysis: Providing insights into historical patterns.

	-> Running and Rolling Total: They aggregate sequence of members, and the aggregation
	                              is updated each time a new member is added.

	1. Running Total: Aggregate all values from the beginning up to the current point without 
	                  dropping off older data.

	2. Rolling Total: Aggregate all values within a fixed time window (e.g. 30 days). As new data
					  is added, the oldest data will be dropped.

    Example: 

	       Running Total						 |           Rolling Total
	SUM(Sales) OVER(ORDER BY Month)				 |   SUM(Sales) OVER(ORDER BY Month) 
												 |   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	Default: ROWS BETWEEN UNBOUNDED 			 |
	PRECEDING AND CURRENT ROW	                 |
	  Note: UNBOUNDED PRECEDING -> UP            |      Note: Preceding -> P
		  	CURRENT ROW -> CR			         |            CURRENT ROW -> CR
		                                         |
		                                         |             
									             |    -> 2P
		       Month      Sales      SUM		 |    -> 2P          MONTH      Sales      SUM
-> CR	-> UP  Jan			20		  20		 |    -> CR -> 2P     Jan         20        20
		-> CR  Feb			10		  30		 |	  -> CR	-> 2P	  Feb         10        30
		-> CR  Mar	  		30   	  60		 |    -> CR -> 2P     Mar         30        60
		-> CR  Apr		     5		  65		 |	  -> CR	-> 2P	  Apr		   5        45
		-> CR  Jun			70		  135		 |    -> CR           Jun         70        105
		-> CR  Jul			40		  175		 |    -> CR           Jul         40        115
*/

-- Task: Calculate moving average of sales for each product over time.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders
-- 

-- Task: Calculate moving average of sales for each product over time, including only the next order.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders

/*
	-> SUMMARY OF WINDOW AGGREGATE FUNCTIONS:
	   Aggregate set of values and return a single aggregated value.
	   1. Rules:
	    - Expression: Numbers(All Functions), Any Data Type(Count).
		- All Clauses are optional.
	   2. Use Cases:
	    - Overall Analysis.
		- Total Per Group Analysis.
		- Part-to-whole Analysis.
		- Comparison Analysis: Average and Extreme: Highest/Lowest.
		- Identify Duplicates.
		- Outlier Detection.
		- Running Total.
		- Rolling Total.
		- Moving Average
*/
