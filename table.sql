-- Implémentation de la table HABITAT
CREATE TABLE HABITAT(
    id number,
    temperature number,
    humidite varchar(30),
    biome varchar(30),
    ph number
);

-- Implémentation de la table ORGANISME
CREATE TABLE ORGANISME(
    genre varchar(20),
    espece varchar(20),
    id_habitat number(3) NOT NULL,
    phyla varchar(20) NOT NULL,
    gram varchar(20),
    hote varchar(20)
);

-- Implémentation de la table GENOME
CREATE TABLE GENOME(
    id number(3),
    chromosomes number(2),
    taille number(15),
    gcpourcent number(5,2),
    genes number(5),
    genre varchar(20),
    espece varchar(20)
);

-- Implémentation de la table PROTEINE
CREATE TABLE PROTEINE(
    id number(3),
    famille varchar(35),
    nom varchar(60) NOT NULL,
    masse number(6,2) NOT NULL,
    atomes number(5),
    taille number(5) NOT NULL,
    sous_unites number(5),
    id_genome number(3)
);

-- Implémentation de la table EXPERIENCE
CREATE TABLE EXPERIENCE(
    id number(3),
    methode varchar(30),
    date_exp date,
    laboratoire varchar(75),
    pays varchar(15),
    auteur varchar(20),
    id_proteine number(3)
);

-- Implémentation de la table HOMOLOGUE
CREATE TABLE HOMOLOGUE(
    id_proteine1 number(3),
    id_proteine2 number(3)
);

-- Implémentation de la table DOMAINE
CREATE TABLE DOMAINE(
    id number(3),
    debut number(5) NOT NULL,
    fin number(5) NOT NULL,
    nom varchar(35),
    id_proteine number(3)
);

-- Implémentation de la table STRUCTURE_SECONDAIRE
CREATE TABLE STRUCTURE_SECONDAIRE(
    id number(4),
    debut number(5),
    fin number(5),
    nom varchar(15),
    id_proteine number(3)
);

