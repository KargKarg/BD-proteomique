-- Requête permettant d'obtenir la moyenne de structure des 'OXIDOREDUCTASE'
SELECT 
ROUND(AVG(COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'helix' THEN 1 END)), 3) AS moy_helice,
ROUND(AVG(COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'strand' THEN 1 END)), 3) AS moy_brin,
ROUND(AVG(COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'turn' THEN 1 END)), 3) AS moy_boucle
FROM PROTEINE JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
WHERE PROTEINE.famille LIKE '%OXIDOREDUCTASE%'
GROUP BY PROTEINE.id;

-- Requête permettant d'obtenir le genre et l'espèce des organismes homologue à 'Homo sapiens' pour l'insulin
SELECT GENOME.genre, GENOME.espece
FROM PROTEINE JOIN GENOME ON PROTEINE.id_genome = GENOME.id
WHERE PROTEINE.id IN (SELECT HOMOLOGUE.id_proteine1
			FROM HOMOLOGUE JOIN PROTEINE ON HOMOLOGUE.id_proteine2 = PROTEINE.id JOIN GENOME ON PROTEINE.id_genome = GENOME.id
			WHERE PROTEINE.nom = 'Insulin' AND GENOME.genre = 'Homo' AND GENOME.espece = 'sapiens');

-- Requête permettant d'obtenir la méthode la plus utilisé pour caractériser la structure des proteines > 10Kda et avec plus d'une sous-unité
SELECT R.methode
FROM (SELECT EXPERIENCE.methode, RANK() OVER (ORDER BY COUNT(*) DESC) as rnk
	FROM PROTEINE JOIN EXPERIENCE ON PROTEINE.id = EXPERIENCE.id_proteine
	WHERE PROTEINE.taille > 10 AND PROTEINE.sous_unites > 1
	GROUP BY EXPERIENCE.methode) R
WHERE rnk = 1;

-- Requête permettant d'obtenir les domaines possédant toutes les structures secondaires
SELECT DOMAINE.id, DOMAINE.nom
FROM DOMAINE
GROUP BY DOMAINE.id, DOMAINE.nom
HAVING (SELECT COUNT(DISTINCT STRUCTURE_SECONDAIRE.nom)
	FROM DOMAINE JOIN PROTEINE ON DOMAINE.id_proteine = PROTEINE.id JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
	WHERE (DOMAINE.debut < STRUCTURE_SECONDAIRE.debut AND DOMAINE.fin > STRUCTURE_SECONDAIRE.debut)
	OR (DOMAINE.debut < STRUCTURE_SECONDAIRE.fin AND DOMAINE.fin > STRUCTURE_SECONDAIRE.fin))
	= (SELECT COUNT(DISTINCT STRUCTURE_SECONDAIRE.nom) FROM STRUCTURE_SECONDAIRE);

-- Requête permettant d'obtenir les protéines possédant moins de 2 types de structures
SELECT PROTEINE.id
FROM PROTEINE LEFT JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
GROUP BY PROTEINE.id
HAVING COUNT(DISTINCT STRUCTURE_SECONDAIRE.nom) < 2;

-- Requête permettant d'obtenir les protéines recouvert à plus de 75% par des helices
SELECT PROTEINE.id, PROTEINE.nom
FROM PROTEINE JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
GROUP BY PROTEINE.id, PROTEINE.taille, PROTEINE.nom
HAVING 
	SUM(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'helix' THEN STRUCTURE_SECONDAIRE.fin - STRUCTURE_SECONDAIRE.debut + 1 END)
	> PROTEINE.taille*0.75;

-- Requête permettant d'obtenir les protéines avec une successions telle que (strand, helice, strand, helice)
SELECT DISTINCT PROTEINE.id, PROTEINE.nom
FROM PROTEINE JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
WHERE EXISTS (SELECT SS.nom 
		FROM STRUCTURE_SECONDAIRE SS
		WHERE SS.debut > STRUCTURE_SECONDAIRE.fin AND SS.nom = 'helix' AND SS.id_proteine = PROTEINE.id
		AND SS.debut = (SELECT MIN(SS1.debut) FROM STRUCTURE_SECONDAIRE SS1 
				WHERE SS1.debut > STRUCTURE_SECONDAIRE.debut AND SS1.id_proteine = PROTEINE.id)
		AND EXISTS (SELECT SSS.nom
				FROM STRUCTURE_SECONDAIRE SSS
				WHERE SSS.debut > SS.fin AND SSS.nom = 'strand' AND SSS.id_proteine = SS.id_proteine
				AND SSS.debut = (SELECT MIN(SSS1.debut) FROM STRUCTURE_SECONDAIRE SSS1 
						WHERE SSS1.debut > SS.debut AND SSS1.id_proteine = PROTEINE.id)
				AND EXISTS (SELECT SSSS.nom
						FROM STRUCTURE_SECONDAIRE SSSS
						WHERE SSSS.debut > SSS.fin 
						AND SSSS.nom = 'helix' AND SSSS.id_proteine = SSS.id_proteine
						AND SSSS.debut = (SELECT MIN(SSSS1.debut) FROM STRUCTURE_SECONDAIRE SSSS1
								WHERE SSSS1.debut > SSS.debut AND SSSS1.id_proteine = PROTEINE.id))))
AND STRUCTURE_SECONDAIRE.nom = 'strand';

