-- Functions:- A built-in SQL code: accepts an i/p value, processes it, returns an output value.
-- Two Types Functions in SQL => Row Level Functions and Aggregation and Analytical Functions.
/*
	Two categories: 
	1. Single Row Functions: Takes one value in input and return one value in output.
	   Example: LOWER() => takes input 'MARIA' and generate output 'maria'
	2. Multi Row Functions: Takes multi value in input and return summarized value only one value.
	   Example: SUM() => Takes input 10 20 30 40 and generate output 100.
*/

/*
    Nested Functions: Function used inside another function.
	Example: 'Maria' -> LEFT(2) -> 'Ma' -> LOWER() -> 'ma'
	                  LOWER (LEFT('Maria', 2))
*/

/*
   Single-Row Functions: 
    1. String Functions
    2. Number Functions
    3. Date and Time Functions
    4. Null Functions
    5. Case Statement

   Multi-Row Functions: 
    1. Aggregate Functions (Basics)
	2. Window Functions (Advanced)
*/

/*
   String Functions: 
     1. Manipulation: CONCAT, UPPER, LOWER, TRIM, REPLACE.
	 2. Calculation: LEN.
	 3. String Extraction: LEFT, RIGHT, SUBSTRING.
*/

-- Manipulation: 
/*
	CONCAT: Combines multiple strings into one.
	UPPER: Converts all characters to uppercase.
	LOWER: Converts all characters to lowercase.
	TRIM: Removes leading and trailing spaces.
	REPLACE: Replace specific character with a new character.
*/

-- Task related to CONCAT: Concatenate first name and country in one column.
SELECT 
first_name,
country,
CONCAT(first_name, ' from ', country) AS name_country
FROM customers

-- Task related to UPPER and LOWER.
-- Transform the customer's first name to lowercase.
SELECT 
first_name,
country,
CONCAT(first_name, ' from ', country) AS name_country,
LOWER(first_name) as lower_name
FROM customers

-- Transform the customer's first name to uppercase.
SELECT 
first_name,
country,
CONCAT(first_name, ' from ', country) AS name_country,
UPPER(first_name) as upper_name
FROM customers

-- Task related to TRIM: Find customer whose first name contains leading or trailing spaces.
SELECT 
	first_name
FROM customers
WHERE first_name != TRIM(first_name)
                              --- or ---
SELECT 
	first_name,
	LEN(first_name) as len_before_trim,
	LEN(TRIM(first_name)) as len_after_trim,
	LEN(first_name) - LEN(TRIM(first_name)) as flag
FROM customers
WHERE LEN(first_name) - LEN(TRIM(first_name)) != 0

-- Replace: REPLACE oldValue = '_' with newValue = '/')
-- Note: Also used for Remove if not specify anything in the place of newValue
-- Task related to the Replace. This time we use static value.
SELECT 
'123-456-7890' as phone, 
REPLACE('123-456-7890', '-', '') as clean_phone,
REPLACE('123-456-7890', '-', '/') as clean_phone_1

SELECT 
'report.txt' as old_filename,
REPLACE('report.txt', '.txt', '.csv') as new_filename


-- Calculation: 
/*
	LEN(): Counts how many characters.
*/

-- Task related to length: Calculate the length of each customer's first name.
SELECT 
	first_name,
	LEN(first_name) as len_first_name
FROM customers


-- String Extraction: 
/*
	LEFT: Extract specific numbers of characters from the start.
	      Syntax: LEFT(value, No. of characters) 
		  Example: value = 'Maria', LEFT(value,2), Output: 'Ma'

	RIGHT: Extract specific numbers of characters from the end.
	       Syntax: RIGHT(value, No. of characters)
		   Example: value = 'Maria', RIGHT(value,2), Output: 'ia' 

	Substring: Extracts a part of string at a specified position.
	           Syntax: Substring(value, start, length)
			   Example: value = 'Maria', start = 3, length = 2 
			   Output: 'ri'
			   Example: value = 'Maria', start = 3, length = LEN()
			   Output: 'ri'
*/

