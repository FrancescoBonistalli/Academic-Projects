	-- ANALYTICS 2----

DROP PROCEDURE IF EXISTS stima_dei_danni;
DELIMITER $$
CREATE PROCEDURE stima_dei_danni (IN _cod_edificio VARCHAR(10), IN _data DATE, IN _tipo VARCHAR(45), OUT messaggio_ VARCHAR(255))
BEGIN
	DECLARE storico DOUBLE DEFAULT 0; -- storico dei danni all'edificio 
    DECLARE G INT DEFAULT 0; -- Gravità della nuova calamità 
    DECLARE D DOUBLE DEFAULT 0; -- Distanza dall'edificio
    DECLARE lat_edificio FLOAT DEFAULT 0; -- latitudine edificio input
    DECLARE long_edificio FLOAT DEFAULT 0; -- longitudine edificio input
    DECLARE coeff_gravita DOUBLE DEFAULT 0; -- coefficiente di gravità 
    DECLARE coeff_totale DOUBLE DEFAULT 0; -- coefficiente totale
    
    -- Calcolo lo storico del danno per quell'edificio
	SET storico =(
		SELECT AVG(D.Entita) AS media 
		FROM danno D 
        WHERE D.Edificio_codiceEdificio = _cod_edificio
    );
    
    -- Trovo latitudine e langitudine edificio in input
    SELECT E.latitudine, E.longitudine INTO lat_edificio, long_edificio
    FROM edificio E 
    WHERE E.codiceEdificio = _cod_edificio;
    
    -- Prendo la calamità di interesse, la sua gravità e il suo epicentro
    WITH calamita_input AS(
		SELECT C.Data, C.Tipo, C.Gravita, C.Epicentrolat, C.Epicentrolon
        FROM calamita C
        WHERE C.Data = _data AND C.Tipo = _tipo    
    )
    -- Calcolo la distanza tra l'epicentro della nuova calamità e la posizione dell'edificio e metto tutto dentro le variabili
    SELECT CI.Gravita, sqrt(power((lat_edificio - CI.Epicentrolat), 2) + power((long_edificio - CI.Epicentrolon), 2)) INTO G, D 
    FROM calamita_input CI;
    
    -- Calcolo il coefficiente di gravità dato dalla gravità della nuova calamità / distanza tra epicentro 
    -- nuova calamità e posizione edificio, *100.
    SET coeff_gravita = G / D * 100;
    -- Calcolo il coefficiente totale
    SET coeff_totale = storico + coeff_gravita;
    
    -- Verifico quanto è il coefficiente totale e mando un messaggio all'utente
    IF coeff_totale = 0 THEN 
		SET messaggio_ = "Nessun danno";
	ELSEIF coeff_totale > 0 AND coeff_totale <= 25 THEN 
		SET messaggio_ = "Danni superficiali";
	ELSEIF coeff_totale > 25 AND coeff_totale <= 50 THEN 
		SET messaggio_ = "Danni medi";
	ELSEIF coeff_totale > 50 AND coeff_totale <= 75 THEN 
		SET messaggio_ = "Danni gravi";
	ELSEIF coeff_totale > 75 THEN 
		SET messaggio_ = "Danni molto gravi, intervento richiesto immediatamente";
	END IF;
    
END $$
DELIMITER ;

SET @mess = '';
CALL stima_dei_danni("A0", '2017-11-05', 'alluvione', @mess);
-- CALL stima_dei_danni ("A0" , '2013-01-09', 'terremoto', @mess);
SELECT @mess;