import mysql from 'mysql2'
// import dotenv from 'dotenv'

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'Iamshiva!1',
    database: 'insurance',
}).promise()

export async function cust_claim_his(id){
    const [rows] = await pool.query(`select * from claim where Claim_Status = 'ACCEPTED' and Cust_Id=?`,[id]);
    return rows;
}
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
export async function incidenthistory(id) {
    try {
        const [rows] = await pool.query(`Select I.*,C.Claim_Status from  incident I join Claim C ON I.Incident_Id = C.Incident_Id where I.Cust_Id = ?`, [id]);
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
        const [result1] = await pool.query('SET SQL_SAFE_UPDATES = 0;');
        const [result2] = await pool.query(`UPDATE incident_report SET Incident_Report_Description = ?, Incident_Cost = ?, Incident_Report_Status = 'ACCEPTED' WHERE Incident_Id = ?;`, [Desc, Cost, Id]);
        const [result3] = await pool.query('SET SQL_SAFE_UPDATES = 1;');

        if (result2.affectedRows > 0) {
            // If at least one row was updated, return success
            return result2; // Return result metadata to confirm successful update
        } else {
            throw new Error(`No incident found with ID: ${Id}`); // If no rows were affected, throw an error
        }
    } catch (error) {
        console.error('Error updating incident:' + error); // Log the error for debugging
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
        // Insert a new incident into the incident table
        const [insertResult] = await pool.query(
            `INSERT INTO incident(Incident_Id, Incident_Type, Incident_Date, Description, Cust_id,Vehicle_Number) 
            VALUES (NULL, ?, ?, ?, ?, ?)`,
            [Incident_Type, Incident_Date, Description, id, Vehicle_Number]
        );

        if (insertResult.affectedRows > 0) {
            // If the insertion was successful, retrieve the newly created Incident_Id
            const [selectResult] = await pool.query(
                `SELECT MAX(Incident_Id) as Incident_Id 
                 FROM incident 
                 WHERE Vehicle_Number = ?;`, 
                [Vehicle_Number]
            );

            // Get the Incident_Id from the result
            const Incident_Id = selectResult[0]?.Incident_Id;

            return { insertResult, Incident_Id }; // Return both results
        } else {
            throw new Error("Failed to register incident"); // Handle failure scenario
        }
    } catch (error) {
        console.error("Error registering incident:", error.message, "\nStack:", error.stack);
        throw error; // Re-throw the error to be caught by the caller
    }
}