-- Task: Retrieve the first two characters of each first_name
SELECT
	first_name,
	LEFT(TRIM(first_name),2) as first_two_character
FROM customers

-- Task: Retrieve the last two characters of each first_name
SELECT
	first_name,
	RIGHT(TRIM(first_name),2) as last_two_character
FROM customers


-- Substring: 
-- Task: Retrieve a list of customer's first name after removing the first character.
SELECT 
	first_name,
	SUBSTRING(TRIM(first_name),2,LEN(first_name)) as sub_name
FROM customers

/*
   Number Functions: ROUND, abs
*/

-- ROUND: 
/*  
    value = 3.516, Here indexing after decimal 5->1, 1->2, 6->3 and before decimal 3->0.
	Syntax: ROUND(value, round off value(0 or 1 or 2))
	Note: The number next with Round decide whether the digit round off or not if greater tahn or equal to 5
	digit round off and reset to 0 after round off digit.
	ROUND 0: Here Round 0 have 3 and next to that at 1 is 5 so it is round off and the value = 4.000.
	ROUND 1: value = 3.500.
	ROUND 2: value = 3.520.
*/

-- Task based on ROUND: Here use static value.
SELECT 
3.516 as value,
ROUND(3.516, 2) as round_2,
ROUND(3.516, 1) as round_1,
ROUND(3.516, 0) as round_0

-- abs: 
/*
   Note: Convert negative number into positive.
*/

-- Exercise:
SELECT
-10 as number,
abs(-10) as abs_negative,
abs(10) as abs_positive


/*
   Date and Time Functions: 
    Important Points.
    1. Date: 2025-08-20 => Year-Month-Day 
    2. Time: 18:55:45 => Hours:Minutes:Seconds 
    3. TimeStamp: Combination of Date and Time => Year-Month-Day Hours:Minutes:Seconds (Oracle,PostgressSQl 
       and MySql)
       DateTime: Combination of Date and Time => Year-Month-Day Hours:Minutes:Seconds (SQL Server)
*/

SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM Sales.Orders

-- Note: Three different sources in order to query the dates.
/*
	1. Dates which aare stored inside our database.
	2. Hardcoded constant string value
	3. GETDATE(): Returns the current date and time at the moment when the query is executed.
*/

SELECT 
OrderID, -- Dates which are stored inside our database.
CreationTime, -- Dates which are stored inside our database.
'2025-08-20' as Hard_Coded, -- Hard Coded Values
GETDATE() as Today  -- Use inbuilt function.
FROM Sales.Orders;

/*
	Note: 
	I) Date manipulating.
	    1. We can extract the different part of the date. Like only year or month part and day also.
	    2. We can change the format. Example: 2025-08-20 => 08/20/25. or 20 Aug 2020 and 20.08.2025
	       First and second same concept.
	II) Date Calculations:
	    Suppose we have a date and we need to find after 3 years that date add and difference.
	III) Test validate the date:
*/

/*
	Date and Time Functions:
	1. Part Extraction: DAY, MONTH, YEAR, DATEPART, DATENAME, DATETRUNC, EOMONTH.
	2. Format and Casting: FORMAT, CONVERT, CAST.
	3. Calculations: DATEADD, DATEDIFF.
    4. Validation: ISDATE.
*/

-- Part Extraction: 
/*
	1. DAY(): returns the day from a date.
			   Syntax: DAY(date)

	2. MONTH(): returns the month from a date.
			   Syntax: MONTH(date)

	3. YEAR(): returns the yearfrom a date.
	           Syntax: YEAR(date)

	4. DATEPART(): returns a specific part of the date as a number. Like week, quarter etc.
	             Syntax: DATEPART(part, date).
				 Examples: DATEPART(month, OrderDate), DATEPART(mm, '2025-08-20').

	5. DATENAME(): returns the name of a specific part of the date. Get the name of the month, week, day and 
	             the quarter etc.
				 Syntax: DATENAME(part, date) same as DATEPART but return string.

	6. DATETRUNC(): Truncates the date to the specific part.
	                Syntax: DATETRUNC(part, date)

					Example: DATETRUNC(minute, date) Keep date to the year to the minute level and reset seconds to 00.
					Explanation: 2025-01-01 12:34:56.000 => 2025-01-01 12:34:00

					Example: DATETRUNC(year, date)
					Explanation: 2025-08-10 12:34:56.000 => 2025-01-01 00:00:00
					
	7. EOMONTH(): Returns the last day of the month.
	             Value => 2025-08-20 : Apply EOMONTH in it it changes the day to the last day. 2025-08-31.
				 Value => 2025-02-01 : Apply EOMONTH in it it changes the day to the last day. 2025-02-28.
				 Value => 2025-03-31 : Apply EOMONTH in it it changes the day to the last day. 2025-03-31.
				 Syntax: EOMONTH(date). 
*/

