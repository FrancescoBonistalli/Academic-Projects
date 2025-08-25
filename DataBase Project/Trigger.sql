	-- TRIGGER E EVENT ----
use pbs;
-- LE DATE DEGLI STADI DI AVANZAMENTO INERENTI ALLO STESSO PROGETTO EDILIZIO NON DEVONO INTERSECARSI
drop trigger if exists date_stadio_avanzamento;
delimiter $$
create trigger date_stadio_avanzamento
before insert on stadiodiavanzamento
for each row
begin

declare dataFStadio date default null;

select MAX(s.datafineeffettiva) into dataFStadio
from stadiodiavanzamento s
where s.progettoedilizio_codiceprogetto = new.progettoedilizio_codiceprogetto;

 if new.datainizio < dataFStadio then
 signal sqlstate '45000'
 set message_text = 'stadio di avanzamento non inseribile';
 end if;
 
end $$
delimiter ;

-- LE DATE DI INIZIO E FINE LAVORO DEVONO RISPETTARE I LIMITI DEGLI STADI DI AVANZAMENTO
drop trigger if exists date_lavoro;
delimiter $$
create trigger date_lavoro
before insert on lavoro
for each row
begin

declare dataIStadio date default null;

select s.datainizio into dataIStadio
from stadiodiavanzamento s	
where s.codicestadiodiavanzamento = new.stadiodiavanzamento_codicestadiodiavanzamento;

 if new.datainizio < dataIStadio then
 signal sqlstate '45000'
 set message_text = 'lavoro non inseribile';
 end if;
 
end $$
delimiter ;


-- TRIGGER CHE BLOCCA L'INSERIMENTO DI UN NUOVO CAPO CANTIERE SE LA SUA PAGA E' MINORE DI ALMENO UN OPERAIO
DROP TRIGGER IF EXISTS blocca_capo_cantiere;
DELIMITER $$
CREATE TRIGGER blocca_capo_cantiere BEFORE INSERT ON capocantiere
FOR EACH ROW
BEGIN
	DECLARE paga_max_operaio INTEGER DEFAULT 0;
    DECLARE paga_nuovo_lavoratore INTEGER DEFAULT 0;
    
    SET paga_max_operaio=(
		SELECT MAX(L.pagaoraria)
        FROM lavoratore L INNER JOIN operaio O ON L.codiceFiscale = O.lavoratore_codiceFiscale    
    );
    
    SELECT L.pagaoraria
    FROM lavoratore L INNER JOIN capocantiere C ON L.codiceFiscale = NEW.lavoratore_codiceFiscale
    INTO paga_nuovo_lavoratore;
    
    IF(paga_nuovo_lavoratore <= paga_max_operaio) THEN 
        DELETE FROM lavoratore L
        WHERE L.codiceFiscale = NEW.lavoratore_codiceFiscale;
	END IF;
    
END $$
DELIMITER ;

-- DURANTE OGNI TURNO IL NUMERO DI OPERAI DEVE ESSERE <= DI CAPO CANTIERE (MAX. OPERAI)
drop trigger if exists operai_massimi;
delimiter $$
create trigger operai_massimi
before insert on turno
for each row
begin

 declare numeroOperai int default 0;
 declare operaiMax int default 0;
 
select count(distinct t.lavoratore_codiceFiscale) into numeroOperai
from turno t
where t.datainizio = new.datainizio and t.datafine = new.datafine;

select sum(c.maxOperai) into operaiMax
from ( select distinct t.lavoratore_codiceFiscale as CD
	from turno t
	where t.datainizio = new.datainizio and t.datafine = new.datafine) as CDutili
	inner join 
    capocantiere c 
    on c.lavoratore_codiceFiscale = CDutili.CD;

if numeroOperai >= operaiMax then
signal sqlstate '45000'
set message_text = 'operaio non inseribile nel turno';
 end if;
 
end $$
delimiter ;
 
-- LA POSIZIONE DI UN NUOVO EDIFICIO DEVE RIENTRARE NEL RAGGIO DELL' AREA GEOGRAFICA DI INTERESSE
drop trigger if exists posizioneEdificio;
delimiter $$
create trigger posizioneEdificio
before insert on edificio
for each row
begin

declare distanza double default 0;
declare raggioArea double default 0;

select a.Raggio into raggioArea
from areageografica a 
where a.nome = new.AreaGeografica_nome;

select sqrt(power((new.latitudine - a1.Centro_Lat), 2) + power((new.longitudine - a1.Centro_lon), 2)) into distanza
from areageografica a1
where a1.nome = new.AreaGeografica_nome;

if distanza > raggioArea then
signal sqlstate '45000'
set message_text = 'area geografica non corretta';
 end if;
 
end $$
delimiter ;

-- SE UNA GRANDEZZA SUPERA LA SOGLIA DI SICUREZZA GENERA UN ALERT
drop trigger if exists nuovoAlert;
delimiter $$
create trigger nuovoAlert
after insert on grandezza
for each row
begin

declare soglia float default 0;

select s.sogliadisicurezza into soglia
from sensore s
where s.codicesensore = new.Sensore_codicesensore;

if new.Valore > soglia then
insert into alert
values (new.Timestamp ,new.Sensore_codicesensore);
end if;
 
end $$
delimiter ;

