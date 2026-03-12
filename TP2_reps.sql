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

SELECT s.name, COUNT(*)
FROM teacher tr  JOIN teaches ts ON tr.ID=ts.ID JOIN takes tk ON tk.course_id= ts.course_id JOIN student s ON s.ID= tk.ID

GROUP BY(tr.name, s.name)
HAVING(COUNT(*)) >=2
