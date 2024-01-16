LOAD DATA
INFILE *
APPEND 
INTO TABLE HABITAT
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(id,temperature,humidite,biome,ph)
BEGINDATA
1,80,'Sous-marin','Mont hydrothermal',2,
2,80,'Faible','Volcanique',3,
3,37,'Eleve','Vaginal',5,
4,40,'Moyenne','Sol',6,
5,30,'Sec','Aliment',7,
6,70,'Eleve','Source Yellow Stone',1,
7,37,'Moyenne','Voie respiratoire',7,
8,37,'Eleve','Tube digestif',3,
9,37,'Moyenne','Peau',7,
10,20,'Moyenne','Terrestre',7,
11,37,'Eleve','Fruit',2,
