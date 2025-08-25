-- TEST OPERAZIONI --

-- procedura che, dato un codice edificio passato per parametro e una variabile  VARCHAR in uscita,  restituisce il tipo dei sensori che  
-- hanno generato alert negli ultimi dieci giorni 
CALL  alert_ultimi_10_giorni('A0', @risultato);
SELECT @risultato;

-- elenco di ogni area geografica colpita da una calamità negli ultimi 20 anni e quante volte è stata colpita da calamità in questo lasso di tempo
CALL area_calamita();

-- inserimento di un lavoro nella base di dati, includendo l'inserimento sull'entità operazione su edificio
-- parametri in ingresso: codice del lavoro, estremi temporali del lavoro, stadio di avanzamento in cui opera e edificio oggetto del lavoro
-- CALL inserimento_lavoro_generico(11, '2022-12-04', '2023-02-27', 13, 'A0');

-- inserimento di un lavoratore, la procedura inserisce in 'lavoratore' e 'operaio' o 'capocantiere' in base al parametro in ingresso maxoperai
-- ulteriori parametri in ingresso: codice fiscale, paga oraria, nome e cognome
-- CALL nuovo_lavoratore('RSSCRL80A01G843L', 11, 'CARLO', 'ROSSINI', NULL);

-- procedura con dato in ingresso il codice di un materiale, che ne calcola la quantità rimasta e la restituisce attraverso una variabile in uscita
CALL quantita_rimasta(04, @rimasto);
SELECT @rimasto; 

-- procedura che analizza uno stadio di avanzamento, ne restituisce la stima della data di fine, la data effettiva e i costi dei lavori che hanno sforato
-- la data di fine prevista
CALL resoconto_avanzamento(11);

-- funzione che restituisce tutti i costi di un lavoro (materiali e personale)
SET @risultato = calcolo_costo_lavoro(1);
SELECT @risultato;

-- funzione che restituisce il valor medio delle misurazioni di un certo tipo di sensori di un certo edificio passati in ingresso, nell'ultima data contenente una grandezza di quel tipo
SET @risultato = media_sensori('A0','termometro');
SELECT @risultato;