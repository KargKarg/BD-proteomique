-- Implementation du trigger permettant de vérifier si le domaine est dans la protéine ou non
CREATE OR REPLACE TRIGGER domaine_intervalle
	BEFORE INSERT ON DOMAINE FOR EACH ROW
	DECLARE
    		limite PROTEINE.taille%TYPE;
	BEGIN
    		SELECT PROTEINE.taille INTO limite FROM PROTEINE WHERE PROTEINE.id = :new.id_proteine;
    		IF :new.fin > limite THEN
        		RAISE_APPLICATION_ERROR(-10, 'Le domaine n''est pas inclus dans la protéine.');
		    END IF;
	END;
/

-- Implementation du trigger permettant de vérifier si la structure secondaire est dans la protéine ou non
CREATE OR REPLACE TRIGGER structure_intervalle
	BEFORE INSERT ON STRUCTURE_SECONDAIRE FOR EACH ROW
	DECLARE
    		limite PROTEINE.taille%TYPE;
	BEGIN
    		SELECT PROTEINE.taille INTO limite FROM PROTEINE WHERE PROTEINE.id = :new.id_proteine;
    		IF :new.fin > limite THEN
        		RAISE_APPLICATION_ERROR(-11, 'La structure n''est pas incluse dans la protéine.');
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table HABITAT
CREATE OR REPLACE TRIGGER sequence_habitat
	BEFORE INSERT ON HABITAT FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_habitat.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table GENOME
CREATE OR REPLACE TRIGGER sequence_genome
	BEFORE INSERT ON GENOME FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_genome.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table PROTEINE
CREATE OR REPLACE TRIGGER sequence_proteine
	BEFORE INSERT ON PROTEINE FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_proteine.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table EXPERIENCE 
CREATE OR REPLACE TRIGGER sequence_experience
	BEFORE INSERT ON EXPERIENCE FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_experience.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table DOMAINE
CREATE OR REPLACE TRIGGER sequence_domaine
	BEFORE INSERT ON DOMAINE FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_domaine.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger permettant d'insérer en séquence dans la table STRUCTURE_SECONDAIRE
CREATE OR REPLACE TRIGGER sequence_structure_secondaire
	BEFORE INSERT ON STRUCTURE_SECONDAIRE FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			SELECT insertion_sequence_structure.nextval INTO :new.id FROM DUAL;
		END IF;
	END;
/

-- Implementation du trigger empêchant la suppression des protéines associées à un article
CREATE OR REPLACE TRIGGER suppression_securise
	BEFORE DELETE ON PROTEINE FOR EACH ROW
	BEGIN
		UPDATE EXPERIENCE SET EXPERIENCE.id = EXPERIENCE.id WHERE EXPERIENCE.id_proteine = :new.id;
		IF SQL%ROWCOUNT > 0 THEN
			RAISE_APPLICATION_ERROR(10, 'La protéine a un article associé');
		END IF;
	END;
/

-- Implementation du trigger contraignant l'insertion par début croissant des domaines
CREATE OR REPLACE TRIGGER croissant_domaine
	BEFORE INSERT ON DOMAINE FOR EACH ROW
	DECLARE
		precedent DOMAINE.debut%TYPE;
	BEGIN
		SELECT debut INTO precedent
		FROM (
			SELECT debut
			FROM DOMAINE
			WHERE id_proteine = :new.id_proteine
			ORDER BY debut DESC)
  		WHERE ROWNUM = 1;
		IF precedent IS NOT NULL AND :new.debut < precedent THEN
			RAISE_APPLICATION_ERROR(-13, 'L''insertion ne se fait pas de manière croissante');
		END IF;
	END;
/

-- Implementation du trigger empêchant la modification des domaines associées à des articles de plus de 10 ans.
CREATE OR REPLACE TRIGGER modification_domaine
	BEFORE UPDATE ON DOMAINE FOR EACH ROW
	DECLARE
		lim EXPERIENCE.date_exp%TYPE;
	BEGIN
		SELECT EXPERIENCE.date_exp INTO lim FROM EXPERIENCE WHERE EXPERIENCE.id_proteine = :new.id_proteine;
		IF lim < ADD_MONTHS(SYSDATE, -12 * 10) THEN
			RAISE_APPLICATION_ERROR(-14, 'Les domaines ne peuvent pas etre modifiees');
		END IF;
	END;