-- Task: Extracting the Year, Month and Day from the Creation Time.
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) as YEAR,
	MONTH(CreationTime) as MONTH,
	DAY(CreationTime) as DAY
FROM Sales.Orders

-- Exercise related to DATEPART.
SELECT 
	OrderID,
	CreationTime,
	DATEPART(year, CreationTime) as Year_dp,
	DATEPART(month, CreationTime) as Month_dp,
	DATEPART(day, CreationTime) as Day_dp,
	DATEPART(hour, CreationTime) as Hour_dp,
	DATEPART(minute, CreationTime) as Minute_dp,
	DATEPART(second, CreationTime) as Second_dp,
	DATEPART(quarter, CreationTime) as Quarter_dp,  -- Also find quarter that info. not present in CreationTime
	DATEPART(week, CreationTime) as Week_dp
FROM Sales.Orders

-- Exercise related to DATENAME
SELECT 
	OrderID,
	CreationTime,
	DATENAME(month, CreationTime) as Month_dn,
	DATENAME(weekday, CreationTime) as Weekday_dn,
	DATENAME(day, CreationTime) as day_dn,  -- day has no name but the difference is it is a string not a integer.
	DATENAME(year, CreationTime) as year_dn
FROM Sales.Orders


-- Exercise related to the DATATRUNC():
SELECT 
	OrderID,
	CreationTime,
	DATETRUNC(minute, CreationTime) as Minute_dt,
	DATETRUNC(hour, CreationTime) as Hour_dt,
	DATETRUNC(year, CreationTime) as Year_dt
FROM Sales.Orders

-- DATATRUNC usecase: Very useful if the data is very big
-- Task: Count the number of order in the year, month and day.

-- Count in the year.
SELECT 
DATETRUNC(year, CreationTime) as Creation,
COUNT(*) as Count
FROM Sales.Orders
GROUP BY DATETRUNC(year,CreationTime) 

-- Count in the month
SELECT 
DATETRUNC(month, CreationTime) as Creation,
COUNT(*) as Count
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime)

-- Count in the day
SELECT 
DATETRUNC(day, CreationTime) as Creation,
COUNT(*) as Count
FROM Sales.Orders
GROUP BY DATETRUNC(day, CreationTime)


-- Exercise related to the EOMONTH():
SELECT 
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) as EndOfMonth
FROM Sales.Orders

-- Note: There is no function to get the first day of the month. But we can use DATATRUNC to get that.
SELECT 
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) as EndOfMonth,
	CAST(DATETRUNC(month,CreationTime) as DATE) as StartOfMonth
FROM Sales.Orders

-- Exercise: 
-- How many orders were placed in the year?
SELECT
YEAR(OrderDate) as Order_Year,
COUNT(*) as NoOfOrdersForYears
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- How many orders were placed in the month?
SELECT 
DATENAME(month, OrderDate) as Order_Month,
COUNT(*) as NoOfOrdersForMonths
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

-- Part Extraction Use Case: Data Filtering.
-- Task: Show All Orders that placed during the month of the February
/*       Note: Avoid using DATENAME for fitering data because it returns String and string is less faster 
               than numbers. Instead you can use DATEPART
*/

SELECT 
*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2


