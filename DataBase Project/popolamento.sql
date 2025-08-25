USE pbs;

/*inserimento di 2 Zone geografiche----------*/

insert into areageografica values 
			("Valdera", 16.23, 8.20, 7.50),
			("Lungomonte", 3.56, 5.69, 3.21);
            
/*rischio-------------------------------*/

insert into rischio values
			('alluvioni', 3, 'Valdera'),
            ('terremoti', 1, 'Lungomonte'),
            ('frane', 2, 'Lungomonte'),
            ('Siccità', 3, 'Valdera');

/*inserimento di edifici0-------------------*/

insert into edificio values
			("A0", 18.598, 3.236, "VILLETTA", "Valdera");
            
insert into piano values
			(0,"A0");
            
insert into vano values
			(1, "cucina", 6, 5, 4, 0, "A0"),
            (2, "soggiorno", 6, 9, 4, 0, "A0"),
            (3, "bagno", 6, 5, 4, 0, "A0"),
            (4, "camera", 12, 5, 4, 0, "A0"),
            (5, "cortile", 12, 10, NULL, 0, "A0");
			
insert into muro values 
			(1, 0, 24, 12, 24, 5),
            (2, 0, 14, 0, 24, 5),
            (3, 0, 14, 12, 14, 5),
            (4, 12, 14, 12, 24, 5),
            (5, 0, 5, 0, 14, 2),
            (6, 0, 5, 6, 5, 2),
            (7, 6, 5, 6, 14, 2),
            (8, 6, 9, 12, 9, 1),
            (9, 12, 9, 12, 14, 1),
            (10, 6, 4, 6, 5, 3),
            (11, 6, 4, 12, 4, 3),
            (12, 12, 4, 12, 9, 3),
            (13, 0, 0, 0, 5, 4),
            (14, 0, 0, 12, 0, 4),
            (15, 12, 0, 12, 4, 4);
            
insert into apertura values 
			("centrale", 1, "cancello", 1.6, 1.7, "SUD"),
            ("laterale-basso", 3, "porta", 1.5, 2.3, "SUD"),
            ("laterale-alto", 3, "porta-finestra", 2, 2.1, "SUD"),
            ("laterale-alto", 7, "porta", 1.5, 2.1, "OVEST"),
            ("centrale-basso", 7, "porta", 1.4, 2.1, "EST"),
            ("centrale", 6, "porta", 1.5, 2.1, "SUD"),
            ("centrale", 11, "porta", 1.4, 2.1, "NORD"),
            ("centrale", 5, "finestra", 3, 2.5, "OVEST"),
            ("centrale", 9, "finestra", 2, 2, "EST"),
            ("centrale", 12, "finestra", 0.5, 0.5, "EST"),
            ("laterale-basso", 14, "finestra", 3, 2.5, "SUD");
            
            
/*inserimento materiali--------------------*/

insert into materiale values
			(001, "Fenice", 40, "intonaco per interni", 40, 7, '2010-04-10'),
            (002, "Fenice", 20, "intonaco per interni", 20, 8, '2010-04-10'),
            (003, "Fenice", 60, "intonaco per esterni", 60, 5, '2010-04-10'),
            (004, "OBI", 15, "mattoni per fondamenta", 15, 85, '2010-01-04'),
            (005, "OBI", 25, "mattoni per costruzione", 25, 110, '2010-01-05'),
            (006, "Bricoman", 450, "piastrelle bagno", 450, 1, '2010-04-02'),
            (007, "Bricoman", 250, "piastrelle cucina", 250, 2, '2010-04-02'),
            (008, "Bertini", 3, "legname per interno", 3, 99, '2010-04-08'),
            (009, "Bricoman", 12, "metallo da costruzione", 12, 100, '2010-02-06'),
            (010, "OBI", 3, "decorazioni per esterni", 3, 20, '2010-03-09'),
            (011, "OBI", 100, "rivestimento tetto", 100, 129, '2010-03-12');
            
insert into intonaco values
			("intonaco bianco granulato", 001),
            ("intonaco beije in polvere", 002),
            ("intonaco giallo idrofobico", 003);            
insert into mattone values
			("struttra cava", "calcestruzzo", 10, 004),
            ("mattoni pieni", "terracotta", 10, 005);
insert into piastrella values
			("barocca qaudrata", "stretta", 12, 006),
            ("floreale quadrata", "normale", 8, 007);
insert into legno values
			("parquet in abete", 008);
insert into metallo values
			("acciaio", 009);
insert into materialegenerico values
			("ciottoli per aiuole", 010),
            ("tegole in terracotta", 011);
            
/*inserimento lavoratori--------------*/

call nuovo_lavoratore('RSSMRA81A06D403J', 12, 'MARIO', 'ROSSI', 6);
call nuovo_lavoratore('VRDLCU73P13G702Z', 13, 'LUCA', 'VERDI', 7);
call nuovo_lavoratore('LFRMRA94B27H501X', 10, 'MAURO', 'ALFREDINI', NULL);
call nuovo_lavoratore('CCGKVN00T31E625D', 10, 'KEVIN', 'ACCIUGA', NULL);
call nuovo_lavoratore('RSSSND89A10G702I', 10, 'SECONDO', 'ROSSI', NULL);

