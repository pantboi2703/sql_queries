
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
	3. AVG(expression): Returns the average of values in a window.
						  Syntax: AVG(Sales) OVER (PARTITION BY PRODUCT).
	4. MIN(expression): Returns the minimum value in a window.
						  Syntax: MIN(Sales) OVER (PARTITION BY PRODUCT).
    5. MAX(expression): Returns the maximum value in a window.
						  Syntax: MAX(Sales) OVER (PARTITION BY PRODUCT).
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
