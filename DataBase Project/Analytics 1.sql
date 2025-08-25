-- ANALYTICS 1 --

DROP PROCEDURE IF EXISTS consigli_di_intervento;
DELIMITER $$
CREATE PROCEDURE consigli_di_intervento (IN _cod_edificio VARCHAR(10), OUT messaggio VARCHAR(255))
BEGIN 

	DECLARE grandezza DOUBLE DEFAULT 0; -- Grandezza max misurata da un sensore
	DECLARE soglia DOUBLE DEFAULT 0; -- Soglia di sicurezza del sensore corrente
    DECLARE coeff_grandezza DOUBLE DEFAULT 0; -- Coefficiente di grandezza
    DECLARE codice_sensore INT DEFAULT 0; -- Codice del sensore corrente
	DECLARE ent_danno INT DEFAULT 0; -- Entità del danno
    DECLARE coeff_totale DOUBLE DEFAULT 0; -- Coefficiente totale
    DECLARE finito INTEGER DEFAULT 0;
    DECLARE tipo_sensore VARCHAR(45) DEFAULT ''; -- Tipo del sensore

    -- Coordinate dei sensori
    DECLARE X FLOAT DEFAULT 0;
	DECLARE Y FLOAT DEFAULT 0;
	DECLARE Z FLOAT DEFAULT 0;

	DECLARE cursore CURSOR FOR 
      WITH sensori_di_interesse AS(
		SELECT DISTINCT S.codicesensore, S.sogliadisicurezza, S.tipo, S.cordX, S.cordY, S.cordZ, S.Edificio_codiceEdificio
        FROM sensore S 
        WHERE S.Edificio_codiceEdificio = _cod_edificio
    ),
    -- 2) Per ogni sensore di interesse prendo il codice, la soglia di sicurezza, le coordinate e il massimo valore che ha 
    -- misurato dalla data corrente fino a una settimana prima.
    grandezza_interesse AS(
		SELECT SDI.codicesensore,SDI.Edificio_codiceEdificio, SDI.sogliadisicurezza, SDI.tipo, SDI.cordX, SDI.cordY, SDI.cordZ, MAX(G.Valore) AS grandezza_max
        FROM grandezza G INNER JOIN sensori_di_interesse SDI ON G.Sensore_codicesensore = SDI.codicesensore
        WHERE G.Timestamp > CURRENT_DATE - INTERVAL 1 WEEK  
        GROUP BY SDI.codicesensore
    ),
    -- 3) Seleziono i danni che hanno coinvolto l'edificio di interesse e la loro entità
	danni_edificio AS (
		SELECT D.Tipo, D.PuntoCoinvolto, D.Entita, D.Edificio_codiceEdificio
		FROM danno D 
		WHERE D.Edificio_codiceEdificio = _cod_edificio
    )
    -- Restituisco il codice del sensore, l'entità del danno, la grandezza massima misurata, la sua soglia di sicurezza, 
    --  il coefficiente di grandezza e le coordinate del sensore
    SELECT GI.codicesensore, DE.entita, GI.grandezza_max, GI.sogliadisicurezza, GI.tipo, ((GI.grandezza_max / GI.sogliadisicurezza) * 100) AS coeff_, GI.cordX, GI.cordY, GI.cordZ
    FROM danni_edificio DE INNER JOIN grandezza_interesse GI ON DE.Edificio_codiceEdificio= GI.Edificio_codiceEdificio;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND 
    SET finito = 1;
    
    OPEN cursore;
	scan: LOOP
		FETCH cursore INTO codice_sensore, ent_danno, grandezza, soglia, tipo_sensore, coeff_grandezza, X, Y, Z;
        IF finito=1 THEN 
			LEAVE scan;
		END IF;
        
        SET coeff_totale = coeff_grandezza + ent_danno; -- calcolo il coefficiente totale
        
        -- Controllo quanto vale il coefficiente totale e stampo il relativo messaggio e le coordinate del sensore relativo.
        IF coeff_totale = 0 THEN 
			SET messaggio = "Nessun intervento richiesto su: ";
            SET messaggio= CONCAT( messaggio, '(', X,',', Y,',', Z,')'," di tipo: ",tipo_sensore);
		ELSEIF coeff_totale > 0 AND coeff_totale <= 25 THEN 
			SET messaggio = "Intervento richiesto entro 1 anno su: ";
            SET messaggio= CONCAT( messaggio,'(', X,',', Y,',', Z,')'," di tipo: ",tipo_sensore);
		ELSEIF coeff_totale > 25 AND coeff_totale <= 50 THEN 
			SET messaggio = "Intervento richiesto entro 6 mesi su: ";
            SET messaggio= CONCAT( messaggio, '(', X,',', Y,',', Z,')'," di tipo: ",tipo_sensore);
		ELSEIF coeff_totale > 50 AND coeff_totale <= 75 THEN 
			SET messaggio = "Intervento richiesto entro 3 mesi su: ";
            SET messaggio= CONCAT( messaggio, '(', X,',', Y,',', Z,')'," di tipo: ",tipo_sensore);
	    ELSEIF coeff_totale > 75 THEN 
			SET messaggio = "Intervento richiesto immediatamente!!!, su: ";
            SET messaggio= CONCAT( messaggio,'(', X,',', Y,',', Z,')'," di tipo: ",tipo_sensore);
		END IF;
		
	END LOOP scan;
	CLOSE cursore;
    
END $$
DELIMITER ;

-- Chiamata alla procedura
 SET @mess = '';
 CALL consigli_di_intervento ("A0" , @mess);
 SELECT @mess;