-- ANALYTICS 3 ----
    
DROP PROCEDURE IF EXISTS consigli_prevenzione;
DELIMITER $$
CREATE PROCEDURE consigli_prevenzione (IN _cod_edificio VARCHAR(10), OUT messaggio_ VARCHAR(255))
BEGIN
	DECLARE tipo_rischio VARCHAR(45) DEFAULT ''; -- Variabile tipo del/dei rischi/o col coefficiente più alto
    DECLARE area_interesse VARCHAR(45) DEFAULT ''; -- Area relativa a edificio in input
    DECLARE avviso VARCHAR(100) DEFAULT ''; -- Variabile di appoggio
    DECLARE count INT DEFAULT 0; -- Contatore di appoggio
	DECLARE finito INT DEFAULT 0; -- Variabile per handler
	
    -- Seleziono i tipi di rischio con coefficiente di rischio più alto
    DECLARE cursore CURSOR FOR 
    SELECT R.Tipo 
    FROM rischio R 
    WHERE R.AreaGeografica_nome = (SELECT A.nome
									FROM edificio E INNER JOIN areageografica A ON E.AreaGeografica_nome = A.nome 
									WHERE E.codiceEdificio = _cod_edificio)
		AND R.Coefficienterischio >= ALL ( SELECT R2.Coefficienterischio
										   FROM rischio R2);
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finito = 1;
    
    OPEN cursore;
    scan: LOOP
		FETCH cursore INTO tipo_rischio; 
		
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
		
		-- Ci sono 5 rischi possibili
		IF tipo_rischio = "alluvioni" THEN
			SET avviso = "Si consiglia di installare pluviometri";   
		ELSEIF tipo_rischio = "terremoti" THEN
			SET avviso = "Si consiglia di installare accelerometri";
		ELSEIF tipo_rischio = "Siccità" THEN
			SET avviso = "Si consiglia di installare termometri e igrometri";
		ELSEIF tipo_rischio = "frane" THEN 
			SET avviso = "Si consiglia di installare accelerometri";
		ELSEIF tipo_rischio = "Uragano" THEN 
			SET avviso = "Si consiglia di installare anemometri";
		END IF;
		
		IF count = 0 THEN
			SET messaggio_ = avviso;
            SET count = 1;
        ELSE
			SET messaggio_ =  CONCAT( messaggio_, ',' , avviso);
		END IF;
        
	END LOOP scan;
	CLOSE cursore;
END $$
DELIMITER ;

SET @messaggio = '';
CALL consigli_prevenzione("A0", @messaggio);
SELECT @messaggio;