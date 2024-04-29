USE insurance;

DELIMITER $$

CREATE PROCEDURE createQuote(IN customer_id BIGINT, Vehicle_Value BIGINT, Product_Id VARCHAR(20), Coverage_Level VARCHAR(20))
BEGIN
    DECLARE Coverage_Amount INT;
    DECLARE Description VARCHAR(100);
    DECLARE curDate DATE; 
    set curDate = CURDATE(); 
    IF Coverage_Level = 'HIGH' THEN
        SET Description = 'ALL TYPES OF ACCIDENTS, MAINTENANCE, DAMAGES ARE COVERED';
        SET Coverage_Amount = 0.9 * Vehicle_Value;
    ELSEIF Coverage_Level = 'MEDIUM' THEN
        SET Description = 'ALL TYPES OF ACCIDENTS AND DAMAGES ARE COVERED';
        SET Coverage_Amount = 0.75 * Vehicle_Value;
    ELSEIF Coverage_Level = 'LOW' THEN
        SET Description = 'ALL TYPES OF ACCIDENTS ARE COVERED';
        SET Coverage_Amount = 0.55 * Vehicle_Value;
    END IF;
    insert into quote values (NULL,curDate,curDate,DATEADD(year,1,curDate),NULL,Product_Id,Coverage_Level,Coverage_Amount,customer_id);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE createPREMIUM_PAYMENT(IN customer_id BIGINT, Application_Id BIGINT, Payment_status BOOL)
BEGIN
	DECLARE Amount INT;
	DECLARE coverageLevel VARCHAR(20);
    DECLARE vehiAmount INT;
    IF Payment_status THEN
        
        SELECT Vehicle_Value INTO vehiAmount FROM VEHICLE 
        WHERE Vehicle_Id = (SELECT Vehicle_Id FROM APPLICATION WHERE Application_Id = Application_Id);
        SELECT Coverage_Level INTO coverageLevel FROM APPLICATION WHERE Application_Id = Application_Id;
        
        IF coverageLevel = 'HIGH' THEN
            SET Amount = 0.9 * vehiAmount;
        ELSEIF coverageLevel = 'MEDIUM' THEN
            SET Amount = 0.75 * vehiAmount;
        ELSEIF coverageLevel = 'LOW' THEN
            SET Amount = 0.55 * vehiAmount;
        END IF;

        INSERT INTO PREMIUM_PAYMENT(Policy_Number, Premium_Payment_Amount, Premium_Payment_Date, Application_Id, Cust_Id) VALUES
            ((SELECT Product_Id FROM APPLICATION WHERE Application_Id = Application_Id), Amount, CURDATE(), Application_Id, customer_id);

        UPDATE APPLICATION
            SET Application_Status = 'ACCEPTED'
            WHERE Application_Id = Application_Id;
    ELSE
        UPDATE APPLICATION
            SET Application_Status = 'REJECTED'
            WHERE Application_Id = Application_Id;
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER createReceipt
AFTER INSERT ON PREMIUM_PAYMENT
FOR EACH ROW
BEGIN
    INSERT INTO RECEIPT (PayTime, Cost, Premium_Payment_Id, Cust_Id)
    VALUES (NEW.Premium_Payment_Date, NEW.Premium_Payment_Amount, NEW.Premium_Payment_Id, NEW.Cust_Id);
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER updatePrePay
AFTER INSERT ON RECEIPT
FOR EACH ROW
BEGIN
    UPDATE PREMIUM_PAYMENT
        SET Receipt_Id = NEW.Receipt_Id
        WHERE Premium_Payment_Id = NEW.Premium_Payment_Id;
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER createCoverage
AFTER UPDATE ON APPLICATION
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
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER createPolicyCov
AFTER INSERT ON INSURANCE_POLICY
FOR EACH ROW
BEGIN
    INSERT INTO INSURANCE_POLICY_COVERAGE (Agreement_id, Application_Id, Cust_Id, Coverage_Id, Company_Name)
    (SELECT NEW.Agreement_id, NEW.Application_Id, NEW.Cust_Id, COVERAGE.Coverage_Id, PRODUCT.Company_Name
    FROM COVERAGE
    JOIN PRODUCT ON COVERAGE.Product_Id = PRODUCT.Product_Number
    WHERE COVERAGE.Application_Id = NEW.Application_Id);
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER createClaimSettlement
AFTER UPDATE ON CLAIM
FOR EACH ROW
BEGIN
    IF NEW.Claim_Status = 'ACCEPTED' THEN
		set @id = (select Application_Id from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);
        set @vehical = (select Vehicle_Id from APPLICATION where @id = Application_Id);
        INSERT INTO CLAIM_SETTLEMENT (Vehicle_Id, Date_Settled, Amount_Paid, Coverage_Id, Claim_Id, Cust_Id)
        VALUES (@vehical, CURDATE(), NEW.Claim_Amount, 'SomeCoverageId', NEW.Claim_Id, NEW.Cust_Id);

        set @id = (select Coverage_Id from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);

        UPDATE COVERAGE
            SET Coverage_Amount = Coverage_Amount - NEW.Claim_Amount
            WHERE Coverage_Id = @id;

    END IF;

    

