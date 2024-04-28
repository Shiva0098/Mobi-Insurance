CREATE DATABASE insurance;
USE insurance;

CREATE TABLE INCIDENT (
    Incident_Id BIGINT NOT NULL AUTO_INCREMENT,
    Incident_Type ENUM('fire', 'Accident', 'Natural disaster', 'breakdown','Theft') DEFAULT 'Accident',
    Incident_Date DATE NOT NULL,
    Description VARCHAR(255) NULL,
    CONSTRAINT XPKINCIDENT_17 PRIMARY KEY (Incident_Id)
);

CREATE UNIQUE INDEX XPKINCIDENT_17 ON INCIDENT (Incident_Id ASC);

CREATE TABLE CUSTOMER (
    Cust_Id BIGINT NOT NULL AUTO_INCREMENT,
    Cust_FName VARCHAR(30) NOT NULL,
    Cust_LName VARCHAR(30) NOT NULL,
    Cust_DOB DATE NOT NULL,
    Cust_Gender VARCHAR(7) NOT NULL,
    Cust_Address VARCHAR(20) NOT NULL,
    Cust_MOB_Number numeric(11) NOT NULL,
    Cust_Email VARCHAR(255) NULL,
    Cust_Passport_Number VARCHAR(20) NULL,
    Cust_Marital_Status VARCHAR(10) NULL,
    Cust_PPS_Number INTEGER NULL,
    Password VARCHAR(20) DEFAULT '',
    CONSTRAINT XPKCUSTOMER_1 PRIMARY KEY (Cust_Id,Password)
);
CREATE UNIQUE INDEX XPKCUSTOMER_1 ON CUSTOMER (Cust_Id ASC);

