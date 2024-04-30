import mysql from 'mysql2'
// import dotenv from 'dotenv'

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'Iamshiva!1',
    database: 'insurance'
}).promise()


export async function GetAllCustomers() {
    const [rows] = await pool.query("select Cust_Id, concat(Cust_FName,' ', Cust_LName) as Name, Cust_Gender, Cust_DOB, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number from insurance.customer")
    return rows
}

export async function logincustomer(email, pass) {
    try {
        const [rows] = await pool.query("SELECT Cust_Id, Cust_Email,Password FROM customer WHERE Cust_Email = ? AND Password = ?", [email, pass]);
        return rows;
    } catch (error) {
        console.error("Error fetching customers:", error);
        throw error;
    }
}
export async function incidenthistory() {
    try {
        const [rows] = await pool.query(`Select * from  incident_report where Incident_Report_Status='ACCEPTED'`);
        return rows
    } catch (error) {
        console.error("Error fetching incident history:", error);
        throw error;
    }
}
export async function loginstaff(email, pass) {
    try {
        const [rows] = await pool.query("SELECT Staff_Email,Password FROM staff WHERE Staff_Email = ? AND Password = ?", [email, pass]);
        return rows;
    } catch (error) {
        console.error("Error fetching customers:", error);
        throw error;
    }
}

export async function successcustomer() {
    const [rows] = await pool.query(`select Cust_Id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number from customer group by cust_id having cust_id = (select max(cust_id) from customer);`)
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}
export async function getcustomer(cust_id) {
    const [rows] = await pool.query(`select * from customer where cust_id = ?`, [cust_id])
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}
export async function getcustomerbyname(Cust_FName) {
    const [rows] = await pool.query(`select * from customer where Cust_FName = ?`, [Cust_FName])
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}