-- Format and Casting (Basic Understanding): 
/*
	Note: 2025-08-20  18:55:45 => yyyy-MM-dd  HH:mm:ss (Date Format Representation)
	2025-08-20 => yyyy-MM-dd (International Standard ISO 8601)
	08-20-2025 => MM-dd-yyyy (USA standard)
	20-08-2025 => dd-MM-yyyy (European Standard)
*/

/*
	Note: Formatting: Changing the format of a value from one to another. Changing how the data looks like.
	   Date(2025-08-20) -> Format -> MM/dd/yy (08/20/25)
	              -> Format -> MMM yyyy (Aug 2025)

				  -> Convert -> 6(style) -> 20 Aug 25
				  -> Convert -> 112(style) -> 20250820
	   Number(1234567.89) -> Format -> N -> 1,234,567.89
	                      -> Format -> C -> $1,234,567.89
						  -> Format -> P => 123,456,789.00%

	   Casting: Casting the data type from one to another.
	            Example: String -> '123' => 123 -> Number
				We can use Cast and Convert for changing the data type		         
*/

/*
	FORMAT(): Formats a date or time value
			  Syntax: FORMAT(value, format, [,culture]) culture is a optional 
			  Example: FORMAT(OrderDate, 'dd/MM/yyyy') default cultuer 'en-us'
			           FORMAT(OrderDate, 'dd/MM/yyyy', 'ja-JP')
					   FORMAT(1234.56, 'D', 'fr-FR')
*/

-- Exercise on Format
SELECT 
OrderID,
CreationTime,
FORMAT(CreationTime, 'dd-MM-yyyy') USA_Format,
FORMAT(CreationTime, 'MM-dd-yyyy') EURO_Format,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd,
FORMAT(CreationTime, 'MM') MM,
FORMAT(CreationTime, 'MMM') MMM,
FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders

-- Task: Show CreationTime using the following format: Day Wed Jan Q1 2025 12:34:56 PM
SELECT 
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime, 'ddd MMM') + ' Q' + DATENAME(quarter, CreationTime)
+ FORMAT(CreationTime, ' yyyy hh:mm:ss tt') as Custom_Format
FROM Sales.Orders

-- Use case of FORMAT in project FORMAT of date before doing aggregation.
SELECT
FORMAT(OrderDate, 'MMM yy') as Format_Order_Date,
COUNT(*) as Counter
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')


/*
	CONVERT(): Converts a date or time value to a different data type & Formats the value.
			   Syntax: CONVERT(data_type, value [,style])   [,style] should be optional.
			   Examples: CONVERT(INT, '124')
						 CONVERT(VARCHAR, OrderDate, '34')
						 Note: Default style is 0.
*/

-- Exercise related to the CONVERT()
SELECT 
CONVERT(INT, '123') AS [String to Int CONVERT],
CONVERT(DATE, '2025-09-07') AS [String to Date CONVERT],
CONVERT(DATE, CreationTime) AS [DateTime to Date Convert],
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style: 32],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style: 34]
FROM Sales.Orders

-- NOTE: This square brackets after alias AS used to show the column name with spaces.

/*
	CAST(): Converts a value to a specified data type.
			Syntax: CAST(value AS data_type)
			Examples: CAST('123' as INT)
			          CAST('2025-09-07' AS DATE)
*/

SELECT 
CAST('123' AS INT) AS [String to Int],
CAST(123 AS VARCHAR) AS [Int to String],
CAST('2025-09-07' AS DATE) [String to Date],
CAST('2025-09-07' AS DATETIME2) [String to Date],
CreationTime,
CAST(CreationTime AS DATE) [DateTime to Date]
FROM Sales.Orders

-- Note: 
/* 
	                   Casting                       Formating
		CAST():        Anytype to Anytype            No Formating
		CONVERT():     Anytype to Anytype            Formats only Date and Time
		FORMAT():      Anytype to Only String        Formates (Date and Time and Numbers)
*/