/

-- Implementation du trigger empêchant la modification des structures associées à des articles de plus de 10 ans. 
CREATE OR REPLACE TRIGGER modification_structure
	BEFORE UPDATE ON STRUCTURE_SECONDAIRE FOR EACH ROW
	DECLARE
		lim EXPERIENCE.date_exp%TYPE;
	BEGIN
		SELECT EXPERIENCE.date_exp INTO lim FROM EXPERIENCE WHERE EXPERIENCE.id_proteine = :new.id_proteine;
		IF lim < TO_DATE('01-01-2013', 'DD-MM-YYYY') THEN
			RAISE_APPLICATION_ERROR(-14, 'Les structures ne peuvent pas etre modifiees');
		END IF;
	END;
/

-- Implementation du trigger contraignant le respect de la nomenclature de Linné, genre = '[A-Z][a-z]*', espèce = '[a-z]*'
CREATE OR REPLACE TRIGGER nomenclature
	BEFORE INSERT OR UPDATE ON ORGANISME FOR EACH ROW
	DECLARE
		premier_genre CHAR(1);
		suite_genre VARCHAR2(50);
		tout_espece VARCHAR2(50);
	BEGIN
		premier_genre := UPPER(SUBSTR(:new.genre, 1, 1));
		suite_genre := LOWER(SUBSTR(:new.genre, 2));
		tout_espece := LOWER(:new.espece);
		IF premier_genre = SUBSTR(:new.genre, 1, 1) THEN
			IF suite_genre = SUBSTR(:new.genre, 2) THEN
				IF tout_espece = :new.espece THEN
					NULL;
				ELSE
					RAISE_APPLICATION_ERROR(-19, 'Cela ne respecte pas la nomenclature');
				END IF;
			ELSE
				RAISE_APPLICATION_ERROR(-19, 'Cela ne respecte pas la nomenclature');
			END IF;
		ELSE
			RAISE_APPLICATION_ERROR(-19, 'Cela ne respecte pas la nomenclature');
		END IF;
	END;
/

-- Implementation du trigger permettant de gérer les domaines chevauchants en ne considérant que le domaine le plus grand
CREATE OR REPLACE TRIGGER domaine_chevauchant
	BEFORE INSERT OR UPDATE ON DOMAINE FOR EACH ROW
	DECLARE
		CURSOR rez_dom IS SELECT * FROM DOMAINE WHERE DOMAINE.id_proteine = :new.id_proteine;
		taille_insert NUMBER := 0;
		taille_table NUMBER := 0;
	BEGIN
		FOR dom in rez_dom LOOP
			IF (:new.debut < dom.fin AND :new.debut > dom.debut) OR (:new.fin < dom.fin AND :new.fin > dom.debut) THEN
				taille_insert := :new.fin - :new.debut;
				taille_table := dom.fin - dom.debut;
				IF taille_insert > taille_table THEN
					DELETE FROM DOMAINE WHERE id = dom.id;
				ELSE
					RAISE_APPLICATION_ERROR(-28, 'Le domaine chevauche un domaine plus grand');
				END IF;
			END IF;
		END LOOP;
	END;
/

-- Implementation du trigger permettant de gérer les structures chevauchantes en ne considérant que la plus grande
CREATE OR REPLACE TRIGGER structure_chevauchante
	BEFORE INSERT OR UPDATE ON DOMAINE FOR EACH ROW
	DECLARE
		CURSOR rez_str IS SELECT * FROM STRUCTURE_SECONDAIRE WHERE STRUCTURE_SECONDAIRE.id_proteine = :new.id_proteine;
		taille_insert NUMBER := 0;
		taille_table NUMBER := 0;
	BEGIN
		FOR struct in rez_str LOOP
			IF (:new.debut < struct.fin AND :new.debut > struct.debut) OR (:new.fin < struct.fin AND :new.fin > struct.debut) THEN
				taille_insert := :new.fin - :new.debut;
				taille_table := struct.fin - struct.debut;
				IF taille_insert > taille_table THEN
					DELETE FROM STRUCTURE_SECONDAIRE WHERE id = struct.id;
				ELSE
					RAISE_APPLICATION_ERROR(-28, 'La structure chevauche une structure plus grande');
				END IF;
			END IF;
		END LOOP;
	END;
