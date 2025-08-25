				-- OPERAZIONI --
use pbs;
-- 1) LETTURA QUANTITA' RIMASTA DI UN DATO MATERIALE
drop procedure if exists quantita_rimasta;
delimiter $$
create procedure quantita_rimasta (in _mat int, out matRimasto_ int)
begin

select M.quantitaRimasta
from materiale M
where _mat = M.codiceLotto
into matRimasto_;

end $$
delimiter ;

-- 2) INSERIMENTO DI UN NUOVO LAVORO GENERICO SU EDIFICIO
drop procedure if exists inserimento_lavoro_generico;
delimiter $$
create procedure inserimento_lavoro_generico (in _idL int, _dataI date, _dataF date, _codiceS int, _codiceE VARCHAR(10))  
begin

insert into lavoro
values (_idL, _dataI, _dataF, _codiceS);

insert into operazioneSuEdificio
values (_idL, _codiceE);

end $$
delimiter ;

-- 3) CALCOLO COSTO DI UN LAVORO
DROP FUNCTION IF EXISTS calcolo_costo_lavoro;
DELIMITER $$
CREATE FUNCTION calcolo_costo_lavoro (lavoro INT)
RETURNS DOUBLE READS SQL DATA
BEGIN
	-- costo della paga degli operai
	DECLARE costoOperai DOUBLE ;
    -- costo dei materiali utilizzati per quel lavoro
    DECLARE costoMateriale DOUBLE ;
    -- costo totale per un determinato lavoro
    DECLARE costo DOUBLE ;
        
    SET costoOperai=(
		WITH tot_ore AS(
			SELECT LA.codiceFiscale, SUM(T.orario) AS totaleOre
        FROM lavoro L INNER JOIN turno T ON L.idlavoro = T.lavoro_idlavoro
			INNER JOIN lavoratore LA ON T.lavoratore_codiceFiscale = LA.codiceFiscale
		where L.idlavoro = lavoro 
        group by LA.codiceFiscale        
	)
        
		SELECT SUM(LA.pagaoraria * T_O.totaleOre)
        FROM lavoratore LA NATURAL JOIN tot_ore T_O 
    );

	SET costoMateriale=(
		SELECT SUM(M.costo_unita * U.quantitaUtilizzata)
        FROM lavoro L INNER JOIN utilizzo U ON L.idlavoro = U.lavoro_idlavoro
			INNER JOIN materiale M ON U.materiale_codiceLotto = M.codiceLotto
		WHERE L.idlavoro = lavoro    
    );
    
    SET costo= costoOperai + costoMateriale;
    
    RETURN costo;
END $$
DELIMITER ;

-- 4) STAMPA DELLA DATA DI FINE EFFETTIVA OGNI VOLTA CHE SI CONCLUDE UNO STADIO DI AVANZAMENTO ED EVENTUALI COSTI AGGIUNTIVI
drop procedure if exists resoconto_avanzamento;
delimiter $$
create procedure resoconto_avanzamento (in codice int)
begin
with costiExtra as(
	select SA.codicestadiodiavanzamento , calcolo_costo_lavoro(LA.idlavoro) as costi
    from StadioDiAvanzamento SA
		inner join
        lavoro LA
        on SA.codicestadiodiavanzamento = LA.StadioDiAvanzamento_codicestadiodiavanzamento
        where codice = SA.codicestadiodiavanzamento and LA.datafine >= SA.stimadatafine
)
select s.stimadatafine, s.datafineeffettiva, SUM(C.costi) 
from StadioDiAvanzamento s
	natural join
    costiExtra C
where s.codicestadiodiavanzamento = codice
group by s.datafineeffettiva;

end $$
delimiter ;

drop trigger if exists stampa_avanzamento_concluso;
delimiter !!
create trigger stampa_avanzamento_concluso
after update on StadioDiAvanzamento
for each row
begin
if datafineeffettiva is not null then
	call resoconto_avanzamento(new.codicestadiodiavanzamento);
end if;
end !!
delimiter ;

-- 5) AL MOMENTO DELLA RICHIESTA LEGGERE IL VALORE MEDIO DELLE GRANDEZZE MISURATE NELL'ULTIMO GIORNO CHE PRESENTA GRANDEZZE DA UN DETERMINATO 
-- TIPO DI SENSORI RELATIVI A UN CERTO EDIFICIO

