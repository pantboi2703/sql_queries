/*
	A stored procedure is a precompiled set of SQL statements stored in the database. 
	You can execute it by calling its name, often with parameters. Think of it like a
	reusable function in programming.

	+---------------------+       CALL           +--------------------------+
    | Application         |  --------------->    |   Stored Procedure (SP)  |
    | (e.g., Web Server)  |                      |     e.g., GetUserDetails |  
    +---------------------+                      +--------------------------+
                                                          |
                                                          |  Executes SQL logic
                                                          v
                                                 +--------------------------+
                                                 |      SQL Statements      |
                                                 |  SELECT, INSERT, UPDATE  |
                                                 +--------------------------+
                                                          |
                                                          v
                                                 +--------------------------+
                                                 |      Database Tables     |
                                                 |     e.g., Users, Orders  |
                                                 +--------------------------+

*/

/*
    Procedure Syntax: 

    CREATE PROCEDURE ProcedureName AS |
    BEGIN                             |--> Definition of Stored Procedure
      -- SQL Statements go here.      |
    END                               |

    EXEC ProcedureName                |--> Execution Call of Stored Procedure.
*/

/* 
    Task: 
    Step 1: Write a query
    For US Customers Find the Total Number of Customers and the Average score.
*/

SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'

-- Step 2: Turning the query into a Stored Procedure.
CREATE PROCEDURE GetCustomerSummary AS 
BEGIN 
    SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END

-- Note: Stores in the Databases -> SalesDB -> Programmability -> Stored Proocedures -> dbo.GetCustomerSummary.

-- Step 3: Execute the store Procedure.
EXEC GetCustomerSummary

/*
    Store Procedures Parameters: Placeholders used to pass values as input from the caller to the procedure,
    allowing dynamic data to be processed.
*/

-- Task: For German Customers find the total number of customers and the average score.
SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany' 

CREATE PROCEDURE GetCustomersSummaryGermany AS 
BEGIN 
SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany' 
END

EXEC GetCustomersSummaryGermany

-- Note: If you notice repeated code in your project, it's a sign that your code can be improved. Here 
-- we see we repeat the same query for the USA and Germany but the difference is only country.

CREATE PROCEDURE GetCustomersSummary2 @Country NVARCHAR(50)
AS 
BEGIN 
SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country
END

EXEC GetCustomersSummary2 @Country = 'Germany'
EXEC GetCustomersSummary2 @Country = 'USA'

-- Note: You can also change the deo=finition of the procedure using ALTER 
ALTER PROCEDURE GetCustomersSummary2 @Country NVARCHAR(50) = 'USA'  -- Use Parameters here by default USA
AS 
BEGIN 
SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = @Country; 

-- Find the total number of orders and total sales
SELECT 
COUNT(OrderID) TotalOrders,
SUM(Sales) TotalSales
FROM Sales.Orders o
JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE c.Country = @Country 

END 

EXEC GetCustomersSummary2
EXEC GetCustomersSummary2 @Country = 'Germany'

/*
    Store Procedure Variables: Variables is like a placeholder used to store values to be used later 
                               in the procedure.
    -> Parameters pass values into a stored procedure or return values back to the caller.
    -> Variables temporarily store and manipulate data during its execution.
*/

/*
    Store Procedure Control Flow If/Else: 
*/
-- Task related to variable: 
-- Output: Total Customers from Germany: 2
--       : Average Score from Germany: 425

/*
    Error Handling: 
    Syntax: 
            BEGIN TRY
             -- SQL Statements that might cause an error.
            END TRY

            BEGIN CATCH
             -- SQL Statements to handle the error.
            END CATCH
*/
ALTER PROCEDURE GetCustomersSummary2 @Country NVARCHAR(50) = 'USA'  -- Use Parameters here by default USA
AS 
BEGIN 
    BEGIN TRY
        DECLARE @TotalCustomers INT, @AvgScore FLOAT; -- Declare Variable 

        -- ================================
        -- Step 1: Prepare and CleanUp data
        -- ================================
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END

        ELSE 
        BEGIN
            PRINT('No NULL Scores found');
        END; 

        -- ==================================
        -- Step 2: Generating Summary Reports 
        -- ==================================
        -- Calculate Total Customers and Average Score for specefic country.
        SELECT 
            @TotalCustomers = COUNT(*),          -- Add values to the variables 
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country; 

        PRINT 'Total Customers from ' + @Country + ':' +  CAST(@TotalCustomers AS NVARCHAR);   -- Use the variables.
        PRINT 'Average Score from ' + @Country + ':' +  CAST(@AvgScore AS NVARCHAR);

        -- Calculate Total Number of Orders and Total Sales for specific country.
        SELECT 
            COUNT(OrderID) TotalOrders,
            SUM(Sales) TotalSales,
            1/0
        FROM Sales.Orders o
        JOIN Sales.Customers c
        ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country 

    END TRY
    BEGIN CATCH 
        -- ================================
        -- Error Handling
        -- ================================
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ERROR_PROCEDURE());
    END CATCH
END 
GO

EXEC GetCustomersSummary2
EXEC GetCustomersSummary2 @Country = 'Germany'



