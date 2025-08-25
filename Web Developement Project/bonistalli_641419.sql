-- Progettazione Web 
DROP DATABASE if exists bonistalli_641419; 
CREATE DATABASE bonistalli_641419; 
USE bonistalli_641419; 
-- MySQL dump 10.13  Distrib 5.7.28, for Win64 (x86_64)
--
-- Host: localhost    Database: bonistalli_641419
-- ------------------------------------------------------
-- Server version	5.7.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `prenotazioni`
--

DROP TABLE IF EXISTS `prenotazioni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prenotazioni` (
  `Numero` int(11) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `Cognome` varchar(45) NOT NULL,
  `Stanza` varchar(45) NOT NULL,
  `Data_inizio` date NOT NULL,
  `Data_fine` date NOT NULL,
  `Prezzo` int(11) NOT NULL,
  `Utenti_Mail` varchar(45) NOT NULL,
  PRIMARY KEY (`Numero`),
  KEY `Stanza_idx` (`Stanza`),
  KEY `fk_Prenotazioni_Utenti1_idx` (`Utenti_Mail`),
  CONSTRAINT `Stanza` FOREIGN KEY (`Stanza`) REFERENCES `stanze` (`Nome`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prenotazioni_Utenti1` FOREIGN KEY (`Utenti_Mail`) REFERENCES `utenti` (`Mail`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prenotazioni`
--

LOCK TABLES `prenotazioni` WRITE;
/*!40000 ALTER TABLE `prenotazioni` DISABLE KEYS */;
INSERT INTO `prenotazioni` VALUES (1,'Mario','Rossi','Stanza rossa','2024-08-05','2024-08-11',900,'mario.rossi@mail.it');
/*!40000 ALTER TABLE `prenotazioni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stanze`
--

DROP TABLE IF EXISTS `stanze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stanze` (
  `Nome` varchar(45) NOT NULL,
  `Posti_letto` int(11) NOT NULL,
  `Prezzo_notte` int(11) NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stanze`
--

LOCK TABLES `stanze` WRITE;
/*!40000 ALTER TABLE `stanze` DISABLE KEYS */;
INSERT INTO `stanze` VALUES ('Stanza blu',3,170),('Stanza rosa',2,110),('Stanza rossa',2,150),('Stanza verde',5,250);
/*!40000 ALTER TABLE `stanze` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utenti`
--

DROP TABLE IF EXISTS `utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utenti` (
  `Mail` varchar(45) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `Cognome` varchar(45) NOT NULL,
  PRIMARY KEY (`Mail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utenti`
--

LOCK TABLES `utenti` WRITE;
/*!40000 ALTER TABLE `utenti` DISABLE KEYS */;
INSERT INTO `utenti` VALUES ('mario.rossi@mail.it','$2y$10$BbgOY.RuZ9TjundC9IAuKuqURtcKl2wKDmoSmvcYUI0Ljm60QxzBW','Mario','Rossi');
/*!40000 ALTER TABLE `utenti` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-15 11:37:45
