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
              
-- 