export async function RegisterNok(Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, id, application_id) {

    if (!Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || !Nok_Marital_Status) {
        throw new Error("Missing required fields");
    }

    try {
        const [result] = await pool.query(
            `INSERT INTO nok(Nok_Id, Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status,Application_Id,Cust_Id) 
             VALUES (NULL, ?, ?, ?, ?, ?,?,?)`, // Removed the extra closing parenthesis
            [Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, application_id,id]
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

export async function RegisterApp(Vehicle_Registration_Number, Product_Id, Coverage_Level, id) {
    try {
        // Insert into the APPLICATION table
        const [insertResult] = await pool.query(
            `INSERT INTO application (Product_Id, Coverage_Level, Cust_Id, Vehicle_Id)
             VALUES (?, ?, UPPER(?), (
                SELECT MIN(Vehicle_Id)
                FROM vehicle
                WHERE Vehicle_Registration_Number = ?
            ));`,
            [Product_Id, Coverage_Level, id, Vehicle_Registration_Number]
        );

        // Check if the insertion was successful
        if (insertResult.affectedRows > 0) {
            // Retrieve the `Application_Id` after the insertion
            const [result] = await pool.query(
                `SELECT MAX(Application_Id) as Application_Id 
                 FROM APPLICATION 
                 WHERE Vehicle_Id = (SELECT MIN(Vehicle_Id)
                 FROM vehicle
                 WHERE Vehicle_Registration_Number = ?);`,
                [Vehicle_Registration_Number]
            );

            // Get the `Application_Id`
            const Application_Id = result[0]?.Application_Id; // Extract the ID safely

            return { insertResult, Application_Id }; // Return insertion result and Application_Id
        } else {
            throw new Error("Failed to insert into APPLICATION");
        }
    } catch (error) {
        console.error("Error in RegisterApp:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}



export async function RegisterAppRenew(VehId, Product_Id, Coverage_Level, id) {
    try {
        // Insert into the APPLICATION table
        const [insertResult] = await pool.query(
            `INSERT INTO application (Product_Id, Coverage_Level, Cust_Id, Vehicle_Id)
            VALUES (?,UPPER(?),?,?)`,
            [Product_Id, Coverage_Level, id, VehId]
        );

        // Check if the insertion was successful
        if (insertResult.affectedRows > 0) {
            // Retrieve the `Application_Id` after the insertion
            const [result] = await pool.query(
                `SELECT MAX(Application_Id) as Application_Id 
                 FROM APPLICATION 
                 WHERE Vehicle_Id = ?;`,
                [VehId]
            );

            // Get the `Application_Id`
            const Application_Id = result[0]?.Application_Id; // Extract the ID safely

            return { insertResult, Application_Id }; // Return insertion result and Application_Id
        } else {
            throw new Error("Failed to insert into APPLICATION");
        }
    } catch (error) {
        console.error("Error in RegisterApp:", error.message, "\nStack:", error.stack); // Detailed error information
        throw error; // Re-throw the error to be caught by the caller
    }
}

// export async function GetApplicationId(Vehicle_Registration_Number, Product_Id, Coverage_Level, Cust_Id) {
//     try {
//         const [result] = await pool.query(
//             // `SELECT Application_Id from application
//             // WHERE Product_Id = ? AND
//             // Coverage_Level = ? AND
//             // Cust_Id = ? AND
//             // Vehicle_Id = ?;
//             // `, // Removed the extra closing parenthesis
//             `SELECT max(Application_Id) as Application_Id from application`
//             // [Product_Id, Coverage_Level, Cust_Id, Vehicle_Registration_Number]
//         );

//         console.log("Rows affected:", result.affectedRows); // Check the number of affected rows
//         return result[0]; // Return the query result
//     } catch (error) {
//         console.error("Error inserting data:", error.message, "\nStack:", error.stack); // Detailed error information
//         throw error; // Re-throw the error to be caught by the caller
//     }
// }

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
        const [result] = await pool.query(`SELECT * FROM Application WHERE Cust_Id = ? order by Application_Id desc limit 1`, [C_Id]);
        return result;
    } catch (error) {
        console.error("Error Getting Application: " + error);
        throw error;
    }
}

export async function show_receipt(C_Id) {
    try {
        const [result] = await pool.query(`SELECT * FROM Receipt WHERE Cust_Id = ? order by Receipt_Id desc limit 1`, [C_Id]);
        return result;
    } catch (error) {
        console.error("Error Getting Application: " + error);
        throw error;
    }
}


export async function prepay(id,prodId) {
    try {
        const [result] = await pool.query(`CALL createPREMIUM_PAYMENT(?,?, TRUE)`, [id,prodId])
        return result;
    } catch (error) {
        console.error("Failed to go to Payment_Gateway");
        throw error;
    }
}


export async function claimAmount(id, vehId, inc_id, claim_amt) {
    try {
        const [result] = await pool.query(`CALL createClaim(?,?,?,?)`,
            [id, vehId, inc_id, claim_amt]
        );
        return result;
    } catch (error) {
        console.error("Failed to claim amount!");
        throw error;
    }
}

export async function CreateQuote(id, Vehicle_value, Product_Id, Coverage_Level) {
    try {
        const [result] = await pool.query(`CALL createQuote(?, ?, ?, ?)`, 
        [id, Vehicle_value, Product_Id, Coverage_Level]
    );
    console.log(result.Product_Id)
    return result;
    } catch (error) {
        console.error('Failed to create Quote!');
        throw error;
    }
}

export async function successquote(id) {
    const [rows] = await pool.query(`select * from quote where quote_id = (select max(quote_id) from quote where cust_id = ?)`, [id])
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}

export async function getrenewable(id) {
    const [rows] = await pool.query(`SELECT Policy_Renewable_Id, Date_Of_Renewal, Agreement_id, Cust_Id,Vehicle_Id FROM policy_renewable WHERE Cust_id = ? and Policy_Renewable_Status ='PENDING'`, [id]);
    return rows;
}
export async function setVCookie(id){
    const  [row] = await pool.query(`select Vehicle_Id from policy_renewable where Policy_Renewable_Id =? `,[id]);
    return row;
}
export async function custvehicle(id) {
    try {
        const [rows] = await pool.query("SELECT * FROM VEHICLE WHERE Cust_Id = ?", [id]);
        return rows;

    } catch (error) {
        console.error("Error Getting Receipts");
        throw error;
    }
}
export async function getfname(id){
 try{
    const [rows] = await pool.query("SELECT Cust_FName FROM customer WHERE Cust_Id = ?", [id]);
        return rows;
 }catch(error){
    throw error;
 }
}





// const notes = await successcustomer()
// console.log(`${notes[0].Cust_Id}`)