END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER createIncidentReport
AFTER INSERT ON INCIDENT
FOR EACH ROW
BEGIN
    DECLARE appId BIGINT;
    
    set appId = (SELECT I.Application_Id from APPLICATION A join INSURANCE_POLICY I on A.Application_Id = I.Application_Id
                    WHERE A.Vehicle_Id in (SELECT Vehicle_Id from VEHICLE V where V.Vehicle_Registration_Number = NEW.Vehicle_Number )
                    AND NEW.Incident_Date BETWEEN I.Start_Date AND I.Expiry_Date);


    INSERT INTO INCIDENT_REPORT (Incident_Id, Cust_Id, Incident_Type, Incident_Date,Application_Id)
    VALUES (NEW.Incident_Id, NEW.Cust_Id, NEW.Incident_Type, NEW.Incident_Date,appId);
END $$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER updateClaim
AFTER UPDATE ON INCIDENT_REPORT
FOR EACH ROW
BEGIN
    DECLARE claim_amount INT;
    DECLARE coverage_amount INT;
    DECLARE coverage_id BIGINT;

    IF NEW.Incident_Report_Status = 'ACCEPTED' THEN
        SET @claim_id = (SELECT Claim_ID FROM CLAIM WHERE Incident_Id = OLD.Incident_Id);
        SET claim_amount = (SELECT Claim_Amount FROM CLAIM WHERE Claim_Id = @claim_id);

        SET coverage_id = (SELECT Coverage_Id FROM INSURANCE_POLICY_COVERAGE WHERE Agreement_id = (
            select Agreement_id from CLAIM Where Claim_ID=@claim_id
        ));
        SET coverage_amount = (SELECT Coverage_Amount FROM COVERAGE WHERE Coverage_Id = coverage_id);

      IF claim_amount <= NEW.Incident_Cost AND claim_amount <= coverage_amount THEN
    UPDATE CLAIM SET Claim_Status = 'ACCEPTED' WHERE Incident_Id = OLD.Incident_Id;
ELSE
    UPDATE CLAIM SET Claim_Status = 'REJECTED' WHERE Incident_Id = OLD.Incident_Id;
END IF;

    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE policyRenew(IN customer_id BIGINT)
BEGIN
    DECLARE Agg_id BIGINT;
    DECLARE expiry_date DATE;
    DECLARE date_diff INT;

    DECLARE cur CURSOR FOR
        SELECT Agreement_id, Expiry_Date, Application_Id
        FROM INSURANCE_POLICY 
        WHERE Cust_Id = customer_id;
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO Agg_id,expiry_date;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET date_diff = DATEDIFF(expiry_date, CURDATE());

        IF date_diff < 30 and date_diff > 0 THEN
            INSERT IGNORE INTO POLICY_RENEWABLE (Date_Of_Renewal, Type_Of_Renewal, Agreement_id, Cust_Id)
            VALUES (expiry_date, Agg_id, customer_id);
        END IF;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;


-- CALL policyRenew(customer_id);


DELIMITER $$

CREATE TRIGGER updateRenewable
AFTER UPDATE ON APPLICATION
FOR EACH ROW
BEGIN
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE createClaim(IN CustId BIGINT, AppId BIGINT, IncId BIGINT, Claim_Amt int)
BEGIN
    DECLARE AggId BIGINT;
    DECLARE curDate DATE; 
    set curDate = CURDATE(); 
    set AggId = (select Agreement_Id from INSURANCE_POLICY I WHERE I.Application_Id = AppId);
    INSERT INTO CLAIM(Agreement_Id,Claim_Amount,Incident_Id,Date_Of_Claim,Cust_ID) 
    VALUES (AggId,Claim_Amt,IncId,curDate,CustId);
END $$

DELIMITER ;



-- SET aggId = (SELECT Agreement_Id 
--                  FROM INSURANCE_POLICY I
--                  WHERE I.Application_Id = AppId);