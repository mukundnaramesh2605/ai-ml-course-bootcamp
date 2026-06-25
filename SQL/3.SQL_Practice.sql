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