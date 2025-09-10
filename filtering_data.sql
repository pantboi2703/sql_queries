-- WHERE Operators
/* 
   1. Comparison Operators: =, <> or !=, >, >=, <, <= 
   2. Logical Operators: AND, OR, NOT
   3. Range Operator: Between
   4. Membership Operator: IN, NOT IN
   5. Search: LIKE
*/

-- Comparison Operator: Compare two things 
/* Task: Retrieve all customers from Germany. */
SELECT * 
FROM customers
WHERE country = 'Germany'

/* Task: Retrieve all customers who are not from Germany */
SELECT * 
FROM customers
WHERE country <> 'Germany'

/* Task: Retrieve all customers with a score greater than 500 */
SELECT * 
FROM customers
WHERE score > 500

/* Task: Retrieve all customers with a score 500 or more */
SELECT * 
FROM customers
WHERE score >= 500

/* Task: Retrieve all customers with a score less than 500 */
SELECT * 
FROM customers
WHERE score < 500

/* Task: Retrieve all customers with a score of 500 or less */
SELECT * 
FROM customers
WHERE score <= 500

-- Logical Operators
/* 
   AND: All conditions must be true
   OR: At least must condition must be true
   NOT: Reverse operator. Excludes matching values.
*/

/* Task: Retrieve all customers who are from USA AND have a score greater than 500 */
SELECT * 
FROM customers
WHERE country = 'USA' AND score > 500

/* Task: Retrieve all customers who are either from USA or have a score greater than 500.*/
SELECT * 
FROM customers
WHERE country = 'USA' OR score > 500

/* Task: Retrieve all customers with a score not less than 500 */
SELECT * 
FROM customers
WHERE NOT(score < 500)

-- Range Operator
/* 
  BETWEEN: Checks if a value is within a range. Have lower boundary and upper boundary and the 
  boundary are inclusive.
/*

-- Task: Retrieve all customers whose score falls in the range between 100 and 500 

SELECT * 
FROM customers
WHERE score BETWEEN 100 AND 500 

-- Membership Operator:
/* 
  1. IN: Check if a value exist in a list.
  2. NOT IN: Check if a value not exist in a list.
*/ 

/* Task: Retrieve all customers from either Germany or USA. Also solve using OR */
SELECT *
FROM CUSTOMERS
WHERE country IN ('Germany', 'USA')

-- Search Operator: 
/* 
  1. LIKE: Search for a pattern in a text.
  pattern matching (% means anything 0, 1, many) or _(exact 1)
  M% => first character is M and after that anything. Example: Martin, Maria.
  %in => last two character is 'in' and before that anything. Example: Martin.
  %r% => 'r' is somewhere before r anything like empty also fine and vice versa. Example: Martin,
  Maria, Peter,  
*/ 

/* Task: Find all customers whose First name starts with 'M' */
SELECT *
FROM CUSTOMERS
WHERE first_name LIKE 'M%'

/* Task: Find all customers whose first name ends with 'n' */
SELECT *
FROM customers 
WHERE first_name LIKE '%n'

/* Task: Find all customers whose first name contains 'r' */
SELECT *
FROM customers 
WHERE first_name LIKE '%r%'

/* Task: Find all customers whose first name hass 'r' in the 3rd position */
SELECT *
FROM customers 
WHERE first_name LIKE '__r%'

