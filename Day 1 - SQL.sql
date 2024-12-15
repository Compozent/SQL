-- Step 1: Create the 'learn' database
CREATE DATABASE learn;

-- Step 3: Create the 'department' table
CREATE TABLE department (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Step 4: Alter the 'department' table to add a new column
ALTER TABLE department ADD COLUMN head_of_dept VARCHAR(100);

-- Step 5: Update a record in the 'department' table
UPDATE department
SET location = 'New York'
WHERE dept_id = 1;

-- Step 6: Rename the 'department' table to 'dept'
ALTER TABLE department RENAME TO dept;

-- Step 7: Drop a column from the 'dept' table
ALTER TABLE dept DROP COLUMN head_of_dept;

-- Step 8: Add a new record to the 'dept' table
INSERT INTO dept (dept_name, location) VALUES ('HR', 'San Francisco');

-- Step 9: Delete a record from the 'dept' table
DELETE FROM dept WHERE dept_name = 'HR';

-- Step 10: Drop the 'dept' table
DROP TABLE dept;

-- Step 11: Example of a WHERE clause to filter records (before dropping the table)
SELECT * FROM department
WHERE location = 'New York';

-- Step 12: Example of GROUP BY with HAVING
-- Group departments by location and count the number of departments in each location
SELECT location, COUNT(*) AS department_count
FROM department
GROUP BY location
HAVING COUNT(*) > 1;

-- Step 13: Example of LIKE operator to find departments
-- Find all departments with names starting with 'H'
SELECT * FROM department
WHERE dept_name LIKE 'H%';

-- Step 14: Example of ORDER BY clause
-- Retrieve all departments and order them by dept_name alphabetically
SELECT * FROM department
ORDER BY dept_name ASC;

-- Step 15: Example of a subquery
-- Find departments in locations where more than one department exists
SELECT * FROM department
WHERE location IN (
    SELECT location
    FROM department
    GROUP BY location
    HAVING COUNT(*) > 1
);

-- Step 16: Example of DISTINCT
-- Get a list of unique locations from the department table
SELECT DISTINCT location FROM department;

-- Step 17: Example of LIMIT and OFFSET
-- Retrieve the first 5 departments, skipping the first 2
SELECT * FROM department
LIMIT 5 OFFSET 2;

-- Sequence, Index, view and temporary table
-- Step 1: Create a SEQUENCE for unique ID generation
CREATE SEQUENCE seq_employee_id
START 1
INCREMENT 1
MINVALUE 1
CACHE 10;

-- Step 2: Create a table 'employee' that uses the SEQUENCE
CREATE TABLE employee (
    emp_id INT DEFAULT NEXTVAL('seq_employee_id') PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    hire_date DATE
);

-- Step 3: Create an INDEX on the 'dept_id' column for faster lookups
CREATE INDEX idx_employee_dept_id ON employee (dept_id);

-- Step 4: Insert sample data into the 'employee' table
INSERT INTO employee (emp_name, dept_id, hire_date) VALUES
    ('Alice Johnson', 1, '2023-01-10'),
    ('Bob Smith', 2, '2023-02-15'),
    ('Charlie Brown', 1, '2023-03-20');

-- Step 5: Create a TEMPORARY TABLE for session-specific data
CREATE TEMPORARY TABLE temp_bonus (
    emp_id INT,
    bonus_amount DECIMAL(10, 2)
);

-- Step 6: Insert sample data into the TEMPORARY TABLE
INSERT INTO temp_bonus (emp_id, bonus_amount) VALUES
    (1, 500.00),
    (2, 700.00);

-- Step 7: Create a VIEW for employee details along with their department name
CREATE VIEW employee_details AS
SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.hire_date
FROM 
    employee e
JOIN 
    department d ON e.dept_id = d.dept_id;

-- Step 8: Query the VIEW to retrieve data
SELECT * FROM employee_details;

-- Step 9: Drop the VIEW
DROP VIEW employee_details;

-- Step 10: Drop the INDEX
DROP INDEX idx_employee_dept_id;

-- Step 11: Drop the SEQUENCE
DROP SEQUENCE seq_employee_id;

-- All types of join
-- Step 1: Create the 'students' table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100),
    class VARCHAR(50)
);

-- Step 2: Create the 'marks' table
CREATE TABLE marks (
    mark_id SERIAL PRIMARY KEY,
    student_id INT,
    subject VARCHAR(100),
    score INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Step 3: Insert sample data into 'students'
INSERT INTO students (student_name, class) VALUES
    ('Alice', '10th Grade'),
    ('Bob', '10th Grade'),
    ('Charlie', '11th Grade');

-- Step 4: Insert sample data into 'marks'
INSERT INTO marks (student_id, subject, score) VALUES
    (1, 'Math', 85),
    (1, 'Science', 90),
    (2, 'Math', 78),
    (2, 'Science', 88),
    (3, 'Math', 92);

-- Step 5: INNER JOIN to get students with their marks
SELECT 
    s.student_name, 
    m.subject, 
    m.score
FROM 
    students s
INNER JOIN 
    marks m ON s.student_id = m.student_id;

-- Step 6: LEFT JOIN to get all students with their marks (including those without marks)
SELECT 
    s.student_name, 
    m.subject, 
    m.score
FROM 
    students s
LEFT JOIN 
    marks m ON s.student_id = m.student_id;

-- Step 7: RIGHT JOIN to get all marks with their corresponding students (if any)
SELECT 
    s.student_name, 
    m.subject, 
    m.score
FROM 
    students s
RIGHT JOIN 
    marks m ON s.student_id = m.student_id;

-- Step 8: FULL OUTER JOIN to get all students and marks, including unmatched rows
SELECT 
    s.student_name, 
    m.subject, 
    m.score
FROM 
    students s
FULL OUTER JOIN 
    marks m ON s.student_id = m.student_id;

-- Step 9: CROSS JOIN to get all combinations of students and subjects
SELECT 
    s.student_name, 
    m.subject
FROM 
    students s
CROSS JOIN 
    marks m;

-- Step 10: SELF JOIN example (students in the same class)
SELECT 
    s1.student_name AS student1, 
    s2.student_name AS student2, 
    s1.class
FROM 
    students s1
JOIN 
    students s2 ON s1.class = s2.class
WHERE 
    s1.student_id != s2.student_id;
