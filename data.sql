-- INCIDENT
INSERT INTO INCIDENT (Incident_Id, Incident_Type, Incident_Date, Description)
VALUES 
    (123001, 'Accident', '2024-04-01', 'Car collision in downtown.'),
    (123002, 'Fire', '2024-03-15', 'House fire due to electrical malfunction.'),
    (123003, 'Theft', '2024-04-20', 'Stolen laptop from office premises.'),
    (123004, 'Natural disaster', '2024-02-10', 'Flood damage in residential area.'),
    (123005, 'Breakdown', '2024-01-05', 'Car engine failure on the highway.');

-- CUSTOMER
INSERT INTO CUSTOMER (Cust_Id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number, Password)
VALUES 
    (1, 'John', 'Doe', '1980-05-20', 'Male', '123 Main St, City', 12345678901, 'john@example.com', NULL, 'Married', NULL, 'password1'),
    (2, 'Jane', 'Smith', '1992-10-15', 'Female', '456 Oak Ave, Town', 98765432109, 'jane@example.com', 'AB123456', 'Single', 123456789, 'password2'),
    (3, 'David', 'Brown', '1975-03-08', 'Male', '789 Elm Rd, Village', 45678901234, 'david@example.com', 'CD789012', 'Divorced', 987654321, 'password3');

-- INCIDENT_REPORT
INSERT INTO INCIDENT_REPORT (Incident_Report_ID, Incident_Type, Incident_Inspector, Incident_Cost, Incident_Report_Description, Incident_Id, Cust_Id)
VALUES 
    (345001, 'Accident', 'John Smith', 5000, 'Car collision', 123001, 1),
    (345002, 'Fire', 'Emily Johnson', 10000, 'House fire', 123002, 2),
    (345003, 'Theft', 'Michael Lee', 2000, 'Stolen laptop', 123003, 3);

-- INSURANCE_COMPANY
INSERT INTO INSURANCE_COMPANY (Company_Name, Company_Address, Company_Contact_Number, Company_Fax, Company_Email, Company_Website, COMPANY_LOCATION, Company_Department_Name, Company_Office_Name)
VALUES 
    ('ABC Insurance', '123 Oak St', 1234567890, 98765, 'info@abcinsurance.com', 'www.abcinsurance.com', 'City Center', 'Claims', 'City Office'),
    ('XYZ Insurance', '456 Elm Rd', 9876543210, 12345, 'info@xyzinsurance.com', 'www.xyzinsurance.com', 'Downtown', 'Customer Service', 'Main Branch');

-- DEPARTMENT
INSERT INTO DEPARTMENT (Department_Name, Department_ID, Department_Staff, Department_Offices, Company_Name)
VALUES 
    ('Claims', 'CLM001', 10, 'City Center', 'ABC Insurance'),
    ('Customer Service', 'CS001', 15, 'Downtown', 'XYZ Insurance');

-- VEHICLE_SERVICE
INSERT INTO VEHICLE_SERVICE (Department_Name, Vehicle_Service_Company_Name, Vehicle_Service_Address, Vehicle_Service_Contact, Vehicle_Service_Incharge, Vehicle_Service_Type, Department_Id, Company_Name)
VALUES 
    ('Claims', 'AutoRepair Co.', '789 Elm Rd, Village', 9876543210, 'Mike Johnson', 'Repair', 'CLM001', 'ABC Insurance'),
    ('Customer Service', 'CarWash Inc.', '456 Oak Ave, Town', 1234567890, 'Sarah Smith', 'Cleaning', 'CS001', 'XYZ Insurance');

-- VEHICLE
INSERT INTO VEHICLE (Vehicle_Id, Policy_Id, Dependent_NOK_ID, Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Size, Vehicle_Number_Of_Seat, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number, Vehicle_Number, Vehicle_Model_Number, Cust_ID)
VALUES 
    (12001, 'POL001', NULL, 'ABC123', 20000, 'Car', 4, 5, 'Toyota', 123456, 987654, 'TN1234', 'Camry', 1),
    (12002, 'POL002', NULL, 'XYZ456', 25000, 'Commercial Vehicle', 5, 2, 'Ford', 789012, 345678, 'CA5678', 'Explorer', 2);

-- PREMIUM_PAYMENT
INSERT INTO PREMIUM_PAYMENT (Premium_Payment_Id, Policy_Number, Premium_Payment_Amount, Premium_Payment_Schedule, Receipt_Id, Cust_Id)
VALUES 
    (101001, 'POL001', 500, '2024-04-15', 801001, 1),
    (101002, 'POL002', 600, '2024-04-20', 801002, 2);

-- RECEIPT
INSERT INTO RECEIPT (Receipt_Id, Time, Cost, Premium_Payment_Id, Cust_Id)
VALUES 
    (801001, '2024-04-15', 500, 101001, 1),
    (801002, '2024-04-20', 600, 101002, 2);

-- APPLICATION
INSERT INTO APPLICATION (Application_Id, Vehicle_Id, Application_Status, Coverage, Cust_Id)
VALUES 
    (101, '12001', 'Pending', 'Comprehensive', 1),
    (102, '12002', 'Approved', 'Third Party', 2);

