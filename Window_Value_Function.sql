/*
	Window Value Function: Access a value from another row.
	Example: 
	                 Month         Sales
		              Jan            20
			          Feb            10
-> Current Row		  Mar            30
			          Apr             5
					  Jun            70
					  Jul            40

			1.	Previous Month (Feb): Use LAG() => Compare Sales Current Month VS Previous Month.
			2.	Next Month (Apr): Use LEAD() => Compare Sales Current Month VS Next Month.
			3.  First Month (Jan): Use FIRST_VALUE() => Compare Sales Current Month VS First Month.
			4.  Last Month (July): Use LAST_VALUE() => Compare Sales Current Month VS Last Month.

			Syntax of Value Functions:
			1. LEAD(expression, offset, default): Expression -> All Data Type, Partition Clause -> Optional,
											      Order Clause -> Required, Frame Clause -> Not Allowed.

			2. LAG(expression, offset, default):  Expression -> All Data Type, Partition Clause -> Optional,
											      Order Clause -> Required, Frame Clause -> Not Allowed.

			3. FIRST_VALUE(expression):           Expression -> All Data Type, Partition Clause -> Optional,
											      Order Clause -> Required, Frame Clause -> Optional.

			4. LAST_VALUE(expression):            Expression -> All Data Type, Partition Clause -> Optional,
											      Order Clause -> Required, Frame Clause -> Should be used.
*/

/*
			1. LEAD(): Access the value from the next row within a window.
		    2. LAG(): Access a value from the previous within a window.
			           -> Example with Syntax: LEAD(Sales, 2, 10) OVER (PARTITION BY ProductID ORDER BY OrderDate).
					   -> Explanation:         Sales: Expression is required any data type.
											   2: Offset(Optional): Number of rows forward or backward from current
											      row Depends on use Lead or Lag. Default = 1
										       10: Default Value(Optional): Returns default value if next/previous
												   row is not available. default = null.

			Example 1: 

			LEAD(Sales) OVER(ORDER BY Month)         |    LAG(Sales) OVER(ORDER BY Month)
												     |
			  Month    Sales     LEAD				 |       Month      Sales      LAG
			   Jan		20        10				 |        Jan        20        NULL
			   Feb      10		  30				 |        Feb        10         20
			   Mar	    30		   5				 |        Mar        30         10
			   Apr		 5		 NULL				 |        Apr         5         30
													 |
				Note: Find Sales of Next Month.		 |           Note: Find Sales of Previous Month.

			 
			Example 2: This time not return NULL. Return default value which is 0.

			LEAD(Sales,2,0) OVER(ORDER BY Month)     |    LAG(Sales,2,0) OVER(ORDER BY Month)
												     |
			  Month    Sales     LEAD				 |       Month      Sales      LAG
			   Jan		20        30				 |        Jan        20          0
			   Feb      10		   5 				 |        Feb        10          0
			   Mar	    30		   0				 |        Mar        30         20
			   Apr		 5		   0				 |        Apr         5         10
													 |
				Note: Find the Sales for the two     |           Note: Find the Sales for the two 
				      months ahead.                  |                 months ago.months ahead.					 |		        
*/

-- Task related to Lead() and Lag():

/* Task 1: Analyze the month-over-month (MOM) performance by finding the percentage 
           change in sales between the current and previous month.
		   USECASE: Time-Series Analysis: Method of analyzing the data to understand patterns, trends 
		            and behaviours over time.
					1. Year-over-Year (YOY): Analyze the overall growth or decline the business's 
					                        performance over time.
					2. Month-over-Month (MOM): Analyze short-term trends and discover patterns in 
					                           seasonality.
*/
SELECT 
*,
CurrentMonthSales - PreviousMonthSales AS MOM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT) / PreviousMonthSales * 100,1) AS MOM_Percentage
FROM (
	SELECT 
		MONTH(OrderDate) OrderMonth,
		SUM(Sales) CurrentMonthSales,
		LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
	FROM Sales.Orders
	GROUP BY
		Month(OrderDate)
)t

-- 2nd Use case of LEAD() AND LAG(): Customer Retention Analysis: Measures customer's behaviour and loyalty
-- to help businesses build strong relationships with customers.

/*
	Task related to 2nd use case: Analyze customer loyalty by ranking customers based on the average number 
	of days between orders.
*/
SELECT 
CustomerId,
AVG(DaysUntilNextOrder) AvgDays,
RANK() OVER(ORDER BY COALESCE(Avg(DaysUntilNextOrder), 99999)) RankAvg
FROM (
	SELECT 
	OrderID,
	CustomerID,
	OrderDate CurrentOrder,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders
)t
GROUP BY
	CustomerID

/*
	FIRST_VALUE(): Access a value from the first row within a window.
	LAST_VALUE(): Access a value from the last row within a window.

	Example 1: 

			FIRST_VALUE(Sales) OVER(ORDER BY Month)  |    LAST_VALUE(Sales) OVER(ORDER BY Month)
												     |
			  Month    Sales     FIRST				 |					    Month      Sales      LAST
-> CR -> UP	   Jan		20        20				 |	-> CR -> UP		     Jan        20         20
	  -> CR	   Feb      10		  20		         |		  -> CR			 Feb        10         10
	  -> CR	   Mar	    30		  20				 |		  -> CR			 Mar        30         30
	  -> CR	   Apr		 5		  20				 |		  -> CR	    	 Apr         5          5

				Default: RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
				Note: UP: Unbounded Preceding, CR: Current Row.

				For LAST_VALUE you not able to use DEFAULT FRAME:
				LAST_VALUE(Sales) OVER(ORDER BY Month ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING).

					Month     Sales     LAST
	      -> CR 	 Jan        20       5
	      -> CR 	 Feb        10       5
	      -> CR 	 Mar        30       5
	-> UF -> CR		 Apr         5       5
*/

-- Task: Find the lowest and highest sales for each product.
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VAlUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VAlUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales
FROM Sales.Orders


-- Where to find system catalogue and the metadata. Find those information in  special header schema.
-- Information Schema: A system-defined schema built-in views that provide info about the database, like
-- tables and columns.

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS