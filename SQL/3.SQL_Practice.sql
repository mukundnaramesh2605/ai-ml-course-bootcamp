-- =====================================================
-- QUESTION 1
-- Difficulty: ⭐
--
-- Display the employee_name and salary
-- of all employees.
--
-- Expected Columns:
-- employee_name | salary
-- =====================================================

SELECT employee_name,SALARY from  employees;

-- =====================================================
-- QUESTION 2
-- Difficulty: ⭐
--
-- Display all columns for employees
-- who belong to the IT department.
-- =====================================================


select * from employees where department = "IT";	


-- =====================================================
-- QUESTION 3
-- Difficulty: ⭐
--
-- Display the employee_name, department,
-- and salary of employees whose salary
-- is greater than 75000.
--
-- Expected Columns:
-- employee_name | department | salary
-- =====================================================

select employee_name,department,salary from employees where salary> 75000;


-- =====================================================
-- QUESTION 4
-- Difficulty: ⭐
--
-- Display the employee_name and city
-- of employees who live in Chennai.
--
-- Expected Columns:
-- employee_name | city
-- =====================================================
SELECT employee_name,city from employees where city='Chennai';


