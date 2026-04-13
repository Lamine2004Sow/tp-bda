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

-- ============================================================
-- EXERCICE 2
-- ============================================================

CREATE TABLE emp (
    matr    NUMBER(10)   NOT NULL,
    nom     VARCHAR2(50) NOT NULL,
    sal     NUMBER(7,2),
    adresse VARCHAR2(96),
    dep     NUMBER(10)   NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);

-- Données de test
INSERT INTO emp VALUES (1, 'Alice', 3000, '10 rue de Paris', 92000);
INSERT INTO emp VALUES (2, 'Bob',   2500, '5 avenue Foch', 75000);
INSERT INTO emp VALUES (3, 'Carl',  4000, '20 rue Victor Hugo', 92000);
INSERT INTO emp VALUES (4, 'Youcef', 2500, 'avenue de la République', 92002);
INSERT INTO emp VALUES (5, 'Diana', 3500, '8 bd Haussmann', 75000);
INSERT INTO emp VALUES (6, 'Eve',   1800, '3 rue des Lilas', 10);
COMMIT;

-- Q1 : Insérer un nouvel employé
DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr    := 7;
    v_employe.nom     := 'Youcef';
    v_employe.sal     := 2500;
    v_employe.adresse := 'avenue de la République';
    v_employe.dep     := 92002;
    INSERT INTO emp VALUES v_employe;
    COMMIT;
END;
/

-- Q2 : Supprimer les employés du dep 10, afficher le nombre supprimé
DECLARE
    nb NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    nb := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Lignes supprimées : ' || nb);
END;
/

-- Q3 : Somme des salaires avec curseur explicite et LOOP
DECLARE
    v_sal   emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;
    CURSOR c IS SELECT sal FROM emp;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_sal;
        EXIT WHEN c%NOTFOUND;
        IF v_sal IS NOT NULL THEN
            v_total := v_total + v_sal;
        END IF;
    END LOOP;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE('Total salaires : ' || v_total);
END;
/

-- Q4 : Salaire moyen avec curseur explicite et LOOP
DECLARE
    v_sal  emp.sal%TYPE;
    v_total emp.sal%TYPE := 0;
    v_nb   NUMBER := 0;
    CURSOR c IS SELECT sal FROM emp;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_sal;
        EXIT WHEN c%NOTFOUND;
        IF v_sal IS NOT NULL THEN
            v_total := v_total + v_sal;
            v_nb    := v_nb + 1;
        END IF;
    END LOOP;
    CLOSE c;
    IF v_nb > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || v_total / v_nb);
    END IF;
END;
/

-- Q5a : Somme des salaires avec FOR IN
DECLARE
    v_total emp.sal%TYPE := 0;
BEGIN
    FOR rec IN (SELECT sal FROM emp) LOOP
        IF rec.sal IS NOT NULL THEN
            v_total := v_total + rec.sal;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total salaires : ' || v_total);
END;
/

-- Q5b : Salaire moyen avec FOR IN
DECLARE
    v_total emp.sal%TYPE := 0;
    v_nb    NUMBER := 0;
BEGIN
    FOR rec IN (SELECT sal FROM emp) LOOP
        IF rec.sal IS NOT NULL THEN
            v_total := v_total + rec.sal;
            v_nb    := v_nb + 1;
        END IF;
    END LOOP;
    IF v_nb > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || v_total / v_nb);
    END IF;
END;
/

-- Q6 : Noms des employés des dep 92000 et 75000 avec curseur paramétré
DECLARE
    CURSOR c(p_dep emp.dep%TYPE) IS
        SELECT nom FROM emp WHERE dep = p_dep;
BEGIN
    FOR rec IN c(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 92000 : ' || rec.nom);
    END LOOP;
    FOR rec IN c(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 75000 : ' || rec.nom);
    END LOOP;
END;
/
