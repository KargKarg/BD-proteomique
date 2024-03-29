LOAD DATA
INFILE *
APPEND 
INTO TABLE DOMAINE
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(id,nom,debut,fin,id_proteine)
BEGINDATA
1,'Thioredoxin',2,105,1,
2,'GMC oxidoreductase',42,352,2,
3,'GMC oxidoreductase',452,593,2,
4,'Methyltransferase',7,239,3,
5,'ABC transporter',41,347,4,
6,'Phosphotransferase',51,297,5,
7,'CheR-type methyltransferase',15,286,7,
8,'Rhodopsin receptor',50,326,8,
9,'G-alpha',32,354,9,
10,'G-alpha',32,354,10,
11,'Methyltransferase',99,210,11,
12,'TaqI Like',291,405,11,
13,'SAM-dependent MTase C5-type',12,325,12,
14,'SAM-dependent MTase C5-type',12,325,13,
15,'Crispr',2,459,14,
16,'Initiation factor',15,77,15,
17,'Initiation factor',15,77,16,
18,'Chaperone',6,118,17,
19,'Chaperone',6,118,18,
20,'Enterocin A immunity',17,76,19,
21,'TPS secretion',36,212,20,
22,'TPS secretion',36,212,21,
23,'Thioredoxin',1,105,22,
24,'Thioredoxin',1,105,23,
25,'Phosphoglycerate kinase',9,404,25,
26,'Phosphoglycerate kinase',9,404,26,
27,'Serpin',1,70,30,
28,'Serpin',1,70,31,
29,'MPN',2182,2311,33,
30,'snRNA intercating',1514,1671,33,
31,'Recognition motif of spliceosome',1059,1149,33,
32,'Helicase ATP-binding',23,408,34,
33,'Helicase C-terminal',425,591,34,
34,'UVR',611,646,34,
35,'Insulin',28,50,35,
36,'Insulin',28,109,36,
37,'Peptidase S1',9,229,37,
38,'Peptidase S1',24,244,38,
39,'NR LBD',163,407,39,
40,'NNMT',16,279,40,
41,'ATP Synthase',1,79,41,
42,'YiDC perisplasmic',61,343,42,
43,'60Kd inner membrane protein',354,533,42,
44,'bHLH',369,421,43,
45,'bZIP',225,281,44,
46,'FERM',34,420,45,
47,'FERM',34,420,45,
48,'FERM',34,420,45,
49,'FERM',34,420,45,
50,'FERM',37,380,46,
51,'Protein kinase 1',545,809,46,
52,'Protein kinase 2',849,1124,46,
53,'PDZ 1',258,349,47,
54,'PDZ 2',355,447,47,
55,'C-type lysozyme',19,147,48,
56,'C-type lysozyme',19,147,49,
57,'C-type lysozyme',19,147,50,
58,'SH2',401,482,50,
