-- Exercice 2 :

-- 1. Afficher la structure de la relation section et son contenu (cours proposés).

DESC section;
SELECT * 
FROM section;


-- 2. Afficher tous les renseignements sur les cours que l’on peut programmer (relation course)

SELECT * 
FROM course 

-- 3. Afficher les titres des cours et les d´epartements qui les proposent.

SELECT title, dept_name 
FROM course

-- 4. Afficher les noms des d´epartements ainsi que leur budget.

SELECT dept_name, budget
FROM department

-- 5. Afficher tous les noms des enseignants et leur d´epartement.

SELECT name, dept_name
FROM teacher

-- 6. Afficher tous les noms des enseignants ayant un salaire sup´erieur strictement `a 65.000 $.

SELECT name
FROM teacher
WHERE salary > 65000

-- 7. Afficher les noms des enseignants ayant un salaire compris entre 55.000 $ et 85.000 $.

SELECT name 
FROM teacher
WHERE salary BETWEEN 55000 AND 85000

-- 8. Afficher les noms des d´epartements, en utilisant la relation teacher et ´eliminer les doublons.

SELECT DISTINCT dept_name
FROM teacher 

-- 9. Afficher tous les noms des enseignants du d´epartement informatique ayant un salaire sup´erieur strictement `a 65.000 $.

SELECT name 
FROM teacher
WHERE dept_name= 'Comp. Sci.' AND salary > 65000

-- 10. Afficher tous les renseignements sur les cours propos´es au printemps 2010 (relation section).

SELECT *
FROM section
WHERE semester='Spring' AND year=2010
