-- CREATE, ALTER, DROP
/* Create a new table called persons with columns: id, person_name, birth_date and phone */

CREATE TABLE persons (
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL
	CONSTRAINT pk_persons PRIMARY KEY(id)
)

/* ALTER used to change and edits in the definition. The new columns are appended at the 
   end of table by default */ 
-- Task: Add a new column called email to the persons table.
ALTER TABLE persons 
ADD email VARCHAR(50) NOT NULL

/* Task: Remove the column phone from the persons table */ 
ALTER TABLE persons 
DROP COLUMN phone 

/* DROP => DRop table and database */
DROP TABLE persons 

SELECT *
FROM persons
