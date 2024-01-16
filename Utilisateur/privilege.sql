-- Implementation des privilèges pour l'utilisateur 'scientifique_USA'
GRANT SELECT ON etudiant.HABITAT TO scientifique_USA;
GRANT SELECT ON etudiant.ORGANISME TO scientifique_USA;
GRANT SELECT ON etudiant.GENOME TO scientifique_USA;
GRANT SELECT ON etudiant.PROTEINE TO scientifique_USA;
GRANT SELECT ON etudiant.DOMAINE TO scientifique_USA;
GRANT SELECT ON etudiant.EXPERIENCE TO scientifique_USA;
GRANT SELECT ON etudiant.HOMOLOGUE TO scientifique_USA;
GRANT SELECT ON etudiant.STRUCTURE_SECONDAIRE TO scientifique_USA;

-- Implementation des privilèges pour l'utilisateur 'visiteur_web'
GRANT SELECT ON etudiant.HABITAT TO visiteur_web;
GRANT SELECT ON etudiant.ORGANISME TO visiteur_web;
GRANT SELECT ON etudiant.GENOME TO visiteur_web;
GRANT SELECT ON etudiant.PROTEINE TO visiteur_web;
GRANT SELECT ON etudiant.DOMAINE TO visiteur_web;

-- Implementation des privilèges pour l'utilisateur 'bacteriologiste'
GRANT SELECT ON etudiant.BACTERIE TO bacteriologiste;

-- Implementation des privilèges pour l'utilisateur 'medecin'
GRANT SELECT ON etudiant.HOMME TO medecin;

-- Implementation des privilèges pour l'utilisateur 'scientifique_NON_USA'
GRANT SELECT ON etudiant.NON_USA TO scientifique_NON_USA;
