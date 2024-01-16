-- Implementation des contraintes de la table HABITAT
ALTER TABLE HABITAT ADD CONSTRAINT pk_habitat PRIMARY KEY (id);
ALTER TABLE HABITAT ADD CONSTRAINT habitat_ph_validite CHECK (ph BETWEEN 0 AND 14);

-- Implementation des contraintes de la table ORGANISME
ALTER TABLE ORGANISME ADD CONSTRAINT pk_organisme PRIMARY KEY (genre, espece);
ALTER TABLE ORGANISME ADD CONSTRAINT fk_organisme FOREIGN KEY (id_habitat) REFERENCES HABITAT(id);

-- Implementation des contraintes de la table GENOME
ALTER TABLE GENOME ADD CONSTRAINT pk_genome PRIMARY KEY (id);
ALTER TABLE GENOME ADD CONSTRAINT fk_genome FOREIGN KEY (genre, espece) REFERENCES ORGANISME(genre, espece);
ALTER TABLE GENOME ADD CONSTRAINT genome_gcpourcent_validite CHECK (gcpourcent BETWEEN 0 AND 100);
ALTER TABLE GENOME ADD CONSTRAINT genome_chromosomes_validite CHECK (chromosomes > 0);
ALTER TABLE GENOME ADD CONSTRAINT genome_taille_validite CHECK (taille > 0);
ALTER TABLE GENOME ADD CONSTRAINT genome_genes_validite CHECK (genes > 0);

-- Implementation des contraintes de la table PROTEINE
ALTER TABLE PROTEINE ADD CONSTRAINT pk_proteine PRIMARY KEY (id);
ALTER TABLE PROTEINE ADD CONSTRAINT fk_proteine FOREIGN KEY (id_genome) REFERENCES GENOME(id);
ALTER TABLE PROTEINE ADD CONSTRAINT proteine_masse_validite CHECK (masse > 0);
ALTER TABLE PROTEINE ADD CONSTRAINT proteine_taille_validite CHECK (taille > 0);
ALTER TABLE PROTEINE ADD CONSTRAINT proteine_atomes_validite CHECK (atomes > 0);
ALTER TABLE PROTEINE ADD CONSTRAINT proteine_sous_unites_validite CHECK (sous_unites > 0);

-- Implementation des contraintes de la table EXPERIENCE
ALTER TABLE EXPERIENCE ADD CONSTRAINT pk_experience PRIMARY KEY (id);
ALTER TABLE EXPERIENCE ADD CONSTRAINT fk_experience FOREIGN KEY (id_proteine) REFERENCES PROTEINE(id);

-- Implementation des contraintes de la table HOMOLOGUE
ALTER TABLE HOMOLOGUE ADD CONSTRAINT fk_homologue1 FOREIGN KEY (id_proteine1) REFERENCES PROTEINE(id);
ALTER TABLE HOMOLOGUE ADD CONSTRAINT fk_homologue2 FOREIGN KEY (id_proteine2) REFERENCES PROTEINE(id);
ALTER TABLE HOMOLOGUE ADD CONSTRAINT homologie_reflexive CHECK (id_proteine1 != id_proteine2);

-- Implementation des contraintes de la table DOMAINE
ALTER TABLE DOMAINE ADD CONSTRAINT pk_domaine PRIMARY KEY (id);
ALTER TABLE DOMAINE ADD CONSTRAINT fk_domaine FOREIGN KEY (id_proteine) REFERENCES PROTEINE(id);
ALTER TABLE DOMAINE ADD CONSTRAINT domaine_intervalle CHECK (debut > 0 AND fin > 0 AND debut + 1 < fin);

-- Implementation des contraintes de la table STRUCTURE_SECONDAIRE
ALTER TABLE STRUCTURE_SECONDAIRE ADD CONSTRAINT pk_structure PRIMARY KEY(id);
ALTER TABLE STRUCTURE_SECONDAIRE ADD CONSTRAINT fk_structure FOREIGN KEY(id_proteine) REFERENCES PROTEINE(id);
ALTER TABLE STRUCTURE_SECONDAIRE ADD CONSTRAINT structure_intervalle CHECK (debut > 0 AND fin > 0 AND debut + 1 < fin);
