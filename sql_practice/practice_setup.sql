-- ============================================================
-- SQL PRACTICE DATABASE  (SQLite 3)
-- ============================================================
-- How to load:
--   sqlite3 practice.db < practice_setup.sql
-- Then open it with:
--   sqlite3 practice.db
-- Or in Python:
--   import sqlite3
--   con = sqlite3.connect("practice.db")
--   con.executescript(open("practice_setup.sql").read())
--
-- Schema overview (a small company):
--   departments (dept_id, dept_name, location)
--   employees   (emp_id, name, dept_id, salary, hire_date, manager_id)
--   projects    (project_id, project_name, dept_id, budget)
--   assignments (emp_id, project_id, hours)   -- who works on what
--   sales       (sale_id, emp_id, amount, sale_date)
-- ============================================================

-- Start clean so the file can be re-run safely
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- NOTE: foreign_keys is deliberately left OFF. Nisha (emp_id 13) sits in
-- dept_id 6, which does not exist in departments, on purpose, so that a
-- LEFT JOIN and an INNER JOIN give different results. The FOREIGN KEY lines
-- below document the intended relationships for readability; they are not
-- enforced, so this orphan row is allowed.

-- ------------------------------------------------------------
-- DEPARTMENTS
-- ------------------------------------------------------------
CREATE TABLE departments (
    dept_id    INTEGER PRIMARY KEY,
    dept_name  TEXT NOT NULL,
    location   TEXT
);

INSERT INTO departments (dept_id, dept_name, location) VALUES
    (1, 'Engineering', 'Chennai'),
    (2, 'Sales',       'Mumbai'),
    (3, 'HR',          'Chennai'),
    (4, 'Finance',     'Delhi'),
    (5, 'Marketing',   'Bangalore');

-- ------------------------------------------------------------
-- EMPLOYEES
-- manager_id references another emp_id (NULL = no manager / top boss)
-- One employee (Nisha) is in dept 6, which does NOT exist in departments,
-- on purpose, so LEFT JOIN vs INNER JOIN behave differently.
-- ------------------------------------------------------------
CREATE TABLE employees (
    emp_id      INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    dept_id     INTEGER,
    salary      INTEGER,
    hire_date   TEXT,          -- ISO format 'YYYY-MM-DD'
    manager_id  INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO employees (emp_id, name, dept_id, salary, hire_date, manager_id) VALUES
    (1,  'Arjun',   1, 95000, '2019-03-15', NULL),   -- Eng head, no manager
    (2,  'Priya',   1, 72000, '2020-07-01', 1),
    (3,  'Karan',   1, 68000, '2021-01-20', 1),
    (4,  'Divya',   1, 81000, '2020-11-11', 1),
    (5,  'Rohit',   2, 60000, '2021-05-30', 6),
    (6,  'Sneha',   2, 88000, '2018-09-10', NULL),   -- Sales head
    (7,  'Vikram',  2, 55000, '2022-02-14', 6),
    (8,  'Anita',   3, 50000, '2021-08-19', NULL),   -- HR head
    (9,  'Manoj',   3, 47000, '2022-06-25', 8),
    (10, 'Kavya',   4, 76000, '2019-12-01', NULL),   -- Finance head
    (11, 'Suresh',  4, 64000, '2021-03-08', 10),
    (12, 'Deepa',   5, 59000, '2022-09-15', NULL),   -- Marketing head
    (13, 'Nisha',   6, 52000, '2023-01-10', NULL),   -- dept 6 does not exist
    (14, 'Ramesh',  1, 70000, '2023-04-22', 1),
    (15, 'Lakshmi', 2, 62000, '2023-07-05', 6);

-- ------------------------------------------------------------
-- PROJECTS
-- ------------------------------------------------------------
CREATE TABLE projects (
    project_id    INTEGER PRIMARY KEY,
    project_name  TEXT NOT NULL,
    dept_id       INTEGER,
    budget        INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
    (101, 'Payment Gateway',   1, 500000),
    (102, 'Mobile App',        1, 350000),
    (103, 'Q4 Campaign',       5, 200000),
    (104, 'CRM Rollout',       2, 280000),
    (105, 'Audit System',      4, 150000),
    (106, 'Internal Portal',   1, 120000);   -- no one assigned yet

-- ------------------------------------------------------------
-- ASSIGNMENTS  (many-to-many: employees <-> projects)
-- ------------------------------------------------------------
CREATE TABLE assignments (
    emp_id      INTEGER,
    project_id  INTEGER,
    hours       INTEGER,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO assignments (emp_id, project_id, hours) VALUES
    (1, 101, 120),
    (2, 101, 200),
    (3, 101, 160),
    (2, 102, 90),
    (4, 102, 210),
    (14, 102, 150),
    (12, 103, 180),
    (5, 104, 140),
    (7, 104, 130),
    (15, 104, 100),
    (10, 105, 170),
    (11, 105, 110);

-- ------------------------------------------------------------
-- SALES  (for window functions and date grouping)
-- Only Sales-dept employees make sales here.
-- ------------------------------------------------------------
CREATE TABLE sales (
    sale_id    INTEGER PRIMARY KEY,
    emp_id     INTEGER,
    amount     INTEGER,
    sale_date  TEXT,           -- 'YYYY-MM-DD'
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO sales (sale_id, emp_id, amount, sale_date) VALUES
    (1,  5, 12000, '2024-01-05'),
    (2,  6, 25000, '2024-01-12'),
    (3,  7,  8000, '2024-01-20'),
    (4,  5, 15000, '2024-02-03'),
    (5,  6, 30000, '2024-02-15'),
    (6,  7, 11000, '2024-02-28'),
    (7,  5, 18000, '2024-03-10'),
    (8,  6, 22000, '2024-03-18'),
    (9, 15,  9000, '2024-03-25'),
    (10, 7, 14000, '2024-04-02'),
    (11, 5, 20000, '2024-04-14'),
    (12, 15, 16000, '2024-04-27');

-- ------------------------------------------------------------
-- Quick sanity checks (optional; comment out if not wanted)
-- ------------------------------------------------------------
-- SELECT COUNT(*) AS n_employees FROM employees;
-- SELECT COUNT(*) AS n_sales FROM sales;
