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

-- 11. Afficher tous les titres des cours dispens´es par le d´epartement informatique qui ont plus de trois cr´edits.

SELECT title 
FROM course
WHERE dept_name ='Comp. Sci.' AND credits > 3

-- 12. Afficher tous les noms des enseignants ainsi que le nom de leur d´epartement et les noms des bˆatiments qui les h´ebergent.

SELECT name, t.dept_name, d.building
FROM teacher t JOIN department d ON t.dept_name =d.dept_name
 
-- 13. Afficher tous les ´etudiants ayant suivi au moins un cours en informatique.

SELECT DISTINCT s.ID, s.name 
FROM student s JOIN takes t ON s.ID =t.ID JOIN course c ON c.course_id = t.course_id 
WHERE c.dept_name ='Comp. Sci.'

-- 14. Afficher les noms des ´etudiants ayant suivi un cours dispens´e par un enseignant nomm´e Eistein (´eliminer les doublons).

SELECT DISTINCT s.name
FROM student s JOIN takes ta ON s.ID =ta.ID JOIN teaches te ON ta.course_id =te.course_id JOIN teacher t ON t.ID =te.ID
WHERE t.name ='Einstein'

-- 15. Afficher tous les identifiants des cours et les enseignants qui les ont assur´es.

SELECT c.course_id, t.ID
FROM course c JOIN teaches te ON c.course_id =te.course_id JOIN teacher t ON t.ID =te.ID

-- 16. Afficher le nombre d’inscrits pour chaque enseignement propos´e au printemps 2010.

SELECT COUNT(ta.ID)
FROM takes ta JOIN section s ON ta.course_id =s.course_id
WHERE s.semester='Spring' AND s.year=2010

-- 17. Afficher les noms des d´epartements et les salaires maximum de leurs enseignants.

SELECT dept_name, MAX(t.salary)
FROM teacher t
GROUP BY dept_name

-- 18. Afficher le nombre d’inscrits pour chaque enseignement propos´e.

SELECT c.title, COUNT(s.ID)
FROM student s JOIN takes ta ON s.ID =ta.ID JOIN course c ON ta.course_id=c.course_id
GROUP BY (c.title)

-- 19. Afficher le nombre total de cours qui ont eu lieu dans chaque bˆatiment, pendant l’automne 2009 et le printemps 2010

SELECT s.building, COUNT(s.course_id)
FROM section s 
WHERE semester='Autumn' AND year=2009 OR s.semester= 'Spring' AND year=2010
GROUP BY (building)

-- 20. Afficher le nombre total de cours dispens´es par chaque d´epartement et qui ont eu dans le mˆeme bˆatiment qui l’abrite.

SELECT c.dept_name, COUNT(s.course_id)
FROM section s JOIN course c ON s.course_id =c.course_id JOIN department d ON c.dept_name =d.dept_name
WHERE s.building= d.building
GROUP BY c.dept_name

-- 21. Afficher les titres des cours propos´es et qui ont eu lieu et les enseignants qui les ont assur´es.

SELECT c.title, t.name
FROM course c JOIN teaches te ON c.course_id =te.course_id JOIN teacher t ON t.ID= te.ID


