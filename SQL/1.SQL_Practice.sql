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

select avg(salary) from employees;



-- Find the number of employees in each department.
--
-- Display:
-- dept_id
-- employee_count


select dept_id,count(*) as "employee_count" from employees
group by dept_id;

-- Find the average salary in each department.
--
-- Display:
-- dept_id
-- avg_salary

select dept_id,avg(salary) as "avg_salary" from employees
group by dept_id;


-- Find the highest salary in each department.
--
-- Display:
-- dept_id
-- highest_salary

select dept_id,MAX(salary) as "highest_salary" from employees
group by dept_id;

-- Find departments having more than 2 employees.
--
-- Display:
-- dept_id
-- employee_count
select dept_id,count(*) as "employee_count" from employees
group by dept_id
having count(*) >2 ;


-- Find the average age of employees in each department.
--
-- Display:
-- dept_id
-- average_age

select dept_id,round(avg(age),0) as "average_age" from employees
group by dept_id;


-- Find the department with the highest average salary.
--
-- Display:
-- dept_id
-- avg_salary

select dept_id,avg(salary) as "avg_salary" from employees
group by dept_id
order by avg(salary) desc
limit 1;


-- Display employee names along with their department names.
--
-- Output:
-- emp_name
-- dept_name

select e.emp_name, d.dept_name from employees e
inner join departments d on d.dept_id = e.dept_id;