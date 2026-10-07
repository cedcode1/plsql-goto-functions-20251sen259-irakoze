SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === A1: Number classifier using GOTO ===

DECLARE
    PROCEDURE classify_number(p_number NUMBER) IS
    BEGIN
        IF p_number IS NULL THEN
            GOTO missing_number;
        ELSIF p_number < 0 THEN
            GOTO negative_number;
        ELSIF p_number = 0 THEN
            GOTO zero_number;
        ELSE
            GOTO positive_number;
        END IF;

        <<negative_number>>
        DBMS_OUTPUT.PUT_LINE(p_number || ': NEGATIVE');
        GOTO finished;

        <<zero_number>>
        DBMS_OUTPUT.PUT_LINE(p_number || ': ZERO');
        GOTO finished;

        <<positive_number>>
        DBMS_OUTPUT.PUT_LINE(p_number || ': POSITIVE');
        GOTO finished;

        <<missing_number>>
        DBMS_OUTPUT.PUT_LINE('NULL: NUMBER REQUIRED');

        <<finished>>
        NULL;
    END;
BEGIN
    classify_number(-7);
    classify_number(0);
    classify_number(12);
    classify_number(NULL);
END;
/
