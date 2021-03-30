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
-- -----------------------------------------------------
-- Schema financialservice
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema financialservice
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `financialservice` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
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
  `Job` VARCHAR(45) NULL DEFAULT NULL,
  `Income` INT NULL DEFAULT NULL,
  `MaritalStatus` INT NULL DEFAULT NULL,
  `Street` VARCHAR(45) NULL DEFAULT NULL,
  `City` VARCHAR(45) NULL DEFAULT NULL,
  `Province` VARCHAR(45) NULL DEFAULT NULL,
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
    REFERENCES `datawarehouse`.`loan_started_date_dimension` (`LoanStartedDateKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `datawarehouse`.`monthly_loan_snapshot_facts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`monthly_loan_snapshot_facts` (
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
  CONSTRAINT `fk_monthly_loan_snapshot_facts_date_dimension`
    FOREIGN KEY (`DateKey`)
    REFERENCES `datawarehouse`.`date_dimension` (`DateKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_branch_dimension1`
    FOREIGN KEY (`BranchKey`)
    REFERENCES `datawarehouse`.`branch_dimension` (`BranchKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_loan_category_dimension1`
    FOREIGN KEY (`CategoryKey`)
    REFERENCES `datawarehouse`.`loan_category_dimension` (`CategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_customer_dimension1`
    FOREIGN KEY (`CustomerKey`)
    REFERENCES `datawarehouse`.`customer_dimension` (`CustomerKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_customer_demographic_dimension1`
    FOREIGN KEY (`CustomerDemographicKey`)
    REFERENCES `datawarehouse`.`customer_demographic_dimension` (`CustomerDemographicKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_monthly_loan_snapshot_facts_loan_dimension1`
    FOREIGN KEY (`LoanKey`)
    REFERENCES `datawarehouse`.`loan_dimension` (`LoanKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `financialservice` ;

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
  CONSTRAINT `fk_account_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `financialservice`.`customer` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account_branch1`
    FOREIGN KEY (`BranchID`)
    REFERENCES `financialservice`.`branch` (`BranchID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
    REFERENCES `financialservice`.`account` (`AccountID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_loan_loan_category1`
    FOREIGN KEY (`CategoryID`)
    REFERENCES `financialservice`.`loan_category` (`CategoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
    REFERENCES `financialservice`.`loan` (`LoanID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
