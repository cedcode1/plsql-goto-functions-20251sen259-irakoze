CREATE OR REPLACE FUNCTION fn_years_of_service (
    p_hire_date IN DATE,
    p_as_of_date IN DATE DEFAULT SYSDATE
) RETURN NUMBER
IS
BEGIN
    IF p_hire_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Hire date is required.');
    ELSIF p_as_of_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Reference date is required.');
    ELSIF TRUNC(p_hire_date) > TRUNC(p_as_of_date) THEN
        RAISE_APPLICATION_ERROR(-20005, 'Hire date is in the future.');
    END IF;

    -- Ignore time of day and keep only completed years.
    -- MONTHS_BETWEEN uses Oracle's same-day/month-end date behavior.
    RETURN TRUNC(MONTHS_BETWEEN(
        TRUNC(p_as_of_date), TRUNC(p_hire_date)
    ) / 12);
END fn_years_of_service;
/
SHOW ERRORS FUNCTION fn_years_of_service