-- INSURANCE_POLICY
INSERT INTO INSURANCE_POLICY (Agreement_id, Department_Name, Policy_Number, Start_Date, Expiry_Date, Term_Condition_Description, Application_Id, Cust_Id)
VALUES 
    (301001, 'Claims', 'POL001', '2024-04-01', '2025-04-01', 'Comprehensive coverage', 101, 1),
    (301002, 'Customer Service', 'POL002', '2024-04-01', '2025-04-01', 'Third party coverage', 102, 2);

-- POLICY_RENEWABLE
INSERT INTO POLICY_RENEWABLE (Policy_Renewable_Id, Date_Of_Renewal, Type_Of_Renewal, Agreement_id, Application_Id, Cust_Id)
VALUES 
    (234001, '2025-04-01', 'Auto', 301001, 101, 1),
    (234002, '2025-04-01', 'Auto', 301002, 102, 2);

-- MEMBERSHIP
INSERT INTO MEMBERSHIP (Membership_Id, Membership_Type, Organisation_Contact, Cust_Id)
VALUES 
    (2001, 'Silver', 'Insurance Associate', 1),
    (2002, 'Gold', 'Insurance Club', 2),
    (2003, 'Bronze', 'Insurance Base', 3);

-- QUOTE
INSERT INTO QUOTE (Quote_Id, Issue_Date, Valid_From_Date, Valid_Till_Date, Description, Product_Id, Coverage_Level, Application_Id, Cust_Id)
VALUES 
    ('Q001', '2024-04-01', '2024-04-15', '2024-05-01', 'Comprehensive coverage', 'P001', 'High', 101, 1),
    ('Q002', '2024-04-01', '2024-04-15', '2024-05-01', 'Third party coverage', 'P002', 'Low', 102, 2);

-- STAFF
INSERT INTO STAFF (Staff_Id, Staff_Fname, Staff_LName, Staff_Address, Staff_Contact, Staff_Email, Staff_Gender, Staff_Marital_Status, Staff_Nationality, Staff_Qualification, Staff_Allowance, Staff_PPS_Number, Company_Name, Password)
VALUES 
    (401001, 'Mark', 'Johnson', '123 Main St, City', 12345678901, 'mark@example.com', 'Male', 'Married', 'American', 'Bachelor', 1000, 123456789, 'ABC Insurance', 'password'),
    (401002, 'Emily', 'Brown', '456 Oak Ave, Town', 98765432109, 'emily@example.com', 'Female', 'Single', 'British', 'Master', 1500, 987654321, 'XYZ Insurance', 'password');

-- NOK
INSERT INTO NOK (Nok_Id, Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, Agreement_id, Application_Id, Cust_Id)
VALUES 
    (001, 'Sarah Johnson', '123 Main St, City', 1234567890, 'Female', 'Married', 301001, 101, 1),
    ('N002', 'Michael Smith', '456 Oak Ave, Town', 9876543210, 'Male', 'Single', 301002, 102, 2);

-- PRODUCT
INSERT INTO PRODUCT (Product_Type, Product_Price, Product_Number, Company_Name)
VALUES 
    ('Insurance', 500, 701001, 'ABC Insurance'),
    ('Insurance', 400, 701002, 'XYZ Insurance');

-- OFFICE
INSERT INTO OFFICE (Office_Name, Office_Leader, Contact_Information, Address, Admin_Cost, Staff, Department_Name, Company_Name)
VALUES 
    ('City Office', 'John Doe', 1234567890, '123 Main St, City', 1000, '10', 'Claims', 'ABC Insurance'),
    ('Main Branch', 'Jane Smith', 9876543210, '456 Oak Ave, Town', 1500, '15', 'Customer Service', 'XYZ Insurance');

-- COVERAGE
INSERT INTO COVERAGE (Coverage_Type, Coverage_Id, Coverage_Amount, Coverage_Level, Product_Id, Coverage_Description, Coverage_Terms, Company_Name)
VALUES 
    ('Comprehensive', 601001, 20000, 'High', 'P001', 'Full coverage for vehicles', 'Terms and conditions apply', 'ABC Insurance'),
    ('Third Party', 601002, 15000, 'Low', 'P002', 'Basic coverage for third party liabilities', 'Terms and conditions apply', 'XYZ Insurance');

-- INSURANCE_POLICY_COVERAGE
INSERT INTO INSURANCE_POLICY_COVERAGE (Agreement_id, Application_Id, Cust_Id, Coverage_Id, Company_Name)
VALUES 
    (301001, 101, 1, 601001, 'ABC Insurance'),
    (301002, 102, 2, 601002, 'XYZ Insurance');

-- CLAIM
INSERT INTO CLAIM (Claim_Id, Agreement_Id, Claim_Amount, Incident_Id, Damage_Type, Date_Of_Claim, Claim_Status, Cust_ID)
VALUES 
    (201001, 301001, 8000, 123001, 'Vehicle Damage', '2024-04-05', 'Pending', 1),
    (201002, 301002, 5000, 123002, 'Property Damage', '2024-04-10', 'Approved', 2);

-- CLAIM_SETTLEMENT
INSERT INTO CLAIM_SETTLEMENT (Claim_Settlement_ID, Vehicle_Id, Date_Settled, Amount_Paid, Coverage_Id, Claim_Id, Cust_Id)
VALUES 
    (13001, 12001, '2024-04-20', 8000, 601001, 201001, 1),
    (13002, 12002, '2024-04-25', 5000, 601002, 201002, 2);
