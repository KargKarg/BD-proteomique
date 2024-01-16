-- Implementation de la fonction renvoyant la taille correspondant au 10 percentile
CREATE OR REPLACE FUNCTION dixieme_percentile_taille RETURN NUMBER IS
	taille_10 NUMBER;
	BEGIN
		SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY taille) INTO taille_10 FROM PROTEINE;
		RETURN taille_10;
	END;
/

-- Implementation de la fonction renvoyant la taille correspondant au 90 percentile
CREATE OR REPLACE FUNCTION quatre_vingt_dix_taille RETURN NUMBER IS
	taille_90 NUMBER;
	BEGIN
		SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY taille) INTO taille_90 FROM PROTEINE;
		RETURN taille_90;
	END;
/

-- Implementation de la fonction renvoyant un curseur avec différentes statistiques sur la proteine
CREATE OR REPLACE FUNCTION info_proteine(id_prot PROTEINE.id%TYPE) RETURN SYS_REFCURSOR IS
	nb_helice NUMBER := 0;
	nb_brin NUMBER := 0;
	nb_boucle NUMBER := 0;
	taille_helice NUMBER := 0;
	taille_brin NUMBER := 0;
	taille_boucle NUMBER := 0;
	moyenne_helice NUMBER := NULL;
	moyenne_brin NUMBER := NULL;
	moyenne_boucle NUMBER := NULL;
	resultats SYS_REFCURSOR;
	CURSOR rez IS SELECT * FROM STRUCTURE_SECONDAIRE WHERE STRUCTURE_SECONDAIRE.id_proteine = id_prot;
	BEGIN
		FOR struct IN rez LOOP
			IF struct.nom = 'helix' THEN
				nb_helice := nb_helice + 1;
				taille_helice := taille_helice + (struct.fin - struct.debut);
			ELSIF struct.nom = 'strand' THEN
				nb_brin := nb_brin + 1;
				taille_brin := taille_brin + (struct.fin - struct.debut);
			ELSE
				nb_boucle := nb_boucle + 1;
				taille_boucle := taille_boucle + (struct.fin - struct.debut);
			END IF;
		END LOOP;
		IF nb_helice > 0 THEN
			moyenne_helice := taille_helice/nb_helice; 
		END IF;		
		IF nb_brin > 0 THEN		
			moyenne_brin := taille_brin/nb_brin;
		END IF;
		IF nb_boucle > 0 THEN
			moyenne_boucle := taille_boucle/nb_boucle;
		END IF;
		OPEN resultats FOR SELECT nb_helice, nb_brin, nb_boucle, taille_helice, taille_brin, taille_boucle, moyenne_helice, moyenne_brin, moyenne_boucle FROM DUAL;
		RETURN resultats;
	END;
/

-- Implementation de la fonction renvoyant un curseur avec différentes statistiques sur le domaine
CREATE OR REPLACE FUNCTION info_domaine(debut_dom DOMAINE.debut%TYPE, fin_dom DOMAINE.fin%TYPE, id_prot PROTEINE.id%TYPE) RETURN SYS_REFCURSOR IS
	nb_helice NUMBER := 0;
	nb_brin NUMBER := 0;
	nb_boucle NUMBER := 0;
	resultats SYS_REFCURSOR;
	CURSOR rez IS SELECT * FROM STRUCTURE_SECONDAIRE WHERE STRUCTURE_SECONDAIRE.id_proteine = id_prot;
	BEGIN
		FOR struct IN rez LOOP
			IF (debut_dom < struct.debut AND fin_dom > struct.debut) OR (debut_dom < struct.fin AND fin_dom > struct.fin) THEN
				IF struct.nom = 'helix' THEN
					nb_helice := nb_helice + 1;
				ELSIF struct.nom = 'strand' THEN
					nb_brin := nb_brin + 1;
				ELSE
					nb_boucle := nb_boucle + 1;
				END IF;
			END IF;
		END LOOP;	
		OPEN resultats FOR SELECT nb_helice, nb_brin, nb_boucle FROM DUAL;
		RETURN resultats;
	END;
/

-- Implementation de la fonction renvoyant l'id du domaine dans lequel la position est.
CREATE OR REPLACE FUNCTION position_to_domaine(struct_debut STRUCTURE_SECONDAIRE.debut%TYPE, struct_fin STRUCTURE_SECONDAIRE.fin%TYPE, id_prot PROTEINE.id%TYPE) RETURN DOMAINE.id%TYPE IS
	localisation DOMAINE.id%TYPE := 0;
	CURSOR rez_dom IS SELECT * FROM DOMAINE WHERE DOMAINE.id_proteine = id_prot;
	BEGIN
		FOR dom in rez_dom LOOP
			IF (dom.debut < struct_debut AND dom.fin > struct_debut) OR (dom.debut < struct_fin AND dom.fin > struct_fin) THEN
				localisation := dom.id;
				EXIT WHEN localisation > 0;
			END IF;
		END LOOP;
		RETURN localisation;
	END;
/

-- Implementation de la fonction renvoyant une liste d'ID de proteine contenant plus de 'seuil' helice et brin successif
CREATE OR REPLACE FUNCTION tim_barrel(seuil NUMBER) RETURN SYS.ODCINUMBERLIST IS
	l_ids SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
	CURSOR rez_struct IS SELECT *
				FROM STRUCTURE_SECONDAIRE
				ORDER BY STRUCTURE_SECONDAIRE.id_proteine, STRUCTURE_SECONDAIRE.debut;
	cpt NUMBER := 0;
	max_local NUMBER := 0;
	precedent_id STRUCTURE_SECONDAIRE.id_proteine%TYPE := 0;
	precedente_structure STRUCTURE_SECONDAIRE.nom%TYPE := '0';
	BEGIN
		FOR struct in rez_struct LOOP
			IF precedent_id = 0 THEN
				precedent_id := struct.id_proteine;
			END IF;
			IF precedent_id != struct.id_proteine THEN
				IF max_local > seuil THEN
					l_ids.EXTEND;
					l_ids(l_ids.COUNT) := precedent_id;
				END IF;
				cpt := 0;
				max_local := 0;
				precedent_id := struct.id_proteine;
			END IF;
			IF precedente_structure = '0' AND struct.nom IN ('helix' , 'strand') THEN
				precedente_structure := struct.nom;
				cpt := cpt + 1;
			ELSIF precedente_structure = 'helix' AND struct.nom = 'strand' THEN
				precedente_structure := struct.nom;
				cpt := cpt + 1;
			ELSIF precedente_structure = 'strand' AND struct.nom = 'helix' THEN
				precedente_structure := struct.nom;
				cpt := cpt + 1;
			ELSE
				max_local := GREATEST(max_local, cpt);
				IF struct.nom IN ('helix','strand') THEN
					cpt := 1;
				END IF;
				precedente_structure := struct.nom;
			END IF;
		END LOOP;
		IF max_local > seuil THEN
			l_ids.EXTEND;
			l_ids(l_ids.COUNT) := precedent_id;
		END IF;
		RETURN l_ids;
	END;
/
			
		
