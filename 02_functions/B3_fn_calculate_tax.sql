-- Classroom tax model only. These are not official Rwanda tax rates.
-- Tax input and output are MONTHLY amounts in RWF.
CREATE OR REPLACE FUNCTION fn_calculate_tax (
    p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
    v_tax NUMBER;
BEGIN
    IF p_monthly_salary IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Monthly salary is required.');
    ELSIF p_monthly_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Monthly salary cannot be negative.');
    END IF;

    IF p_monthly_salary <= 100000 THEN
        v_tax := 0;
    ELSIF p_monthly_salary <= 300000 THEN
        v_tax := (p_monthly_salary - 100000) * 0.10;
    ELSE
        v_tax := 200000 * 0.10 + (p_monthly_salary - 300000) * 0.20;
    END IF;

    RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/
SHOW ERRORS FUNCTION fn_calculate_tax
