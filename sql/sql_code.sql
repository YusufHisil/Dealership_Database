-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema proiectbd
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema proiect
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`reprezentanta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reprezentanta` (
  `idReprezentanta` INT NOT NULL AUTO_INCREMENT,
  `Nume` VARCHAR(45) NOT NULL,
  `Adresa` VARCHAR(45) NOT NULL,
  `Nr_atelier` INT NOT NULL,
  PRIMARY KEY (`idReprezentanta`),
  UNIQUE INDEX `Nume_UNIQUE` (`Nume` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`angajat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`angajat` (
  `idAngajat` INT NOT NULL AUTO_INCREMENT,
  `Nume` VARCHAR(45) NOT NULL,
  `Prenume` VARCHAR(45) NOT NULL,
  `CNP` VARCHAR(45) NOT NULL,
  `Rol` ENUM('Mecanic', 'Agent_vanzari', 'Director_reprezentanta', 'Director_principal', 'Contabil', 'Resurse_umane') NOT NULL,
  `Adresa` VARCHAR(45) NOT NULL,
  `Salariu` DOUBLE NOT NULL,
  `Ore_lucru` INT NOT NULL,
  `Valabilitate_contract` DATETIME NULL DEFAULT NULL,
  `Angajatcol` INT NULL DEFAULT NULL,
  `IdReprezentanta` INT NOT NULL,
  PRIMARY KEY (`idAngajat`),
  INDEX `idReprezentanta_idx` (`IdReprezentanta` ASC) VISIBLE,
  CONSTRAINT `idReprezentanta`
    FOREIGN KEY (`IdReprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`idReprezentanta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`agent_vanzare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`agent_vanzare` (
  `id_Agent` INT NOT NULL,
  `idAngajat` INT NOT NULL,
  PRIMARY KEY (`id_Agent`),
  INDEX `idAngajat_idx` (`idAngajat` ASC) VISIBLE,
  CONSTRAINT `fk_idAngajat_agent`
    FOREIGN KEY (`idAngajat`)
    REFERENCES `mydb`.`angajat` (`idAngajat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`atelier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`atelier` (
  `idAtelier` INT NOT NULL AUTO_INCREMENT,
  `id_reprezentanta` INT NOT NULL,
  `Specializare` VARCHAR(45) NOT NULL,
  `Dimensiune` ENUM('Masina', 'Duba', 'Tir') NOT NULL,
  PRIMARY KEY (`idAtelier`),
  INDEX `id_reprezentanta_idx` (`id_reprezentanta` ASC) VISIBLE,
  CONSTRAINT `id_reprezentanta`
    FOREIGN KEY (`id_reprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`idReprezentanta`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`client` (
  `idClient` INT NOT NULL AUTO_INCREMENT,
  `Nume` VARCHAR(45) NOT NULL,
  `Prenume` VARCHAR(45) NOT NULL,
  `CNP` VARCHAR(45) NOT NULL,
  `Adresa` VARCHAR(45) NULL DEFAULT NULL,
  `Tel` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idClient`, `Nume`),
  UNIQUE INDEX `nume_unique_idx` (`Nume` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`piesa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`piesa` (
  `idPiesa` INT NOT NULL AUTO_INCREMENT,
  `Nume` VARCHAR(45) NOT NULL,
  `Marca` VARCHAR(45) NOT NULL,
  `Serie` VARCHAR(45) NOT NULL,
  `Pret` DOUBLE NOT NULL,
  PRIMARY KEY (`idPiesa`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`comanda` (
  `idComanda` INT NOT NULL AUTO_INCREMENT,
  `id_reprezentanta` INT NOT NULL,
  `idPiesa` INT NOT NULL,
  `cantitate` INT NOT NULL,
  `idDistribuitor` INT NOT NULL,
  PRIMARY KEY (`idComanda`),
  INDEX `idPiesa_idx` (`idPiesa` ASC) VISIBLE,
  INDEX `id_reprezentanta_idx` (`id_reprezentanta` ASC) VISIBLE,
  CONSTRAINT `fk_id_reprezentanta`
    FOREIGN KEY (`id_reprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`idReprezentanta`),
  CONSTRAINT `fk_idPiesa`
    FOREIGN KEY (`idPiesa`)
    REFERENCES `mydb`.`piesa` (`idPiesa`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`distribuitor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`distribuitor` (
  `idDistribuitor` INT NOT NULL AUTO_INCREMENT,
  `Nume` VARCHAR(45) NULL DEFAULT NULL,
  `Telefon` VARCHAR(45) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NULL DEFAULT NULL,
  `Adresa` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idDistribuitor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`depozit_distribuitor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`depozit_distribuitor` (
  `idPiesa` INT NOT NULL,
  `id_distribuitor` INT NOT NULL,
  `Cantitate` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idPiesa`, `id_distribuitor`),
  INDEX `id_distribuitor_idx` (`id_distribuitor` ASC) VISIBLE,
  CONSTRAINT `id_distribuitor`
    FOREIGN KEY (`id_distribuitor`)
    REFERENCES `mydb`.`distribuitor` (`idDistribuitor`),
  CONSTRAINT `idPiesa`
    FOREIGN KEY (`idPiesa`)
    REFERENCES `mydb`.`piesa` (`idPiesa`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`mecanic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mecanic` (
  `idMecanic` INT NOT NULL AUTO_INCREMENT,
  `idAngajat` INT NOT NULL,
  `Nivel_exprtiza` INT NOT NULL,
  `Specializare` ENUM('mecanic', 'electrician') NOT NULL,
  PRIMARY KEY (`idMecanic`),
  INDEX `idAngajat_idx` (`idAngajat` ASC) VISIBLE,
  CONSTRAINT `idAngajat`
    FOREIGN KEY (`idAngajat`)
    REFERENCES `mydb`.`angajat` (`idAngajat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`programare_atelier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`programare_atelier` (
  `idProgramare_atelier` INT NOT NULL AUTO_INCREMENT,
  `idAtelier` INT NOT NULL,
  `idMecanic` INT NOT NULL,
  `idClient` INT NOT NULL,
  `Data` DATETIME NOT NULL,
  PRIMARY KEY (`idProgramare_atelier`),
  INDEX `idAtelier_idx` (`idAtelier` ASC) VISIBLE,
  INDEX `idMecanic_idx` (`idMecanic` ASC) VISIBLE,
  INDEX `idClient_idx` (`idClient` ASC) VISIBLE,
  CONSTRAINT `idAtelier`
    FOREIGN KEY (`idAtelier`)
    REFERENCES `mydb`.`atelier` (`idAtelier`),
  CONSTRAINT `idClient`
    FOREIGN KEY (`idClient`)
    REFERENCES `mydb`.`client` (`idClient`),
  CONSTRAINT `idMecanic`
    FOREIGN KEY (`idMecanic`)
    REFERENCES `mydb`.`mecanic` (`idMecanic`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`factura_serviciu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`factura_serviciu` (
  `idFactura` INT NOT NULL AUTO_INCREMENT,
  `Nume_client` VARCHAR(45) NOT NULL,
  `Nume_reprezentanta` VARCHAR(45) NOT NULL,
  `Data_facturarii` DATE NOT NULL,
  `Suma` DOUBLE NULL,
  `id_programare` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idFactura`),
  INDEX `id_programare_idx` (`id_programare` ASC) VISIBLE,
  INDEX `nume_client_idx` (`Nume_client` ASC) VISIBLE,
  INDEX `nume_reprezentanta_idx` (`Nume_reprezentanta` ASC) VISIBLE,
  CONSTRAINT `id_programare`
    FOREIGN KEY (`id_programare`)
    REFERENCES `mydb`.`programare_atelier` (`idProgramare_atelier`),
  CONSTRAINT `nume_client`
    FOREIGN KEY (`Nume_client`)
    REFERENCES `mydb`.`client` (`Nume`),
  CONSTRAINT `nume_reprezentanta`
    FOREIGN KEY (`Nume_reprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`Nume`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`masina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`masina` (
  `idMasina` INT NOT NULL AUTO_INCREMENT,
  `Marca` VARCHAR(45) NOT NULL,
  `Model` VARCHAR(45) NOT NULL,
  `An_fabricatie` VARCHAR(45) NOT NULL,
  `Tip_caroserie` ENUM('Sedan', 'Suv', 'Cabrio', 'Coupe', 'Berlina', 'Hatchback', 'Break') NOT NULL,
  `Serie_sasiu` VARCHAR(45) NOT NULL,
  `Culoare` ENUM('Rosie', 'Albastra', 'Alba', 'Neagra', 'Gri') NOT NULL,
  `CP` INT NOT NULL,
  `Combustibil` ENUM('Diesel', 'Benzina', 'Electric') NOT NULL,
  `Pret` DOUBLE NOT NULL,
  PRIMARY KEY (`idMasina`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`vanzare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vanzare` (
  `idVanzare` INT NOT NULL,
  `id_Agent` INT NOT NULL,
  `id_client` INT NOT NULL,
  `id_masina` INT NOT NULL,
  `Data` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idVanzare`),
  INDEX `id_masina_idx` (`id_masina` ASC) VISIBLE,
  INDEX `id_client_idx` (`id_client` ASC) VISIBLE,
  INDEX `id_Agent_idx` (`id_Agent` ASC) VISIBLE,
  CONSTRAINT `id_Agent`
    FOREIGN KEY (`id_Agent`)
    REFERENCES `mydb`.`agent_vanzare` (`id_Agent`),
  CONSTRAINT `id_client`
    FOREIGN KEY (`id_client`)
    REFERENCES `mydb`.`client` (`idClient`),
  CONSTRAINT `id_masina`
    FOREIGN KEY (`id_masina`)
    REFERENCES `mydb`.`masina` (`idMasina`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`factura_vanzare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`factura_vanzare` (
  `idFactura` INT NOT NULL,
  `Nume_client` VARCHAR(45) NOT NULL,
  `Nume_reprezentanta` VARCHAR(45) NOT NULL,
  `Data_facturarii` DATE NOT NULL,
  `Suma` DOUBLE NOT NULL,
  `id_vanzare` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idFactura`),
  INDEX `Nume_client_idx` (`Nume_client` ASC) VISIBLE,
  INDEX `Nume_reprezentanta_idx` (`Nume_reprezentanta` ASC) VISIBLE,
  INDEX `id_vanzare_idx` (`id_vanzare` ASC) VISIBLE,
  CONSTRAINT `fk_id_vanzare_factura`
    FOREIGN KEY (`id_vanzare`)
    REFERENCES `mydb`.`vanzare` (`idVanzare`),
  CONSTRAINT `fk_Nume_client_factura`
    FOREIGN KEY (`Nume_client`)
    REFERENCES `mydb`.`client` (`Nume`),
  CONSTRAINT `fk_Nume_reprezentanta_factura`
    FOREIGN KEY (`Nume_reprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`Nume`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`inventar_masini`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`inventar_masini` (
  `id_Inventar` INT NOT NULL AUTO_INCREMENT,
  `id_reprezentanta` INT NOT NULL,
  `id_masina` INT NOT NULL,
  `nr_masini` INT NOT NULL,
  PRIMARY KEY (`id_Inventar`),
  INDEX `id_reprezentanta_idx` (`id_reprezentanta` ASC) VISIBLE,
  INDEX `id_masina_idx` (`id_masina` ASC) VISIBLE,
  CONSTRAINT `fk_id_masina_inventar`
    FOREIGN KEY (`id_masina`)
    REFERENCES `mydb`.`masina` (`idMasina`),
  CONSTRAINT `fk_id_reprezentanta_inventar`
    FOREIGN KEY (`id_reprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`idReprezentanta`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`inventar_piese`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`inventar_piese` (
  `idInventar` INT NOT NULL AUTO_INCREMENT,
  `idReprezentanta` INT NOT NULL,
  `idPiesa` INT NOT NULL,
  `Cantitate` INT NOT NULL,
  PRIMARY KEY (`idInventar`),
  INDEX `idReprezentanta_idx` (`idReprezentanta` ASC) VISIBLE,
  CONSTRAINT `idReprezentanta2`
    FOREIGN KEY (`idReprezentanta`)
    REFERENCES `mydb`.`reprezentanta` (`idReprezentanta`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`lista_serviciu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`lista_serviciu` (
  `Serviciu` VARCHAR(45) NOT NULL,
  `Pret` DOUBLE NOT NULL,
  `Durata_estimata_ore` INT NULL DEFAULT NULL,
  `SpecializareServiciu` ENUM('mecanic', 'electrician') NOT NULL,
  PRIMARY KEY (`Serviciu`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`serviciu_programare`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`serviciu_programare` (
  `idServiciu_programare` INT NOT NULL AUTO_INCREMENT,
  `Nume_serviciu` VARCHAR(45) NOT NULL,
  `id_programare` INT NOT NULL,
  PRIMARY KEY (`idServiciu_programare`),
  INDEX `id_programare_idx` (`id_programare` ASC) VISIBLE,
  INDEX `Nume_serviciu_idx` (`Nume_serviciu` ASC) VISIBLE,
  CONSTRAINT `fk_id_programare`
    FOREIGN KEY (`id_programare`)
    REFERENCES `mydb`.`programare_atelier` (`idProgramare_atelier`),
  CONSTRAINT `fk_Nume_serviciu`
    FOREIGN KEY (`Nume_serviciu`)
    REFERENCES `mydb`.`lista_serviciu` (`Serviciu`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `Password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUser`),
  CONSTRAINT `id_User`
    FOREIGN KEY (`idUser`)
    REFERENCES `mydb`.`angajat` (`idAngajat`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`piese_necesare_serviciu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`piese_necesare_serviciu` (
  `idPiese_necesare` INT NOT NULL,
  `Serviciu` VARCHAR(45) NULL,
  `idPiesa` INT NULL,
  `Cantitate` INT NULL,
  PRIMARY KEY (`idPiese_necesare`),
  INDEX `fk1_idx` (`Serviciu` ASC) VISIBLE,
  CONSTRAINT `fk1`
    FOREIGN KEY (`Serviciu`)
    REFERENCES `mydb`.`lista_serviciu` (`Serviciu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- For `reprezentanta` table
ALTER TABLE `mydb`.`reprezentanta` AUTO_INCREMENT=1;

-- For `angajat` table
ALTER TABLE `mydb`.`angajat` AUTO_INCREMENT=1;

-- For `agent_vanzare` table
ALTER TABLE `mydb`.`agent_vanzare` AUTO_INCREMENT=1;

-- For `atelier` table
ALTER TABLE `mydb`.`atelier` AUTO_INCREMENT=1;

-- For `client` table
ALTER TABLE `mydb`.`client` AUTO_INCREMENT=1;

-- For `piesa` table
ALTER TABLE `mydb`.`piesa` AUTO_INCREMENT=1;

-- For `comanda` table
ALTER TABLE `mydb`.`comanda` AUTO_INCREMENT=1;

-- For `distribuitor` table
ALTER TABLE `mydb`.`distribuitor` AUTO_INCREMENT=1;

-- For `depozit_distribuitor` table
ALTER TABLE `mydb`.`depozit_distribuitor` AUTO_INCREMENT=1;

-- For `mecanic` table
ALTER TABLE `mydb`.`mecanic` AUTO_INCREMENT=1;

-- For `programare_atelier` table
ALTER TABLE `mydb`.`programare_atelier` AUTO_INCREMENT=1;

-- For `factura_serviciu` table
ALTER TABLE `mydb`.`factura_serviciu` AUTO_INCREMENT=1;

-- For `masina` table
ALTER TABLE `mydb`.`masina` AUTO_INCREMENT=1;

-- For `vanzare` table
ALTER TABLE `mydb`.`vanzare` AUTO_INCREMENT=1;

-- For `factura_vanzare` table
ALTER TABLE `mydb`.`factura_vanzare` AUTO_INCREMENT=1;

-- For `inventar_masini` table
ALTER TABLE `mydb`.`inventar_masini` AUTO_INCREMENT=1;

-- For `inventar_piese` table
ALTER TABLE `mydb`.`inventar_piese` AUTO_INCREMENT=1;

-- For `lista_serviciu` table
ALTER TABLE `mydb`.`lista_serviciu` AUTO_INCREMENT=1;

-- For `serviciu_programare` table
ALTER TABLE `mydb`.`serviciu_programare` AUTO_INCREMENT=1;

-- For `user` table
ALTER TABLE `mydb`.`user` AUTO_INCREMENT=1;

-- For `piese_necesare_serviciu` table
ALTER TABLE `mydb`.`piese_necesare_serviciu`
MODIFY COLUMN `idPiese_necesare` INT AUTO_INCREMENT;
-- For `piese_necesare_serviciu` table
ALTER TABLE `mydb`.`piese_necesare_serviciu` AUTO_INCREMENT=1;


-- Alter the table to make idFactura an auto-incrementing primary key
ALTER TABLE `mydb`.`factura_vanzare`
MODIFY COLUMN `idFactura` INT NOT NULL AUTO_INCREMENT,
 AUTO_INCREMENT=1;
