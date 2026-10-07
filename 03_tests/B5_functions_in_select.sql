SELECT employee_id,
       full_name,
       fn_dept_name(department_id) AS department_name,
       employee_status,
       monthly_salary,
       fn_annual_salary(monthly_salary) AS annual_salary,
       fn_years_of_service(
           hire_date,
           DATE '2026-10-06'
       ) AS years_of_service,
       fn_calculate_tax(monthly_salary) AS monthly_tax,
       monthly_salary - fn_calculate_tax(monthly_salary)
           AS net_monthly_salary
FROM a3_employees
ORDER BY employee_id;