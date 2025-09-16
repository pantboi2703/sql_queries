/*
	Window Ranking Function:
	Task: Rank the products based on their sales.

	Product                 Sales
	   A                      20
	   B                      30
	   C                      10
	   D                       5
	   E                      70

	   First step SQL, sorts the data from the highest to the lowest.
    Product                 Sales
	   E                     70
	   B                     30
	   A                     20
	   C                     10
	   D                      5
	   
	   2 methods for ranking the data: Integer Based Ranking and Percentage Based Ranking

	    Integer and Percentage Based Ranking:
		Note: In Percentage based Ranking SQL gonna first and calculate the relative position of row
		      compare to others and assign a percentage to each row. Scale 0 to 1.
	    Note: Discrete Distinct Values in Integer-Based Ranking
		      Continuous Value at the same sacle 0 to 1. Normalised scale.
	   Product          Sales          Integer-based Ranking          Percentage-Based Ranking
	     E                70                  1                                  0
	     B                30                  2                                 0.25
	     A                20                  3                                 0.50
	     C                10                  4                                 0.75
	     D                 5                  5                                 1.00

		 Type of Question: Integer Based Ranking is used in: Find top 3 Products.(Top/Bottom N Analysis).
		                   Percentage Based Ranking is used in: Find top 20% Products.(Distribution Analysis).

		 -> In Integer-Based Ranking we have 4 functions: 
		    1. ROW_NUMBER(),  2. RANK(),  3. DENSE_RANK(),  4. NTILE().
		 -> Percentage-Based Ranking generate by 2 functions:
			1. CUME_DIST(),   2. PERCENT_RANK().

		=> Syntax of Rank Functions: RANK() OVER(PARTITION BY ProductID ORDER BY Sales)
*/                                        ^              ^                      ^
                                          |              |                      |
--								Expression must       Partition By            Order By
--                                 be empty            is optional          is required

/*
		Rank Functions: 
		1. ROW_NUMBER(): expression empty, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.
		2. RANK(): expression empty, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.
		3. DENSE_RANK(): expression empty, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.
		4. CUME_DIST(): expression empty, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.
		5. PERCENT_RANK(): expression empty, expression empty, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.
		6. NTILE(n): expression number, Partition Clause optional, Order Clause required,
		                 Frame Clause not allowed.		
*/

/*
	1. ROW_NUMBER(): -> Assign a unique number to each row.
	                 -> It doesn't handle ties. Means if two Rows sharing the same value they will not 
				        share same rank.
				        Example:    Sales           
				                     80
								     20 
								     80
								     50 
							        100
						Syntax: ROW_NUMBER() OVER(ORDER BY Sales DESC)
				               Sales               Rank
							    100                  1
								 80                  2
								 80                  3
								 50                  4
								 20                  5
						  Note: Unique ranking without gap/skipping.
						  Observation: In Sales same values twice (80) but ROW_NUMBER() 
						               give distinct value. So it not handle ties.
*/

-- Task: Rank the orders based on their sales from highest to lowest [USE ROW_NUMBER()].
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row
FROM Sales.Orders

/*
	2. RANK(): -> Assign a rank to each row.
	           -> It handles ties.
			   -> It leaves gaps in ranking.
			    Example:           Sales           
				                     80
								     20 
								     80
								     50 
							        100
				Syntax: RANK() OVER(ORDER BY Sales DESC) 
				               Sales               Rank
							    100                  1
								 80                  2
								 80                  2   ---|> Gap in Ranking
	-> position no. = 4			 50                  4   ---|> 
								 20                  5
*/

-- Task: Rank the orders based on their sales from highest to lowest [USE RANK()].
SELECT 
	OrderID,
	ProductID,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders


/*
	DENSE_RANK(): -> Assign a rank to each row.
	              -> It handles ties.
			      -> It doesn't leaves gaps in ranking.
				  Example:          Sales           
				                     80
								     20 
								     80
								     50 
							        100
				Syntax: DENSE_RANK() OVER(ORDER BY Sales DESC) 
				               Sales               Rank
							    100                  1
								 80                  2
								 80                  2   ---|> Shared Ranking leaves no gap (no skipping)
	-> Next Rank Sequence		 50                  3   ---|> 
								 20                  4
*/

-- Task: Rank the orders based on their sales from highest to lowest [USE DENSE_RANK()]
SELECT 
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_Dense
FROM Sales.Orders

-- Just modify upper task with subquery to calculate highest sales.
SELECT
	OrderID,
	ProductID,
	Sales
FROM (
	SELECT 
		OrderID,
		ProductID,
		Sales,
		DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_Dense
	FROM Sales.Orders
) t WHERE SalesRank_Dense = 1