/

-- Implementation du trigger permettant de la suppression du domaine associé après suppression d'une structure
CREATE OR REPLACE TRIGGER structure_fonction
	BEFORE DELETE ON STRUCTURE_SECONDAIRE FOR EACH ROW
	DECLARE
		CURSOR rez_dom IS SELECT * FROM DOMAINE WHERE DOMAINE.id_proteine = :new.id_proteine;
	BEGIN
		FOR dom IN rez_dom LOOP
			IF (:new.debut < dom.fin AND :new.debut > dom.debut) OR (:new.fin < dom.fin AND :new.fin > dom.debut) THEN
				DELETE FROM DOMAINE WHERE DOMAINE.id = dom.id;
			END IF;
		END LOOP;
	END;
/

-- Implementation du trigger permettant de mettre à jour la table STATS_PROTEINE à chaque insertion (TABLE MUTANTE)
CREATE OR REPLACE TRIGGER statistiques_proteine
	AFTER INSERT ON STRUCTURE_SECONDAIRE FOR EACH ROW
	DECLARE
		nouv_nb_helice NUMBER := 0;
		nouv_nb_brin NUMBER := 0;
		nouv_nb_boucle NUMBER := 0;
		nouv_taille_helice NUMBER := 0;
		nouv_taille_brin NUMBER := 0;
		nouv_taille_boucle NUMBER := 0;
		nouv_moyenne_helice NUMBER := NULL;
		nouv_moyenne_brin NUMBER := NULL;
		nouv_moyenne_boucle NUMBER := NULL;
		resultats SYS_REFCURSOR;
	BEGIN
		resultats := info_proteine(:new.id, CURSOR(SELECT * FROM STRUCTURE_SECONDAIRE WHERE id = :new.id_proteine));
		FETCH resultats INTO nouv_nb_helice, nouv_nb_brin, nouv_nb_boucle, nouv_taille_helice, nouv_taille_brin, nouv_taille_boucle, nouv_moyenne_helice, nouv_moyenne_brin, nouv_moyenne_boucle;
		CLOSE resultats;
		IF nouv_nb_helice + nouv_nb_brin + nouv_nb_boucle = 1 THEN
			INSERT INTO STATS_PROTEINE VALUES (:new.id, nouv_nb_helice, nouv_nb_brin, nouv_nb_boucle, nouv_taille_helice, nouv_taille_brin, nouv_taille_boucle, nouv_moyenne_helice, nouv_moyenne_brin, nouv_moyenne_boucle);
		ELSE
			UPDATE STATS_PROTEINE 
			SET 
				nb_helice = nouv_nb_helice,
				nb_brin = nouv_nb_brin,
				nb_boucle = nouv_nb_boucle,
				taille_helice = nouv_taille_helice,
				taille_brin = nouv_taille_brin,
				taille_boucle = nouv_taille_boucle,
				moyenne_helice = nouv_moyenne_helice,
				moyenne_brin = nouv_moyenne_brin,
				moyenne_boucle = nouv_moyenne_boucle
			WHERE id = :new.id;
		END IF;
	END;
/

-- Implementation du trigger permettant de mettre à jour la vue taille_proteine (ERREUR)
CREATE OR REPLACE TRIGGER modif_taille_vue
	AFTER INSERT ON PROTEINE FOR EACH ROW
	DECLARE
		limite_haute NUMBER;
		limite_basse NUMBER;
	BEGIN
		limite_basse := dixieme_percentile_taille;
		limite_haute := quatre_vingt_dix_taille;
		DELETE FROM plus_petite WHERE plus_petite.taille > limite_basse;
		DELETE FROM plus_grande WHERE plus_grande.taille <= limite_haute;
		IF :new.taille > limite_haute THEN
			INSERT INTO plus_grande VALUES (
				:new.id,
				:new.famille,
				:new.nom,
				:new.masse,
				:new.atomes,
				:new.taille,
				:new.sous_unites,
				:new.id_genome);
		ELSIF :new.taille <= limite_basse THEN
			INSERT INTO plus_petite VALUES (
				:new.id,
				:new.famille,
				:new.nom,
				:new.masse,
				:new.atomes,
				:new.taille,
				:new.sous_unites,
				:new.id_genome);
		END IF;
	END;
/
