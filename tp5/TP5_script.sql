-- ============================================================
-- TP 5 : Transactions et controle de concurrence
-- ============================================================

-- SET AUTOCOMMIT OFF  (a executer au debut de chaque session)


-- ============================================================
-- EXERCICE 1 : Atomicite d'une transaction
-- ============================================================

-- Q1 : Creation de la table (Session S1)

CREATE TABLE transaction (
    idTransaction  VARCHAR2(44),
    valTransaction NUMBER(10)
);


-- Q2 : Insertions, modification, suppression puis ROLLBACK (Session S2)

INSERT INTO transaction VALUES ('T001', 100);
INSERT INTO transaction VALUES ('T002', 200);
INSERT INTO transaction VALUES ('T003', 300);

UPDATE transaction SET valTransaction = 999 WHERE idTransaction = 'T001';

DELETE FROM transaction WHERE idTransaction = 'T002';

ROLLBACK;

SELECT * FROM transaction;


-- Q3 : Insertions puis fermeture avec quit (Session S2)

INSERT INTO transaction VALUES ('T001', 100);
INSERT INTO transaction VALUES ('T002', 200);
-- quit;

-- Verification depuis S1 (la table est vide car quit provoque un ROLLBACK implicite)
SELECT * FROM transaction;


-- Q4 : Insertions puis fermeture brutale (Session S1)

INSERT INTO transaction VALUES ('TX01', 500);
INSERT INTO transaction VALUES ('TX02', 600);
-- [fermeture forcee du terminal]

-- Apres reconnexion : les donnees ne sont pas preservees (ROLLBACK implicite)
SELECT * FROM transaction;


-- Q5 : INSERT + DDL (ALTER) + ROLLBACK

INSERT INTO transaction VALUES ('T001', 100);

ALTER TABLE transaction ADD val2transaction NUMBER(10);

ROLLBACK;

-- La colonne val2transaction est toujours presente car le DDL provoque un COMMIT implicite
SELECT * FROM transaction;


-- Q6 : pas de script, voir le rapport


-- ============================================================
-- EXERCICE 2 : Transactions concurrentes
-- ============================================================

-- Creation des tables

CREATE TABLE vol (
    idVol                 VARCHAR2(44),
    capaciteVol           NUMBER(10),
    nbrPlacesReserveesVol NUMBER(10)
);

CREATE TABLE client (
    idClient                 VARCHAR2(44),
    prenomClient             VARCHAR2(11),
    nbrPlacesReserveesCleint NUMBER(10)
);

-- Insertion des donnees initiales

INSERT INTO vol    VALUES ('V001', 100, 0);
INSERT INTO client VALUES ('C001', 'Alice', 0);
INSERT INTO client VALUES ('C002', 'Bob',   0);
COMMIT;


-- Isolation des transactions (niveau READ COMMITTED par defaut)
-- T1 : reservation de 2 places pour Alice, sans COMMIT (Session S1)

UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C001';

-- Depuis S2 : les modifications de T1 sont invisibles
SELECT * FROM vol;
SELECT * FROM client;


-- ROLLBACK de T1 (Session S1)

ROLLBACK;

-- La base est revenue a son etat initial
SELECT * FROM vol;
SELECT * FROM client;


-- T1 recommence et valide (Session S1)

UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C001';
COMMIT;

-- Depuis S2 : les modifications sont maintenant visibles (READ COMMITTED confirme)
SELECT * FROM vol;
SELECT * FROM client;


-- Remise a zero

UPDATE vol    SET nbrPlacesReserveesVol    = 0 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 WHERE idClient = 'C001';
UPDATE client SET nbrPlacesReserveesCleint = 0 WHERE idClient = 'C002';
COMMIT;


-- Probleme des mises a jour perdues (READ COMMITTED, execution entrelacee)

-- Etape 1 : T1 lit (Session S1)
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V001';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C001';

-- Etape 2 : T2 lit (Session S2)
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V001';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C002';

-- Etape 3 : T1 ecrit et valide (Session S1)
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 2 WHERE idClient = 'C001';
COMMIT;

-- Etape 4 : T2 ecrit avec la valeur lue avant le COMMIT de T1, et valide (Session S2)
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 3 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 3 WHERE idClient = 'C002';
COMMIT;

-- Resultat : vol = 3 au lieu de 5 => mise a jour perdue
SELECT * FROM vol;
SELECT * FROM client;


-- Remise a zero

UPDATE vol    SET nbrPlacesReserveesVol    = 0 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 WHERE idClient = 'C001';
UPDATE client SET nbrPlacesReserveesCleint = 0 WHERE idClient = 'C002';
COMMIT;


-- Isolation complete : mode SERIALIZABLE (a executer dans S1 ET S2 avant de commencer)

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Meme execution entrelacee qu'avant

-- T1 lit (Session S1)
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V001';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C001';

-- T2 lit (Session S2)
SELECT nbrPlacesReserveesVol    FROM vol    WHERE idVol    = 'V001';
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C002';

-- T1 ecrit et valide (Session S1)
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 2 WHERE idClient = 'C001';
COMMIT;

-- T2 tente d'ecrire et de valider (Session S2) => ORA-08177
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 3 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 3 WHERE idClient = 'C002';
COMMIT;


-- Reproduction de la sequence du cours : r1(d) w2(d) w2(d') C2 w1(d') C1

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- r1(d) : T1 lit d (Session S1)
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V001';

-- w2(d) : T2 ecrit sur d (Session S2)
UPDATE vol SET nbrPlacesReserveesVol = 10 WHERE idVol = 'V001';

-- w2(d') : T2 ecrit sur d' (Session S2)
UPDATE client SET nbrPlacesReserveesCleint = 10 WHERE idClient = 'C001';

-- C2 : T2 valide (Session S2)
COMMIT;

-- w1(d') : T1 tente d'ecrire sur d' (Session S1)
UPDATE client SET nbrPlacesReserveesCleint = 99 WHERE idClient = 'C001';

-- C1 : T1 tente de valider (Session S1) => ORA-08177 en mode SERIALIZABLE
COMMIT;
