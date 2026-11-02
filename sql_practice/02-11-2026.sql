-- ============================================================
-- Service-company SQL interview practice - QUESTIONS
-- Run service_sql_practice.sql first to create the database.
-- Write your query under each question. Functions/queries RETURN results.
-- ============================================================

USE sql_practice;

-- ------------------------------------------------------------
-- Q1. [join] Basic join
-- List every employee's name, their department name, and location.
-- Include employees who have no department (Kiran). Sort by employee name.
-- ------------------------------------------------------------
select e.emp_name,d.dept_name from employees e 
join departments d on d.dept_id = e.dept_id
order by e.emp_name ASC;


-- ------------------------------------------------------------
-- Q2. [group by] Aggregate with zero-count groups
-- For each department, show department name and the number of employees in it.
-- Departments with zero employees must appear with a count of 0.
-- Sort by count descending.
-- ------------------------------------------------------------
select d.dept_name,COUNT(e.emp_id) as 'emp_count' from departments d
left join employees e on d.dept_id=e.dept_id
group by d.dept_name
order by emp_count desc;


-- ------------------------------------------------------------
-- Q3. [group by / having] Filter on an aggregate
-- Show each department name and its average salary, but only for departments
-- whose average salary is above 70000. Round the average to 2 decimals.
-- ------------------------------------------------------------
select d.dept_name,ROUND(AVG(e.salary),2) as 'avg_salary' from departments d
join employees e on d.dept_id=e.dept_id
group by d.dept_name
having avg_salary > 70000
order by avg_salary desc;


-- ------------------------------------------------------------
-- Q4. [subquery] Compare against a whole-table aggregate
-- Find all employees who earn more than the average salary of the whole company.
-- Return name and salary, highest first.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q5. [subquery / window] Second highest salary
-- Return the second highest DISTINCT salary in the company as a single value.
-- Note the ties: two people at 90000, two at 60000.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q6. [window] Top per group
-- For each department, return the name of the highest-paid employee and their salary.
-- If a department has a tie for highest, return all tied employees.
-- Employees with no department are excluded.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q7. [self join] Employee and manager
-- List each employee's name alongside their manager's name.
-- Employees with no manager (Anita) must still appear, manager shown as NULL.
-- Sort by employee name.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q8. [join / null] Anti-join
-- Find customers who have never placed an order. Return customer name and city.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q9. [window] Running total with a filter
-- For customer 101 (Ravi), list each order date, amount, and a running total of
-- amount ordered over time, counting ONLY Completed orders. Order by date.
-- ------------------------------------------------------------



-- ------------------------------------------------------------
-- Q10. [date / group by] Monthly rollup
-- Count completed orders and total completed revenue per month.
-- Return month as 'YYYY-MM', the order count, and total amount. Sort by month.
-- ------------------------------------------------------------