-- trigger su inserimento di una calamità, con inserimenti affini
drop trigger if exists SUnuova_calamita;
delimiter ££
create trigger SUnuova_calamita
after insert on calamita
for each row
begin
	DECLARE nome VARCHAR(45) DEFAULT '0';
	DECLARE centrox FLOAT  DEFAULT 0;
    DECLARE centroy FLOAT DEFAULT 0;
    DECLARE raggio INTEGER DEFAULT 0;
	DECLARE finito INTEGER DEFAULT 0;
    DECLARE cursore CURSOR FOR
    SELECT  * 
    FROM areageografica A;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore;
    
    scan: LOOP
		FETCH cursore INTO nome, centrox, centroy, raggio;
        if finito = 1 then leave scan;
        end if;
        if(sqrt(power((centrox - new.Epicentrolat), 2)+power((centroy - new.Epicentrolon), 2)) < (new.Estensione + raggio)) then
			insert into occorrenzacalamitosa values (new.Data, new.tipo, nome);
		end if;
        
    END LOOP scan;
    CLOSE cursore;
    
end ££
DELIMITER ;

/*trigger su danno per installazione necessaria-----------*/
-- Se si verifica un danno con entità >25 è richiesta l'installazione di un sensore per monitorare il danneggiamento
drop trigger if exists onDanno;
delimiter ^^
create trigger onDanno
after insert on danno
for each row
begin
	declare codeSensore int default 0;
    declare tipoSensore varchar(45) default '';
    select max(codicesensore)
    from   sensore
    into   codeSensore;
    set    codeSensore = codeSensore + 1;
	if new.entita > 25 then
		insert into installazionenecessaria values (date_add(new.calamita_data, interval 10 day), new.tipo, new.puntocoinvolto, new.edificio_codiceEdificio, codeSensore) ;
		end if;
end ^^
DELIMITER ;

/*trigger consecutivo a installazione necessaria---------------*/
drop trigger if exists onInstallazionenecessaria;
delimiter ??
create trigger onInstallazionenecessaria
before insert on installazionenecessaria
for each row
begin
	declare cordX float default 0;
    declare cordY float default 0;
    declare cordZ float default 0;
    declare tipo  varchar(45) default '';
    declare soglia float default 0;
    
    select	Xcord, Ycord into cordX, cordY
    from    vano inner join muro on vano.codiceVano = muro.vano_codiceVano
    where   vano.funzione = new.danno_puntoCoinvolto and muro.codiceMuro = (select min(codiceMuro)
																			from   vano inner join muro on vano.codiceVano = muro.vano_codiceVano
																			where   vano.funzione = new.danno_puntoCoinvolto);
    set cordZ = 2;
    case
    when new.danno_tipo = 'crepa' then
		set tipo = 'sensore sismico';
        set soglia = 0.255;
	when new.danno_tipo = 'infiltrazione' then
		set tipo = 'sensore di umidità';
        set soglia = 3.7;
	when new.danno_tipo = 'bruciatura'  then
		set tipo = 'sensore anti incendio';
        set soglia = 68;
	end case;
    
    insert into sensore values (new.sensore_codiceSensore, cordX, cordY, cordZ, soglia, tipo, new.danno_edificio_codiceEdificio);
end ??
DELIMITER ;

-- L'ENTITA' DI UN DANNO DEVE ESSERE UN INTERO CHE VA DA 1 A 100
DROP TRIGGER IF EXISTS nuovo_danno;
DELIMITER $$
CREATE TRIGGER nuovo_danno 
BEFORE INSERT ON danno
FOR EACH ROW
BEGIN
	IF NEW.Entita < 1 OR NEW.Entita > 100 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Danno non possibile";
	END IF;
END $$
DELIMITER ;

/*LA GRAVITA' DI UNA NUOVA CALAMITA' DEVE ESSERE UN INTERO CHE VA DA 1 A 10*/
drop trigger if exists onCalamity;
delimiter !!
create trigger onCalamity
before insert on calamita
for each row
begin
	if new.gravita<1 OR new.gravita > 10 then
		signal sqlstate '45000'
		set message_text = "calamità non possibile";
end if;
end !!
DELIMITER ;

/*trigger di utilizzo materiale, quantità utilizzata non può essere maggiore della quantità rimasta*/
drop trigger if exists utilizzoMateriali;
delimiter $$
create trigger utilizzoMateriali
before insert on utilizzo
for each row
begin
	if new.quantitaUtilizzata > (select quantitaRimasta from materiale where codiceLotto = new.materiale_codiceLotto) then
		signal sqlstate '45000'
		set message_text = "materiali insufficienti";
	end if;
end $$
DELIMITER ;

-- AGGIORNA LA QUANTITA' RIMASTA DI UN MATERIALE
drop trigger if exists utilizzoMateriali2;
delimiter !!
create trigger utilizzoMateriali2
after insert on utilizzo
for each row
begin
	update materiale
    set quantitaRimasta = quantitaRimasta - new.quantitaUtilizzata
    where codiceLotto = new.materiale_codiceLotto;
end !!
DELIMITER ;

-- EVENT CHE OGNI GIORNO CANCELLA LE GRANDEZZE MISURATE PIU' DI UN MESE FA
DROP EVENT IF EXISTS cancella_grandezze;
DELIMITER ££
CREATE EVENT cancella_grandezze
ON SCHEDULE EVERY 1 DAY 
DO 
BEGIN
	DELETE FROM grandezza G
    WHERE G.Timestamp > CURRENT_DATE - INTERVAL 1 MONTH;
    
END ££
DELIMITER ; 

-- IL COEFFICIENTE DI UN NUOVO RISCHIO DEVE ESSERE UN INTERO DA 1 A 5
DROP TRIGGER IF EXISTS blocca_rischio;
DELIMITER $$
CREATE TRIGGER blocca_rischio 
BEFORE INSERT ON rischio
FOR EACH ROW
BEGIN
	IF NEW.Coefficienterischio < 1 OR NEW.Coefficienterischio > 5 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Rischio non possibile";
	END IF;
END $$
DELIMITER ; 