DROP FUNCTION IF EXISTS media_sensori;  -- AGGIUNTA SI UNA SUBQUERY PER INDIVIDUARE L'ULTIMA DATA A CUI SONO ATTRIBUITE GRANDEZZE
DELIMITER $$
CREATE FUNCTION media_sensori (cod_edificio VARCHAR(10), tipo_sensore VARCHAR(45))
RETURNS DOUBLE READS SQL DATA
BEGIN
	DECLARE media_tipo DOUBLE;
    
    SET media_tipo=(
		SELECT AVG(G.valore) 
		FROM Sensore S INNER JOIN Grandezza G ON S.codicesensore = G.Sensore_codicesensore
        WHERE S.Edificio_codiceEdificio = cod_Edificio AND S.tipo = tipo_sensore 
			AND G.Timestamp = (
								SELECT max(G.timestamp)
                                FROM   Sensore S2 INNER JOIN Grandezza G2 ON S2.codicesensore = G2.Sensore_codicesensore
                                WHERE  S2.Edificio_codiceEdificio = cod_Edificio AND S2.tipo = tipo_sensore 
							  ));
    
    RETURN media_tipo;
END $$
DELIMITER ;

-- 6) INSERIMENTO DI UN NUOVO LAVORATORE CON RELATIVI DATI
-- un capocantiere non può guadagnare meno di qualsiasi operaio
drop trigger if exists bloccaLA;
delimiter $$
create trigger bloccaLA
before insert on lavoratore
for each row
begin

if new.pagaoraria < 10 then 
	signal sqlstate '45000'
    set message_text = "lavoratore non inseribile, paga oraria insufficiente";
end if;
end $$
delimiter ;

drop procedure if exists nuovo_lavoratore;
delimiter !!
create procedure nuovo_lavoratore (codFiscale varchar(16), pagaO int, n varchar(45), c varchar(45), maxOp INT)
begin
insert into lavoratore values (codFiscale, pagaO, n, c);
if maxOp IS NULL then
	insert into operaio values(codFiscale);
else 
	insert into capocantiere values (maxOp, codFiscale);
end if;
end !!
delimiter ;

-- 7) PER OGNI AREA GEOGRAFICA TROVARE QUANTE VOLTE E' STATA COLPITA DA UNA CALAMITA' NEGLI ULTIMI 20 ANNI
DROP PROCEDURE IF EXISTS area_calamita;
DELIMITER $$
CREATE PROCEDURE area_calamita()
BEGIN
	SELECT A.Nome, COUNT(*) AS NCalamita
    FROM areageografica A INNER JOIN occorrenzacalamitosa O ON A.nome = O.AreaGeografica_nome
    WHERE O.Calamita_Data >= CURRENT_DATE - INTERVAL 20 YEAR
	GROUP BY A.Nome;
END $$
DELIMITER ;

-- 8) AL MOMENTO DELLA RICHIESTA MOSTRARE I TIPI DI SENSORI DI UN DETERMINATO EDIFICIO CHE HANNO GENERATO UN ALERT NEGLI ULTIMI 10 GIORNI
/*Dato in ingresso il codice di un determinato edificio, restituisce una stringa contenente tutti 
i tipi dei sensori che negli ultimi 10 giorni hanno restituito un valore che ha superato la 
soglia di sicurezza.*/
DROP PROCEDURE IF EXISTS alert_ultimi_10_giorni;
DELIMITER $$
CREATE PROCEDURE alert_ultimi_10_giorni(IN _edificio VARCHAR(45), OUT tipo_ VARCHAR(255))
BEGIN 
    DECLARE finito INTEGER DEFAULT 0;
    DECLARE sensori VARCHAR(255) DEFAULT '';
    DECLARE uscita  VARCHAR(255) DEFAULT '';
    
    DECLARE tipo_sensore CURSOR FOR
    SELECT S.tipo 
    FROM Sensore S INNER JOIN alert A ON S.codicesensore = A.Grandezza_Sensore_codicesensore
    WHERE S.Edificio_codiceEdificio = _edificio AND A.Grandezza_Timestamp >= CURRENT_DATE - INTERVAL 10 DAY;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET finito = 1;
    
    OPEN tipo_sensore;
    
    scan: LOOP
		FETCH tipo_sensore INTO sensori;    
        IF finito = 1 THEN
			LEAVE scan;
		END IF;
        SET uscita = CONCAT(uscita, sensori, ';');
    
    END LOOP scan;
    CLOSE tipo_sensore;
    SET   tipo_ = uscita;
END $$
DELIMITER ;