/*
	Calculations: DATEADD(): Adds or Subtracts a specific time interval to/from a date.
	              Example: Date: 2025-08-20.
				           Add 3 years -> 2028-08-20
						   Add 2 months -> 2025-10-20
						   Add 5 days -> 2025-08-25
						   Note: We can also do Subtract using DateAdd.
						   Syntax: DATEADD(part, interval, date)
						   Examples: DATEADD(year,2,OrderDate).
				  	             DATEADD(month, -4, OrderDate).
				  
				  DATEDIFF(): Find the difference between two dates.
				              Use Case: Suppose we have two dates.
							            OrderDate: 2025-08-20 and ShippingDate: 2026-02-01
										Ask: How many years passed have between the OrderDate and ShippingDate.
										Note: We can also find the difference in days and months etc.
										Syntax: DATEDIFF(part, start_date, end_date).
										Examples: DATEDIFF(year, OrderDate, ShipDate).
										          DATEDIFF(day, OrderDate, ShipDate).
*/

-- Task Add 2 years in each date.
SELECT 
OrderID,
OrderDate,
DATEADD(year, 2, OrderDate) as [OrderDate after 2 years],
DATEADD(month, 3, OrderDate) as [OrderDate after 3 months],
DATEADD(day, -10, OrderDate) as [OrderDate before 10 days]
FROM Sales.Orders

-- Task related to the DATEDIFF: Calculate the age of employees
SELECT 
	EmployeeID,
	BirthDate,
	DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees;

-- Task related to the DATEDIFF: Find the average shipping duration in days for each month.
SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	DATEDIFF(day, OrderDate, ShipDate) [Day2Ship]
FROM Sales.Orders

-- Task related to the DATEDIFF: Find the average duration in days for each combined month.
SELECT
MONTH(OrderDate) OrderDate,
AVG(DATEDIFF(day, OrderDate, ShipDate)) [Combined Avg. for each month]
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- Task: Find the number of days between each order and previous order.
-- Note: Don't have the previous record. So use LAG() function.
--       LAG(): Access a value from a previous row. LAG is a window Function

SELECT 
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NrOfDays
FROM Sales.Orders


/*
	ISDATE(): Check if a value is a date. Returns 1 if the string is valid or not.
			  Syntax: ISDATE(value)
			          Example: ISDATE('2025-09-8')
							   ISDATE(2025)
*/

-- Exercise on ISDATE(): 
SELECT
ISDATE('123') DateCheck1,  -- 0
ISDATE('2025-08-20') DateCheck2, -- (1) return 1 true because follow the standard format yyyy, MM, dd).
ISDATE('20-08-2025') DateCheck3, -- 0
ISDATE('2025') DataCheck4,  -- 1
ISDATE('08') DataCheck5     -- 0


/*
   NULL FUNCTIONS: NULL means nothing, unknown! NULL is not equal to anything!
				   NULL is not zero. Null is not empty string. Null is not blank space.
		           
				   OverView: Replace Values => NULL -> value(40) -> ISNULL, COALESCE
				                               value -> NULL     -> NULLIF
						     Check for NULLs => NULL -> IS NULL -> TRUE (ISNULL return boolean value)
							                 => NULL -> IS NOT NULL _ FALSE 
*/

/*
		ISNULL(): Replaces 'NULL' with a specified value.
		          Syntax: ISNULL(value, replacement_value)
				  Example: ISNULL(Shipping_Address, 'unknown') [unknown is a default value]
				           ISNULL(Shipping_Address, Billing_Address) [if Shipping_Address isnull replace 
						   with Billing_Address].

		COALESCE(): Returns the first non-null value from a list.
		            Syntax:  COALESCE(value1, value2, value3, ....)
					Example: COALESCE(Shipping_Address, 'unknown')
					         COALESCE(Shipping_Address, Billing_Address)
							 COALESCE(Shipping_Address, Billing_Address, 'unknown')

		    ISNULL                                   COALESCE
	1. Limited to 2 values.                         Unlimited  
	2. Fast                                           Slow
	3. SQL Server -> ISNULL                    Available in all Databases
	   Oracle -> NVL                           
	   MySQL -> IFNULL
*/

