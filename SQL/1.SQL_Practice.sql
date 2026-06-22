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