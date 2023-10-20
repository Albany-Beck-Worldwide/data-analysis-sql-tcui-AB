/* Setup & Import scripts
DROP DATABASE IF EXISTS employees; 
CREATE DATABASE IF NOT EXISTS employees; 
USE employees; 
SELECT 'CREATING DATABASE STRUCTURE' as 'INFO'; 
DROP TABLE IF EXISTS dept_emp, 
dept_manager, 
titles, 
salaries, 
employees, 
departments; 


CREATE TABLE employees ( 
emp_no INT NOT NULL, 
birth_date DATE NOT NULL, 
first_name VARCHAR(14) NOT NULL, 
last_name VARCHAR(16) NOT NULL, 
gender ENUM ('M','F') NOT NULL, 
hire_date DATE NOT NULL, 
PRIMARY KEY (emp_no) 
); 
CREATE TABLE departments ( 
dept_no CHAR(4) NOT NULL, 
dept_name VARCHAR(40) NOT NULL, 
PRIMARY KEY (dept_no), 
UNIQUE KEY (dept_name) 
);
CREATE TABLE dept_manager ( 
emp_no INT NOT NULL, 
dept_no CHAR(4) NOT NULL, 
from_date DATE NOT NULL,
to_date DATE NOT NULL, 
FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE, 
FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE, 
PRIMARY KEY (emp_no,dept_no) 
); 
CREATE TABLE dept_emp ( 
emp_no INT NOT NULL, 
dept_no CHAR(4) NOT NULL, 
from_date DATE NOT NULL, 
to_date DATE NOT NULL, 
FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE, 
FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
PRIMARY KEY (emp_no,dept_no) 
); 
CREATE TABLE titles ( 
emp_no INT NOT NULL, 
title VARCHAR(50) NOT NULL, 
from_date DATE NOT NULL, 
to_date DATE, 
FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE, 
PRIMARY KEY (emp_no,title, from_date) 
); 
CREATE TABLE salaries ( 
emp_no INT NOT NULL, 
salary INT NOT NULL, 
from_date DATE NOT NULL, 
to_date DATE NOT NULL, 
FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE, 
PRIMARY KEY (emp_no, from_date) 
);


INSERT INTO `departments` VALUES ('d001','Marketing'), 
('d002','Finance'), 
('d003','Human Resources'), 
('d004','Production'),('d005','Development'), 
('d006','Quality Management'),('d007','Sales'), 
('d008','Research'),('d009','Customer Service'); 
INSERT INTO `employees` VALUES (10001,'1953-09-02','Georgi','Facello','M','1986-06-26'), 
(10002,'1964-06-02','Bezalel','Simmel','F','1985-11-21'), 
(10003,'1959-12-03','Parto','Bamford','M','1986-08-28'), 
(10004,'1954-05-01','Chirstian','Koblick','M','1986-12-01'), 
(10005,'1955-01-21','Kyoichi','Maliniak','M','1989-09-12'), 
(10006,'1953-04-20','Anneke','Preusig','F','1989-06-02'), 
(10007,'1957-05-23','Tzvetan','Zielinski','F','1989-02-10'), 
(10008,'1958-02-19','Saniya','Kalloufi','M','1994-09-15'), 
(10009,'1952-04-19','Sumant','Peac','F','1985-02-18'), 
(10010,'1963-06-01','Duangkaew','Piveteau','F','1989-08-24'),
(10011,'1953-11-07','Mary','Sluis','F','1990-01-22'), 
(10012,'1960-10-04','Patricio','Bridgland','M','1992-12-18'), 
(10013,'1963-06-07','Eberhardt','Terkki','M','1985-10-20'), 
(10014,'1956-02-12','Berni','Genin','M','1987-03-11'); 
INSERT INTO `dept_emp` VALUES (10001,'d005','1986-06-26','9999-01-01'), 
(10002,'d007','1996-08-03','9999-01-01'), 
(10003,'d004','1995-12-03','9999-01-01'), 
(10004,'d004','1986-12-01','9999-01-01'), 
(10005,'d003','1989-09-12','9999-01-01'),
(10006,'d005','1990-08-05','9999-01-01'), 
(10014,'d005','1993-12-29','9999-01-01');
INSERT INTO `dept_manager` VALUES (10013,'d001','1985-01-01','1991-10-01'), 
(10001,'d001','1991-10-01','9999-01-01'), 
(10002,'d002','1985-01-01','1989-12-17'), 
(10008,'d002','1989-12-17','9999-01-01'), 
(10012,'d003','1985-01-01','1992-03-21'), 
(10011,'d003','1992-03-21','9999-01-01'), 
(10014,'d004','1985-01-01','1988-09-09'), 
(10003,'d004','1988-09-09','1992-08-02'); 
INSERT INTO `salaries` VALUES (10001,60117,'1986-06-26','1987-06-26'), 
(10001,62102,'1987-06-26','1988-06-25'), 
(10002,66074,'1988-06-25','1989-06-25'), 
(10003,66596,'1989-06-25','1990-06-25'),
(10004,66961,'1990-06-25','1991-06-25'), 
(10005,71046,'1991-06-25','1992-06-24'), 
(10006,74333,'1992-06-24','1993-06-24'), 
(10007,75286,'1993-06-24','1994-06-24'), 
(10008,75994,'1994-06-24','1995-06-24'); 
INSERT INTO `titles` VALUES (10001,'Senior Engineer','1986-06-26','9999-01-01'), 
(10002,'Staff','1996-08-03','9999-01-01'), 
(10003,'Senior Engineer','1995-12-03','9999-01-01'), 
(10004,'Engineer','1986-12-01','1995-12-01'), 
(10004,'Senior Engineer','1995-12-01','9999-01-01'), 
(10005,'Senior Staff','1996-09-12','9999-01-01'), 
(10005,'Staff','1989-09-12','1996-09-12'), 
(10006,'Senior Engineer','1990-08-05','9999-01-01'), 
(10007,'Senior Staff','1996-02-11','9999-01-01'), 
(10007,'Staff','1989-02-10','1996-02-11'), 
(10008,'Assistant Engineer','1998-03-11','2000-07-31');
*/



