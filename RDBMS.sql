-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema financialservice
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema financialservice
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `financialservice` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `financialservice` ;

-- -----------------------------------------------------
-- Table `financialservice`.`branch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`branch` (
  `BranchID` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`BranchID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `financialservice`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`customer` (
  `ID` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Job` VARCHAR(45) NULL DEFAULT NULL,
  `DOB` DATETIME NULL DEFAULT NULL,
  `Address` VARCHAR(45) NULL DEFAULT NULL,
  `MaritalStatus` INT NULL DEFAULT NULL,
  `Income` INT NULL DEFAULT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `financialservice`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`account` (
  `AccountID` VARCHAR(45) NOT NULL,
  `CreatedDate` DATETIME NULL DEFAULT NULL,
  `Balance` INT NULL DEFAULT NULL,
  `CustomerID` VARCHAR(45) NOT NULL,
  `BranchID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AccountID`),
  INDEX `fk_account_customer_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_account_branch1_idx` (`BranchID` ASC) VISIBLE,
  CONSTRAINT `fk_account_branch1`
    FOREIGN KEY (`BranchID`)
    REFERENCES `financialservice`.`branch` (`BranchID`),
  CONSTRAINT `fk_account_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `financialservice`.`customer` (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `financialservice`.`loan_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`loan_category` (
  `CategoryID` VARCHAR(45) NOT NULL,
  `LifeSpan` INT NULL DEFAULT NULL,
  `Rate` DOUBLE NULL DEFAULT NULL,
  `Purpose` VARCHAR(45) NULL DEFAULT NULL,
  `IsSecured` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `financialservice`.`loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`loan` (
  `LoanID` VARCHAR(45) NOT NULL,
  `AvailableAmount` INT NULL DEFAULT NULL,
  `StartDate` DATETIME NULL DEFAULT NULL,
  `AccountID` VARCHAR(45) NOT NULL,
  `CategoryID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LoanID`),
  INDEX `fk_loan_account1_idx` (`AccountID` ASC) VISIBLE,
  INDEX `fk_loan_loan_category1_idx` (`CategoryID` ASC) VISIBLE,
  CONSTRAINT `fk_loan_account1`
    FOREIGN KEY (`AccountID`)
    REFERENCES `financialservice`.`account` (`AccountID`),
  CONSTRAINT `fk_loan_loan_category1`
    FOREIGN KEY (`CategoryID`)
    REFERENCES `financialservice`.`loan_category` (`CategoryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `financialservice`.`loan_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `financialservice`.`loan_transaction` (
  `TransactionID` VARCHAR(45) NOT NULL,
  `Date` DATETIME NULL DEFAULT NULL,
  `Amount` INT NULL DEFAULT NULL,
  `LoanID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TransactionID`),
  INDEX `fk_loan_transaction_loan1_idx` (`LoanID` ASC) VISIBLE,
  CONSTRAINT `fk_loan_transaction_loan1`
    FOREIGN KEY (`LoanID`)
    REFERENCES `financialservice`.`loan` (`LoanID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
