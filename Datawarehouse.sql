-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema datawarehouse
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema datawarehouse
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `datawarehouse` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `datawarehouse` ;

-- -----------------------------------------------------
-- Table `datawarehouse`.`branch_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`branch_dimension` (
  `BranchKey` VARCHAR(45) NOT NULL,
  `Street` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `Province` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`BranchKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`customer_demographic_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`customer_demographic_dimension` (
  `CustomerDemographicKey` VARCHAR(45) NOT NULL,
  `AgeBand` INT NULL DEFAULT NULL,
  `IncomeBand` INT NULL DEFAULT NULL,
  `MaritalStatus` INT NULL DEFAULT NULL,
  `IsEmployed` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerDemographicKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`customer_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`customer_dimension` (
  `CustomerKey` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `DOB` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`date_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`date_dimension` (
  `DateKey` VARCHAR(45) NOT NULL,
  `Date` INT NULL DEFAULT NULL,
  `Month` INT NULL DEFAULT NULL,
  `Year` INT NULL DEFAULT NULL,
  `Quater` INT NULL DEFAULT NULL,
  PRIMARY KEY (`DateKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`loan_category_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`loan_category_dimension` (
  `CategoryKey` VARCHAR(45) NOT NULL,
  `Lifespan` INT NULL DEFAULT NULL,
  `Rate` DOUBLE NULL DEFAULT NULL,
  `Purpose` VARCHAR(45) NULL DEFAULT NULL,
  `IsSecured` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`loan_started_date_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`loan_started_date_dimension` (
  `LoanStartedDateKey` VARCHAR(45) NOT NULL,
  `LoanStartedDate` INT NULL DEFAULT NULL,
  `LoanStartedMonth` INT NULL DEFAULT NULL,
  `LoanStartedYear` INT NULL DEFAULT NULL,
  `LoanStartedQuater` INT NULL DEFAULT NULL,
  PRIMARY KEY (`LoanStartedDateKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`loan_dimension`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`loan_dimension` (
  `LoanKey` VARCHAR(45) NOT NULL,
  `AvailableLoanAmount` INT NULL DEFAULT NULL,
  `LoanStartedDateKey` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LoanKey`),
  INDEX `fk_loan_dimension_loan_started_date_dimension1_idx` (`LoanStartedDateKey` ASC) VISIBLE,
  CONSTRAINT `fk_loan_dimension_loan_started_date_dimension1`
    FOREIGN KEY (`LoanStartedDateKey`)
    REFERENCES `datawarehouse`.`loan_started_date_dimension` (`LoanStartedDateKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`loan_transaction_facts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`loan_transaction_facts` (
  `DateKey` VARCHAR(45) NOT NULL,
  `BranchKey` VARCHAR(45) NOT NULL,
  `CategoryKey` VARCHAR(45) NOT NULL,
  `CustomerKey` VARCHAR(45) NOT NULL,
  `CustomerDemographicKey` VARCHAR(45) NOT NULL,
  `LoanKey` VARCHAR(45) NOT NULL,
  `RepaidAmount` INT NULL DEFAULT NULL,
  `LoanAmount` INT NULL DEFAULT NULL,
  INDEX `fk_monthly_loan_snapshot_facts_date_dimension_idx` (`DateKey` ASC) VISIBLE,
  INDEX `fk_monthly_loan_snapshot_facts_branch_dimension1_idx` (`BranchKey` ASC) VISIBLE,
  INDEX `fk_monthly_loan_snapshot_facts_loan_category_dimension1_idx` (`CategoryKey` ASC) VISIBLE,
  INDEX `fk_monthly_loan_snapshot_facts_customer_dimension1_idx` (`CustomerKey` ASC) VISIBLE,
  INDEX `fk_monthly_loan_snapshot_facts_customer_demographic_dimensi_idx` (`CustomerDemographicKey` ASC) VISIBLE,
  INDEX `fk_monthly_loan_snapshot_facts_loan_dimension1_idx` (`LoanKey` ASC) VISIBLE,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_branch_dimension1`
    FOREIGN KEY (`BranchKey`)
    REFERENCES `datawarehouse`.`branch_dimension` (`BranchKey`),
  CONSTRAINT `fk_monthly_loan_snapshot_facts_customer_demographic_dimension1`
    FOREIGN KEY (`CustomerDemographicKey`)
    REFERENCES `datawarehouse`.`customer_demographic_dimension` (`CustomerDemographicKey`),
  CONSTRAINT `fk_monthly_loan_snapshot_facts_customer_dimension1`
    FOREIGN KEY (`CustomerKey`)
    REFERENCES `datawarehouse`.`customer_dimension` (`CustomerKey`),
  CONSTRAINT `fk_monthly_loan_snapshot_facts_date_dimension`
    FOREIGN KEY (`DateKey`)
    REFERENCES `datawarehouse`.`date_dimension` (`DateKey`),
  CONSTRAINT `fk_monthly_loan_snapshot_facts_loan_category_dimension1`
    FOREIGN KEY (`CategoryKey`)
    REFERENCES `datawarehouse`.`loan_category_dimension` (`CategoryKey`),
  CONSTRAINT `fk_monthly_loan_snapshot_facts_loan_dimension1`
    FOREIGN KEY (`LoanKey`)
    REFERENCES `datawarehouse`.`loan_dimension` (`LoanKey`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
