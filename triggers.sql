USE insurance;
DELIMITER $$

CREATE PROCEDURE createQuote(IN customer_id BIGINT, Vehicle_Value BIGINT, Product_Id VARCHAR(20), Coverage_Level VARCHAR(20))
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

END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE createPREMIUM_PAYMENT(IN customer_id BIGINT, productId BIGINT, Payment_status BOOL)
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

-- CREATE TRIGGER updatePrePay
-- AFTER INSERT ON RECEIPT
-- FOR EACH ROW
-- BEGIN
--     UPDATE PREMIUM_PAYMENT
--         SET Receipt_Id = NEW.Receipt_Id
--         WHERE Premium_Payment_Id = NEW.Premium_Payment_Id;
-- END $$

-- DELIMITER ;


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
		set @id = (select MAX(Application_Id) from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);
        set @vehical = (select Vehicle_Id from APPLICATION where @id = Application_Id);
        INSERT INTO CLAIM_SETTLEMENT (Vehicle_Id, Date_Settled, Amount_Paid, Coverage_Id, Claim_Id, Cust_Id)
        VALUES (@vehical, CURDATE(), NEW.Claim_Amount, 'SomeCoverageId', NEW.Claim_Id, NEW.Cust_Id);

        set @id = (select MAX(Coverage_Id) from INSURANCE_POLICY_COVERAGE IPC where new.Agreement_Id=IPC.Agreement_Id);

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
    
    set appId = (SELECT MAX(I.Application_Id) from APPLICATION A join INSURANCE_POLICY I on A.Application_Id = I.Application_Id
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
    DECLARE claimAmt INT;  -- Declare claimAmt
    DECLARE covAmt INT;  -- Declare covAmt
    DECLARE covId BIGINT;  -- Declare covId
    DECLARE claimId BIGINT;  -- Declare claimId

    IF NEW.Incident_Report_Status = 'ACCEPTED' THEN
        SET claimId = (SELECT MAX(Claim_ID) FROM CLAIM WHERE Incident_Id = NEW.Incident_Id);
        SET claimAmt = (SELECT Claim_Amount FROM CLAIM WHERE Claim_Id = claimId);

        SET covId = (SELECT Coverage_Id FROM INSURANCE_POLICY_COVERAGE WHERE Agreement_id = (
            SELECT Agreement_id FROM CLAIM WHERE Claim_ID = claimId
        ));
        SET covAmt = (SELECT Coverage_Amount FROM COVERAGE WHERE Coverage_Id = covId);

        IF claimAmt <= NEW.Incident_Cost AND claimAmt <= covAmt THEN
            UPDATE CLAIM SET Claim_Status = 'ACCEPTED' WHERE Incident_Id = NEW.Incident_Id;
        ELSE
            UPDATE CLAIM SET Claim_Status = 'REJECTED' WHERE Incident_Id = NEW.Incident_Id;
        END IF;

    END IF;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE policyRenew(IN customer_id BIGINT)
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

-- CALL policyRenew(customer_id);


DELIMITER $$

CREATE TRIGGER updateRenewable
AFTER UPDATE ON APPLICATION
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE createClaim(IN CustId BIGINT, VehNo VarChar(20), IncId BIGINT, Claim_Amt int)
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
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE InsertApplication(IN VehId BIGINT, IN Product_Id VARCHAR(20), IN Coverage_Level VARCHAR(20), IN Cust_Id BIGINT)
BEGIN

    INSERT INTO application (Product_Id, Coverage_Level, Cust_Id, Vehicle_Id)
    VALUES (Product_Id, Coverage_Level, Cust_Id, VehId); -- Ensure proper parameter passing

END $$

DELIMITER ;


-- SET aggId = (SELECT Agreement_Id 
--                  FROM INSURANCE_POLICY I
--                  WHERE I.Application_Id = AppId);