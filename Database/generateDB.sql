-- MySQL Script generated by MySQL Workbench
-- Thu May 20 19:59:08 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema syllabus_system
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `syllabus_system` ;

-- -----------------------------------------------------
-- Schema syllabus_system
-- -----------------------------------------------------
CREATE SCHEMA `syllabus_system` DEFAULT CHARACTER SET utf8 ;
USE `syllabus_system` ;

-- -----------------------------------------------------
-- Table `syllabus_system`.`users_access`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`users_access` (
  `nombre` VARCHAR(50) NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `username` VARCHAR(35) NOT NULL,
  `hashaccess` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `hashaccess_UNIQUE` (`hashaccess` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`role`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`role` (
  `nivel_acceso` INT(1) NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  `descripcion` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`nivel_acceso`),
  UNIQUE INDEX `nivel_acceso_UNIQUE` (`nivel_acceso` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`role_users`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`role_users` (
  `username` VARCHAR(35) NOT NULL,
  `nivel_acceso` INT(1) NOT NULL,
  `date_assign` DATETIME NOT NULL,
  `deadline` DATETIME NULL,
  PRIMARY KEY (`username`, `nivel_acceso`),
  INDEX `nivel_acceso_idx` (`nivel_acceso` ASC) VISIBLE,
  CONSTRAINT `nivel_acceso`
    FOREIGN KEY (`nivel_acceso`)
    REFERENCES `syllabus_system`.`role` (`nivel_acceso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `username`
    FOREIGN KEY (`username`)
    REFERENCES `syllabus_system`.`users_access` (`username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`menuElement`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`menuElement` (
  `menuId` INT(2) NOT NULL,
  `title` VARCHAR(40) NOT NULL,
  `description` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`menuId`),
  UNIQUE INDEX `menuId_UNIQUE` (`menuId` ASC) VISIBLE,
  UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`webPage`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`webPage` (
  `pageURL` VARCHAR(40) NOT NULL,
  `pageTitle` VARCHAR(55) NOT NULL,
  `description` MEDIUMTEXT NOT NULL,
  `menuId` INT(2) NOT NULL,
  PRIMARY KEY (`pageURL`),
  UNIQUE INDEX `pageURL_UNIQUE` (`pageURL` ASC) VISIBLE,
  INDEX `menuId_idx` (`menuId` ASC) VISIBLE,
  CONSTRAINT `menuId`
    FOREIGN KEY (`menuId`)
    REFERENCES `syllabus_system`.`menuElement` (`menuId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`role_web_page`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`role_web_page` (
  `nivel_acceso` INT(1) NOT NULL,
  `pageURL` VARCHAR(40) NOT NULL,
  `date_assign` DATETIME NOT NULL,
  PRIMARY KEY (`nivel_acceso`, `pageURL`),
  INDEX `pageURL_idx` (`pageURL` ASC) VISIBLE,
  CONSTRAINT `nivel_acceso2`
    FOREIGN KEY (`nivel_acceso`)
    REFERENCES `syllabus_system`.`role` (`nivel_acceso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `pageURL`
    FOREIGN KEY (`pageURL`)
    REFERENCES `syllabus_system`.`webPage` (`pageURL`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`webPagePrevious`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`webPagePrevious` (
  `currentPageURL` VARCHAR(40) NOT NULL,
  `previousPageURL` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`currentPageURL`, `previousPageURL`),
  INDEX `previousPageURL_idx` (`previousPageURL` ASC) VISIBLE,
  CONSTRAINT `currentPageURL`
    FOREIGN KEY (`currentPageURL`)
    REFERENCES `syllabus_system`.`webPage` (`pageURL`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `previousPageURL`
    FOREIGN KEY (`previousPageURL`)
    REFERENCES `syllabus_system`.`webPage` (`pageURL`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`cursos`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`cursos` (
  `codigo_curso` VARCHAR(10) NOT NULL,
  `titulo_curso` VARCHAR(100) NOT NULL,
  `tipo_curso` VARCHAR(45) NOT NULL,
  `modalidad` VARCHAR(25) NOT NULL,
  `username` VARCHAR(35) NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`codigo_curso`),
  UNIQUE INDEX `codigo_curso_UNIQUE` (`codigo_curso` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`tipos_solicitudes`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`tipos_solicitudes` (
  `tipo_solicitud` INT(1) NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`tipo_solicitud`),
  UNIQUE INDEX `tipo_solicitud_UNIQUE` (`tipo_solicitud` ASC) VISIBLE,
  UNIQUE INDEX `descripcion_UNIQUE` (`descripcion` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`solicitudes`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`solicitudes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `justificacion` MEDIUMTEXT NOT NULL,
  `fecha_solicitud` DATETIME NOT NULL,
  `dia_limite` DATETIME NOT NULL,
  `status` TINYINT(3) NOT NULL,
  `username` VARCHAR(35) NOT NULL,
  `codigo_curso` VARCHAR(10) NOT NULL,
  `tipo_solicitud` INT(1) NOT NULL,
  `visto_profesor` CHAR(1) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `username_idx` (`username` ASC) VISIBLE,
  INDEX `tipo_solicitud_idx` (`tipo_solicitud` ASC) VISIBLE,
  INDEX `codigo_curso_idx` (`codigo_curso` ASC) VISIBLE,
  CONSTRAINT `username2`
    FOREIGN KEY (`username`)
    REFERENCES `syllabus_system`.`users_access` (`username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `codigo_curso`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `syllabus_system`.`cursos` (`codigo_curso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `tipo_solicitud`
    FOREIGN KEY (`tipo_solicitud`)
    REFERENCES `syllabus_system`.`tipos_solicitudes` (`tipo_solicitud`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`estados_syllabuses`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`estados_syllabuses` (
  `status` CHAR(1) NOT NULL,
  `descripcion` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`status`),
  UNIQUE INDEX `status_UNIQUE` (`status` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`syllabuses`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`syllabuses` (
  `id_entrada` INT NOT NULL,
  `codigo_curso` VARCHAR(10) NOT NULL,
  `username` VARCHAR(35) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `duracion` VARCHAR(100) NOT NULL,
  `creditos` VARCHAR(10) NOT NULL,
  `descripcion` MEDIUMTEXT NOT NULL,
  `justificacion` MEDIUMTEXT NOT NULL,
  `status` CHAR(1) NOT NULL,
  `visto_profesor` CHAR(1) NOT NULL,
  INDEX `status_idx` (`status` ASC) VISIBLE,
  PRIMARY KEY (`id_entrada`),
  CONSTRAINT `status`
    FOREIGN KEY (`status`)
    REFERENCES `syllabus_system`.`estados_syllabuses` (`status`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `codigo_curso2`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `syllabus_system`.`cursos` (`codigo_curso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`grado_educacion`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`grado_educacion` (
  `id_grado` CHAR(1) NOT NULL,
  `nivel_educ` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_grado`),
  UNIQUE INDEX `id_grado_UNIQUE` (`id_grado` ASC) VISIBLE,
  UNIQUE INDEX `nivel_educ_UNIQUE` (`nivel_educ` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`programas`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`programas` (
  `id_programa` CHAR(4) NOT NULL,
  `id_grado` CHAR(1) NOT NULL,
  `nombre_programa` VARCHAR(80) NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`id_programa`),
  UNIQUE INDEX `id_programa_UNIQUE` (`id_programa` ASC) VISIBLE,
  UNIQUE INDEX `nombre_programa_UNIQUE` (`nombre_programa` ASC) VISIBLE,
  INDEX `id_programa_idx` (`id_grado` ASC) VISIBLE,
  CONSTRAINT `id_programa`
    FOREIGN KEY (`id_grado`)
    REFERENCES `syllabus_system`.`grado_educacion` (`id_grado`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`programa_curso`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`programa_curso` (
  `id_programa` CHAR(4) NOT NULL,
  `codigo_curso` VARCHAR(10) NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`id_programa`, `codigo_curso`),
  CONSTRAINT `id_programa2`
    FOREIGN KEY (`id_programa`)
    REFERENCES `syllabus_system`.`programas` (`id_programa`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `codigo_curso3`
    FOREIGN KEY (`codigo_curso`)
    REFERENCES `syllabus_system`.`cursos` (`codigo_curso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`bibliografias`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`bibliografias` (
  `id_entrada` INT NOT NULL,
  `bibliografia` MEDIUMTEXT NOT NULL,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  CONSTRAINT `id_entrada1`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`contenido_tematico`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`contenido_tematico` (
  `id_entrada` INT NOT NULL,
  `contenido_tem` MEDIUMTEXT NOT NULL,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  CONSTRAINT `id_entrada2`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`tipos_assessment`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`tipos_assessment` (
  `id_assessment` CHAR(2) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_assessment`),
  UNIQUE INDEX `id_assessment_UNIQUE` (`id_assessment` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`estrategias_assessment`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`estrategias_assessment` (
  `id_entrada` INT NOT NULL,
  `id_assessment` CHAR(2) NOT NULL,
  INDEX `id_assessment_idx` (`id_assessment` ASC) VISIBLE,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  CONSTRAINT `id_entrada3`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_assessment`
    FOREIGN KEY (`id_assessment`)
    REFERENCES `syllabus_system`.`tipos_assessment` (`id_assessment`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`politica_reglas_cursos`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`politica_reglas_cursos` (
  `id_regla` CHAR(2) NOT NULL,
  `titulo` VARCHAR(255) NOT NULL,
  `descripcion` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id_regla`),
  UNIQUE INDEX `id_UNIQUE` (`id_regla` ASC) VISIBLE,
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`reglas_aplicadas`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`reglas_aplicadas` (
  `id_entrada` INT NOT NULL,
  `id_regla` CHAR(2) NOT NULL,
  PRIMARY KEY (`id_entrada`, `id_regla`),
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  CONSTRAINT `id_entrada4`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_regla`
    FOREIGN KEY (`id_regla`)
    REFERENCES `syllabus_system`.`politica_reglas_cursos` (`id_regla`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`tipos_estrategias`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`tipos_estrategias` (
  `id_estrategias` CHAR(2) NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id_estrategias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`estrategias_ensenanza`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`estrategias_ensenanza` (
  `id_entrada` INT NOT NULL,
  `id_estrategias` CHAR(2) NOT NULL,
  INDEX `id_estrategias_idx` (`id_estrategias` ASC) VISIBLE,
  CONSTRAINT `id_estrategias`
    FOREIGN KEY (`id_estrategias`)
    REFERENCES `syllabus_system`.`tipos_estrategias` (`id_estrategias`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_entrada11`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`agencias`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`agencias` (
  `id_agencia` INT(2) NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `descripcion_agencia` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id_agencia`),
  UNIQUE INDEX `id_agencia_UNIQUE` (`id_agencia` ASC) VISIBLE,
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`objetivos_agencias`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`objetivos_agencias` (
  `id_agencia` INT(2) NOT NULL,
  `id_objetivo_agencia` VARCHAR(10) NOT NULL,
  `descripcion` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id_objetivo_agencia`, `id_agencia`),
  CONSTRAINT `id_agencia`
    FOREIGN KEY (`id_agencia`)
    REFERENCES `syllabus_system`.`agencias` (`id_agencia`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`objetivos`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`objetivos` (
  `id_entrada` INT NOT NULL,
  `id_objetivo` INT(2) NOT NULL,
  `desc` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id_entrada`, `id_objetivo`),
  INDEX `id_objetivo_idx` (`id_objetivo` ASC) VISIBLE,
  CONSTRAINT `id_entrada5`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`objetivos_alineados`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`objetivos_alineados` (
  `id_entrada` INT NOT NULL,
  `id_objetivo` INT(2) NOT NULL,
  `id_agencia` INT(2) NOT NULL,
  `id_objetivo_agencia` VARCHAR(10) NOT NULL,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  INDEX `id_objetivo_idx` (`id_objetivo` ASC) VISIBLE,
  PRIMARY KEY (`id_entrada`, `id_objetivo`, `id_agencia`, `id_objetivo_agencia`),
  INDEX `id_objetivo_agencia_idx` (`id_objetivo_agencia` ASC) VISIBLE,
  CONSTRAINT `id_agencia2`
    FOREIGN KEY (`id_agencia`)
    REFERENCES `syllabus_system`.`objetivos_agencias` (`id_agencia`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_objetivo_agencia`
    FOREIGN KEY (`id_objetivo_agencia`)
    REFERENCES `syllabus_system`.`objetivos_agencias` (`id_objetivo_agencia`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `id_entrada6`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`objetivos` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_objetivo`
    FOREIGN KEY (`id_objetivo`)
    REFERENCES `syllabus_system`.`objetivos` (`id_objetivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`recursos_en_linea`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`recursos_en_linea` (
  `id_entrada` INT NOT NULL,
  `recursos` VARCHAR(250) NOT NULL,
  INDEX `codigo_curso_idx` (`id_entrada` ASC) VISIBLE,
  CONSTRAINT `codigo_curso7`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`libro_texto`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`libro_texto` (
  `id_entrada` INT NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  CONSTRAINT `id_entrada10`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`prerequisito`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`prerequisito` (
  `id_entrada` INT NOT NULL,
  `curso_previo` VARCHAR(10) NOT NULL,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  INDEX `curso_previo_idx` (`curso_previo` ASC) VISIBLE,
  CONSTRAINT `id_entrada9`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `curso_previo`
    FOREIGN KEY (`curso_previo`)
    REFERENCES `syllabus_system`.`cursos` (`codigo_curso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `syllabus_system`.`correquisitos`
-- -----------------------------------------------------
CREATE TABLE `syllabus_system`.`correquisitos` (
  `id_entrada` INT NOT NULL,
  `curso` VARCHAR(10) NOT NULL,
  INDEX `id_entrada_idx` (`id_entrada` ASC) VISIBLE,
  INDEX `curso_idx` (`curso` ASC) VISIBLE,
  CONSTRAINT `id_entrada8`
    FOREIGN KEY (`id_entrada`)
    REFERENCES `syllabus_system`.`syllabuses` (`id_entrada`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `curso`
    FOREIGN KEY (`curso`)
    REFERENCES `syllabus_system`.`cursos` (`codigo_curso`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE = '';
DROP USER IF EXISTS education_client;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'education_client' IDENTIFIED BY 'YourPassword';
GRANT SELECT, INSERT, UPDATE on syllabus_system.* to 'education_client'@'%'; 

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;