/*
	Use-Case of ISNULL and COALESCE:
	1. Handle the null before doing data aggregations.
	Example: Imagine we have three sales 15, 25 and NULL and if we use aggregate function like average and
	         SQL calculates (15+25)/2 = 20 and it ignores null. Same thing with other aggregate function like
			 SUM(), COUNT(Sales), MIN() and MAX(). Only one exception about the aggregate function COUNT(*) if
			 you are using it with * here SQL not considers value it considers rows so it includes all 3 and if
			 business handles null as 0. We have to handle it before aggregation.So we have to replace NULL with
			 0 using ISNULL() or COALESCE().So now the average is (15+25+0)/3 = 13.3

	2. Handle the NULL before doing mathematical operations.
	Example: NULL + 5 = NULL, NULL + 'B' = NULL

	3. Handle the NULL before Joining Tables(Advanced UseCase)
	   If NULL value present in the table keys your data is loose.

	4. Handle the NULL before sorting the data.
	   Example: Suppose have three Sales 15, 25 and NULL.
	            1. Sort the data by Sales via Ascending (Lowest to Highest) so the order is:
				   NULL -> 15 -> 25.
				2. Sort the data by Sales via Descending (Highest to Lowest) so the order is:
				   25 -> 15 -> NULL.
*/

-- Task: Find the average scores of the customers.
SELECT 
CustomerID,
Score,
COALESCE(Score, 0) Score2,
AVG(Score) OVER () AvgScores,
AVG(COALESCE(Score, 0)) OVER () AvgScores2
FROM Sales.Customers

-- Task: Display the full name of customers in a single field by merging their first name and last names,
--       and add 10 bonus points to each customer's score

SELECT 
CustomerId,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, '') AS FullName,
Score,
COALESCE(Score, 0) + 10 as ScoreWithBonus
FROM Sales.Customers

-- Task related to the usecase of Handle the NULL before sorting the data.

-- Task: Sort the customers from lowest to highest scores, with NULLs appearing last.
SELECT
CustomerId,
Score
FROM Sales.Customers
ORDER BY Score

-- 2way by which we can Push Null's at last: 

-- 1st way: 
SELECT
CustomerId,
Score,
COALESCE(Score, 9999999)
FROM Sales.Customers
ORDER BY COALESCE(Score, 9999999)

-- 2nd way: 
SELECT
CustomerId,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

/*
	NULLIF: Compares two expressions returns:
	        - NULL, if they are equal.
			- First Value. if they are not equal.
			Syntax: NULLIF(value1, value2)
			Example: NULLIF(Shipping_Address, 'unknown')
			         NULLIF(Shipping_Address, Billing_Address)
			
			UseCase of NULLIF: Preventing the error of dividing by zero.
*/

-- Task: Find the sales price for each order by dividing sales by quantity.
SELECT 
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) AS Price
FROM Sales.Orders

/*
	IS NULL: Returns TRUE if the value IS NULL otherwise it returns false.
	IS NOT NULL: Returns TRUE if the value IS NOT NULL otherwise it returns false.
	             Syntax: VALUE IS NULL and VALUE IS NOT NULL
	             Example: Shipping_Address  IS NULL
	             Shipping_Address  IS NOT NULL

				 Use Case of IS NULL:
				 1. Filtering Data: Searching of missing information.
*/

-- Task: Identify the customers whose have no score:
SELECT 
*
FROM Sales.Customers
WHERE Score IS NULL

-- Task: List all customers whose have Scores.
SELECT 
*
FROM Sales.Customers
WHERE Score IS NOT NULL

-- Task: List all details for customers who have not placed any orders.
-- Based on LEFT ANTI JOIN: All rows from the left table without matches in the right table.
SELECT 
c.*,
o.OrderId
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerId
WHERE o.CustomerID IS NULL  

-- NULL VS Empty VS Space.
/*
	NULL: NULL means nothing, unknown!
	Empty String: String value has zero characters.
	Blank Space: String value has one or more space characters.
*/
WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2,  NULL UNION
SELECT 3,  '' UNION
SELECT 4,  '  ' 
) 

SELECT 
*,
DATALENGTH(Category) CategoryLen
FROM Orders

