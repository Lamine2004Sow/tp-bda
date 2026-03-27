# TP n°5 — Transactions et contrôle de concurrence

---

## Exercice 1 : Atomicité d'une transaction

### Q2 — INSERT, UPDATE, DELETE puis ROLLBACK

```sql
INSERT INTO transaction VALUES ('T001', 100);
INSERT INTO transaction VALUES ('T002', 200);
INSERT INTO transaction VALUES ('T003', 300);

UPDATE transaction SET valTransaction = 999 WHERE idTransaction = 'T001';

DELETE FROM transaction WHERE idTransaction = 'T002';

ROLLBACK;

SELECT * FROM transaction;
```

**Résultat :** La table est vide. Le `ROLLBACK` annule toutes les opérations effectuées depuis le début de la transaction.

---

### Q3 — INSERT puis `quit;`

```sql
INSERT INTO transaction VALUES ('T001', 100);
INSERT INTO transaction VALUES ('T002', 200);
quit;
```

```sql
-- Depuis S1
SELECT * FROM transaction;
```

**Résultat :** La table est vide. `quit;` ferme la session et provoque un `ROLLBACK` implicite. Sans `COMMIT`, les données sont perdues.

---

### Q4 — Fermeture brutale

```sql
INSERT INTO transaction VALUES ('TX01', 500);
INSERT INTO transaction VALUES ('TX02', 600);
-- [fermeture forcée du terminal]
```

```sql
-- Après reconnexion
SELECT * FROM transaction;
```

**Résultat :** Les données ne sont pas là. Oracle effectue un `ROLLBACK` implicite en cas de déconnexion anormale.

---

### Q5 — DDL + ROLLBACK

```sql
INSERT INTO transaction VALUES ('T001', 100);

ALTER TABLE transaction ADD val2transaction NUMBER(10);

ROLLBACK;

SELECT * FROM transaction;
```

**Résultat :** La colonne `val2transaction` est toujours présente. En Oracle, un DDL provoque un `COMMIT` implicite, le `ROLLBACK` qui suit n'annule rien.

---

### Q6 — Définitions

- **Session** : connexion d'un utilisateur à la base, du login au logout. Une session peut contenir plusieurs transactions.
- **Transaction** : suite d'opérations SQL traitée comme une unité. Elle se termine par un `COMMIT` ou un `ROLLBACK`.
- **COMMIT** : valide les modifications de façon définitive, elles deviennent visibles pour les autres sessions.
- **ROLLBACK** : annule toutes les modifications depuis le début de la transaction courante.

---

## Exercice 2 : Transactions concurrentes

### Isolation des transactions

```sql
-- Session S1 (T1) — sans COMMIT
UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C001';
```

```sql
-- Session S2 (T2)
SELECT * FROM vol;
SELECT * FROM client;
```

**Résultat :** T2 voit encore 0. En `READ COMMITTED`, une transaction ne voit que les données déjà validées.

---

### COMMIT et ROLLBACK

```sql
-- Session S1 : ROLLBACK
ROLLBACK;
```

La base revient à l'état initial, T2 voit tout comme si T1 n'avait pas existé.

```sql
-- Session S1 : on recommence et on valide
UPDATE vol    SET nbrPlacesReserveesVol    = nbrPlacesReserveesVol    + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = nbrPlacesReserveesCleint + 2 WHERE idClient = 'C001';
COMMIT;
```

```sql
-- Session S2
SELECT * FROM vol;
SELECT * FROM client;
```

**Résultat :** T2 voit maintenant les modifications. Cela confirme le niveau `READ COMMITTED`. Un `ROLLBACK` après un `COMMIT` est impossible (durabilité).

---

### Isolation incomplète — mises à jour perdues

```sql
-- T1 lit (S1)
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V001';       -- 0
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C001'; -- 0

-- T2 lit (S2)
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V001';       -- 0
SELECT nbrPlacesReserveesCleint FROM client WHERE idClient = 'C002'; -- 0

-- T1 écrit et valide (S1)
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 2 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 2 WHERE idClient = 'C001';
COMMIT;

-- T2 écrit avec la valeur lue avant le COMMIT de T1, et valide (S2)
UPDATE vol    SET nbrPlacesReserveesVol    = 0 + 3 WHERE idVol    = 'V001';
UPDATE client SET nbrPlacesReserveesCleint = 0 + 3 WHERE idClient = 'C002';
COMMIT;

SELECT * FROM vol;
SELECT * FROM client;
```

**Résultat :** Le vol affiche 3 au lieu de 5. La mise à jour de T1 a été écrasée par T2 (mises à jour perdues). La base est incohérente.

---

### Isolation complète — mode SERIALIZABLE

```sql
-- Dans S1 ET S2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

On rejoue la même séquence. Cette fois Oracle rejette T2 :

```
ORA-08177: can't serialize access for this transaction
```

**Explication :** Oracle détecte que T2 a lu des données qui ont été modifiées par T1 et refuse de valider.

---

### Séquence du cours : `r1(d) w2(d) w2(d') C2 w1(d') C1`

```sql
-- r1(d) : T1 lit (S1)
SELECT nbrPlacesReserveesVol FROM vol WHERE idVol = 'V001';

-- w2(d) : T2 écrit (S2)
UPDATE vol SET nbrPlacesReserveesVol = 10 WHERE idVol = 'V001';

-- w2(d') : T2 écrit (S2)
UPDATE client SET nbrPlacesReserveesCleint = 10 WHERE idClient = 'C001';

-- C2 : T2 valide (S2)
COMMIT;

-- w1(d') : T1 écrit (S1)
UPDATE client SET nbrPlacesReserveesCleint = 99 WHERE idClient = 'C001';

-- C1 : T1 tente de valider (S1)
COMMIT;
```

- En `READ COMMITTED` : les deux transactions valident, T1 écrase T2 sur `d'`.
- En `SERIALIZABLE` : T1 est rejetée avec `ORA-08177`.

---

### Conclusion : Oracle utilise-t-il le verrouillage à deux phases (2PL) ?

Non. Oracle utilise la **MVCC** (Multi-Version Concurrency Control). Les lectures ne posent pas de verrou, elles lisent un snapshot de la base. Les conflits sont détectés au moment du `COMMIT` et non par blocage préventif comme dans le 2PL vu en cours.
