select * from employees;

select department,emp_name,salary, ROW_NUMBER() OVER(partition by department order by salary desc) as 'row_num'
from employees;

select department,emp_name,salary, RANK() OVER(partition by department order by salary desc) as 'rank'
from employees;


select department,emp_name,salary, DENSE_RANK() OVER(partition by department order by salary desc) as 'rank'
from employees;

SELECT
    department,
    emp_name,
    salary
FROM (
    SELECT
        department,
        emp_name,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
) t
WHERE salary_rank = 2;