-- Requête permettant d'obtenir les protéines avec au moins 5 helices de taille supérieur à 10
SELECT PROTEINE.id, PROTEINE.nom
FROM PROTEINE JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
WHERE (STRUCTURE_SECONDAIRE.fin- STRUCTURE_SECONDAIRE.debut + 1) > 10 AND STRUCTURE_SECONDAIRE.nom = 'helix'
GROUP BY PROTEINE.id, PROTEINE.nom
HAVING COUNT(DISTINCT STRUCTURE_SECONDAIRE.id) >= 5;

-- Requête permettant d'obtenir les protéines avec un domaine dans (1/1O ou supérieur à 9/10) de la protéine composé uniquement d'hélice
SELECT PROTEINE.id 
FROM PROTEINE 
JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine 
JOIN DOMAINE ON PROTEINE.id = DOMAINE.id_proteine
WHERE (DOMAINE.debut < PROTEINE.taille*0.1 OR DOMAINE.debut>PROTEINE.taille*0.9)
AND ((STRUCTURE_SECONDAIRE.debut < DOMAINE.fin AND STRUCTURE_SECONDAIRE.debut > DOMAINE.debut)
OR (STRUCTURE_SECONDAIRE.fin < DOMAINE.fin AND STRUCTURE_SECONDAIRE.fin > DOMAINE.debut))
GROUP BY PROTEINE.id
HAVING COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'helix' THEN 1 END) > 0 AND COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'strand' THEN 1 END) = 0 AND COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'turn' THEN 1 END) = 0;

-- Requête permettant d'obtenir la moyenne des genes des organismes par habitat
SELECT HABITAT.id, HABITAT.biome, ROUND(AVG(GENOME.genes), 3)
FROM HABITAT 
JOIN ORGANISME ON HABITAT.id = ORGANISME.id_habitat 
JOIN GENOME ON ORGANISME.genre = GENOME.genre AND ORGANISME.espece = GENOME.espece
GROUP BY HABITAT.id, HABITAT.biome;

-- Requête permettant d'obtenir les proteines avec autant d'helice que de brin et possédant au plus deux fois moins de boucle
SELECT PROTEINE.id, PROTEINE.nom
FROM PROTEINE
JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine 
GROUP BY PROTEINE.id, PROTEINE.nom
HAVING 
COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'helix' THEN 1 END) = COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'strand' THEN 1 END)
AND 
COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'turn' THEN 1 END)*2 < COUNT(CASE WHEN STRUCTURE_SECONDAIRE.nom = 'strand' THEN 1 END);

-- Requête permettant d'obtenir les auteurs travaillant sur le phyla bactérie
SELECT EXPERIENCE.auteur
FROM ORGANISME JOIN GENOME ON ORGANISME.genre = GENOME.genre AND ORGANISME.espece = GENOME.espece
JOIN PROTEINE ON PROTEINE.id_genome = GENOME.id
JOIN EXPERIENCE ON PROTEINE.id = EXPERIENCE.id_proteine
WHERE ORGANISME.phyla = 'Bacteria';

-- Requête permettant d'obtenir les pays travaillant le plus sur 'Homo sapiens'
SELECT EXPERIENCE.pays, COUNT(DISTINCT ORGANISME.genre) AS frequence
FROM ORGANISME JOIN GENOME ON ORGANISME.genre = GENOME.genre AND ORGANISME.espece = GENOME.espece
JOIN PROTEINE ON PROTEINE.id_genome = GENOME.id
JOIN EXPERIENCE ON PROTEINE.id = EXPERIENCE.id_proteine
WHERE ORGANISME.hote = 'Homo sapiens'
GROUP BY EXPERIENCE.pays
ORDER BY frequence DESC;

-- Requête permettant d'avoir le pourcentage de structure identique au moins chevauchante pour les proteines homologues
SELECT DISTINCT G1.genre, G1.espece, G2.genre, G2.espece, 
COUNT(CASE WHEN 
(((S1.debut >= S2.debut AND S1.debut <= S2.fin) OR (S1.fin >= S2.debut AND S1.fin <= S2.fin))
OR
((S1.debut <= S2.debut AND S1.debut >= S2.fin) OR (S1.fin <= S2.debut AND S1.fin >= S2.fin)))
AND S1.nom = S2.nom THEN 1 END)/COUNT(DISTINCT S1.id)*100
FROM HOMOLOGUE JOIN PROTEINE P1 ON HOMOLOGUE.id_proteine1 = P1.id 
JOIN PROTEINE P2 ON HOMOLOGUE.id_proteine2 = P2.id
JOIN STRUCTURE_SECONDAIRE S1 ON P1.id = S1.id_proteine
JOIN STRUCTURE_SECONDAIRE S2 ON P2.id = S2.id_proteine
JOIN GENOME G1 ON P1.id_genome = G1.id
JOIN GENOME G2 ON P2.id_genome = G2.id
GROUP BY G1.genre, G1.espece, G2.genre, G2.espece;

-- Requête permettant d'obtenir les proteines ayant moins de 20% de sa taille recouvert par une structure quelconque
SELECT PROTEINE.id, PROTEINE.nom
FROM PROTEINE JOIN STRUCTURE_SECONDAIRE ON PROTEINE.id = STRUCTURE_SECONDAIRE.id_proteine
GROUP BY PROTEINE.id, PROTEINE.taille, PROTEINE.nom
HAVING SUM(STRUCTURE_SECONDAIRE.fin - STRUCTURE_SECONDAIRE.debut + 1) < PROTEINE.taille*0.2;
