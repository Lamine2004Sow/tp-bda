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