export async function createcustomer(Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number) {
    const result = await pool.query(
        `INSERT INTO CUSTOMER (Cust_id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number) 
        VALUES ( NULL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number]
    )
    // This funciton or the basic syntax is for inserting from a table.It can be modified according to the requirements.
    return result
}

export async function deletecustomer(cust_id) {
    const result = await pool.query(`delete from customer where cust_id = ?`, [cust_id])  // This funciton or the basic syntax is for deleting from a table.It can be modified according to the requirements.
    return result
}

export async function updatecustomer(cust_id, New_Cust_Address) { // This funciton or the basic syntax is for updating from a table.It can be modified according to the requirements.
    try {
        const [rows] = await pool.query(`UPDATE customer SET Cust_Address = ? WHERE cust_id = ?`, [New_Cust_Address, cust_id]);
        return rows;
    } catch (error) {
        console.error('Error updating customer:', error);
        throw error;
    }
}

export async function customerpassword(Password, Confirm_password) { // This funciton or the basic syntax is for updating from a table.It can be modified according to the requirements.
    try {
        if (Password === Confirm_password) {
            const [rows] = await pool.query(`UPDATE customer 
        SET password = ?
        WHERE cust_id = (SELECT * FROM (SELECT MAX(cust_id) FROM customer) AS subquery);
        `, [Password]);
            return rows;
        }
    } catch (error) {
        console.error('Error updating customer:', error);
        throw error;
    }
}

export async function createIncidentReport() {


    try {
        const [result] = await pool.query(`SELECT Incident_Id, Incident_Type, Incident_Date FROM incident_report WHERE Incident_Report_Status = 'PENDING'`);
        return result; // Return the ID of the newly created record
    } catch (error) {
        console.error("Error creating incident report:", error);
        throw new Error("Failed to create incident report"); // Rethrow error for handling by the caller
    }
}

export async function UpdateIncidentReport(Desc, Cost, Id) {
    try {
        // Use parameterized query to prevent SQL injection
        const [result] = await pool.query(
            `UPDATE incident_report SET Incident_Report_Description = ?, Incident_Cost = ? ,Incident_Report_Status='ACCEPTED' WHERE Incident_Id = ?`,
            [Desc, Cost, Id]
        );

        if (result.affectedRows > 0) {
            // If at least one row was updated, return success
            return result; // Return result metadata to confirm successful update
        } else {
            throw new Error(`No incident found with ID: ${Id}`); // If no rows were affected, throw an error
        }
    } catch (error) {
        console.error('Error updating incident:', error); // Log the error for debugging
        throw error; // Rethrow the error to be handled by the caller
    }
}

export async function UpdateApplicationStatus(appId, status) {
    try {
        const [result] = await pool.query(
            `UPDATE Application SET Application_Status = ? Where Application_Id = ?`, [status, appId]
        );
        return result;
    } catch (error) {
        console.error('Error Updating Application:', error); // Log the error for debugging
        throw error;
    }
}
export async function RegisterIncident(Vehicle_Number, Incident_Type, Incident_Date, Description, id) {
    try {
        const [result] = await pool.query(
            `INSERT INTO incident(Incident_Id, Incident_Type, Incident_Date, Description, Cust_id,Vehicle_Number) VALUES (NULL, ?, ?, ?, ?,?)`,
            [Incident_Type, Incident_Date, Description, id, Vehicle_Number]
        );

        console.log("Rows affected:", result.affectedRows);
        return result;
    } catch (error) {
        console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}
export async function RegisterNok(Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, application_id, agreement_id) {

    if (!Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || !Nok_Marital_Status) {
        throw new Error("Missing required fields");
    }

    try {
        const [result] = await pool.query(
            `INSERT INTO nok(Nok_Id, Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status,Application_Id,Agreement_id) 
             VALUES (NULL, ?, ?, ?, ?, ?,?,?)`, // Removed the extra closing parenthesis
            [Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, application_id, agreement_id]
        );


        console.log("Rows affected:", result.affectedRows); // Check the number of affected rows
        return result; // Return the query result
    } catch (error) {
        console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}
export async function RegisterVehicle(Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number, Vehicle_Model_Number, Cust_Id) {

    // if (!Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || !Nok_Marital_Status) {
    //     throw new Error("Missing required fields");
    // }

    try {
        const [result] = await pool.query(
            `INSERT INTO vehicle(Vehicle_Id,Policy_Id, Dependent_NOK_ID, Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Size, Vehicle_Number_Of_Seat, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number,  Vehicle_Model_Number,Cust_Id) 
             VALUES (NULL, NULL, NULL, ?, ?, ?,NULL,NULL,?,?,?,?,?)`, // Removed the extra closing parenthesis
            [Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number, Vehicle_Model_Number, Cust_Id]
        );


        console.log("Rows affected:", result.affectedRows); // Check the number of affected rows
        return result; // Return the query result
    } catch (error) {
        console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}
export async function RegisterApp(Vehicle_Registration_Number, Product_Id, Coverage_Level, Cust_Id) {

    // if (!Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || !Nok_Marital_Status) {
    //     throw new Error("Missing required fields");
    // }

    try {
        const [result] = await pool.query(
            `INSERT INTO application (Product_Id, Coverage_Level, Cust_Id, Vehicle_Id)
            values (?, ?, ?, (
                SELECT MIN(Vehicle_Id)
                FROM vehicle
                WHERE Vehicle_Registration_Number = ?
            ));
            `, // Removed the extra closing parenthesis
            [Product_Id, Coverage_Level, Cust_Id, Vehicle_Registration_Number]
        );

        console.log("Rows affected:", result.affectedRows); // Check the number of affected rows
        return result; // Return the query result
    } catch (error) {
        console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}

export async function GetApplicationId(Vehicle_Registration_Number, Product_Id, Coverage_Level, Cust_Id) {
    try {
        const [result] = await pool.query(
            // `SELECT Application_Id from application
            // WHERE Product_Id = ? AND
            // Coverage_Level = ? AND
            // Cust_Id = ? AND
            // Vehicle_Id = ?;
            // `, // Removed the extra closing parenthesis
            `SELECT max(Application_Id) as Application_Id from application`
            // [Product_Id, Coverage_Level, Cust_Id, Vehicle_Registration_Number]
        );

        console.log("Rows affected:", result.affectedRows); // Check the number of affected rows
        return result[0]; // Return the query result
    } catch (error) {
        console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}

export async function Getpolicies(C_Id) {
    try {
        const [result] = await pool.query(`SELECT * FROM insurance_policy Where Cust_Id = ?`, [C_Id]);
        return result;
    } catch (error) {
        console.error("Error Getting Policies");
        throw error;
    }
}
export async function GetReceipts(C_Id) {
    try {
        const [result] = await pool.query(`SELECT * FROM receipt Where Cust_Id = ?`, [C_Id]);
        return result;

    } catch (error) {
        console.error("Error Getting Receipts");
        throw error;
    }
}

export async function payGate(C_Id) {
    try {
        const [result] = await pool.query(`SELECT * FROM Application WHERE Cust_Id = ?`, [C_Id]);
        return result;
    } catch (error) {
        console.error("Error Getting Application: " + error);
        throw error;
    }
}

export async function show_receipt(C_Id) {
    try {
        const [result] = await pool.query(`SELECT * FROM Receipt WHERE Cust_Id = ?`, [C_Id]);
        return result;
    } catch (error) {
        console.error("Error Getting Application: " + error);
        throw error;
    }
}


export async function prepay(id) {
    try {
        const [result] = await pool.query(`CALL createPREMIUM_PAYMENT(?, TRUE)`, [id])
        return result;
    } catch (error) {
        console.error("Failed to go to Payment_Gateway");
        throw error;
    }
}


export async function claimAmount(id, app_id, inc_id, claim_amt) {
    try {
        const [result] = await pool.query(`CALL createClaim(?,?,?,?)`,
            [id, app_id, inc_id, claim_amt]
        );
        return result;
    } catch (error) {
        console.error("Failed to claim amount!");
        throw error;
    }
}

// const notes = await successcustomer()
// console.log(`${notes[0].Cust_Id}`)
