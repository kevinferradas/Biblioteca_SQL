CREATE DATABASE  IF NOT EXISTS `biblioteca` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `biblioteca`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: biblioteca
-- ------------------------------------------------------
-- Server version	8.4.5

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `autores`
--

DROP TABLE IF EXISTS `autores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autores` (
  `id_autor` int NOT NULL AUTO_INCREMENT,
  `nombre_autor` varchar(50) NOT NULL,
  `apellido_autor` varchar(100) NOT NULL,
  `id_epoca` int NOT NULL,
  PRIMARY KEY (`id_autor`),
  KEY `fk_epoca` (`id_epoca`),
  CONSTRAINT `fk_epoca` FOREIGN KEY (`id_epoca`) REFERENCES `epocas` (`id_epoca`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autores`
--

LOCK TABLES `autores` WRITE;
/*!40000 ALTER TABLE `autores` DISABLE KEYS */;
INSERT INTO `autores` VALUES (1,'Jules','Verne',1),(2,'Isaac','Asimov',1),(3,'Stanislaw','Lem',1),(4,'Stephen','King',1);
/*!40000 ALTER TABLE `autores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autores_libros`
--

DROP TABLE IF EXISTS `autores_libros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autores_libros` (
  `id_autores_libros` int NOT NULL AUTO_INCREMENT,
  `id_autor` int NOT NULL,
  `id_libro` int NOT NULL,
  PRIMARY KEY (`id_autores_libros`),
  KEY `fk_autores_idx` (`id_autor`),
  KEY `fk_libros_idx` (`id_libro`),
  CONSTRAINT `fk_autores` FOREIGN KEY (`id_autor`) REFERENCES `autores` (`id_autor`),
  CONSTRAINT `fk_libros` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id_libro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autores_libros`
--

LOCK TABLES `autores_libros` WRITE;
/*!40000 ALTER TABLE `autores_libros` DISABLE KEYS */;
INSERT INTO `autores_libros` VALUES (1,1,1),(2,1,2),(3,2,3),(4,3,4);
/*!40000 ALTER TABLE `autores_libros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `editoriales`
--

DROP TABLE IF EXISTS `editoriales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `editoriales` (
  `id_editorial` int NOT NULL AUTO_INCREMENT,
  `nombre_editorial` varchar(50) NOT NULL,
  `id_poblacion` int NOT NULL,
  PRIMARY KEY (`id_editorial`),
  KEY `fk_poblaciones` (`id_poblacion`),
  CONSTRAINT `fk_poblaciones` FOREIGN KEY (`id_poblacion`) REFERENCES `poblaciones` (`id_poblacion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `editoriales`
--

LOCK TABLES `editoriales` WRITE;
/*!40000 ALTER TABLE `editoriales` DISABLE KEYS */;
INSERT INTO `editoriales` VALUES (1,'Taurus',1),(2,'Gredos',2),(3,'Alfaguara',2);
/*!40000 ALTER TABLE `editoriales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `epocas`
--

DROP TABLE IF EXISTS `epocas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `epocas` (
  `id_epoca` int NOT NULL AUTO_INCREMENT,
  `epoca` varchar(20) NOT NULL,
  PRIMARY KEY (`id_epoca`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `epocas`
--

LOCK TABLES `epocas` WRITE;
/*!40000 ALTER TABLE `epocas` DISABLE KEYS */;
INSERT INTO `epocas` VALUES (1,'s.XX'),(2,'s.XXI'),(3,'S.XIX');
/*!40000 ALTER TABLE `epocas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `libros`
--

DROP TABLE IF EXISTS `libros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `libros` (
  `id_libro` int NOT NULL AUTO_INCREMENT,
  `titulo_libro` varchar(100) NOT NULL,
  `ejemplares_stock` smallint DEFAULT NULL,
  `id_editorial` int NOT NULL,
  PRIMARY KEY (`id_libro`),
  KEY `fk_editoriales_idx` (`id_editorial`),
  CONSTRAINT `fk_editoriales` FOREIGN KEY (`id_editorial`) REFERENCES `editoriales` (`id_editorial`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libros`
--

LOCK TABLES `libros` WRITE;
/*!40000 ALTER TABLE `libros` DISABLE KEYS */;
INSERT INTO `libros` VALUES (1,'La vuelta al mundo en 80 días',5,1),(2,'De la Tierra a la luna',3,1),(3,'Yo, robot',3,2),(4,'Solaris',5,3),(5,'Python',20,1),(6,'HTML',10,1),(7,'CSS',1,1);
/*!40000 ALTER TABLE `libros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poblaciones`
--

DROP TABLE IF EXISTS `poblaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poblaciones` (
  `id_poblacion` int NOT NULL AUTO_INCREMENT,
  `poblacion` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id_poblacion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poblaciones`
--

LOCK TABLES `poblaciones` WRITE;
/*!40000 ALTER TABLE `poblaciones` DISABLE KEYS */;
INSERT INTO `poblaciones` VALUES (1,'Barcelona'),(2,'Madrid'),(3,'Cornellà'),(4,'París');
/*!40000 ALTER TABLE `poblaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prestamos`
--

DROP TABLE IF EXISTS `prestamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prestamos` (
  `id_prestamos` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `id_libro` int NOT NULL,
  `fecha_prestamo` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_devolucion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_prestamos`),
  KEY `fk_libros_prestamos` (`id_libro`),
  KEY `fk_usuarios` (`id_usuario`),
  CONSTRAINT `fk_libros_prestamos` FOREIGN KEY (`id_libro`) REFERENCES `libros` (`id_libro`),
  CONSTRAINT `fk_usuarios` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prestamos`
--

LOCK TABLES `prestamos` WRITE;
/*!40000 ALTER TABLE `prestamos` DISABLE KEYS */;
INSERT INTO `prestamos` VALUES (1,1,1,'2025-04-23 17:24:13',NULL),(2,1,2,'2025-04-23 17:24:13',NULL),(3,1,3,'2025-04-23 17:24:13',NULL),(4,2,1,'2025-04-23 17:24:13',NULL),(5,2,2,'2025-04-23 17:24:13',NULL),(6,3,1,'2025-04-23 17:24:13',NULL),(7,4,4,'2025-04-23 17:32:53',NULL),(8,5,2,'2025-04-30 15:16:07',NULL);
/*!40000 ALTER TABLE `prestamos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre_usuario` varchar(20) NOT NULL,
  `apellido_usuario` varchar(50) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `carnet_biblio` int NOT NULL,
  `fecha_inscripcion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `carnet_biblio` (`carnet_biblio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Steve','Jobs','1955-02-04',76155230,'2025-04-23 17:08:09'),(2,'Letizia','Ortiz','1968-06-30',81402723,'2025-04-23 17:08:09'),(3,'Peter','Parker','2000-03-11',78547927,'2025-04-23 17:08:09'),(4,'Clark','Kent','1989-09-11',48531471,'2025-04-23 17:08:09'),(5,'Lois','Lane','1989-10-06',87013578,'2025-04-23 17:08:09');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'biblioteca'
--

--
-- Dumping routines for database 'biblioteca'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-30 18:02:43