/*-------------------------------------------------------------------------------------------------------------------------------*/
-- Prep (Run this before anything else to set up temp tables)
-- Every employee with dept_emp information 
-- Every employee with dept_manager information 
-- UNION JOIN TO STACK THE TWO TEMP TABLES ON TOP OF EACH OTHER
CREATE OR REPLACE TEMPORARY TABLE e_dept_emp (
    SELECT e.emp_no AS 'e_emp_no', 
    de.emp_no AS 'dedm_emp_no', 
    de.dept_no AS 'dedm_dept_no', 
    de.from_date AS 'dedm_from_date', 
    de.to_date AS 'dedm_to_date'
    FROM employees e
    LEFT JOIN dept_emp de ON e.emp_no = de.emp_no
);

CREATE OR REPLACE TEMPORARY TABLE e_dept_manager (
    SELECT e.emp_no AS 'e_emp_no', 
    dm.emp_no AS 'dedm_emp_no', 
    dm.dept_no AS 'dedm_dept_no', 
    dm.from_date AS 'dedm_from_date', 
    dm.to_date AS 'dedm_to_date'
    FROM employees e
    LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
);

CREATE OR REPLACE TEMPORARY TABLE e_de_dm (
    SELECT * FROM e_dept_emp
    UNION ALL 
    SELECT * FROM e_dept_manager
    ORDER BY e_emp_no
);

SELECT * FROM e_de_dm;


/* 1. Create a SQL statement to list all managers and their titles. */
SELECT e.emp_no AS 'Employee Number', 
CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name, 
GROUP_CONCAT(DISTINCT t.title) AS All_Titles
FROM employees e 
INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
LEFT JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no;

/* WHERE YEAR(dm.to_date) = 9999; */


/* 2. Create a SQL statement to show the salary of all employees and their department 
name. */

