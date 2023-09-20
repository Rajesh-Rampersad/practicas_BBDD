-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Productos
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Productos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Productos` ;
USE `Productos` ;

-- -----------------------------------------------------
-- Table `Productos`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`Productos` (
  `Prod_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Prod_Descripcion` VARCHAR(80) NULL,
  `Prod_ColorId` SMALLINT(4) UNSIGNED NULL,
  `Prod_UnimedID` SMALLINT(2) UNSIGNED NULL,
  `Prod_Medida` DECIMAL(6,2) UNSIGNED NULL,
  `Prod_ProvId` INT UNSIGNED NULL,
  `Prod_CompraSusp` BIT(1) NULL,
  `Prod_VentaSusp` BIT(1) NULL,
  `Prod_Status` CHAR(1) NULL,
  PRIMARY KEY (`Prod_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`Sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`Sucursal` (
  `Suc_Id` SMALLINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Suc_Nombre` VARCHAR(50) NULL,
  `Suc_Status` CHAR(1) NULL,
  PRIMARY KEY (`Suc_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`Deposito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`Deposito` (
  `Dep_Id` SMALLINT(4) UNSIGNED NOT NULL,
  `Dep_SucId` SMALLINT(3) UNSIGNED NULL,
  `Dep_Status` CHAR(1) NULL,
  `Dep_Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`Dep_Id`),
  INDEX `fk_Depo_Sucursales_idx` (`Dep_SucId` ASC) VISIBLE,
  CONSTRAINT `fk_Depo_Sucursales`
    FOREIGN KEY (`Dep_SucId`)
    REFERENCES `Productos`.`Sucursal` (`Suc_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`DepSecciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`DepSecciones` (
  `DS_Id` MEDIUMINT(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `DS_DepId` SMALLINT(4) UNSIGNED NULL,
  `DS_Nombre` VARCHAR(45) NULL,
  `DS_Status` CHAR(1) NULL,
  PRIMARY KEY (`DS_Id`),
  INDEX `fk_DS_Depositos_idx` (`DS_DepId` ASC) VISIBLE,
  CONSTRAINT `fk_DS_Depositos`
    FOREIGN KEY (`DS_DepId`)
    REFERENCES `Productos`.`Deposito` (`Dep_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`Racks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`Racks` (
  `Rack_Id` INT UNSIGNED NULL AUTO_INCREMENT,
  `Rack_DSId` MEDIUMINT(6) UNSIGNED NULL,
  `Rack_Nro` MEDIUMINT(4) UNSIGNED NULL,
  `Rack_Fila` TINYINT(2) UNSIGNED NULL,
  `Rack_Columna` TINYINT(3) UNSIGNED NULL,
  `Rack_Status` CHAR(1) NULL,
  PRIMARY KEY (`Rack_Id`),
  INDEX `fk_Racks_DS_idx` (`Rack_DSId` ASC) VISIBLE,
  CONSTRAINT `fk_Racks_DS`
    FOREIGN KEY (`Rack_DSId`)
    REFERENCES `Productos`.`DepSecciones` (`DS_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`StockDet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`StockDet` (
  `STD_Id` INT UNSIGNED ZEROFILL NOT NULL,
  `SDT_ProdId` INT UNSIGNED NULL,
  `SDT_RackId` INT UNSIGNED NULL,
  `STD_Fila` TINYINT(2) UNSIGNED NULL,
  `STD_Columna` TINYINT(3) UNSIGNED NULL,
  `STD_Stock` MEDIUMINT(5) UNSIGNED NULL,
  `STD_UltMov` DATE NULL,
  `STD_UltInventario` DATE NULL,
  PRIMARY KEY (`STD_Id`),
  INDEX `FechaUltMov` () VISIBLE,
  INDEX `FechaUltInventario` () VISIBLE,
  UNIQUE INDEX `RackFilaColumna` (`SDT_RackId` ASC, `STD_Fila` ASC, `STD_Columna` ASC) VISIBLE,
  UNIQUE INDEX `ProdRackFilaColumna` (`SDT_ProdId` ASC, `SDT_RackId` ASC, `STD_Fila` ASC, `STD_Columna` ASC) VISIBLE,
  CONSTRAINT `fk_STD_Productos`
    FOREIGN KEY (`SDT_ProdId`)
    REFERENCES `Productos`.`Productos` (`Prod_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_STD_Racks`
    FOREIGN KEY (`SDT_RackId`)
    REFERENCES `Productos`.`Racks` (`Rack_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`Mapa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`Mapa` (
  `Mapa_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Mapa_RackId` INT UNSIGNED NULL,
  `Mapa_Fila` SMALLINT(2) UNSIGNED NULL,
  `Mapa_Columna` SMALLINT(3) UNSIGNED NULL,
  `Mapa_ProdId` INT UNSIGNED NULL,
  `Mapa_Cantidad` MEDIUMINT(5) UNSIGNED NULL,
  PRIMARY KEY (`Mapa_Id`),
  INDEX `fk_Mapa_Racks_idx` (`Mapa_RackId` ASC) VISIBLE,
  CONSTRAINT `fk_Mapa_Racks`
    FOREIGN KEY (`Mapa_RackId`)
    REFERENCES `Productos`.`Racks` (`Rack_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`StockMae`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`StockMae` (
  `STM_ProdID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `STM_Stock` INT NULL,
  `STM_Status` CHAR(1) NULL,
  `STM_UltMov` DATE NULL,
  `STM_UltInvent` DATE NULL,
  PRIMARY KEY (`STM_ProdID`),
  INDEX `FechaUltMov` (`STM_UltMov` ASC) VISIBLE,
  INDEX `FechaUltInventario` (`STM_UltInvent` ASC) VISIBLE,
  CONSTRAINT `fk_STM_Productos`
    FOREIGN KEY (`STM_ProdID`)
    REFERENCES `Productos`.`Productos` (`Prod_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`StockHist2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`StockHist2019` (
  `SH_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `SH_Mes` TINYINT(2) UNSIGNED NULL,
  `SH_ProdID` INT UNSIGNED NULL,
  `SH_DepoID` SMALLINT(4) UNSIGNED NULL,
  `SH_Stock` INT NULL,
  `SH_Costo` DECIMAL(10,2) UNSIGNED NULL,
  PRIMARY KEY (`SH_Id`),
  INDEX `Mes` () VISIBLE,
  INDEX `FechaUltMov` () VISIBLE,
  INDEX `fk_SH_Productos_idx` (`SH_ProdID` ASC) VISIBLE,
  INDEX `fk_SH_Depositos_idx` (`SH_DepoID` ASC) VISIBLE,
  CONSTRAINT `fk_SH_Productos`
    FOREIGN KEY (`SH_ProdID`)
    REFERENCES `Productos`.`Productos` (`Prod_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SH_Depositos`
    FOREIGN KEY (`SH_DepoID`)
    REFERENCES `Productos`.`Deposito` (`Dep_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Productos`.`StockMovDet2019_08`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos`.`StockMovDet2019_08` (
  `SMD_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `SMD_Fecha` DATETIME NULL,
  `SMD_Mov` CHAR(1) NULL,
  `SMD_ProdId` INT UNSIGNED NULL,
  `SMD_RackId` INT UNSIGNED NULL,
  `SMD_Cant` MEDIUMINT(5) NULL,
  PRIMARY KEY (`SMD_Id`),
  INDEX `Fecha` (`SMD_Fecha` ASC) VISIBLE,
  INDEX `fk_SMD_Racks_idx` (`SMD_RackId` ASC) VISIBLE,
  INDEX `fk_SMD_Productos_idx` (`SMD_ProdId` ASC) VISIBLE,
  CONSTRAINT `fk_SMD_Racks`
    FOREIGN KEY (`SMD_RackId`)
    REFERENCES `Productos`.`Racks` (`Rack_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SMD_Productos`
    FOREIGN KEY (`SMD_ProdId`)
    REFERENCES `Productos`.`Productos` (`Prod_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
