SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR CONTINUE


BEGIN
    GOTO inside_if;

    IF 250000 > 0 THEN
        <<inside_if>>
        DBMS_OUTPUT.PUT_LINE('This statement must not execute.');
    END IF;
END;
/

PROMPT === A3: Corrected version ===
PROMPT The label is now before the whole IF statement, in the same outer block.

BEGIN
    GOTO check_salary;

    <<check_salary>>
    IF 250000 > 0 THEN
        DBMS_OUTPUT.PUT_LINE('FIXED: positive salary checked legally.');
    END IF;
END;
/