SELECT CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name,
GROUP_CONCAT(DISTINCT s.salary) AS Salary,
GROUP_CONCAT(DISTINCT d.dept_name) AS Department_Name
FROM employees e
INNER JOIN e_de_dm ON e.emp_no = e_de_dm.e_emp_no
LEFT JOIN departments d ON d.dept_no = e_de_dm.dedm_dept_no
LEFT JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

/* WHERE YEAR(dedm_to_date) = 9999; */ 

/* 3. Create a SQL statement to show the hire date and birth date who belongs to HR 
department. */

SELECT CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name, 
e.hire_date AS Hire_Date, 
e.birth_date AS Birth_Date, 
d.dept_name AS Department_Name,
e_de_dm.dedm_to_date AS Contract_End
FROM employees e 
INNER JOIN e_de_dm ON e.emp_no = e_de_dm.e_emp_no
LEFT JOIN departments d ON d.dept_no = e_de_dm.dedm_dept_no
WHERE dept_name = 'Human Resources';

/* AND YEAR(dedm_to_date) = 9999; */


/* 4. Create a SQL statement to show all departments and their department’s managers. */

SELECT d.dept_name AS Department_Name,
CONCAT_WS(' ', e.first_name, e.last_name) AS Department_Managers_Full_Name
FROM employees e
INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
RIGHT JOIN departments d ON dm.dept_no = d.dept_no;

/* WHERE YEAR(to_date) = 9999; */


/* 5. Create a SQL statement to show a list of HR’s employees who were hired after 1986. */

CREATE OR REPLACE TEMPORARY TABLE HR_emp (
    SELECT CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name, 
    e.hire_date AS Hire_Date, 
    e.birth_date AS Birth_Date, 
    d.dept_name AS Department_Name,
    e_de_dm.dedm_to_date AS Contract_End
    FROM employees e 
    INNER JOIN e_de_dm ON e.emp_no = e_de_dm.e_emp_no
    LEFT JOIN departments d ON d.dept_no = e_de_dm.dedm_dept_no
    WHERE 
    dept_name = 'Human Resources'
);

SELECT Full_Name, 
Hire_Date
FROM HR_emp;

/* WHERE YEAR(Hire_Date) > 1986; */ 


/* 6. Create a SQL statement to increase any employee’s salary up to 2%. Assume the 
employee has just phoned in with his/her last name. */

CREATE OR REPLACE TEMPORARY TABLE inc_by_2 (
    SELECT e.last_name AS LastName, MAX(s.salary) AS salary, e.emp_no
    FROM salaries s
    RIGHT JOIN employees e ON s.emp_no = e.emp_no
    GROUP BY last_name
);

DELIMITER $$
CREATE OR REPLACE PROCEDURE f_inc2(
    IN percent INT, 
    IN inputName VARCHAR(16)
    )
BEGIN
    UPDATE inc_by_2
    SET salary = (salary + (salary*percent)/100)
    WHERE LastName = inputName AND
    percent <= 2;
END $$
DELIMITER;
/* Increase Bamford's salary by 2% */
CALL f_inc2(2,'Bamford');

SELECT * FROM inc_by_2;


/* 7. Create a SQL statement to delete employee’s record who belongs to marketing 
department and name start with A. */

CREATE OR REPLACE TEMPORARY TABLE del_mark_A (
    SELECT e.*,
    d.dept_name AS Department_Name,
    e_de_dm.dedm_to_date AS Contract_End
    FROM employees e
    INNER JOIN e_de_dm ON e_de_dm.e_emp_no = e.emp_no
    INNER JOIN departments d ON e_de_dm.dedm_dept_no = d.dept_no
    
);
/* WHERE YEAR(dedm_to_date) = 9999 */ 
SELECT * FROM del_mark_A;

DELETE FROM del_mark_A
WHERE Department_Name = 'Marketing' AND
first_name LIKE 'A%'; 


