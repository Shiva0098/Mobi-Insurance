-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema insurance
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema insurance
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `insurance` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `insurance` ;

-- -----------------------------------------------------
-- Table `insurance`.`insurance_company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`insurance_company` (
  `Company_Name` VARCHAR(255) NOT NULL,
  `Company_Address` VARCHAR(255) NULL DEFAULT NULL,
  `Company_Contact_Number` DECIMAL(11,0) NULL DEFAULT NULL,
  `Company_Fax` INT NULL DEFAULT NULL,
  `Company_Email` VARCHAR(255) NULL DEFAULT NULL,
  `Company_Website` VARCHAR(50) NULL DEFAULT NULL,
  `COMPANY_LOCATION` VARCHAR(100) NULL DEFAULT NULL,
  `Company_Department_Name` VARCHAR(100) NULL DEFAULT NULL,
  `Company_Office_Name` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`Company_Name`),
  UNIQUE INDEX `XPKINSURANCE_COMPANY_15` (`Company_Name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`product` (
  `Product_Type` VARCHAR(15) NULL DEFAULT NULL,
  `Product_Price` INT NULL DEFAULT NULL,
  `Product_Number` VARCHAR(20) NOT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Product_Number`, `Company_Name`),
  UNIQUE INDEX `XPKPRODUCT_20` (`Product_Number` ASC, `Company_Name` ASC) VISIBLE,
  INDEX `R_107` (`Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_107`
    FOREIGN KEY (`Company_Name`)
    REFERENCES `insurance`.`insurance_company` (`Company_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`customer` (
  `Cust_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Cust_FName` VARCHAR(30) NOT NULL,
  `Cust_LName` VARCHAR(30) NOT NULL,
  `Cust_DOB` DATE NOT NULL,
  `Cust_Gender` VARCHAR(7) NOT NULL,
  `Cust_Address` VARCHAR(255) NOT NULL,
  `Cust_MOB_Number` DECIMAL(11,0) NOT NULL,
  `Cust_Email` VARCHAR(255) NULL DEFAULT NULL,
  `Cust_Passport_Number` VARCHAR(20) NULL DEFAULT NULL,
  `Cust_Marital_Status` VARCHAR(10) NULL DEFAULT NULL,
  `Cust_PPS_Number` INT NULL DEFAULT NULL,
  `Password` VARCHAR(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`Cust_Id`, `Password`),
  UNIQUE INDEX `XPKCUSTOMER_1` (`Cust_Id` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`application`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`application` (
  `Application_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Vehicle_Id` BIGINT NOT NULL,
  `Application_Status` ENUM('ACCEPTED', 'REJECTED', 'PENDING') NULL DEFAULT 'PENDING',
  `Product_Id` VARCHAR(20) NOT NULL,
  `Coverage_Level` ENUM('HIGH', 'MEDIUM', 'LOW') NULL DEFAULT 'HIGH',
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Application_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKAPPLICATION_2` (`Application_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_93` (`Cust_Id` ASC) VISIBLE,
  INDEX `P_104` (`Product_Id` ASC) VISIBLE,
  CONSTRAINT `P_104`
    FOREIGN KEY (`Product_Id`)
    REFERENCES `insurance`.`product` (`Product_Number`),
  CONSTRAINT `R_93`
    FOREIGN KEY (`Cust_Id`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 74
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`claim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`claim` (
  `Claim_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Agreement_Id` BIGINT NOT NULL,
  `Claim_Amount` INT NOT NULL,
  `Incident_Id` BIGINT NOT NULL,
  `Date_Of_Claim` DATE NOT NULL,
  `Claim_Status` ENUM('ACCEPTED', 'REJECTED', 'PENDING') NULL DEFAULT 'PENDING',
  `Cust_ID` BIGINT NOT NULL,
  PRIMARY KEY (`Claim_Id`, `Cust_ID`),
  UNIQUE INDEX `XPKCLAIM_7` (`Claim_Id` ASC, `Cust_ID` ASC) VISIBLE,
  INDEX `R_88` (`Cust_ID` ASC) VISIBLE,
  CONSTRAINT `R_88`
    FOREIGN KEY (`Cust_ID`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`claim_settlement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`claim_settlement` (
  `Claim_Settlement_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `Vehicle_Id` BIGINT NOT NULL,
  `Date_Settled` DATE NOT NULL,
  `Amount_Paid` INT NOT NULL,
  `Coverage_Id` VARCHAR(20) NOT NULL,
  `Claim_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Claim_Settlement_ID`, `Claim_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKCLAIM_SETTLEMENT_8` (`Claim_Settlement_ID` ASC, `Claim_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_90` (`Claim_Id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_90`
    FOREIGN KEY (`Claim_Id` , `Cust_Id`)
    REFERENCES `insurance`.`claim` (`Claim_Id` , `Cust_ID`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`coverage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`coverage` (
  `Coverage_Type` VARCHAR(20) NOT NULL,
  `Coverage_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Application_Id` BIGINT NOT NULL,
  `Coverage_Amount` INT NOT NULL,
  `Coverage_Level` VARCHAR(20) NOT NULL,
  `Product_Id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Coverage_Id`),
  UNIQUE INDEX `XPKCOVERAGE_19` (`Coverage_Id` ASC) VISIBLE,
  INDEX `P_101` (`Product_Id` ASC) VISIBLE,
  CONSTRAINT `P_101`
    FOREIGN KEY (`Product_Id`)
    REFERENCES `insurance`.`product` (`Product_Number`))
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`department` (
  `Department_Name` VARCHAR(100) NOT NULL,
  `Department_ID` VARCHAR(18) NOT NULL,
  `Department_Staff` VARCHAR(18) NULL DEFAULT NULL,
  `Department_Offices` VARCHAR(50) NULL DEFAULT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Department_Name`, `Department_ID`, `Company_Name`),
  UNIQUE INDEX `XPKDEPARTMENT` (`Department_Name` ASC, `Department_ID` ASC, `Company_Name` ASC) VISIBLE,
  INDEX `R_56` (`Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_56`
    FOREIGN KEY (`Company_Name`)
    REFERENCES `insurance`.`insurance_company` (`Company_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`incident`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`incident` (
  `Incident_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Incident_Type` ENUM('fire', 'Accident', 'Natural disaster', 'breakdown', 'Theft') NULL DEFAULT 'Accident',
  `Incident_Date` DATE NOT NULL,
  `Description` VARCHAR(255) NULL DEFAULT NULL,
  `Cust_Id` BIGINT NOT NULL,
  `Vehicle_Number` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`Incident_Id`),
  UNIQUE INDEX `XPKINCIDENT_17` (`Incident_Id` ASC) VISIBLE,
  INDEX `FK_CUST_ID` (`Cust_Id` ASC) VISIBLE,
  CONSTRAINT `FK_CUST_ID`
    FOREIGN KEY (`Cust_Id`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 33
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`incident_report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`incident_report` (
  `Incident_Report_ID` BIGINT NOT NULL AUTO_INCREMENT,
  `Incident_Type` VARCHAR(30) NULL DEFAULT NULL,
  `Incident_Report_Status` ENUM('ACCEPTED', 'PENDING') NULL DEFAULT 'PENDING',
  `Incident_Date` DATE NOT NULL,
  `Incident_Cost` INT NULL DEFAULT NULL,
  `Incident_Report_Description` VARCHAR(255) NULL DEFAULT NULL,
  `Incident_Id` BIGINT NOT NULL,
  `Application_Id` BIGINT NULL DEFAULT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Incident_Report_ID`),
  UNIQUE INDEX `XPKINCIDENT_REPORT_18` (`Incident_Report_ID` ASC) VISIBLE,
  INDEX `FK_INCIDENT_ID` (`Incident_Id` ASC) VISIBLE,
  INDEX `FK_CUST_ID_2` (`Cust_Id` ASC) VISIBLE,
  CONSTRAINT `FK_CUST_ID_2`
    FOREIGN KEY (`Cust_Id`)
    REFERENCES `insurance`.`customer` (`Cust_Id`),
  CONSTRAINT `FK_INCIDENT_ID`
    FOREIGN KEY (`Incident_Id`)
    REFERENCES `insurance`.`incident` (`Incident_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 25
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`insurance_policy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`insurance_policy` (
  `Agreement_id` BIGINT NOT NULL AUTO_INCREMENT,
  `Policy_Number` VARCHAR(20) NOT NULL,
  `Start_Date` DATE NULL DEFAULT NULL,
  `Expiry_Date` DATE NULL DEFAULT NULL,
  `Term_Condition_Description` VARCHAR(255) NULL DEFAULT NULL,
  `Application_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Agreement_id`, `Application_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKINSURANCE_POLICY_4` (`Agreement_id` ASC, `Application_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_95` (`Application_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `P_102` (`Policy_Number` ASC) VISIBLE,
  INDEX `R_101` (`Agreement_id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `P_102`
    FOREIGN KEY (`Policy_Number`)
    REFERENCES `insurance`.`product` (`Product_Number`),
  CONSTRAINT `R_95`
    FOREIGN KEY (`Application_Id` , `Cust_Id`)
    REFERENCES `insurance`.`application` (`Application_Id` , `Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`insurance_policy_coverage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`insurance_policy_coverage` (
  `Agreement_id` BIGINT NOT NULL AUTO_INCREMENT,
  `Application_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  `Coverage_Id` BIGINT NOT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Agreement_id`, `Application_Id`, `Cust_Id`, `Coverage_Id`, `Company_Name`),
  UNIQUE INDEX `XPKINSURANCE_POLICY_4_COVERAGE` (`Agreement_id` ASC, `Application_Id` ASC, `Cust_Id` ASC, `Coverage_Id` ASC, `Company_Name` ASC) VISIBLE,
  INDEX `R_98` (`Coverage_Id` ASC) VISIBLE,
  INDEX `R_80` (`Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_80`
    FOREIGN KEY (`Company_Name`)
    REFERENCES `insurance`.`insurance_company` (`Company_Name`),
  CONSTRAINT `R_97`
    FOREIGN KEY (`Agreement_id` , `Application_Id` , `Cust_Id`)
    REFERENCES `insurance`.`insurance_policy` (`Agreement_id` , `Application_Id` , `Cust_Id`),
  CONSTRAINT `R_98`
    FOREIGN KEY (`Coverage_Id`)
    REFERENCES `insurance`.`coverage` (`Coverage_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`membership` (
  `Membership_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Membership_Type` VARCHAR(15) NOT NULL,
  `Organisation_Contact` VARCHAR(20) NULL DEFAULT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Membership_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKMEMBERSHIP_12` (`Membership_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_91` (`Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_91`
    FOREIGN KEY (`Cust_Id`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`nok`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`nok` (
  `Nok_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Nok_Name` VARCHAR(20) NULL DEFAULT NULL,
  `Nok_Address` VARCHAR(20) NULL DEFAULT NULL,
  `Nok_Phone_Number` BIGINT NULL DEFAULT NULL,
  `Nok_Gender` VARCHAR(7) NULL DEFAULT NULL,
  `Nok_Marital_Status` ENUM('single', 'married', 'divorsed') NULL DEFAULT 'single',
  `Application_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Nok_Id`, `Application_Id`, `Cust_Id`),
  INDEX `R_99` (`Application_Id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_99`
    FOREIGN KEY (`Application_Id` , `Cust_Id`)
    REFERENCES `insurance`.`application` (`Application_Id` , `Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`office`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`office` (
  `Office_Name` VARCHAR(20) NOT NULL,
  `Office_Leader` VARCHAR(20) NOT NULL,
  `Contact_Information` BIGINT NOT NULL,
  `Address` VARCHAR(20) NOT NULL,
  `Admin_Cost` INT NULL DEFAULT NULL,
  `Staff` VARCHAR(50) NULL DEFAULT NULL,
  `Department_Name` VARCHAR(100) NOT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Office_Name`, `Department_Name`, `Company_Name`),
  UNIQUE INDEX `XPKOFFICE_11` (`Office_Name` ASC, `Department_Name` ASC, `Company_Name` ASC) VISIBLE,
  INDEX `R_104` (`Department_Name` ASC) VISIBLE,
  INDEX `R_109` (`Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_104`
    FOREIGN KEY (`Department_Name`)
    REFERENCES `insurance`.`department` (`Department_Name`),
  CONSTRAINT `R_109`
    FOREIGN KEY (`Company_Name`)
    REFERENCES `insurance`.`insurance_company` (`Company_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`policy_renewable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`policy_renewable` (
  `Policy_Renewable_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Date_Of_Renewal` DATE NOT NULL,
  `Agreement_id` BIGINT NOT NULL,
  `Vehicle_Id` BIGINT NOT NULL,
  `NewApplication_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  `Policy_Renewable_Status` ENUM('PENDING', 'RENEWED') NULL DEFAULT 'PENDING',
  PRIMARY KEY (`Policy_Renewable_Id`, `Agreement_id`, `Cust_Id`),
  UNIQUE INDEX `XPKPOLICY_RENEWABLE_16` (`Policy_Renewable_Id` ASC, `Agreement_id` ASC, `NewApplication_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_101` (`Agreement_id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_101`
    FOREIGN KEY (`Agreement_id` , `Cust_Id`)
    REFERENCES `insurance`.`insurance_policy` (`Agreement_id` , `Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`premium_payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`premium_payment` (
  `Premium_Payment_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Policy_Number` VARCHAR(20) NOT NULL,
  `Premium_Payment_Amount` INT NOT NULL,
  `Premium_Payment_Date` DATE NOT NULL,
  `Application_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Premium_Payment_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKPREMIUM_PAYMENT_5` (`Premium_Payment_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_13` (`Application_Id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_13`
    FOREIGN KEY (`Application_Id` , `Cust_Id`)
    REFERENCES `insurance`.`application` (`Application_Id` , `Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`quote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`quote` (
  `Quote_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Issue_Date` DATE NOT NULL,
  `Valid_From_Date` DATE NULL DEFAULT NULL,
  `Valid_Till_Date` DATE NULL DEFAULT NULL,
  `Description` VARCHAR(100) NULL DEFAULT NULL,
  `Product_Id` BIGINT NULL DEFAULT NULL,
  `Coverage_Level` VARCHAR(20) NOT NULL,
  `Coverage_Amount` INT NULL DEFAULT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Quote_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKQUOTE_3` (`Quote_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_94` (`Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_94`
    FOREIGN KEY (`Cust_Id`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`receipt` (
  `Receipt_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `PayTime` DATE NOT NULL,
  `Cost` INT NOT NULL,
  `Premium_Payment_Id` BIGINT NOT NULL,
  `Cust_Id` BIGINT NOT NULL,
  PRIMARY KEY (`Receipt_Id`, `Premium_Payment_Id`, `Cust_Id`),
  UNIQUE INDEX `XPKRECEIPT_21` (`Receipt_Id` ASC, `Premium_Payment_Id` ASC, `Cust_Id` ASC) VISIBLE,
  INDEX `R_84` (`Premium_Payment_Id` ASC, `Cust_Id` ASC) VISIBLE,
  CONSTRAINT `R_84`
    FOREIGN KEY (`Premium_Payment_Id` , `Cust_Id`)
    REFERENCES `insurance`.`premium_payment` (`Premium_Payment_Id` , `Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`staff` (
  `Staff_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Staff_Fname` VARCHAR(10) NULL DEFAULT NULL,
  `Staff_LName` VARCHAR(10) NULL DEFAULT NULL,
  `Staff_Address` VARCHAR(20) NULL DEFAULT NULL,
  `Staff_Contact` BIGINT NULL DEFAULT NULL,
  `Staff_Email` VARCHAR(255) NULL DEFAULT NULL,
  `Staff_Gender` VARCHAR(7) NULL DEFAULT NULL,
  `Staff_Marital_Status` CHAR(8) NULL DEFAULT NULL,
  `Staff_Nationality` VARCHAR(15) NULL DEFAULT NULL,
  `Staff_Qualification` VARCHAR(20) NULL DEFAULT NULL,
  `Staff_Allowance` INT NULL DEFAULT NULL,
  `Staff_PPS_Number` INT NULL DEFAULT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  `Password` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`Staff_Id`, `Company_Name`),
  UNIQUE INDEX `XPKSTAFF_9` (`Staff_Id` ASC, `Company_Name` ASC) VISIBLE,
  INDEX `R_105` (`Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_105`
    FOREIGN KEY (`Company_Name`)
    REFERENCES `insurance`.`insurance_company` (`Company_Name`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`vehicle` (
  `Vehicle_Id` BIGINT NOT NULL AUTO_INCREMENT,
  `Policy_Id` VARCHAR(20) NULL DEFAULT NULL,
  `Dependent_NOK_ID` VARCHAR(20) NULL DEFAULT NULL,
  `Vehicle_Registration_Number` VARCHAR(20) NOT NULL,
  `Vehicle_Value` INT NULL DEFAULT NULL,
  `Vehicle_Type` VARCHAR(20) NOT NULL,
  `Vehicle_Size` INT NULL DEFAULT NULL,
  `Vehicle_Number_Of_Seat` INT NULL DEFAULT NULL,
  `Vehicle_Manufacturer` VARCHAR(20) NULL DEFAULT NULL,
  `Vehicle_Engine_Number` INT NULL DEFAULT NULL,
  `Vehicle_Chasis_Number` INT NULL DEFAULT NULL,
  `Vehicle_Model_Number` VARCHAR(20) NULL DEFAULT NULL,
  `Cust_ID` BIGINT NOT NULL,
  PRIMARY KEY (`Vehicle_Id`, `Cust_ID`),
  UNIQUE INDEX `XPKVEHICLE_6` (`Vehicle_Id` ASC, `Cust_ID` ASC) VISIBLE,
  INDEX `R_92` (`Cust_ID` ASC) VISIBLE,
  CONSTRAINT `R_92`
    FOREIGN KEY (`Cust_ID`)
    REFERENCES `insurance`.`customer` (`Cust_Id`))
ENGINE = InnoDB
AUTO_INCREMENT = 45
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `insurance`.`vehicle_service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `insurance`.`vehicle_service` (
  `Department_Name` VARCHAR(100) NOT NULL,
  `Vehicle_Service_Company_Name` VARCHAR(100) NOT NULL,
  `Vehicle_Service_Address` VARCHAR(255) NULL DEFAULT NULL,
  `Vehicle_Service_Contact` DECIMAL(11,0) NULL DEFAULT NULL,
  `Vehicle_Service_Incharge` VARCHAR(20) NULL DEFAULT NULL,
  `Vehicle_Service_Type` VARCHAR(20) NULL DEFAULT NULL,
  `Department_Id` VARCHAR(50) NOT NULL,
  `Company_Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Vehicle_Service_Company_Name`, `Department_Name`),
  UNIQUE INDEX `XPKVEHICLE_SERVICE` (`Vehicle_Service_Company_Name` ASC, `Department_Name` ASC) VISIBLE,
  INDEX `R_50` (`Department_Name` ASC, `Department_Id` ASC, `Company_Name` ASC) VISIBLE,
  CONSTRAINT `R_50`
    FOREIGN KEY (`Department_Name` , `Department_Id` , `Company_Name`)
    REFERENCES `insurance`.`department` (`Department_Name` , `Department_ID` , `Company_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `insurance` ;

-- -----------------------------------------------------
-- procedure createClaim
-- -----------------------------------------------------

DELIMITER $$
USE `insurance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createClaim`(IN CustId BIGINT, VehNo VarChar(20), IncId BIGINT, Claim_Amt int)
BEGIN
    DECLARE AggId BIGINT;
    DECLARE curDate DATE; 
    set curDate = CURDATE(); 
    set AggId = (WITH AppId AS (
    SELECT Application_Id 
    FROM APPLICATION 
    WHERE Vehicle_Id = (SELECT MIN(Vehicle_Id) FROM VEHICLE WHERE Vehicle_Registration_Number = VehNo)
)
SELECT MAX(Agreement_Id) 
FROM INSURANCE_POLICY 
WHERE Application_Id IN (SELECT Application_Id FROM AppId));

    INSERT INTO CLAIM(Agreement_Id,Claim_Amount,Incident_Id,Date_Of_Claim,Cust_ID) 
    VALUES (AggId,Claim_Amt,IncId,curDate,CustId);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createPREMIUM_PAYMENT
-- -----------------------------------------------------

DELIMITER $$
USE `insurance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createPREMIUM_PAYMENT`(IN customer_id BIGINT, productId BIGINT, Payment_status BOOL)
BEGIN
    DECLARE AppId BIGINT;
    DECLARE Amount DECIMAL(10, 2);
    DECLARE coverageLevel VARCHAR(20);
    DECLARE vehiAmount DECIMAL(10, 2);
    DECLARE productAmount DECIMAL(10, 2);

    -- Retrieve product price based on productId
    SET productAmount = (SELECT Product_Price FROM PRODUCT WHERE Product_Number = productId);

    -- Retrieve the latest Application_Id for the customer
    SET AppId = (SELECT MAX(Application_Id) FROM APPLICATION WHERE Cust_ID = customer_id);
    
    -- Retrieve vehicle value based on the latest application
    SELECT Vehicle_Value INTO vehiAmount
    FROM VEHICLE
    WHERE Vehicle_Id = (SELECT MAX(Vehicle_Id)
                        FROM APPLICATION
                        WHERE Application_Id = AppId
                        LIMIT 1);

    -- Retrieve coverage level for the application
    SELECT Coverage_Level INTO coverageLevel
    FROM APPLICATION
    WHERE Application_Id = AppId
    LIMIT 1;

    -- Calculate the premium payment amount based on coverage level
    IF coverageLevel = 'HIGH' THEN
        SET Amount = (0.05 * vehiAmount) + productAmount;
    ELSEIF coverageLevel = 'MEDIUM' THEN
        SET Amount = (0.035 * vehiAmount) + productAmount;
    ELSEIF coverageLevel = 'LOW' THEN
        SET Amount = (0.02 * vehiAmount) + productAmount;
    ELSE
        -- Default case for unexpected coverage levels
        SET Amount = productAmount; -- Fallback to product price only
    END IF;

    -- Execute different actions based on Payment_status
    IF Payment_status THEN
        -- Insert the premium payment
        INSERT INTO PREMIUM_PAYMENT (Policy_Number, Premium_Payment_Amount, Premium_Payment_Date, Application_Id, Cust_Id)
        VALUES (
            (SELECT Product_Id
             FROM APPLICATION
             WHERE Application_Id = AppId
             LIMIT 1),
            Amount,
            CURDATE(),
            AppId,
            customer_id
        );

        -- Update the application status to 'ACCEPTED'
        UPDATE APPLICATION
        SET Application_Status = 'ACCEPTED'
        WHERE Application_Id = AppId;

    ELSE
        -- Update the application status to 'REJECTED'
        UPDATE APPLICATION
        SET Application_Status = 'REJECTED'
        WHERE Application_Id = AppId;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure createQuote
-- -----------------------------------------------------

DELIMITER $$
USE `insurance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createQuote`(IN customer_id BIGINT, Vehicle_Value BIGINT, Product_Id VARCHAR(20), Coverage_Level VARCHAR(20))
BEGIN
    DECLARE CovAmt INT;
    DECLARE Descp VARCHAR(100);
    DECLARE curDate DATE; 
    set curDate = CURDATE();
    SET SQL_SAFE_UPDATES = 0;
 
    IF Coverage_Level = 'HIGH' THEN
        SET Descp = 'ALL TYPES OF ACCIDENTS, MAINTENANCE, DAMAGES ARE COVERED';
        SET CovAmt = 0.9 * Vehicle_Value;
    ELSEIF Coverage_Level = 'MEDIUM' THEN
        SET Descp = 'ALL TYPES OF ACCIDENTS AND DAMAGES ARE COVERED';
        SET CovAmt = 0.75 * Vehicle_Value;
    ELSEIF Coverage_Level = 'LOW' THEN
        SET Descp = 'ALL TYPES OF ACCIDENTS ARE COVERED';
        SET CovAmt = 0.55 * Vehicle_Value;
    END IF;
    insert into quote 
    VALUES (NULL,curDate, curDate, DATE_ADD(curDate, INTERVAL 1 YEAR),Descp, Product_Id, Coverage_Level, CovAmt, customer_id);
	SET SQL_SAFE_UPDATES = 1;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure policyRenew
-- -----------------------------------------------------

DELIMITER $$
USE `insurance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `policyRenew`(IN customer_id BIGINT)
BEGIN
    DECLARE Agg_id BIGINT;
    DECLARE expidate DATE;
    DECLARE date_diff INT;
    DECLARE done INT DEFAULT 0;
    DECLARE VehId BIGINT;

    -- Cursor declaration must be before handler and after all variable declarations
    DECLARE cur CURSOR FOR
        SELECT Agreement_id, Expiry_Date
        FROM INSURANCE_POLICY
        WHERE Cust_Id = customer_id;

    -- Handler must come after cursor declaration
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO Agg_id, expidate;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Fixed syntax for NOT IN and subquery logic
        IF NOT EXISTS (SELECT 1 FROM POLICY_RENEWABLE WHERE Agreement_id = Agg_id AND Cust_Id = customer_id) THEN
            SET date_diff = DATEDIFF(expidate, CURDATE());

            IF date_diff < 30 AND date_diff > 0 THEN
                SET VehId = (SELECT Vehicle_Id FROM APPLICATION A
                             WHERE A.Application_Id = (SELECT Application_Id FROM INSURANCE_POLICY
                                                       WHERE Agreement_id = Agg_id LIMIT 1)); -- Ensuring single row return
                INSERT IGNORE INTO POLICY_RENEWABLE (Date_Of_Renewal, Agreement_id, Cust_Id, Vehicle_Id)
                VALUES (expidate, Agg_id, customer_id, VehId);
            END IF;
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
USE `insurance`;

DELIMITER $$
USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`createCoverage`
AFTER UPDATE ON `insurance`.`application`
FOR EACH ROW
BEGIN
	DECLARE amount INT;

    IF NEW.Application_Status = 'ACCEPTED' THEN
        
        SET @amount = (SELECT Vehicle_Value FROM VEHICLE WHERE Vehicle_Id = NEW.Vehicle_Id);
        
        IF NEW.Coverage_Level = 'HIGH' THEN
            SET @amount = 0.9 * @amount;
        ELSEIF NEW.Coverage_Level = 'MEDIUM' THEN
            SET @amount = 0.75 * @amount;
        ELSEIF NEW.Coverage_Level = 'LOW' THEN
            SET @amount = 0.55 * @amount;
        END IF;
        
        INSERT INTO COVERAGE (Coverage_Type, Coverage_Amount, Coverage_Level, Product_Id, Application_Id)
        VALUES ('New Coverage Type', @amount, NEW.Coverage_Level, NEW.Product_Id, NEW.Application_Id);

        INSERT INTO INSURANCE_POLICY (Policy_Number, Start_Date, Expiry_Date, Application_Id, Cust_Id)
        VALUES (
            (SELECT Product_Id FROM APPLICATION WHERE Application_Id = NEW.Application_Id),
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 1 YEAR),
            NEW.Application_Id,
            (SELECT Cust_Id FROM CUSTOMER WHERE Cust_Id = NEW.Cust_Id)
        );
    END IF;
END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`updateRenewable`
AFTER UPDATE ON `insurance`.`application`
FOR EACH ROW
BEGIN
	SET SQL_SAFE_UPDATES = 0;

    IF NEW.Application_Status = 'ACCEPTED' THEN
        UPDATE POLICY_RENEWABLE
            SET Policy_Renewable_Status = 'RENEWED'
            WHERE NewApplication_Id = NEW.Application_Id;

    END IF;
    IF NEW.Application_Status = 'REJECTED' THEN
        UPDATE POLICY_RENEWABLE
            SET Application_Id = NULL
            WHERE NewApplication_Id = NEW.Application_Id;
    END IF;
	SET SQL_SAFE_UPDATES = 1;
END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`createClaimSettlement`
AFTER UPDATE ON `insurance`.`claim`
FOR EACH ROW
BEGIN
    IF NEW.Claim_Status = 'ACCEPTED' THEN
		set @id = (select MAX(Application_Id) from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);
        set @vehical = (select Vehicle_Id from APPLICATION where @id = Application_Id);
        INSERT INTO CLAIM_SETTLEMENT (Vehicle_Id, Date_Settled, Amount_Paid, Coverage_Id, Claim_Id, Cust_Id)
        VALUES (@vehical, CURDATE(), NEW.Claim_Amount, 'SomeCoverageId', NEW.Claim_Id, NEW.Cust_Id);

        set @id = (select MAX(Coverage_Id) from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);

        UPDATE COVERAGE
            SET Coverage_Amount = Coverage_Amount - NEW.Claim_Amount
            WHERE Coverage_Id = @id;

    END IF;

    

END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`createIncidentReport`
AFTER INSERT ON `insurance`.`incident`
FOR EACH ROW
BEGIN
    DECLARE appId BIGINT;
    
    set appId = (SELECT MAX(I.Application_Id) from APPLICATION A join INSURANCE_POLICY I on A.Application_Id = I.Application_Id
                    WHERE A.Vehicle_Id in (SELECT Vehicle_Id from VEHICLE V where V.Vehicle_Registration_Number = NEW.Vehicle_Number )
                    AND NEW.Incident_Date BETWEEN I.Start_Date AND I.Expiry_Date);


    INSERT INTO INCIDENT_REPORT (Incident_Id, Cust_Id, Incident_Type, Incident_Date,Application_Id)
    VALUES (NEW.Incident_Id, NEW.Cust_Id, NEW.Incident_Type, NEW.Incident_Date,appId);
END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`updateClaim`
AFTER UPDATE ON `insurance`.`incident_report`
FOR EACH ROW
BEGIN
    DECLARE claimAmt INT;  -- Declare claimAmt
    DECLARE covAmt INT;  -- Declare covAmt
    DECLARE covId BIGINT;  -- Declare covId
    DECLARE claimId BIGINT;  -- Declare claimId

    IF NEW.Incident_Report_Status = 'ACCEPTED' THEN
        SET claimId = (SELECT MAX(Claim_ID) FROM CLAIM WHERE Incident_Id = NEW.Incident_Id);
        SET claimAmt = (SELECT Claim_Amount FROM CLAIM WHERE Claim_Id = claimId);

        SET covId = (SELECT MAX(Coverage_Id) FROM INSURANCE_POLICY_COVERAGE WHERE Agreement_id = (
            SELECT Agreement_id FROM CLAIM WHERE Claim_ID = claimId
        ));
        SET covAmt = (SELECT Coverage_Amount FROM COVERAGE WHERE Coverage_Id = covId);

        IF claimAmt <= NEW.Incident_Cost AND claimAmt <= covAmt THEN
            UPDATE CLAIM SET Claim_Status = 'ACCEPTED' WHERE Incident_Id = NEW.Incident_Id;
        ELSE
            UPDATE CLAIM SET Claim_Status = 'REJECTED' WHERE Incident_Id = NEW.Incident_Id;
        END IF;

    END IF;
END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`createPolicyCov`
AFTER INSERT ON `insurance`.`insurance_policy`
FOR EACH ROW
BEGIN
    INSERT INTO INSURANCE_POLICY_COVERAGE (Agreement_id, Application_Id, Cust_Id, Coverage_Id, Company_Name)
    (SELECT NEW.Agreement_id, NEW.Application_Id, NEW.Cust_Id, COVERAGE.Coverage_Id, PRODUCT.Company_Name
    FROM COVERAGE
    JOIN PRODUCT ON COVERAGE.Product_Id = PRODUCT.Product_Number
    WHERE COVERAGE.Application_Id = NEW.Application_Id);
END$$

USE `insurance`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `insurance`.`createReceipt`
AFTER INSERT ON `insurance`.`premium_payment`
FOR EACH ROW
BEGIN
    INSERT INTO RECEIPT (PayTime, Cost, Premium_Payment_Id, Cust_Id)
    VALUES (NEW.Premium_Payment_Date, NEW.Premium_Payment_Amount, NEW.Premium_Payment_Id, NEW.Cust_Id);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
