-- Find all employees whose salary is greater than 60000.
-- Display:
-- emp_name
-- salary
--
-- Sort by salary in descending order.

select emp_name,salary from employees where salary > 60000
order by salary desc;


-- Find all female employees whose salary is greater than 55000.
--
-- Display:
-- emp_name
-- gender
-- salary
--
-- Sort by salary descending.

select emp_name,gender,salary from employees where salary > 55000 and gender = 'Female'
order by salary desc; 


-- Find all unique department IDs present in the employees table.
--
-- Display:
-- dept_id

select DISTINCT dept_id from employees;


-- Find the top 3 highest-paid employees.
--
-- Display:
-- emp_name
-- salary

select emp_name, salary from employees order by salary desc
limit 3;


-- Find employees whose salary is between 55000 and 70000.
--
-- Display:
-- emp_name
-- salary

select emp_name, salary from employees where salary between 55000 and  70000;


-- Find employees who belong to department 1 or department 3.
--
-- Display:
-- emp_name
-- dept_id


select emp_name,dept_id from employees where dept_id in (1,3);


-- Find employees whose names start with the letter 'A'.
--
-- Display:
-- emp_name

select emp_name from employees where emp_name like 'A%';


-- Find employees who joined after January 1st, 2023.
--
-- Display:
-- emp_name
-- joining_date


select emp_name from employees where joining_date > '2023-01-01';


-- Find the total number of employees.
--
-- Display:
-- total_employees
select count(*) as "total_employees" from employees;


-- Find the average salary of all employees.
--
-- Display:
-- average_salary