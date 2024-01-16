LOAD DATA
INFILE *
APPEND 
INTO TABLE GENOME
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(id,chromosomes,taille,gcpourcent,genes,genre,espece)
BEGINDATA
1,24,3298430636,40.5,59652,'Homo','sapiens',
2,8,33975768,50,14404,'Aspergillus','niger',
3,1,168903,35,288,'Tequatrovirus','T4',
4,1,1139502,52.5,1037,'Treponema','pallidum',
5,1,3929321,43.5,4536,'Bacillus','subtilis',
6,22,2647915728,41.5,42049,'Rattus','norvegicus',
7,2,4721537,52,4717,'Salmonella','enterica',
8,5,2338641,68,2553,'Thermus','aquaticus',
9,1,1895310,38,1863,'Haemophilus','haemolyticus',
10,2,2081464,40,2047,'Haemophilus','parahaemolyticus',
11,1,5980817,50.5,4639,'Escherichia','coli',
12,3,1739927,31,1904,'Methanocaldococcus','jannaschii',
13,3,4754952,47,4113,'Yersinia','enterocolitica',
14,3,4476274,47.5,4234,'Yersinia','pestis',
15,1,2443782,34.5,2391,'Lactococcus','lactis',
16,3,5183553,54.5,4819,'Enterobacter','cloacae',
17,4,3124048,61.5,3188,'Alicyclobacillus','acidocaldarius',
18,16,12157105,38,6470,'Saccharomyces','cerevisiae',
19,1,3024820,35.5,2922,'Saccharolobus','solfataricus',
20,31,2770686120,42,37073,'Bos','taurus',
21,3,2143732,69,2280,'Thermus','thermophilus',
22,20,2501912388,41.5,30371,'Sus','scrofa',
23,21,2728222451,41.5,50562,'Mus','musculus',
24,41,1050511239,42,25635,'Gallus','gallus',
