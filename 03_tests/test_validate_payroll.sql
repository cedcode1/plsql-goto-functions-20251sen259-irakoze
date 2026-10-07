SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';

PROMPT === C1 payroll report ===

SELECT employee_id,
       full_name,
       fn_validate_payroll(employee_id, DATE '2026-10-06') AS payroll_status
FROM a3_employees
ORDER BY employee_id;

PROMPT === C1 assertion tests ===

DECLARE
    v_pass_count PLS_INTEGER := 0;

    PROCEDURE assert_status(
        p_test VARCHAR2, p_employee_id NUMBER, p_as_of_date DATE,
        p_expected VARCHAR2
    ) IS
        v_actual VARCHAR2(200);
    BEGIN
        v_actual := fn_validate_payroll(p_employee_id, p_as_of_date);
        IF v_actual IS NULL OR v_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20991,
                'FAIL: ' || p_test || '; expected=' || p_expected ||
                '; actual=' || NVL(v_actual, 'NULL'));
        END IF;
        v_pass_count := v_pass_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_test);
    END;
BEGIN
    assert_status('Employee 101', 101, DATE '2026-10-06', 'VALID');
    assert_status('Employee 102', 102, DATE '2026-10-06', 'VALID');
    assert_status('Employee 103', 103, DATE '2026-10-06', 'VALID');
    assert_status('Employee 104', 104, DATE '2026-10-06', 'VALID');
    assert_status('Employee 105', 105, DATE '2026-10-06', 'VALID');
    assert_status('Employee 106: less than one year',
                  106, DATE '2026-10-06', 'VALID');
    assert_status('Employee 110: hired on reference date',
                  110, DATE '2026-10-06', 'VALID');
    assert_status('Employee 107: future hire date',
                  107, DATE '2026-10-06', 'INVALID: future hire date');
    assert_status('Employee 108: inactive',
                  108, DATE '2026-10-06', 'INVALID: inactive employee');
    assert_status('Employee 109: zero salary',
                  109, DATE '2026-10-06', 'INVALID: salary must be positive');
    assert_status('Missing employee',
                  999, DATE '2026-10-06', 'INVALID: employee not found');
    assert_status('Missing employee ID',
                  NULL, DATE '2026-10-06', 'INVALID: employee ID is required');
    assert_status('Missing reference date',
                  101, NULL, 'INVALID: reference date is required');
    assert_status('Reference date before existing employee hire',
                  101, DATE '2020-01-01', 'INVALID: future hire date');

    DBMS_OUTPUT.PUT_LINE('All ' || v_pass_count || ' payroll tests passed.');
END;
/
