CREATE OR REPLACE FUNCTION fn_dept_name (
    p_department_id IN NUMBER
) RETURN VARCHAR2
IS
    v_name a3_departments.department_name%TYPE;
BEGIN
    SELECT department_name
    INTO v_name
    FROM a3_departments
    WHERE department_id = p_department_id;

    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'UNKNOWN DEPARTMENT';
END fn_dept_name;
/
SHOW ERRORS FUNCTION fn_dept_name