/*inserimento sensori e grandezze--------------*/

insert into sensore values
					(1, 6, 7.5, 3, 35, 'termometro', 'A0'),
                    (2, 12, 12, 3.9, 10,  'sensore anti incendio', 'A0'),
                    (3, 6, 18, 0.2, 1, 'sensore di movimento', 'A0'),
                    (5, 7,10,4, 35, 'termometro', 'A0'),
                    (6, 8, 2, 3.3, 20, 'pluviometro', 'A0'),
                    (7, 1, 9, 2.2, 35, 'Termometro', 'A0');

insert into grandezza values
					('2018-01-01 04:56:01', 34, 1),
					('2019-01-19 03:14:07', 11, 2),
					('2020-05-23 02:05:33', 2, 3),
                    ('2023-02-25 16:00:30', 39, 5),
                    ('2023-02-10 01:20:15', 25, 6),
                    ('2023-02-13 12:10:02', 20, 7),
                    ('2023-02-16 12:40:00', 3, 3),
                    ('2023-02-27 10:05:01', 36, 1);
                    
                    
                    
/*inserimento calamità------------*/

insert into calamita values 
					('2013-01-09', 'terremoto', 18, 9, 10, 10),
					('2017-11-05', 'alluvione', 40, 40, 3, 2);

/*danni-----------------------------*/

insert into danno values
					(56, 'crepa', 'cucina', '2013-01-09', 'terremoto', 'A0');

/*progetto edilizio--------------*/

insert into progettoedilizio values
					(1, '2008-01-10', '2009-03-20', 'A0');

/*stadi di avanzamento------------*/

insert into stadiodiavanzamento values
					(11, '2010-01-01', '2010-03-01', '2010-04-12', 1),
					(12, '2010-05-01', '2010-08-01', '2010-08-29', 1),
                    (13, '2010-09-01', '2010-12-01', '2010-12-12', 1);

/*lavori-------------------------*/

call inserimento_lavoro_generico(1, '2010-01-02', '2010-02-28', 11, 'A0');
call inserimento_lavoro_generico(2, '2010-02-01', '2010-04-12', 11, 'A0');
call inserimento_lavoro_generico(3, '2010-05-02', '2010-07-20', 12, 'A0');
call inserimento_lavoro_generico(4, '2010-09-02', '2010-10-03', 13, 'A0');
call inserimento_lavoro_generico(5, '2010-09-20', '2010-10-31', 13, 'A0');
call inserimento_lavoro_generico(6, '2010-12-01', '2010-12-12', 13, 'A0');

insert into operazionesuvano values (3, 1),(3, 2),(3, 3),(3, 4),(3, 5);
insert into operazionesumuro values (4, 1),(4, 2),(4, 3),(4, 4),(4, 5),(4, 6),(4, 7),(4, 8),(4, 9),
									(5, 10),(5, 11),(5, 12),(5, 13),(5, 14),(5, 15),
									(6, 1),(6, 2),(6, 3),(6, 4),(6, 5),(6, 6),(6, 7),(6, 8),(6, 9),(6, 10),(6, 11),(6, 12),(6, 13),(6, 14),(6, 15);

/*inserimento in utilizzo--------*/

insert into utilizzo values 
							(14, 1, 004), (9, 2, 009),
                            (24, 3, 005), (3, 3, 008), (2, 3, 009),
                            (422, 4, 006), (222, 4, 007), (38, 5, 001), (19, 5, 002), (55, 5, 003),
                            (3, 6, 010),(99, 6, 011);

/*turni-----------------------*/

insert into turno values 
							('2010-03-02','2010-03-30', 8, 'RSSMRA81A06D403J',1),
                            ('2010-03-02','2010-03-30', 8, 'LFRMRA94B27H501X',1),
                            ('2010-03-02','2010-03-30', 8, 'CCGKVN00T31E625D',1),
                            ('2010-04-01','2010-04-12', 7, 'VRDLCU73P13G702Z', 2),
                            ('2010-04-01','2010-04-12', 7, 'RSSSND89A10G702I', 2),
                            ('2010-08-02','2010-08-20', 7,  'RSSMRA81A06D403J', 3),
                            ('2010-08-02','2010-08-20', 7,  'LFRMRA94B27H501X', 3),
                            ('2010-08-02','2010-08-20', 7,  'CCGKVN00T31E625D', 3),
                            ('2010-09-02', '2010-10-03', 6, 'VRDLCU73P13G702Z', 4),
                            ('2010-09-02', '2010-10-03', 6, 'RSSSND89A10G702I', 4),
                            ('2010-09-20', '2010-10-31', 7, 'RSSMRA81A06D403J', 5),
                            ('2010-09-20', '2010-10-31', 7, 'CCGKVN00T31E625D', 5),
                            ('2010-12-01', '2010-12-12', 5, 'RSSMRA81A06D403J', 6),
                            ('2010-12-01', '2010-12-12', 5, 'LFRMRA94B27H501X', 6);