/* 8. Create a database view to list the full names of all departments’ managers, and their 
salaries. */
/* NOT WORKING
WITH q8_cte AS (
    SELECT e.emp_no AS 'e_emp_no', 
    de.emp_no AS 'dedm_emp_no', 
    de.dept_no AS 'dedm_dept_no', 
    de.from_date AS 'dedm_from_date', 
    de.to_date AS 'dedm_to_date'
    FROM employees e
    LEFT JOIN dept_emp de ON e.emp_no = de.emp_no

    UNION ALL

    SELECT e.emp_no AS 'e_emp_no', 
    dm.emp_no AS 'dedm_emp_no', 
    dm.dept_no AS 'dedm_dept_no', 
    dm.from_date AS 'dedm_from_date', 
    dm.to_date AS 'dedm_to_date'
    FROM employees e
    LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
)
CREATE OR REPLACE VIEW dept_mng_sal AS (
    SELECT d.dept_name AS Department_Name,
    CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name,
    MAX(s.salary) AS Salary
    FROM employees e
    INNER JOIN q8_cte ON q8_cte.e_emp_no = e.emp_no
    INNER JOIN departments d ON dm.dept_no = d.dept_no
    LEFT JOIN salaries s ON e.emp_no = s.emp_no
    GROUP BY e.emp_no
);
*/

CREATE OR REPLACE VIEW q8_mng AS (
    SELECT GROUP_CONCAT(d.dept_name) AS Department_Name,
    CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name, 
    GROUP_CONCAT(DISTINCT s.salary) AS Salary

    FROM employees e

    INNER JOIN (            
        SELECT e.emp_no AS 'e_emp_no', 
        dm.emp_no AS 'dedm_emp_no', 
        dm.dept_no AS 'dedm_dept_no', 
        dm.from_date AS 'dedm_from_date', 
        dm.to_date AS 'dedm_to_date'
        FROM employees e
        INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
    ) e_de_dm ON e.emp_no = e_de_dm.e_emp_no
    LEFT JOIN salaries s ON e.emp_no = s.emp_no
    LEFT JOIN departments d ON e_de_dm.dedm_dept_no = d.dept_no
    GROUP BY e.emp_no
    );

SELECT * FROM q8_mng;


/* 9. Create a database view to list all departments and their department’s managers, who 
were hired between 1980 and 1990. */

CREATE OR REPLACE VIEW dept_mng_80_90 AS (
    SELECT d.dept_name AS Department_Name,
    CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name,
    MAX(s.salary) AS Salary,
    e.hire_date AS Hire_Date
    FROM employees e
    INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
    INNER JOIN departments d ON dm.dept_no = d.dept_no
    LEFT JOIN salaries s ON e.emp_no = s.emp_no
    WHERE YEAR(e.hire_date) >= 1980 AND YEAR(e.hire_date) <= 1990 
    GROUP BY e.emp_no
);


/* 10. Create a SQL statement to increase salaries of all department’s managers up to 10% 
who are working since 1990. */

CREATE OR REPLACE TEMPORARY TABLE inc_mng_by_10 (
    SELECT d.dept_name AS Department_Name,
    CONCAT_WS(' ', e.first_name, e.last_name) AS Full_Name,
    MAX(s.salary) AS Salary,
    e.hire_date AS Hire_Date
    FROM employees e
    INNER JOIN dept_manager dm ON e.emp_no = dm.emp_no
    INNER JOIN departments d ON dm.dept_no = d.dept_no
    LEFT JOIN salaries s ON e.emp_no = s.emp_no
    WHERE YEAR(e.hire_date) >= 1990
    GROUP BY e.emp_no
);   

SELECT * FROM inc_mng_by_10;

DELIMITER $$
CREATE OR REPLACE PROCEDURE f_inc10(
    IN percent INT 
    )
BEGIN
    UPDATE inc_mng_by_10
    SET salary = (salary + (salary*percent)/100)
    WHERE percent <= 10;
END $$
DELIMITER;

CALL f_inc10(10);

/*-------------------------------------------------------------------------------------------------------------------------------*/