CREATE TABLE INCIDENT_REPORT (
    Incident_Report_ID BIGINT NOT NULL AUTO_INCREMENT,
    Incident_Type VARCHAR(30) NULL,
    Incident_Inspector VARCHAR(20) NULL,
    Incident_Cost INTEGER NULL,
    Incident_Report_Description VARCHAR(255) NULL,
    Incident_Id VARCHAR(20) NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKINCIDENT_REPORT_18 PRIMARY KEY (Incident_Report_Id),
    CONSTRAINT FK_INCIDENT_ID FOREIGN KEY (Incident_Id) REFERENCES INCIDENT (Incident_Id),
    CONSTRAINT FK_CUST_ID FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKINCIDENT_REPORT_18 ON INCIDENT_REPORT (Incident_Report_Id ASC);

CREATE TABLE INSURANCE_COMPANY (
    Company_Name VARCHAR(255) NOT NULL,
    Company_Address VARCHAR(255) NULL,
    Company_Contact_Number numeric(11) NULL,
    Company_Fax INTEGER NULL,
    Company_Email VARCHAR(255) NULL,
    Company_Website VARCHAR(50) NULL,
    COMPANY_LOCATION VARCHAR(100) NULL,
    Company_Department_Name VARCHAR(100) NULL,
    Company_Office_Name VARCHAR(50) NULL,
    CONSTRAINT XPKINSURANCE_COMPANY_15 PRIMARY KEY (Company_Name)
);

CREATE UNIQUE INDEX XPKINSURANCE_COMPANY_15 ON INSURANCE_COMPANY (Company_Name ASC);

CREATE TABLE DEPARTMENT (
    Department_Name VARCHAR(100) NOT NULL,
    Department_ID VARCHAR(18) NOT NULL,
    Department_Staff VARCHAR(18) NULL,
    Department_Offices VARCHAR(50) NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKDEPARTMENT PRIMARY KEY (Department_Name, Department_ID, Company_Name),
    CONSTRAINT R_56 FOREIGN KEY (Company_Name) REFERENCES  INSURANCE_COMPANY(Company_Name)
);

CREATE UNIQUE INDEX XPKDEPARTMENT ON DEPARTMENT (Department_Name ASC, Department_ID ASC, Company_Name ASC);

CREATE TABLE VEHICLE_SERVICE (
    Department_Name VARCHAR(100) NOT NULL,
    Vehicle_Service_Company_Name VARCHAR(100) NOT NULL,
    Vehicle_Service_Address VARCHAR(255) NULL,
    Vehicle_Service_Contact NUMERIC(11) NULL,
    Vehicle_Service_Incharge VARCHAR(20) NULL,
    Vehicle_Service_Type VARCHAR(20) NULL,
    Department_Id VARCHAR(50) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKVEHICLE_SERVICE PRIMARY KEY (Vehicle_Service_Company_Name, Department_Name),
    CONSTRAINT R_50 FOREIGN KEY (Department_Name, Department_Id, Company_Name) REFERENCES DEPARTMENT (Department_Name, Department_ID, Company_Name)
);

CREATE UNIQUE INDEX XPKVEHICLE_SERVICE ON VEHICLE_SERVICE (Vehicle_Service_Company_Name ASC, Department_Name ASC);

CREATE TABLE VEHICLE (
    Vehicle_Id VARCHAR(20) NOT NULL,
    Policy_Id VARCHAR(20) NULL,
    Dependent_NOK_ID VARCHAR(20) NULL,
    Vehicle_Registration_Number VARCHAR(20) NOT NULL,
    Vehicle_Value INTEGER NULL,
    Vehicle_Type VARCHAR(20) NOT NULL,
    Vehicle_Size INTEGER NULL,
    Vehicle_Number_Of_Seat INTEGER NULL,
    Vehicle_Manufacturer VARCHAR(20) NULL,
    Vehicle_Engine_Number INTEGER NULL,
    Vehicle_Chasis_Number INTEGER NULL,
    Vehicle_Number VARCHAR(20) NULL,
    Vehicle_Model_Number VARCHAR(20) NULL,
    Cust_ID BIGINT NOT NULL,
    CONSTRAINT XPKVEHICLE_6 PRIMARY KEY (Vehicle_Id, Cust_Id),
    CONSTRAINT R_92 FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKVEHICLE_6 ON VEHICLE (Vehicle_Id ASC, Cust_Id ASC);

CREATE TABLE PREMIUM_PAYMENT (
    Premium_Payment_Id VARCHAR(20) NOT NULL,
    Policy_Number VARCHAR(20) NOT NULL,
    Premium_Payment_Amount INTEGER NOT NULL,
    Premium_Payment_Schedule DATE NOT NULL,
    Receipt_Id VARCHAR(20) NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKPREMIUM_PAYMENT_5 PRIMARY KEY (Premium_Payment_Id, Cust_Id),
    CONSTRAINT R_85 FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKPREMIUM_PAYMENT_5 ON PREMIUM_PAYMENT (Premium_Payment_Id ASC, Cust_Id ASC);

CREATE TABLE RECEIPT (
    Receipt_Id VARCHAR(20) NOT NULL,
    Time DATE NOT NULL,
    Cost INTEGER NOT NULL,
    Premium_Payment_Id VARCHAR(20) NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKRECEIPT_21 PRIMARY KEY (Receipt_Id, Premium_Payment_Id, Cust_Id),
    CONSTRAINT R_84 FOREIGN KEY (Premium_Payment_Id, Cust_Id) REFERENCES PREMIUM_PAYMENT (Premium_Payment_Id, Cust_Id)
);

CREATE UNIQUE INDEX XPKRECEIPT_21 ON RECEIPT (Receipt_Id ASC, Premium_Payment_Id ASC, Cust_Id ASC);

CREATE TABLE APPLICATION (
    Application_Id BIGINT NOT NULL AUTO_INCREMENT,
    Vehicle_Id VARCHAR(20) NOT NULL,
    Application_Status VARCHAR(8) NOT NULL,
    Coverage VARCHAR(50) NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKAPPLICATION_2 PRIMARY KEY (Application_Id, Cust_Id),
    CONSTRAINT R_93 FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKAPPLICATION_2 ON APPLICATION (Application_Id ASC, Cust_Id ASC);

CREATE TABLE INSURANCE_POLICY (
    Agreement_id VARCHAR(20) NOT NULL,
    Department_Name VARCHAR(20) NULL,
    Policy_Number VARCHAR(20) NOT NULL,
    Start_Date DATE NULL,
    Expiry_Date DATE NULL,
    Term_Condition_Description VARCHAR(255) NULL,
    Application_Id BIGINT NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKINSURANCE_POLICY_4 PRIMARY KEY (Agreement_id, Application_Id, Cust_Id),
    CONSTRAINT R_95 FOREIGN KEY (Application_Id, Cust_Id) REFERENCES APPLICATION (Application_Id, Cust_Id)
);

CREATE UNIQUE INDEX XPKINSURANCE_POLICY_4 ON INSURANCE_POLICY (Agreement_id ASC, Application_Id ASC, Cust_Id ASC);
CREATE TABLE POLICY_RENEWABLE (
    Policy_Renewable_Id VARCHAR(20) NOT NULL,
    Date_Of_Renewal DATE NOT NULL,
    Type_Of_Renewal VARCHAR(15) NOT NULL,
    Agreement_id VARCHAR(20) NOT NULL,
    Application_Id BIGINT NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKPOLICY_RENEWABLE_16 PRIMARY KEY (Policy_Renewable_Id, Agreement_id, Application_Id, Cust_Id),
    CONSTRAINT R_101 FOREIGN KEY (Agreement_id, Application_Id, Cust_Id) REFERENCES INSURANCE_POLICY (Agreement_id, Application_Id, Cust_Id)
);

CREATE UNIQUE INDEX XPKPOLICY_RENEWABLE_16 ON POLICY_RENEWABLE (Policy_Renewable_Id ASC, Agreement_id ASC, Application_Id ASC, Cust_Id ASC);

CREATE TABLE MEMBERSHIP (
    Membership_Id VARCHAR(20) NOT NULL,
    Membership_Type VARCHAR(15) NOT NULL,
    Organisation_Contact VARCHAR(20) NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKMEMBERSHIP_12 PRIMARY KEY (Membership_Id, Cust_Id),
    CONSTRAINT R_91 FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKMEMBERSHIP_12 ON MEMBERSHIP (Membership_Id ASC, Cust_Id ASC);

CREATE TABLE QUOTE (
    Quote_Id VARCHAR(20) NOT NULL,
    Issue_Date DATE NOT NULL,
    Valid_From_Date DATE NOT NULL,
    Valid_Till_Date DATE NOT NULL,
    Description VARCHAR(100) NULL,
    Product_Id VARCHAR(20) NOT NULL,
    Coverage_Level VARCHAR(20) NOT NULL,
    Application_Id BIGINT NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKQUOTE_3 PRIMARY KEY (Quote_Id, Application_Id, Cust_Id),
    CONSTRAINT R_94 FOREIGN KEY (Application_Id, Cust_Id) REFERENCES APPLICATION (Application_Id, Cust_Id)
);

CREATE UNIQUE INDEX XPKQUOTE_3 ON QUOTE (Quote_Id ASC, Application_Id ASC, Cust_Id ASC);

CREATE TABLE STAFF (
    Staff_Id VARCHAR(20) NOT NULL,
    Staff_Fname VARCHAR(10) NULL,   
    Staff_LName VARCHAR(10) NULL,
    Staff_Address VARCHAR(20) NULL,
    Staff_Contact BIGINT NULL,
    Staff_Gender VARCHAR(7) NULL,
    Staff_Marital_Status CHAR(8) NULL,
    Staff_Nationality VARCHAR(15) NULL,
    Staff_Qualification VARCHAR(20) NULL,
    Staff_Allowance INTEGER NULL,
    Staff_PPS_Number INTEGER NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKSTAFF_9 PRIMARY KEY (Staff_Id, Company_Name),
    CONSTRAINT R_105 FOREIGN KEY (Company_Name) REFERENCES INSURANCE_COMPANY (Company_Name)
);

CREATE UNIQUE INDEX XPKSTAFF_9 ON STAFF (Staff_Id ASC, Company_Name ASC);

CREATE TABLE NOK (
    Nok_Id VARCHAR(20) NOT NULL,
    Nok_Name VARCHAR(20) NULL,
    Nok_Address VARCHAR(20) NULL,
    Nok_Phone_Number BIGINT NULL,
    Nok_Gender VARCHAR(7) NULL,
    Nok_Marital_Status ENUM('single', 'married', 'divorsed') DEFAULT 'single',
    Agreement_id VARCHAR(20) NOT NULL,
    Application_Id BIGINT NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKNOK_14 PRIMARY KEY (Nok_Id, Agreement_id, Application_Id, Cust_Id),
    CONSTRAINT R_99 FOREIGN KEY (Agreement_id, Application_Id, Cust_Id) REFERENCES INSURANCE_POLICY (Agreement_id, Application_Id, Cust_Id)
);

CREATE UNIQUE INDEX XΡΚΝΟΚ_14 ON NOK (Nok_Id ASC, Agreement_id ASC, Application_Id ASC, Cust_Id ASC);

CREATE TABLE PRODUCT (
    Product_Type VARCHAR(15) NULL,
    Product_Price INTEGER DEFAULT NULL,
    Product_Number VARCHAR(20) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKPRODUCT_20 PRIMARY KEY (Product_Number, Company_Name),
    CONSTRAINT R_107 FOREIGN KEY (Company_Name) REFERENCES INSURANCE_COMPANY (Company_Name)
);

CREATE UNIQUE INDEX XPKPRODUCT_20 ON PRODUCT (Product_Number ASC, Company_Name ASC);

CREATE TABLE OFFICE (
    Office_Name VARCHAR(20) NOT NULL,
    Office_Leader VARCHAR(20) NOT NULL,
    Contact_Information BIGINT NOT NULL,
    Address VARCHAR(20) NOT NULL,
    Admin_Cost INTEGER NULL,
    Staff VARCHAR(50) NULL,
    Department_Name VARCHAR(100) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKOFFICE_11 PRIMARY KEY (Office_Name, Department_Name, Company_Name),
    CONSTRAINT R_104 FOREIGN KEY (Department_Name) REFERENCES DEPARTMENT (Department_Name),
    CONSTRAINT R_109   FOREIGN KEY (Company_Name) REFERENCES INSURANCE_COMPANY(Company_Name)
);

CREATE UNIQUE INDEX XPKOFFICE_11 ON OFFICE (Office_Name ASC, Department_Name ASC, Company_Name ASC);

CREATE TABLE COVERAGE (
    Coverage_Type VARCHAR(20) NOT NULL,
    Coverage_Id VARCHAR(20) NOT NULL,
    Coverage_Amount INTEGER NOT NULL,
    Coverage_Level VARCHAR(20) NOT NULL,
    Product_Id VARCHAR(20) NOT NULL,
    Coverage_Description VARCHAR(100) NULL,
    Coverage_Terms VARCHAR(50) NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKCOVERAGE_19 PRIMARY KEY (Coverage_Id, Company_Name),
    CONSTRAINT R_102 FOREIGN KEY (Company_Name) REFERENCES INSURANCE_COMPANY (Company_Name)
);

CREATE UNIQUE INDEX XPKCOVERAGE_19 ON COVERAGE (Coverage_Id ASC, Company_Name ASC);

CREATE TABLE INSURANCE_POLICY_COVERAGE (
    Agreement_id VARCHAR(20) NOT NULL,
    Application_Id BIGINT NOT NULL,
    Cust_Id BIGINT NOT NULL,
    Coverage_Id VARCHAR(20) NOT NULL,
    Company_Name VARCHAR(255) NOT NULL,
    CONSTRAINT XPKINSURANCE_POLICY_4_COVERAGE PRIMARY KEY (Agreement_id, Application_Id, Cust_Id, Coverage_Id, Company_Name),
    CONSTRAINT R_97 FOREIGN KEY (Agreement_id, Application_Id, Cust_Id) REFERENCES INSURANCE_POLICY (Agreement_id, Application_Id, Cust_Id),
    CONSTRAINT R_98 FOREIGN KEY (Coverage_Id, Company_Name) REFERENCES COVERAGE (Coverage_Id, Company_Name)
);

CREATE UNIQUE INDEX XPKINSURANCE_POLICY_4_COVERAGE ON INSURANCE_POLICY_COVERAGE (Agreement_id ASC, Application_Id ASC, Cust_Id ASC, Coverage_Id ASC, Company_Name ASC);

CREATE TABLE CLAIM (
    Claim_Id VARCHAR(20) NOT NULL,
    Agreement_Id VARCHAR(20) NOT NULL,
    Claim_Amount INTEGER NOT NULL,
    Incident_Id VARCHAR(20) NOT NULL,
    Damage_Type VARCHAR(20) NOT NULL,
    Date_Of_Claim DATE NOT NULL,
    Claim_Status VARCHAR(10) NOT NULL,
    Cust_ID BIGINT NOT NULL,
    CONSTRAINT XPKCLAIM_7 PRIMARY KEY (Claim_Id, Cust_Id),
    CONSTRAINT R_88 FOREIGN KEY (Cust_Id) REFERENCES CUSTOMER (Cust_Id)
);

CREATE UNIQUE INDEX XPKCLAIM_7 ON CLAIM (Claim_Id ASC, Cust_Id ASC);

CREATE TABLE CLAIM_SETTLEMENT (
    Claim_Settlement_ID VARCHAR(20) NOT NULL,
    Vehicle_Id VARCHAR(20) NOT NULL,
    Date_Settled DATE NOT NULL,
    Amount_Paid INTEGER NOT NULL,
    Coverage_Id VARCHAR(20) NOT NULL,
    Claim_Id VARCHAR(20) NOT NULL,
    Cust_Id BIGINT NOT NULL,
    CONSTRAINT XPKCLAIM_SETTLEMENT_8 PRIMARY KEY (Claim_Settlement_Id, Claim_Id, Cust_Id),
    CONSTRAINT R_90 FOREIGN KEY (Claim_Id, Cust_Id) REFERENCES CLAIM (Claim_Id, Cust_Id)
);

CREATE UNIQUE INDEX XPKCLAIM_SETTLEMENT_8 ON CLAIM_SETTLEMENT (Claim_Settlement_ID ASC, Claim_Id ASC, Cust_Id ASC);