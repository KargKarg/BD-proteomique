LOAD DATA
INFILE *
APPEND 
INTO TABLE ORGANISME
FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"'
(phyla,gram,hote,genre,espece,id_habitat)
BEGINDATA
'Archaea','None','None','Methanocaldococcus','jannaschii',1,
'Archaea','None','None','Saccharolobus','solfataricus',2,
'Bacteria','-','Homo sapiens','Treponema','pallidum',3,
'Bacteria','+','None','Bacillus','subtilis',4,
'Bacteria','-','None','Salmonella','enterica',5,
'Bacteria','-','None','Thermus','aquaticus',6,
'Bacteria','-','Homo sapiens','Haemophilus','haemolyticus',7,
'Bacteria','-','Homo sapiens','Haemophilus','parahaemolyticus',7,
'Bacteria','-','Homo sapiens','Escherichia','coli',8,
'Bacteria','-','Sus scrofa','Yersinia','enterocolitica',9,
'Bacteria','-','Rattus rattus','Yersinia','pestis',9,
'Bacteria','+','Bos taurus','Lactococcus','lactis',9,
'Bacteria','-','Homo sapiens','Enterobacter','cloacae',8,
'Bacteria','+','None','Alicyclobacillus','acidocaldarius',6,
'Bacteria','-','None','Thermus','thermophilus',1,
'Eukaryota','None','None','Homo','sapiens',10,
'Eukaryota','None','None','Aspergillus','niger',11,
'Eukaryota','None','None','Rattus','norvegicus',10,
'Eukaryota','None','None','Saccharomyces','cerevisiae',11,
'Eukaryota','None','None','Bos','taurus',10,
'Eukaryota','None','None','Sus','scrofa',10,
'Eukaryota','None','None','Mus','musculus',10,
'Eukaryota','None','None','Gallus','gallus',10,
'Viruses','None','Escherichia coli','Tequatrovirus','T4',8,