/*
	-> Use Case of ROW_NUMBER() Function:
	1. Top-N Analyisis: Analysis the top performances to do targeted marketing.
	2. Bottom-N Analysis: Help Analysis the underperformance to manage risks and to do optimizations.
	3. Generate Unique Id's: Help to assign unique identifier for each row to help paginating.
	             Paginating: The process of breaking down a large data into samller, more manageable
				             blocks.
	4. Identify Duplicates: Identify and remove duplicate rows to improve data quality.
*/

-- Task related to Top-N Analysis: Find the top highest sales for each product.
SELECT
*
FROM (
	SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
	FROM Sales.Orders
) t WHERE RankByProduct = 1

-- Task related to Bottom-N Analysis: Find the lowest 2 customers based on their total sales.
SELECT 
*
FROM (
	SELECT 
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER(ORDER BY Sum(Sales)) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
) t WHERE RankCustomers <= 2

-- Task related to generate unique id's: Assign unique id's to the rows of the 'Orders Archive' table.
SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

-- Task related to Identify Duplicates: Identify duplicates rows in the table 'Orders Archive'.
--								        and return a clean result without any duplicates.
SELECT * FROM (
SELECT 
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
*
FROM Sales.OrdersArchive
) t WHERE rn = 1

/*
	NTILE(): Divides the rows into a specified number of approximately equal groups (Buckets).
	         Syntax: NTILE(2) OVER (ORDER BY Sales DESC)
			 Example 1: Even Entry

						Sales                NTILE
						 100                   1
						  80                   1
						  80                   2
						  50                   2

				Bucket Size: Number of Rows / Number of Buckets = 4 / 2 = 2.

			 Example 2: Odd Entry 

			            Sales                NTILE
						 100                   1
						  80                   1
						  80                   1
						  50                   2
						  30                   2
                Bucket Size: Number of Rows / Number of Buckets = 5 / 2 
				Rule: Larger Groups comes first.
*/

-- Example related to NTILE():
SELECT 
OrderID,
Sales,
NTILE(1) OVER (ORDER BY Sales DESC) OneBucket,
NTILE(2) OVER (ORDER BY Sales DESC) TwoBucket,
NTILE(3) OVER (ORDER BY Sales DESC) ThreeBucket,
NTILE(4) OVER (ORDER BY Sales DESC) FourBucket
FROM Sales.Orders

/*
	NTILE Use Case: 
	Data Analyst -> Data Segmentation: Divides a dataset into distinct subsets based on certain criteria.
	Data Engineer -> Equalizing load Processing
*/

-- Task related to Data Segmentation: Segment all orders into three categories: High, Low and Medium Sales.
SELECT 
	*,
	CASE WHEN Buckets = 1 THEN 'High'
	     WHEN Buckets = 2 THEN 'Medium'
	     WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM (
SELECT
	OrderID,
	Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) Buckets
FROM Sales.Orders
)t

-- Task related to load processing: In order to export data, divide the orders into 4 groups.
SELECT 
NTILE(4) OVER(ORDER BY OrderID) Buckets,
*
FROM Sales.Orders

/*
	CUME_DIST(): Cumulative Distribution calculates the distribution of data points within a window.
	             Query: CUME_DIST() OVER (ORDER BY Sales DESC) 
				 Formula: CUME_DIST: Position Number / Number of Rows.
				 Tie Rule: The position of the last occurence of the same value.
				 Note: Inclusive (The current row is included)
				 Explanation: 
				 Sales                     DIST
				  100                      0.2 (1/5)
				   80                      0.6 (3/5)
				   80                      0.6 (3/5)
				   50                      0.8 (4/5)
				   30                      1.0 (5/5)

	PERCENT_RANK(): Calculates the relative position of each row.
	                Query:   PERCENT_RANK() OVER (ORDER BY Sales DESC) 
					Formula: PERCENT_RANK: Position Number - 1 / Number of Rows - 1.
					Tie Rule: The position of the first occurence of the same value.
					Note: Exclusive (The current row is excluded)
					Explanation: 
					Sales                     DIST
				     100                      0.00 (0/4)
					  80                      0.25 (1/4) 
					  80                      0.25 (1/4)
					  50                      0.75 (3/4)
					  30                      1.00 (4/4)
*/

-- Task: Find the products that fall within the highest 40% of prices.
SELECT 
*,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM (
	SELECT 
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) DistRank
    FROM Sales.Products
) t WHERE DistRank <= 0.4 

-- Task: Find the products that fall within the highest 40% of prices.(Use PERCENT_RANK)
SELECT 
*,
CONCAT(DistRank * 100, '%') DistRankPerc
FROM (
	SELECT 
		Product,
		Price,
		PERCENT_RANK() OVER(ORDER BY Price DESC) DistRank
    FROM Sales.Products
) t WHERE DistRank <= 0.4 

SELECT * FROM Sales.Products

