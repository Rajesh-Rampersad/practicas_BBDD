-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema controldehorario
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema controldehorario
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `controldehorario` ;
USE `controldehorario` ;

-- -----------------------------------------------------
-- Table `controldehorario`.`Estados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Estados` (
  `Estado_Id` TINYINT(2) UNSIGNED NOT NULL,
  `Estado_Descripcion` VARCHAR(50) NULL,
  PRIMARY KEY (`Estado_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Paises`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Paises` (
  `Pais_Id` TINYINT(3) UNSIGNED NOT NULL,
  `Pais_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Pais_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Provincias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Provincias` (
  `Provin_Id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Provin_PaisID` TINYINT(3) UNSIGNED NOT NULL,
  `Provin_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Provin_Id`),
  INDEX `fk_Provin_Pais_idx` (`Provin_PaisID` ASC) VISIBLE,
  CONSTRAINT `fk_Provin_Pais`
    FOREIGN KEY (`Provin_PaisID`)
    REFERENCES `controldehorario`.`Paises` (`Pais_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Localidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Localidades` (
  `Local_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Local_ProvinID` MEDIUMINT(8) UNSIGNED NOT NULL,
  `Local_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Local_Id`),
  INDEX `fk_Local_Pronvicia_idx` (`Local_ProvinID` ASC) VISIBLE,
  CONSTRAINT `fk_Local_Pronvicia`
    FOREIGN KEY (`Local_ProvinID`)
    REFERENCES `controldehorario`.`Provincias` (`Provin_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`PoliticaHoraria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`PoliticaHoraria` (
  `PH_Id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PH_HorarioFlexible` BIT(1) NULL,
  `PH_Nombre` VARCHAR(60) NULL,
  `PH_Estado` BIT(1) NULL DEFAULT 1,
  PRIMARY KEY (`PH_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Categorias` (
  `Categ_Id` SMALLINT(4) UNSIGNED NOT NULL,
  `Categ_Nombre` VARCHAR(60) NULL,
  PRIMARY KEY (`Categ_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Sectores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Sectores` (
  `Sector_Id` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Sector_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Sector_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Empleados` (
  `Emp_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Emp_Apellido` VARCHAR(60) NULL,
  `Emp_Nombre` VARCHAR(100) NULL,
  `Emp_FechaNac` VARCHAR(45) NULL,
  `Empleadoscol` DATE NULL,
  `Emp_FechaAlta` DATE NULL,
  `Emp_FechaBaja` DATE NULL,
  `Emp_EstadoId` TINYINT(2) UNSIGNED NULL DEFAULT 1,
  `Emp_LocalidadID` INT UNSIGNED NULL,
  `Emp_CategoriaID` SMALLINT(4) UNSIGNED NULL,
  `Emp_SectoId` SMALLINT(3) UNSIGNED NULL,
  `Emp_Salario` DECIMAL(10,2) UNSIGNED NULL DEFAULT 0,
  `Emp_PoliticaHoraria` SMALLINT(4) UNSIGNED NULL,
  `Emp_Domicilio` VARCHAR(150) NULL,
  `Emp_Email` VARCHAR(80) NULL,
  `Emp_Telefono` VARCHAR(20) NULL,
  PRIMARY KEY (`Emp_Id`),
  INDEX `fk_Emp_Estado_idx` (`Emp_EstadoId` ASC) VISIBLE,
  INDEX `fk_Emp_Localidad_idx` (`Emp_LocalidadID` ASC) VISIBLE,
  INDEX `fk_Emp_PH_idx` (`Emp_PoliticaHoraria` ASC) VISIBLE,
  INDEX `fk_Emp_Categ_idx` (`Emp_CategoriaID` ASC) VISIBLE,
  INDEX `fk_Emp_Sector_idx` (`Emp_SectoId` ASC) VISIBLE,
  CONSTRAINT `fk_Emp_Estado`
    FOREIGN KEY (`Emp_EstadoId`)
    REFERENCES `controldehorario`.`Estados` (`Estado_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emp_Localidad`
    FOREIGN KEY (`Emp_LocalidadID`)
    REFERENCES `controldehorario`.`Localidades` (`Local_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emp_PH`
    FOREIGN KEY (`Emp_PoliticaHoraria`)
    REFERENCES `controldehorario`.`PoliticaHoraria` (`PH_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emp_Categ`
    FOREIGN KEY (`Emp_CategoriaID`)
    REFERENCES `controldehorario`.`Categorias` (`Categ_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emp_Sector`
    FOREIGN KEY (`Emp_SectoId`)
    REFERENCES `controldehorario`.`Sectores` (`Sector_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`PoliticaHoraria_Detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`PoliticaHoraria_Detalle` (
  `PHD_Id` MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PHD_PHID` SMALLINT(5) UNSIGNED NOT NULL,
  `PHD_DiaSemana` TINYINT(1) NULL,
  `PHD_HoraD` TIME NULL,
  `PHD_HoraH` TIME NULL,
  `PHD_Horas` TINYINT(2) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`PHD_Id`),
  INDEX `FK_PHD_PH_idx` (`PHD_PHID` ASC) VISIBLE,
  CONSTRAINT `FK_PHD_PH`
    FOREIGN KEY (`PHD_PHID`)
    REFERENCES `controldehorario`.`PoliticaHoraria` (`PH_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`ControlHorario_Mov`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`ControlHorario_Mov` (
  `CHM_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHM_Fecha` DATE NULL,
  `CHM_Hora` TIME NULL,
  `HM_EmpladoID` INT UNSIGNED NULL,
  PRIMARY KEY (`CHM_Id`),
  INDEX `Fecha` (`CHM_Fecha` ASC) VISIBLE,
  INDEX `FechaEmp` (`CHM_Fecha` ASC, `HM_EmpladoID` ASC) VISIBLE,
  INDEX `fk_CHM_Emp_idx` (`HM_EmpladoID` ASC) VISIBLE,
  CONSTRAINT `fk_CHM_Emp`
    FOREIGN KEY (`HM_EmpladoID`)
    REFERENCES `controldehorario`.`Empleados` (`Emp_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`ControlHorario_Res`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`ControlHorario_Res` (
  `CHR_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHR_Fecha` DATE NULL,
  `CHR_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHR_Horas` TINYINT(2) NULL,
  PRIMARY KEY (`CHR_Id`),
  INDEX `Fecha` (`CHR_Fecha` ASC) VISIBLE,
  INDEX `FechaEmpleado` (`CHR_Fecha` ASC, `CHR_EmpleadoID` ASC) VISIBLE,
  INDEX `fk_CHR_Empleado_idx` (`CHR_EmpleadoID` ASC) VISIBLE,
  CONSTRAINT `fk_CHR_Empleado`
    FOREIGN KEY (`CHR_EmpleadoID`)
    REFERENCES `controldehorario`.`Empleados` (`Emp_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`infracciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`infracciones` (
  `infrac_Id` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `infrac_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`infrac_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`ControlHorarioNovedades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`ControlHorarioNovedades` (
  `CHN_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHN_Fecha` VARCHAR(45) NULL,
  `CHN_InfraccionID` SMALLINT(3) UNSIGNED NOT NULL,
  `CHN_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHN_Horas` TINYINT(1) UNSIGNED NULL,
  `CHN_Minutos` TINYINT(3) NULL,
  PRIMARY KEY (`CHN_Id`),
  INDEX `Fecha` (`CHN_Fecha` ASC) VISIBLE,
  INDEX `Empleado` (`CHN_EmpleadoID` ASC) VISIBLE,
  INDEX `FechaEmpleado` (`CHN_Fecha` ASC, `CHN_EmpleadoID` ASC) VISIBLE,
  INDEX `fk_CHN_Empleado_idx` (`CHN_InfraccionID` ASC) VISIBLE,
  CONSTRAINT `fk_CHN_Empleado`
    FOREIGN KEY (`CHN_InfraccionID`)
    REFERENCES `controldehorario`.`Empleados` (`Emp_CategoriaID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CHN_Infrac`
    FOREIGN KEY (`CHN_InfraccionID`)
    REFERENCES `controldehorario`.`infracciones` (`infrac_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`Novedades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`Novedades` (
  `Nove_Id` SMALLINT(4) NOT NULL AUTO_INCREMENT,
  `Nove_Descripcion` VARCHAR(60) NULL,
  PRIMARY KEY (`Nove_Id`),
  CONSTRAINT `fk_Nove_Exc`
    FOREIGN KEY ()
    REFERENCES `controldehorario`.`ControlHorario_Exc` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `controldehorario`.`ControlHorario_Exc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `controldehorario`.`ControlHorario_Exc` (
  `CHE_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CHE_EmpleadoID` INT UNSIGNED NOT NULL,
  `CHE_FechaD` DATE NULL,
  `CHE_FechaH` DATE NULL,
  `CHE_NovedadId` SMALLINT(4) NULL,
  `CHE_Horas` SMALLINT(5) NULL,
  PRIMARY KEY (`CHE_Id`),
  INDEX `fk_CHE_Empleado_idx` (`CHE_EmpleadoID` ASC) VISIBLE,
  INDEX `fk_CHE_Nove_idx` (`CHE_NovedadId` ASC) VISIBLE,
  CONSTRAINT `fk_CHE_Empleado`
    FOREIGN KEY (`CHE_EmpleadoID`)
    REFERENCES `controldehorario`.`Empleados` (`Emp_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CHE_Nove`
    FOREIGN KEY (`CHE_NovedadId`)
    REFERENCES `controldehorario`.`Novedades` (`Nove_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
