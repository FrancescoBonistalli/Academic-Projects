-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pbs
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pbs
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pbs` ;
CREATE SCHEMA  `pbs` DEFAULT CHARACTER SET utf8 ;
USE `pbs` ;

-- -----------------------------------------------------
-- Table `AreaGeografica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AreaGeografica` ;

CREATE TABLE IF NOT EXISTS `AreaGeografica` (
  `nome` VARCHAR(45) NOT NULL,
  `Centro_Lat` FLOAT NOT NULL,
  `Centro_lon` FLOAT NOT NULL,
  `Raggio` INT NOT NULL,
  PRIMARY KEY (`nome`))
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `Edificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Edificio` ;

CREATE TABLE IF NOT EXISTS `Edificio` (
  `codiceEdificio` VARCHAR(10) NOT NULL DEFAULT '000AAAA000',
  `latitudine` FLOAT NOT NULL DEFAULT 10.00,
  `longitudine` FLOAT NOT NULL,
  `tipologia` VARCHAR(45) NOT NULL DEFAULT 'CONDOMINIO',
  `AreaGeografica_nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceEdificio`),
  INDEX `fk_Edificio_AreaGeografica1_idx` (`AreaGeografica_nome` ASC) VISIBLE,
  CONSTRAINT `fk_Edificio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica_nome`)
    REFERENCES `AreaGeografica` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `piano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `piano` ;

