-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Productos` (
  `Prod_Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Prod_Descripcion` VARCHAR(80) NULL,
  `Prod_ColorId` SMALLINT(4) UNSIGNED NULL,
  `Prod_UnimedId` SMALLINT(2) UNSIGNED NULL,
  `Prod_Medida` DECIMAL(6,2) UNSIGNED NULL,
  `Prod_ProvId` INT UNSIGNED NULL,
  `Prod_CompraSusp` BIT(1) NULL,
  `Prod_VentaSusp` BIT(1) NULL,
  `Prod_Status` CHAR(1) NULL,
  PRIMARY KEY (`Prod_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Listas_CostoPrecio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Listas_CostoPrecio` (
  `LCP_Id` SMALLINT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
  `LCP_Nombre` VARCHAR(45) NULL,
  `LCP_CP` ENUM("C", "P") NULL,
  `LCP_Status` CHAR(1) NULL,
  `LCP_FechaDesde` DATE NULL,
  `LCP_FechaHasta` DATE NULL,
  PRIMARY KEY (`LCP_Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Costos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Costos` (
  `Costos_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Costo_LCPId` SMALLINT(4) UNSIGNED NULL,
  `Costo_ProdId` INT UNSIGNED NULL,
  `Costo_PrecioLista` DECIMAL(10,4) UNSIGNED NULL,
  `Costo_Cotizacion` DECIMAL(10,4) UNSIGNED NULL,
  `Costo_MonedaCorriente` DECIMAL(10,4) UNSIGNED NULL,
  `Costo_Dto1` DECIMAL(4,2) NULL,
  `Costo_Dto2` DECIMAL(4,2) NULL,
  `Costo_Dto3` DECIMAL(4,2) NULL,
  `Costo_Dto4` DECIMAL(4,2) NULL,
  `Costo_Dto5` DECIMAL(4,2) NULL,
  `Costo_Transporte` DECIMAL(4,2) NULL,
  `Costo_iva` DECIMAL(4,2) NULL,
  `Costo_CostoCiva` DECIMAL(4,2) NULL,
  `Costo_CostoSiva` DECIMAL(4,2) NULL,
  `Costo_Fecha` DATETIME NULL,
  PRIMARY KEY (`Costos_Id`),
  INDEX `fk_Costos_LCP_idx` (`Costo_LCPId` ASC) VISIBLE,
  INDEX `fk_Costos_Productos_idx` (`Costo_ProdId` ASC) VISIBLE,
  CONSTRAINT `fk_Costos_LCP`
    FOREIGN KEY (`Costo_LCPId`)
    REFERENCES `mydb`.`Listas_CostoPrecio` (`LCP_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Costos_Productos`
    FOREIGN KEY (`Costo_ProdId`)
    REFERENCES `mydb`.`Productos` (`Prod_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`costo_Historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`costo_Historial` (
  `costoH_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `costoH_CostoID` BIGINT(10) UNSIGNED NULL,
  `costoH_Fecha` DATETIME NULL,
  `costoH_campo` TINYINT(2) NULL,
  `costo_ValorAnt` DECIMAL(10,4) NULL,
  `costoH_ValorPos` VARCHAR(45) NULL,
  PRIMARY KEY (`costoH_Id`),
  INDEX `CostoID_Fecha` (`costoH_CostoID` ASC, `costoH_Fecha` ASC) VISIBLE,
  INDEX `CostoID_Campo` (`costoH_CostoID` ASC, `costoH_campo` ASC) VISIBLE,
  CONSTRAINT `fk_CH_Costos`
    FOREIGN KEY (`costoH_CostoID`)
    REFERENCES `mydb`.`Costos` (`Costos_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Precios` (
  `Precios_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Precios_LCPId` SMALLINT(4) UNSIGNED NULL,
  `Precios_ProdId` INT UNSIGNED NULL,
  `Precios_Margen` DECIMAL(5,2) UNSIGNED NULL,
  `Precios_Precio` DECIMAL(10,4) UNSIGNED NULL,
  PRIMARY KEY (`Precios_Id`),
  INDEX `fk_Precios_LCP_idx` (`Precios_LCPId` ASC) VISIBLE,
  INDEX `fk_Precios_Productos_idx` (`Precios_ProdId` ASC) VISIBLE,
  CONSTRAINT `fk_Precios_LCP`
    FOREIGN KEY (`Precios_LCPId`)
    REFERENCES `mydb`.`Listas_CostoPrecio` (`LCP_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Precios_Productos`
    FOREIGN KEY (`Precios_ProdId`)
    REFERENCES `mydb`.`Productos` (`Prod_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Precio_Historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Precio_Historial` (
  `PrecioH_Id` BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PrecioH_PrecioID` BIGINT(10) UNSIGNED NULL,
  `PrecioH_Fecha` DATETIME NULL,
  `PrecioH_MargenAnt` DECIMAL(5,2) UNSIGNED NULL,
  `PrecioH_MargentPos` DECIMAL(5,2) UNSIGNED NULL,
  `PrecioH_PrecioAnt` DECIMAL(10,4) UNSIGNED NULL,
  `PrecioH_PrecioPos` DECIMAL(10,4) UNSIGNED NULL,
  PRIMARY KEY (`PrecioH_Id`),
  INDEX `PrecioId_Fecha` (`PrecioH_PrecioID` ASC, `PrecioH_Fecha` ASC) VISIBLE,
  CONSTRAINT `fk_PH_Precio`
    FOREIGN KEY (`PrecioH_PrecioID`)
    REFERENCES `mydb`.`Precios` (`Precios_Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
