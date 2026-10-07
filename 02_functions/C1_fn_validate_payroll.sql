CREATE OR REPLACE FUNCTION fn_validate_payroll (
    p_employee_id IN NUMBER,
    p_as_of_date IN DATE DEFAULT SYSDATE
) RETURN VARCHAR2
IS
    v_salary a3_employees.monthly_salary%TYPE;
    v_hire_date a3_employees.hire_date%TYPE;
    v_status a3_employees.employee_status%TYPE;
    v_annual_salary NUMBER;
    v_monthly_tax NUMBER;
    v_years NUMBER;
    v_reason VARCHAR2(100);
BEGIN
    IF p_employee_id IS NULL THEN
        v_reason := 'employee ID is required';
        GOTO invalid_payroll;
    END IF;

    IF p_as_of_date IS NULL THEN
        v_reason := 'reference date is required';
        GOTO invalid_payroll;
    END IF;

    SELECT monthly_salary, hire_date, employee_status
    INTO v_salary, v_hire_date, v_status
    FROM a3_employees
    WHERE employee_id = p_employee_id;

    IF v_status <> 'ACTIVE' THEN
        v_reason := 'inactive employee';
        GOTO invalid_payroll;
    END IF;

    IF v_salary IS NULL OR v_salary <= 0 THEN
        v_reason := 'salary must be positive';
        GOTO invalid_payroll;
    END IF;

    IF TRUNC(v_hire_date) > TRUNC(p_as_of_date) THEN
        v_reason := 'future hire date';
        GOTO invalid_payroll;
    END IF;

    -- Reuse existing functions rather than writing their calculations again.
    v_annual_salary := fn_annual_salary(v_salary);
    v_monthly_tax := fn_calculate_tax(v_salary);
    v_years := fn_years_of_service(v_hire_date, p_as_of_date);

    IF v_annual_salary <= 0 OR v_monthly_tax > v_salary OR v_years < 0 THEN
        v_reason := 'inconsistent payroll calculation';
        GOTO invalid_payroll;
    END IF;

    RETURN 'VALID';

    <<invalid_payroll>>
    RETURN 'INVALID: ' || v_reason;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'INVALID: employee not found';
END fn_validate_payroll;
/
SHOW ERRORS FUNCTION fn_validate_payroll
