-- Requête permettant d'obtenir les tables implementées
SELECT TABLE_NAME 
FROM USER_TABLES 
ORDER BY TABLE_NAME;

-- Requête permettant d'obtenir les contraintes associées aux tables
SELECT table_name, constraint_name, constraint_type
FROM user_constraints
ORDER BY table_name;

-- Requête permettant d'obtenir les trigger associés aux tables
SELECT table_name, trigger_name, trigger_type
FROM user_triggers
ORDER BY table_name;

-- Requête permettant d'obtenir les vues implementées
SELECT VIEW_NAME 
FROM USER_VIEWS 
ORDER BY VIEW_NAME;

-- Requête permettant d'obtenir les séquences implementées
SELECT *
FROM all_sequences
WHERE sequence_name LIKE 'insertion_sequence_%';

-- Requête permettant d'obtenir les fonctions implementées ainsi que les arguments associés
SELECT OBJECT_NAME, ARGUMENT_NAME
FROM ALL_OBJECTS JOIN ALL_ARGUMENTS ON ALL_OBJECTS.OBJECT_NAME = ALL_ARGUMENTS.OBJECT_NAME 
WHERE OBJECT_TYPE = 'FUNCTION' AND OWNER = 'etudiant';

-- Requête permettant d'obtenir les utilisateurs ainsi que les privilèges associés
SELECT GRANTEE, TABLE_NAME, PRIVILEGE
FROM ALL_USERS JOIN ALL_TAB_PRIVS ON ALL_TAB_PRIVS.GRANTOR = ALL_USERS.USERNAME
WHERE USERNAME = 'ETUDIANT';
