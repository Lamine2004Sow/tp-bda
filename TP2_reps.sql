-- TP2 : Requêtes, dépendances fonctionnelles et normalisation
-- Nom : TAÏBI 
-- Prénom : Abderrahmane
-- Numéro étudiant : 12411518

-- Exercice 1: 

-- 1. Afficher le nom du d´epartement qui a le budget le plus ´elev´e.

SELECT dept_name 
FROM department 
WHERE budget= (SELECT MAX(budget) 
              FROM department)
              
-- 2. Afficher les salaires et les noms des enseignants qui gagnent plus que le salaire moyen

SELECT salary, name
FROM teacher
WHERE salary > (SELECT AVG(salary)
                 FROM teacher)	
                 
-- 3. Pour chaque enseignant, afficher tous les ´etudiants qui ont suivi plus de deux cours dispens´es par cet enseignent ainsi que le nombre total de cours suivis par chaque ´etudiant, en utilisant la clause HAVING

SELECT s.name, tr.name, COUNT(*)
FROM teacher tr  JOIN teaches ts ON tr.ID=ts.ID JOIN takes tk ON tk.course_id= ts.course_id JOIN student s ON s.ID= tk.ID

GROUP BY(tr.name, s.name)
HAVING(COUNT(*)) >=2

-- 4. Pour chaque enseignant, afficher tous les ´etudiants qui ont suivi plus de deux cours dispens´es par cet enseignent ainsi que le nombre total de cours suivis par chaque ´etudiant, sans utiliser la clause HAVING.

SELECT T.teachername , T.studentname , T.totalcount
FROM ( SELECT teacher.name as teachername, student.name as studentname, count (*) as totalcount
FROM teacher, student, takes, teaches
WHERE teacher.id = teaches.id and student.id = takes.id and (takes.course_id, takes.sec_id, takes.semester, takes.year)=(teaches.course_id, teaches.sec_id, teaches.semester, teaches.year )
GROUP BY teacher.name , student.name) T
WHERE T.totalcount >= 2 ORDER BY T.teachername

-- 5. Afficher les identifiants et les noms des ´etudiants qui n’ont pas suivi de cours avant 2010.

SELECT s.ID, s.name FROM student s
MINUS
SELECT s.ID, s.name
FROM student s JOIN takes tk ON s.ID=tk.ID
WHERE tk.year < 2010

-- 6. Afficher tous les enseignants dont les noms commencent par E

SELECT tr.name
FROM teacher tr
WHERE tr.name LIKE 'E%'

--


