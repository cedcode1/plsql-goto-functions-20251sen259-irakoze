SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === Shop staff payroll: setup ===
PROMPT Run once in a dedicated student/lab schema. This script does not drop tables.

ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';

CREATE TABLE a3_departments (
    department_id   NUMBER(6) CONSTRAINT a3_dept_pk PRIMARY KEY,
    department_name VARCHAR2(60) CONSTRAINT a3_dept_name_nn NOT NULL,
    CONSTRAINT a3_dept_name_uq UNIQUE (department_name)
);

CREATE TABLE a3_employees (
    employee_id    NUMBER(6) CONSTRAINT a3_emp_pk PRIMARY KEY,
    full_name      VARCHAR2(100) CONSTRAINT a3_emp_name_nn NOT NULL,
    department_id  NUMBER(6) CONSTRAINT a3_emp_dept_nn NOT NULL,
    monthly_salary NUMBER(12,2) CONSTRAINT a3_emp_salary_nn NOT NULL,
    hire_date      DATE CONSTRAINT a3_emp_hire_nn NOT NULL,
    employee_status VARCHAR2(8) DEFAULT 'ACTIVE'
        CONSTRAINT a3_emp_status_nn NOT NULL,
    CONSTRAINT a3_emp_dept_fk FOREIGN KEY (department_id)
        REFERENCES a3_departments (department_id),
    CONSTRAINT a3_emp_salary_ck CHECK (monthly_salary >= 0),
    CONSTRAINT a3_emp_status_ck CHECK (employee_status IN ('ACTIVE', 'INACTIVE'))
);

INSERT INTO a3_departments VALUES (1, 'Sales');
INSERT INTO a3_departments VALUES (2, 'Finance');
INSERT INTO a3_departments VALUES (3, 'Store Operations');

INSERT INTO a3_employees VALUES
    (101, 'Aline Uwase', 1, 150000, DATE '2022-05-03', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (102, 'Eric Habimana', 1, 250000, DATE '2023-09-15', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (103, 'Grace Mukamana', 2, 500000, DATE '2020-01-10', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (104, 'Jean Nkurunziza', 3, 180000, DATE '2024-02-01', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (105, 'Diane Uwamahoro', 2, 750000, DATE '2019-07-20', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (106, 'Patrick Mugisha', 3, 320000, DATE '2025-10-07', 'ACTIVE');

-- These three rows are deliberate business-validation examples.
-- A future hire and an inactive employee can be stored, but not paid now.
-- Zero salary is allowed in the table, but rejected by the payroll validator.
INSERT INTO a3_employees VALUES
    (107, 'Alice Nyiraneza', 1, 200000, DATE '2030-01-01', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (108, 'Samuel Ndizeye', 3, 200000, DATE '2021-11-01', 'INACTIVE');
INSERT INTO a3_employees VALUES
    (109, 'Rose Uwera', 2, 0, DATE '2024-04-12', 'ACTIVE');
INSERT INTO a3_employees VALUES
    (110, 'Paul Niyonzima', 1, 300000, DATE '2026-10-06', 'ACTIVE');

COMMIT;

SELECT department_id, department_name
FROM a3_departments
ORDER BY department_id;

SELECT employee_id, full_name, department_id, monthly_salary,
       TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date, employee_status
FROM a3_employees
ORDER BY employee_id;