/*
	Data Policy: Set of rules that defines how data should be handled.
	1. Only use NULLs and empty strings, but avoid blank spaces.
	2. Only use NULLs and avoid using empty strings and blank spaces.
	3. Use the default value 'unknown' and avoid using nulls, empty strings, and blank spaces.
*/

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2,  NULL UNION
SELECT 3,  '' UNION
SELECT 4,  '  ' 
) 

SELECT 
*,
DATALENGTH(Category) CategoryLen,
TRIM(Category) Policy1,
NULLIF(TRIM(Category), '') Policy2,
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') Policy3
FROM Orders


/*
	CASE Statement: Evaluates a list of conditions and returns a value when the first condition is met.
	                Syntax:
					CASE   -- Start of Logic
						WHEN condition1 THEN result1
						WHEN condition2 THEN result2
						....
						ELSE result                  -- default value used if none of the condition is true if not define else it show NULL
					END    -- End of Logic
*/

/*
	USECASE of Case Statements: 
	Main purpose is Data Transformation -> Derive new information -> Create new columns based on existing data.
	1. Categorizing data: Group the data into different categories based on certain conditions.
	2. Mapping Values: Transform the values from one form to another.
	3. Handling Nulls: Replace NULLs with a specific value.
					   NULLs can lead to inaccurate results which can lead to wrong decision-making.
	4. Conditional Aggregation: Apply aggregate functions only on subsets of data that fulfill certain conditions.
*/

/*  
    Case Statement Rules: 
	1. The data type of the results must be matching.
	2. Case Statements can be used anywhere in the query.
    Task related to the Categorizing data.
	Task: Create report showing total sales for each of the following categories:
		  - High: Sales over 50. 
		  - Medium: Sales 20-50.
		  - Low: Sales 20 or less.
		  Sort the categories from Highest to Lowest.
*/

SELECT 
Category,
SUM(Sales) as TotalSales
FROM(
	SELECT 
	OrderID,
	Sales,
	CASE
		WHEN SALES > 50 THEN 'High'
		WHEN SALES > 20 THEN 'Medium'
		ELSE 'Low'
	END Category
	FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales 

/*
	Task 1 related to Mapping:
	Retrieve employee details with gender displayed as full text.
*/
SELECT 
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
	WHEN Gender = 'F' THEN 'Female'
	WHEN Gender = 'M' THEN 'Male'
	ELSE 'Not Available'
END GenderFullText
FROM Sales.Employees

/*
	Task 2 related to Mapping:
	Retrieve customers details with abbreviated country code.
*/

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'n/a'
	END CountryAbbr,

	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'n/a'
	END CountryAbbr2
FROM Sales.Customers;

SELECT DISTINCT Country
FROM Sales.Customers;

/*
	QuickForm of Case Statements:
	1. Full Form of Case Statements:
	2. QuickForm of Case Statements:
*/

/*
   1. Full Form:
      CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'United States' THEN 'US'
		WHEN Country = 'India' THEN 'IN'
		WHEN Country = 'France' THEN 'FR'
		WHEN Country = 'Italy' THEN 'IT'
		ELSE 'n/a'
	  END CountryAbbr

	2. QuickForm 
	   CASE Country
			WHEN 'Germany' THEN 'DE'
			WHEN 'India' THEN 'IN'
			WHEN 'United States' THEN 'US'
			WHEN 'France' THEN 'FR'
			WHEN 'Italy' THEN 'IT'
			ELSE 'n/a'
	   END
*/

-- Task related to SQL UseCase Handling Nulls:
-- Task: Find the average scores of customers and treat NULLs as 0 and additional provide details such 
--       CustomerID and LastName.

SELECT 
	CustomerID,
	LastName,
	Score,
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END ScoreClean,

	AVG(CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	    END) OVER() AvgCustomerClean,

	AVG(Score) OVER() AvgCustomer
FROM Sales.Customers

-- Task related to Conditional Aggregation:
-- Task: Count how many times each customer has made an order with sales greater than 30.

SELECT 
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrdersHighSales,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

