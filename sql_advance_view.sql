/*
 -> Hierarchy Structure of Database: 
    1. SQL Server (DB Server): stores, manages, and provides access to databases for users or applications.

    2. Multiple Databases: Inside the server. A Database is a collection of information that is stored in 
                           a structured way.

    3. Multiple Schema: Schema is a logical layer that groups related objects together.

    4. Table: Inside the schema. A table where data is stored and organized into rows and columns.
       View: Inside the schema. View is a virtual table that shows data without storing it physiclly.

    5. Columns and keys: Inside the table.
       Columns: Inside the view.

    6. Name and DataType: Inside the columns of table.

                                            SQL Server 
                                                |
                                            -----------
                                            |         |
                                        Database   Database
                                            |
                                        ---------
                                        |       |
                                     Schema   Schema
                                        |
                                    ------------
                                    |          |
                                  Table      View
                                    |          |
                                --------     ------
                                |       |      |
                             Columns   Key  Columns
                                |
                            --------
                            |      |
                          Name  DataType

     -> To build and manage this structure we have several commands DDL (Data Definition Langauge).
     -> DDL: A set of commands that allows us to define and manage the structure of a database.
             Commands are: CREATE, ALTER, DROP
     -> In Object Explorer we have same hierarchy. (Server -> Databases -> SalesDB, MyDatabase -> 
        Table and Views Inside SalesDB)
        Note: In Tables Sales.Customers, Sales.Employees, Sales.Orders Prefix of Tables "Sales" is a schema
              bring these tables together.

---------------------------------------------------------------------------------------------------------------
                                    Three Level Architecture
----------------------------------------------------------------------------------------------------------------
                                                  View Level (External Layer)

                        Highest Level of abstraction in the database. It is what end users and application 
                        can access and see. 

                        View 1                      View 2                 View N
                    For Business Analyst        For Power BI            For End Users
                                    \                /                      /
                                    
----------------------------------------------------------------------------------------------------------------
                                                  Logical Level (Conceptual Layer)

                        Deals: How to organize your data. Application Developer and Data Engineer has the access
                        of the logical level in order to define the structure of your data.

                        Creating Tables, Finding relationship between the tables, Views, Indexes, Procedures, 
                        Functions

----------------------------------------------------------------------------------------------------------------
                                                 Physical Level (Internal Layer)
                                                                 |
                                                              Database

                Lowest Level of the database where the actual data store in physical storage and actually
                database administrator has the access to this layer. They are the experts and they have to
                manage the access and security of this layer. Because they are the experts they have to manage
                lot of stuff optimize the performance making everything is secure and managing backup and 
                recovery.
                In Physical layer we have to deal many things like Data Files, Partitions, Logs, Catalogs, Blocks,
                Caches.

                High ----------->      Abstraction     <---------------- Low

                View                         Logical                Physical

                Low ------------>      Complexity      <---------------- High

    View: Virtual Table based on the result set of a query, without storing the data in the database.
          Views are persisted SQL queries in the database.

          Database Table with data: Write query to get the data from the table. Normal Table called Physical
          table.

          But View has the structure of table but without any data inside it. And for ecah view there
          is a query which is attached to it. But view is called Virtual table.

          -> So how exactly we get the data?
             Go and write the query for selecting data from the view not from the table what can happen 
             SQL can go and trigger the query that is attached to the view and this query is responsible
             to query in the physical table and then the result can fill the structure of the view. And
             we get back the result.

               Table                         View (Empty) Attached Query                 Query
             id   name     <---------                       SELECT...                    SELECT 
             1     Sam                                      FROM...        <------>      FROM VIEW
             2     Ram     <---------                       JOIN...                      WHERE
                                                            WHERE
            
            Real Data      <--------->           Abstracted Layer         <-------->     You


                                      View VS Table
                View                                                      Table
            No persistance                             Persisted Data (stores on a disk permanently).
            Easy to Maintain                                       Hard to maintain
            Slow Response                                          Fast Response
            Read                                                       Read/Write
*/

/*
        UseCase of View: 
        1. Central Query Logic: Store central, complex query logic in the database for access by multiple
           queries, reducing project complexity.

           DataBase        |  Query (Take data from Tables and perform JOIN and SUM ) |       Result 
                           |   CTE Query    Interemdiate Result     Main Query        |   Financial Analyst
                           |     SUM             Table                 Rank           |
                           |     JOIN                                                 |
                           |                                                          |
                           |                                                          |
                           |                     Query                                |
                           |   CTE Query    Interemdiate Result     Main Query        |       Result
           Orders Table    |     SUM             Table               MAX / MIN        |   Budget Analyst    
                           |     JOIN                                                 |
                           |                                                          |
                           |                                                          |
                           |                                                          |
                           |                                                          |
                           |                     Query                                |       Result
           Customer Table  |   CTE Query    Interemdiate Result     Main Query        |   Risk Analyst
                           |     SUM             Table               COMPARE          |
                           |     JOIN                                                 |
                           |                                                          |

        USE View instead of CTE as a central logic.

        DataBase                            |         Query        |       Result 
                                            |         Rank         |   Financial Analyst
                                            |                      |
                                            |                      |
                                            |                      |
                                            |                      |
                                            |         Query        |       Result
                                            |         MAX MIN      |   Budget Analyst    
       Orders Table                         |                      |       
                                            |                      |
                             INTERMEDIATE   |                      |
                     VIEW    RESULT         |                      |
    Central Logic <- SUM   ->               |                      |
                     JOIN                   |                      |
                                            |         Query        |       Result
       Customer Table                       |         COMPARE      |   Risk Analyst
                                            |                      |
                                            |                      |
                                            |                      |


                                   Views VS CTE
                Views                                           CTE
     1. Reduce Redundancy in Multiple - queries.          Reduce Redundancy in 1 query.
     2. Improve Reusability in multi - queries.           Improve Reusability in 1 query.
     3. Persisted Logic                                   Temporary logic - on the fly -.
     4. Need to Maintain - CREATE / DROP                  No Maintenance - Auto Cleanup.

*/

