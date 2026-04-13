SET SERVEROUTPUT ON;

-- Q1 : Somme de deux entiers
BEGIN
    DBMS_OUTPUT.PUT_LINE('Somme : ' || (&a + &b));
END;
/

-- Q2 : Table de multiplication
DECLARE
    n NUMBER := &n;
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(n || ' x ' || i || ' = ' || n * i);
    END LOOP;
END;
/

-- Q3 : Fonction récursive x^n
CREATE OR REPLACE FUNCTION puissance(x NUMBER, n NUMBER) RETURN NUMBER IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        RETURN x * puissance(x, n - 1);
    END IF;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(puissance(&x, &n));
END;
/

-- Q4 : Factorielle d'un nombre, stockée dans resultatFactoriel
CREATE TABLE resultatFactoriel (nombre NUMBER, factorielle NUMBER);

DECLARE
    n    NUMBER := &n;
    fact NUMBER := 1;
BEGIN
    FOR i IN 1..n LOOP
        fact := fact * i;
    END LOOP;
    INSERT INTO resultatFactoriel VALUES (n, fact);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(n || '! = ' || fact);
END;
/

-- Q5 : Factorielles des 20 premiers entiers dans resultatsFactoriels
CREATE TABLE resultatsFactoriels (nombre NUMBER, factorielle NUMBER);

DECLARE
    fact NUMBER;
BEGIN
    FOR n IN 1..20 LOOP
        fact := 1;
        FOR i IN 1..n LOOP
            fact := fact * i;
        END LOOP;
        INSERT INTO resultatsFactoriels VALUES (n, fact);
        DBMS_OUTPUT.PUT_LINE(n || '! = ' || fact);
    END LOOP;
    COMMIT;
END;
/
