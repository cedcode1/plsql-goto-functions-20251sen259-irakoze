SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === A2: Salary review using GOTO ===

DECLARE
    PROCEDURE review_salary(p_employee_id NUMBER) IS
        v_name   a3_employees.full_name%TYPE;
        v_salary a3_employees.monthly_salary%TYPE;
        v_review VARCHAR2(30);
    BEGIN
        SELECT full_name, monthly_salary
        INTO v_name, v_salary
        FROM a3_employees
        WHERE employee_id = p_employee_id;

        IF v_salary IS NULL OR v_salary <= 0 THEN
            GOTO invalid_salary;
        ELSIF v_salary < 200000 THEN
            GOTO low_salary;
        ELSIF v_salary <= 500000 THEN
            GOTO standard_salary;
        ELSE
            GOTO high_salary;
        END IF;

        <<low_salary>>
        v_review := 'LOW SALARY';
        GOTO display_result;

        <<standard_salary>>
        v_review := 'STANDARD SALARY';
        GOTO display_result;

        <<high_salary>>
        v_review := 'HIGH SALARY';
        GOTO display_result;

        <<invalid_salary>>
        v_review := 'INVALID SALARY';

        <<display_result>>
        DBMS_OUTPUT.PUT_LINE(p_employee_id || ' | ' || v_name ||
            ' | salary=' || v_salary || ' | ' || v_review);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(p_employee_id || ': EMPLOYEE NOT FOUND');
    END;
BEGIN
    FOR employee_row IN (
        SELECT employee_id FROM a3_employees ORDER BY employee_id
    ) LOOP
        review_salary(employee_row.employee_id);
    END LOOP;
    review_salary(999);
END;
/
