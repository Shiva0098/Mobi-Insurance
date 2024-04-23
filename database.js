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

export async function getcustomer(cust_id){
    const [rows] = await pool.query(`select * from customer where cust_id = ?`,[cust_id])
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



const notes = await updatecustomer(2025,'amaravathi')
console.log(notes)