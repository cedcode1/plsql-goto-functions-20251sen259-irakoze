SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';

PROMPT === B1-B4 assertion tests ===

DECLARE
    v_pass_count PLS_INTEGER := 0;

    PROCEDURE assert_number(
        p_test VARCHAR2, p_actual NUMBER, p_expected NUMBER
    ) IS
    BEGIN
        IF p_actual IS NULL OR ABS(p_actual - p_expected) > 0.000001 THEN
            RAISE_APPLICATION_ERROR(-20990,
                'FAIL: ' || p_test || '; expected=' || p_expected ||
                '; actual=' || NVL(TO_CHAR(p_actual), 'NULL'));
        END IF;
        v_pass_count := v_pass_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_test);
    END;

    PROCEDURE assert_text(
        p_test VARCHAR2, p_actual VARCHAR2, p_expected VARCHAR2
    ) IS
    BEGIN
        IF p_actual IS NULL OR p_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20990,
                'FAIL: ' || p_test || '; expected=' || p_expected ||
                '; actual=' || NVL(p_actual, 'NULL'));
        END IF;
        v_pass_count := v_pass_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_test);
    END;

    -- Both salary functions must raise exactly the documented error code.
    -- Capturing an unexpected error does not pass the test: assert_number fails.
    PROCEDURE expect_salary_errors(
        p_salary NUMBER, p_expected_code NUMBER, p_description VARCHAR2
    ) IS
        v_result NUMBER;
        v_error_code NUMBER;
    BEGIN
        v_error_code := NULL;
        BEGIN
            v_result := fn_annual_salary(p_salary);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_code := SQLCODE;
        END;
        assert_number('Annual salary: ' || p_description,
                      v_error_code, p_expected_code);

        v_error_code := NULL;
        BEGIN
            v_result := fn_calculate_tax(p_salary);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_code := SQLCODE;
        END;
        assert_number('Tax: ' || p_description,
                      v_error_code, p_expected_code);
    END;

    PROCEDURE expect_service_error(
        p_test VARCHAR2, p_hire_date DATE, p_as_of_date DATE,
        p_expected_code NUMBER
    ) IS
        v_result NUMBER;
        v_error_code NUMBER;
    BEGIN
        BEGIN
            v_result := fn_years_of_service(p_hire_date, p_as_of_date);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_code := SQLCODE;
        END;
        assert_number(p_test, v_error_code, p_expected_code);
    END;
BEGIN
    assert_number('Annual salary: 150000 per month',
                  fn_annual_salary(150000), 1800000);
    assert_number('Annual salary: zero', fn_annual_salary(0), 0);
    assert_number('Annual salary: decimal amount',
                  fn_annual_salary(150000.25), 1800003);

    assert_number('Tax: zero', fn_calculate_tax(0), 0);
    assert_number('Tax: first threshold', fn_calculate_tax(100000), 0);
    assert_number('Tax: just above first threshold',
                  fn_calculate_tax(100001), 0.10);
    assert_number('Tax: middle band', fn_calculate_tax(150000), 5000);
    assert_number('Tax: second threshold', fn_calculate_tax(300000), 20000);
    assert_number('Tax: just above second threshold',
                  fn_calculate_tax(300001), 20000.20);
    assert_number('Tax: high salary', fn_calculate_tax(500000), 60000);
    assert_number('Tax: rounding to two decimals',
                  fn_calculate_tax(100000.15), 0.02);

    expect_salary_errors(NULL, -20001, 'missing salary');
    expect_salary_errors(-1, -20002, 'negative salary');

    assert_number('Service: six completed years',
        fn_years_of_service(DATE '2020-01-10', DATE '2026-10-06'), 6);
    assert_number('Service: day before first anniversary',
        fn_years_of_service(DATE '2025-10-07', DATE '2026-10-06'), 0);
    assert_number('Service: first anniversary',
        fn_years_of_service(DATE '2025-10-07', DATE '2026-10-07'), 1);
    assert_number('Service: same day',
        fn_years_of_service(DATE '2026-10-06', DATE '2026-10-06'), 0);
    assert_number('Service: Oracle leap-day month-end rule',
        fn_years_of_service(DATE '2024-02-29', DATE '2025-02-28'), 1);

    expect_service_error('Service: missing hire date', NULL,
                         DATE '2026-10-06', -20003);
    expect_service_error('Service: missing reference date',
                         DATE '2020-01-10', NULL, -20004);
    expect_service_error('Service: future hire date',
                         DATE '2030-01-01', DATE '2026-10-06', -20005);

    assert_text('Department: Sales', fn_dept_name(1), 'Sales');
    assert_text('Department: Finance', fn_dept_name(2), 'Finance');
    assert_text('Department: Store Operations',
                fn_dept_name(3), 'Store Operations');
    assert_text('Department: missing ID',
                fn_dept_name(999), 'UNKNOWN DEPARTMENT');
    assert_text('Department: NULL ID',
                fn_dept_name(NULL), 'UNKNOWN DEPARTMENT');

    DBMS_OUTPUT.PUT_LINE('All ' || v_pass_count || ' function tests passed.');
END;
/
