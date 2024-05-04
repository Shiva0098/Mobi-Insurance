import mysql from 'mysql2'
// import dotenv from 'dotenv'

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'Iamshiva!1',
    database: 'insurance'
}).promise()