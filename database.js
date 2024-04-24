import mysql from 'mysql2'
// import dotenv from 'dotenv'

const pool = mysql.createPool({
    host: '127.0.0.1',
    user:'root',
    password: 'Tatapunch*9',
    database: 'insurance'
}).promise()


export async function getcustomers(){
const [rows] = await pool.query("select * from customer")
return rows
}

export async function logincustomer(email, pass) {
    try {
        const [rows] = await pool.query("SELECT Cust_Email,Password FROM customer WHERE Cust_Email = ? AND Password = ?", [email, pass]);
        return rows;
    } catch (error) {
        console.error("Error fetching customers:", error);
        throw error; 
    }
}


export async function successcustomer(cust_id){
    const [rows] = await pool.query(`select Cust_Id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number from customer group by cust_id having cust_id = (select max(cust_id) from customer);`)
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}
export async function getcustomer(cust_id){
    const [rows] = await pool.query(`select * from customer where cust_id = ?`,[cust_id])
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}
export async function getcustomerbyname(Cust_FName){
    const [rows] = await pool.query(`select * from customer where Cust_FName = ?`,[Cust_FName])
    // This funciton or the basic syntax is for viewing/reading from a table.It can be modified according to the requirements.
    return rows
}

export async function createcustomer(Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number) {
    const result = await pool.query(
        `INSERT INTO CUSTOMER (Cust_id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number) 
        VALUES ( NULL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [ Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number]
    )
    // This funciton or the basic syntax is for inserting from a table.It can be modified according to the requirements.
    return result
}

export async function deletecustomer(cust_id){
    const result = await pool.query(`delete from customer where cust_id = ?`,[cust_id])  // This funciton or the basic syntax is for deleting from a table.It can be modified according to the requirements.
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
        if(Password===Confirm_password){
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


// const notes = await successcustomer()
// console.log(`${notes[0].Cust_Id}`)