CREATE TABLE IF NOT EXISTS `piano` (
  `numeropiano` INT NOT NULL,
  `Edificio_idEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`numeropiano`, `Edificio_idEdificio`),
  INDEX `fk_piano_Edificio1_idx` (`Edificio_idEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_piano_Edificio1`
    FOREIGN KEY (`Edificio_idEdificio`)
    REFERENCES `Edificio` (`codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vano` ;

CREATE TABLE IF NOT EXISTS `vano` (
  `codiceVano` INT NOT NULL AUTO_INCREMENT,
  `funzione` VARCHAR(45) NOT NULL,
  `luunghezzamax` FLOAT NOT NULL,
  `larghezzamax` FLOAT NOT NULL,
  `altezzamax` FLOAT NULL,
  `piano_numeropiano` INT NOT NULL,
  `piano_Edificio_idEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`codiceVano`),
  INDEX `fk_vano_piano1_idx` (`piano_numeropiano` ASC, `piano_Edificio_idEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_vano_piano1`
    FOREIGN KEY (`piano_numeropiano` , `piano_Edificio_idEdificio`)
    REFERENCES `piano` (`numeropiano` , `Edificio_idEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muro` ;

CREATE TABLE IF NOT EXISTS `muro` (
  `codiceMuro` INT NOT NULL AUTO_INCREMENT,
  `Xcord` FLOAT NOT NULL,
  `Ycord` FLOAT NOT NULL,
  `X1cord` FLOAT NOT NULL,
  `Y1cord` FLOAT NOT NULL,
  `vano_codiceVano` INT NOT NULL,
  PRIMARY KEY (`codiceMuro`),
  INDEX `fk_muro_vano1_idx` (`vano_codiceVano` ASC) VISIBLE,
  CONSTRAINT `fk_muro_vano1`
    FOREIGN KEY (`vano_codiceVano`)
    REFERENCES `vano` (`codiceVano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apertura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `apertura` ;

CREATE TABLE IF NOT EXISTS `apertura` (
  `posizione` VARCHAR(45) NOT NULL,
  `muro_codiceMuro` INT NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `dimensioneX` FLOAT NOT NULL,
  `dimensioneY` FLOAT NOT NULL,
  `puntoCardinale` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`muro_codiceMuro`, `posizione`),
  INDEX `fk_apertura_muro1_idx` (`muro_codiceMuro` ASC) VISIBLE,
  CONSTRAINT `fk_apertura_muro1`
    FOREIGN KEY (`muro_codiceMuro`)
    REFERENCES `muro` (`codiceMuro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `progetto edilizio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `progettoedilizio` ;

CREATE TABLE IF NOT EXISTS `progettoedilizio` (
  `codiceprogetto` INT NOT NULL AUTO_INCREMENT,
  `datapresentazione` DATE NOT NULL,
  `data approvazione` DATE NOT NULL,
  `Edificio_idEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`codiceprogetto`),
  INDEX `fk_progettoedilizio_Edificio1_idx` (`Edificio_idEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_progettoedilizio_Edificio1`
    FOREIGN KEY (`Edificio_idEdificio`)
    REFERENCES `Edificio` (`codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `stadio di avanzamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `stadio di avanzamento` ;

CREATE TABLE IF NOT EXISTS `stadiodiavanzamento` (
  `codicestadiodiavanzamento` INT NOT NULL AUTO_INCREMENT,
  `datainizio` DATE NOT NULL,
  `stimadatafine` DATE NOT NULL,
  `datafineeffettiva` DATE NULL,
  `progettoedilizio_codiceprogetto` INT NOT NULL,
  PRIMARY KEY (`codicestadiodiavanzamento`),
  INDEX `fk_stadiodiavanzamento_progettoedilizio1_idx` (`progettoedilizio_codiceprogetto` ASC) VISIBLE,
  CONSTRAINT `fk_stadiodiavanzamento_progettoedilizio1`
    FOREIGN KEY (`progettoedilizio_codiceprogetto`)
    REFERENCES `progettoedilizio` (`codiceprogetto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lavoro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lavoro` ;

CREATE TABLE IF NOT EXISTS `lavoro` (
  `idlavoro` INT NOT NULL AUTO_INCREMENT,
  `datainizio` DATE NOT NULL,
  `datafine` DATE NOT NULL,
  `stadiodiavanzamento_codicestadiodiavanzamento` INT NOT NULL,
  PRIMARY KEY (`idlavoro`),
  INDEX `fk_lavoro_stadiodiavanzamento1_idx` (`stadiodiavanzamento_codicestadiodiavanzamento` ASC) VISIBLE,
  CONSTRAINT `fk_lavoro_stadiodiavanzamento1`
    FOREIGN KEY (`stadiodiavanzamento_codicestadiodiavanzamento`)
    REFERENCES `stadiodiavanzamento` (`codicestadiodiavanzamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lavoratore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lavoratore` ;

CREATE TABLE IF NOT EXISTS `lavoratore` (
  `codiceFiscale` CHAR(16) NOT NULL,
  `pagaoraria` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cognome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codiceFiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `turno` ;

CREATE TABLE IF NOT EXISTS `turno` (
  `datainizio` DATE NOT NULL,
  `datafine` DATE NOT NULL,
  `orario` INT NOT NULL,
  `lavoratore_codiceFiscale` CHAR(16) NOT NULL,
  `lavoro_idlavoro` INT NOT NULL,
  PRIMARY KEY (`datainizio`, `datafine`, `lavoratore_codiceFiscale`),
  INDEX `fk_turno_lavoratore1_idx` (`lavoratore_codiceFiscale` ASC) VISIBLE,
  INDEX `fk_turno_lavoro1_idx` (`lavoro_idlavoro` ASC) VISIBLE,
  CONSTRAINT `fk_turno_lavoratore1`
    FOREIGN KEY (`lavoratore_codiceFiscale`)
    REFERENCES `lavoratore` (`codiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_turno_lavoro1`
    FOREIGN KEY (`lavoro_idlavoro`)
    REFERENCES `lavoro` (`idlavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `capoCantiere`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `capoCantiere` ;

CREATE TABLE IF NOT EXISTS `capoCantiere` (
  `maxOperai` INT NOT NULL,
  `lavoratore_codiceFiscale` CHAR(16) NOT NULL,
  PRIMARY KEY (`lavoratore_codiceFiscale`),
  CONSTRAINT `fk_capoCantiere_lavoratore1`
    FOREIGN KEY (`lavoratore_codiceFiscale`)
    REFERENCES `lavoratore` (`codiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `operaio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operaio` ;

CREATE TABLE IF NOT EXISTS `operaio` (
  `lavoratore_codiceFiscale` CHAR(16) NOT NULL,
  PRIMARY KEY (`lavoratore_codiceFiscale`),
  CONSTRAINT `fk_operaio_lavoratore1`
    FOREIGN KEY (`lavoratore_codiceFiscale`)
    REFERENCES `lavoratore` (`codiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `materiale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `materiale` ;

CREATE TABLE IF NOT EXISTS `materiale` (
  `codiceLotto` INT NOT NULL AUTO_INCREMENT,
  `nomeFornitore` VARCHAR(45) NOT NULL,
  `quantitaRimasta` INT NOT NULL,
  `funzione` VARCHAR(45) NOT NULL,
  `quantita` INT NOT NULL,
  `costo_unita` INT NOT NULL,
  `dataAcquisto` DATE NOT NULL,
  PRIMARY KEY (`codiceLotto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `utilizzo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `utilizzo` ;

CREATE TABLE IF NOT EXISTS `utilizzo` (
  `quantitaUtilizzata` INT NOT NULL,
  `lavoro_idlavoro` INT NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`lavoro_idlavoro`, `materiale_codiceLotto`),
  INDEX `fk_utilizzo_materiale1_idx` (`materiale_codiceLotto` ASC) VISIBLE,
  CONSTRAINT `fk_utilizzo_lavoro1`
    FOREIGN KEY (`lavoro_idlavoro`)
    REFERENCES `lavoro` (`idlavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_utilizzo_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `intonaco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `intonaco` ;

CREATE TABLE IF NOT EXISTS `intonaco` (
  `tipo` VARCHAR(45) NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_intonaco_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mattone`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mattone` ;

CREATE TABLE IF NOT EXISTS `mattone` (
  `descrizioneStruttura` VARCHAR(100) NOT NULL,
  `composizione` VARCHAR(45) NOT NULL,
  `dimensione` FLOAT NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_mattone_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `piastrella`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `piastrella` ;

CREATE TABLE IF NOT EXISTS `piastrella` (
  `texture` VARCHAR(45) NOT NULL,
  `fuga` VARCHAR(45) NOT NULL,
  `dimensione` INT NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_piastrella_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `legno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `legno` ;

CREATE TABLE IF NOT EXISTS `legno` (
  `Tipo-di-legname` VARCHAR(45) NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_legno_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metallo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `metallo` ;

CREATE TABLE IF NOT EXISTS `metallo` (
  `nome` VARCHAR(45) NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_metallo_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `materialeGenerico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `materialeGenerico` ;

CREATE TABLE IF NOT EXISTS `materialeGenerico` (
  `descrizione` VARCHAR(45) NOT NULL,
  `materiale_codiceLotto` INT NOT NULL,
  PRIMARY KEY (`materiale_codiceLotto`),
  CONSTRAINT `fk_materialeGenerico_materiale1`
    FOREIGN KEY (`materiale_codiceLotto`)
    REFERENCES `materiale` (`codiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rischio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rischio` ;

CREATE TABLE IF NOT EXISTS `Rischio` (
  `tipo` VARCHAR(45) NOT NULL,
  `Coefficienterischio` INT NOT NULL,
  `AreaGeografica_nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`tipo`, `AreaGeografica_nome`),
  INDEX `fk_Rischio_AreaGeografica1_idx` (`AreaGeografica_nome` ASC) VISIBLE,
  CONSTRAINT `fk_Rischio_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica_nome`)
    REFERENCES `AreaGeografica` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Calamita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Calamita` ;

CREATE TABLE IF NOT EXISTS `Calamita` (
  `Data` DATE NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `Epicentrolat` FLOAT NOT NULL,
  `Epicentrolon` FLOAT NOT NULL,
  `Gravita` INT NOT NULL,
  `Estensione` INT NOT NULL,
  PRIMARY KEY (`Data`, `Tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Danno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Danno` ;

CREATE TABLE IF NOT EXISTS `Danno` (
  `Entita` INT NOT NULL,
  `Tipo` VARCHAR(45) NOT NULL,
  `PuntoCoinvolto` VARCHAR(45) NOT NULL,
  `Calamita_Data` DATE NOT NULL,
  `Calamita_Tipo` VARCHAR(45) NOT NULL,
  `Edificio_codiceEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Tipo`, `PuntoCoinvolto`, `Edificio_codiceEdificio`),
  INDEX `fk_Danno_Calamità1_idx` (`Calamita_Data` ASC, `Calamita_Tipo` ASC) VISIBLE,
  INDEX `fk_Danno_Edificio1_idx` (`Edificio_codiceEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_Danno_Calamità1`
    FOREIGN KEY (`Calamita_Data` , `Calamita_Tipo`)
    REFERENCES `Calamita` (`Data` , `Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Danno_Edificio1`
    FOREIGN KEY (`Edificio_codiceEdificio`)
    REFERENCES `Edificio` (`codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Sensore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sensore` ;

CREATE TABLE IF NOT EXISTS `Sensore` (
  `codicesensore` INT NOT NULL AUTO_INCREMENT,
  `cordX` FLOAT NOT NULL,
  `cordY` FLOAT NOT NULL,
  `cordZ` FLOAT NOT NULL,
  `sogliadisicurezza` FLOAT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `Edificio_codiceEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`codicesensore`),
  INDEX `fk_Sensore_Edificio1_idx` (`Edificio_codiceEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_Sensore_Edificio1`
    FOREIGN KEY (`Edificio_codiceEdificio`)
    REFERENCES `Edificio` (`codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `installazione necessaria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `installazionenecessaria` ;

CREATE TABLE IF NOT EXISTS `installazionenecessaria` (
  `datainstallazione` DATE NOT NULL,
  `Danno_Tipo` VARCHAR(45) NOT NULL,
  `Danno_PuntoCoinvolto` VARCHAR(45) NOT NULL,
  `Danno_Edificio_codiceEdificio` VARCHAR(10) NOT NULL,
  `Sensore_codicesensore` INT NOT NULL,
  PRIMARY KEY (`Danno_Tipo`, `Danno_PuntoCoinvolto`, `Danno_Edificio_codiceEdificio`, `Sensore_codicesensore`),
  INDEX `fk_installazionenecessaria_Sensore1_idx` (`Sensore_codicesensore` ASC) VISIBLE,
  CONSTRAINT `fk_installazionenecessaria_Danno1`
    FOREIGN KEY (`Danno_Tipo` , `Danno_PuntoCoinvolto` , `Danno_Edificio_codiceEdificio`)
    REFERENCES `Danno` (`Tipo` , `PuntoCoinvolto` , `Edificio_codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_installazionenecessaria_Sensore1`
    FOREIGN KEY (`Sensore_codicesensore`)
    REFERENCES `Sensore` (`codicesensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Grandezza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Grandezza` ;

CREATE TABLE IF NOT EXISTS `Grandezza` (
  `Timestamp` TIMESTAMP NOT NULL,
  `Valore` DOUBLE NOT NULL,
  `Sensore_codicesensore` INT NOT NULL,
  PRIMARY KEY (`Timestamp`, `Sensore_codicesensore`),
  INDEX `fk_Grandezza_Sensore1_idx` (`Sensore_codicesensore` ASC) VISIBLE,
  CONSTRAINT `fk_Grandezza_Sensore1`
    FOREIGN KEY (`Sensore_codicesensore`)
    REFERENCES `Sensore` (`codicesensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Alert`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Alert` ;

CREATE TABLE IF NOT EXISTS `Alert` (
  `Grandezza_Timestamp` TIMESTAMP NOT NULL,
  `Grandezza_Sensore_codicesensore` INT NOT NULL,
  PRIMARY KEY (`Grandezza_Timestamp`, `Grandezza_Sensore_codicesensore`),
  CONSTRAINT `fk_Alert_Grandezza1`
    FOREIGN KEY (`Grandezza_Timestamp` , `Grandezza_Sensore_codicesensore`)
    REFERENCES `Grandezza` (`Timestamp` , `Sensore_codicesensore`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `occorrenzacalamitosa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `occorrenzacalamitosa` ;

CREATE TABLE IF NOT EXISTS `occorrenzacalamitosa` (
  `Calamita_Data` DATE NOT NULL,
  `Calamita_Tipo` VARCHAR(45) NOT NULL,
  `AreaGeografica_nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Calamita_Data`, `Calamita_Tipo`, `AreaGeografica_nome`),
  INDEX `fk_Calamità_has_AreaGeografica_Calamità1_idx` (`Calamita_Data` ASC, `Calamita_Tipo` ASC) VISIBLE,
  INDEX `fk_occorrenzacalamitosa_AreaGeografica1_idx` (`AreaGeografica_nome` ASC) VISIBLE,
  CONSTRAINT `fk_Calamità_has_AreaGeografica_Calamità1`
    FOREIGN KEY (`Calamita_Data` , `Calamita_Tipo`)
    REFERENCES `Calamita` (`Data` , `Tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_occorrenzacalamitosa_AreaGeografica1`
    FOREIGN KEY (`AreaGeografica_nome`)
    REFERENCES `AreaGeografica` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `operazioneSuEdificio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operazioneSuEdificio` ;

CREATE TABLE IF NOT EXISTS `operazioneSuEdificio` (
  `lavoro_idlavoro` INT NOT NULL,
  `Edificio_codiceEdificio` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`lavoro_idlavoro`, `Edificio_codiceEdificio`),
  INDEX `fk_operazioneSuEdificio_Edificio1_idx` (`Edificio_codiceEdificio` ASC) VISIBLE,
  CONSTRAINT `fk_operazioneSuEdificio_lavoro1`
    FOREIGN KEY (`lavoro_idlavoro`)
    REFERENCES `lavoro` (`idlavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operazioneSuEdificio_Edificio1`
    FOREIGN KEY (`Edificio_codiceEdificio`)
    REFERENCES `Edificio` (`codiceEdificio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `operazioneSuVano`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operazioneSuVano` ;

CREATE TABLE IF NOT EXISTS `operazioneSuVano` (
  `lavoro_idlavoro` INT NOT NULL,
  `vano_codiceVano` INT NOT NULL,
  PRIMARY KEY (`lavoro_idlavoro`, `vano_codiceVano`),
  INDEX `fk_operazioneSuVano_vano1_idx` (`vano_codiceVano` ASC) VISIBLE,
  CONSTRAINT `fk_operazioneSuVano_lavoro1`
    FOREIGN KEY (`lavoro_idlavoro`)
    REFERENCES `lavoro` (`idlavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operazioneSuVano_vano1`
    FOREIGN KEY (`vano_codiceVano`)
    REFERENCES `vano` (`codiceVano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `operazioneSuMuro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operazioneSuMuro` ;

CREATE TABLE IF NOT EXISTS `operazioneSuMuro` (
  `lavoro_idlavoro` INT NOT NULL,
  `muro_codiceMuro` INT NOT NULL,
  PRIMARY KEY (`lavoro_idlavoro`, `muro_codiceMuro`),
  INDEX `fk_operazioneSuMuro_muro1_idx` (`muro_codiceMuro` ASC) VISIBLE,
  CONSTRAINT `fk_operazioneSuMuro_lavoro1`
    FOREIGN KEY (`lavoro_idlavoro`)
    REFERENCES `lavoro` (`idlavoro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operazioneSuMuro_muro1`
    FOREIGN KEY (`muro_codiceMuro`)
    REFERENCES `muro` (`codiceMuro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