/*  
                         SQL Views -> CREATE / UPDATE / DROP

    View Syntax: CREATE VIEW VIEW-NAME AS   -> DDL Command
                 (
                   SELECT ...
                   FROM ...                 -> Query
                   WHERE ...
                 )
*/

-- Task: Find the Running total of sales for each month.
WITH CTE_Monthly_Summary AS (
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)

-- Main Query
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary

-- Suppose we have to do lot of aggregations in the CTE.
WITH CTE_Monthly_Summary AS (
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales,
    COUNT(OrderID) TotalOrders,
    SUM(Quantity) TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)

-- Main Query
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary

-- Use View 
CREATE VIEW V_Monthly_Summary AS 
(
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales,
    COUNT(OrderID) TotalOrders,
    SUM(Quantity) TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)

SELECT * FROM V_MONTHLY_SUMMARY   

-- Do the same task Using View
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM V_Monthly_Summary

-- DROP the View
DROP VIEW V_Monthly_Summary

-- Create View with Schema otherwise by default it would be dbo.View_Name
CREATE VIEW Sales.V_Monthly_Summary AS 
(
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales,
    COUNT(OrderID) TotalOrders,
    SUM(Quantity) TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)

-- After create view suppose if you want to update it. Remove TotalQuantities column.
CREATE VIEW Sales.V_Monthly_Summary AS 
(
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales,
    COUNT(OrderID) TotalOrders
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)
-- This gives error shows already an object named 'V_Monthly_Summary'.

/*
  In Postgress is simple use OR REPLACE like CREATE OR REPLACE VIEW Sales.V_Monthly_Summary AS ().
  
  1. DROP the view and recreate the view.
  2. I want to do everything in one command. So we use T-SQL (Transact SQL) is an extension of SQL that 
     adds programming features.
*/

IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS 
(
    SELECT 
    DATETRUNC(month, OrderDate) OrderMonth,
    SUM(Sales) TotalSales,
    COUNT(OrderID) TotalOrders
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)

-- UseCase 2: View is used to hide complexity.
-- Task: Provide view that combines details from orders, products, customers and employees.
CREATE VIEW Sales.V_Order_Details AS (
    SELECT 
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(c.FirstName, ' ') + ' ' + COALESCE(c.LastName, ' ') CustomerName,
    c.Country CustomerCountry,
    COALESCE(e.FirstName, ' ') + ' ' + COALESCE(e.LastName, ' ') SalesName,
    e.Department,
    o.Sales,
    o.Quantity
    FROM Sales.Orders o
    LEFT JOIN Sales.Products p
    ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees e
    ON e.EmployeeID = o.SalesPersonID
)

SELECT * FROM Sales.V_Order_Details

/*
    UseCase 3: Data Security.
    Use views to enforce security and protect sensitive data, by hiding columns and / or rows from tables.
    
    
                                               ORDERS_MANAGERS (VIEW)
                                                    A  B  C  D
                                                    1  -  -  -         All Data     Manager
                                                    2  -  -  -        <--------> 
                                                    3  -  -  -
                                                        |
                                                        |
                                                      ORDERS         
  ORDERS_ANALYSTS (VIEW)                              A  B  C          ORDERS_STUDENTS (VIEW)     
  A  B  C  D                                          1  -  -              A  B  C               Column - Security      STUDENT
  1  -  -  -       Column     DATA ANALYST  <---      2  -  -    --->      1  -  -             <-------------------->
  2  -  -  -      <-------->                          3  -  -              2  -  -                 Row - Security
  3  -  -  -       Security
                                         
*/

/*  
    Task: 
    - Provide a view for the EU Sales team.
    - that combines details from all tables.
    - And excludes Data related to the USA.
*/

CREATE VIEW Sales.V_Order_Details_EU AS (
    SELECT 
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(c.FirstName, ' ') + ' ' + COALESCE(c.LastName, ' ') CustomerName,
    c.Country CustomerCountry,
    COALESCE(e.FirstName, ' ') + ' ' + COALESCE(e.LastName, ' ') SalesName,
    e.Department,
    o.Sales,
    o.Quantity
    FROM Sales.Orders o
    LEFT JOIN Sales.Products p
    ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees e
    ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA' 
)

SELECT * FROM Sales.V_Order_Details_EU

          