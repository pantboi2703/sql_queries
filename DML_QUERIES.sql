-- Insert, Update, Delete

-- Insert single row or also multiple row. 
-- Order of column arguments matching with the insert values.

INSERT INTO customers (id, first_name, country, score) 
VALUES 
	(6, 'Mayank', 'India', NULL),
	(7, 'Sam', NULL, 100);

/* Move data from one table (source table) to another table (target table) */
-- Task:- Copy data from 'customers' table into 'persons' table
INSERT INTO persons(id, person_name, birth_date, phone)
SELECT 
	id,
	first_name,
	NULL AS birth_date,
	'Unknown' AS phone
FROM customers 

/* Update */
/* Task:- Change the score of customer 6 to 0. */
UPDATE customers
SET score = 0
WHERE id = 6

/* Task:- Change the score of customer with ID 4 to 0 and update the country to UK */
UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id = 4 

/* Update all customers with a NULL score by setting their score to 0. */
UPDATE customers 
SET score = 0
WHERE score IS NULL

/* Delete row */
-- Task:- Delete all customers with an ID greater than 5.
DELETE FROM customers
WHERE id > 5

SELECT * FROM persons

SELECT * 
FROM customers

/* Delete all the data from the table use truncate little bit faster */
TRUNCATE TABLE persons

UPDATE customers
SET score = 500,
    country = 'Germany'
WHERE id = 4