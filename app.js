import express from 'express'
import cors from 'cors';
import { 
    UpdateIncidentReport, 
    getcustomers, 
    getcustomer, 
    createcustomer, 
    deletecustomer, 
    updatecustomer, 
    customerpassword, 
    successcustomer, 
    logincustomer, 
    createIncidentReport, 
} from './database.js'

const app = express();

app.use(express.static('./staff_confirm_application'));
app.use(express.json())
app.use(cors({
    origin: '*'
}));
app.get("/customers", async (req, res) => {
    try {
        const customers = await getcustomers();
        res.status(200).json({ data: customers });
    
    } catch (error) {
        console.error("Error fetching customers:", error);
        res.status(500).json({ error: "An error occurred while fetching customers" });
    }
});

app.post("/login", async (req, res) => {
    try {
        const { Cust_Email, Password } = req.body;

        if (!Cust_Email || !Password) {
            return res.status(400).json({ error: "Missing email or password" });
        }

        const customers = await logincustomer(Cust_Email, Password);


        if (customers.length === 0) {
            return res.status(401).json({ error: "Invalid credentials" });
        }


        const customer = customers[0];
        console.log('customer:', customer);
        if (customer.Cust_Email === Cust_Email && customer.Password === Password) {
            // res.cookie('userEmail', Cust_Email, { httpOnly: true, maxAge: new Date(Date.now() + 60 * 60 * 1000) })
            res.status(200).send("Authentication successful");
        } else {

            res.status(401).json({ error: "Invalid credentials" });
        }
    } catch (error) {
        console.error("Error fetching customers:", error);
        res.status(500).json({ error: "An error occurred while logging in" });
    }
});


app.get("/customer/:id", async (req, res) => {
    try {
        const id = req.params.id;


        const customer = await getcustomer(id);


        if (!customer) {
            return res.status(404).json({ error: "Customer not found" });
        }


        res.send();
    } catch (error) {
        console.error("Error fetching customer:", error);
        res.status(500).json({ error: "An error occurred while fetching customer" });
    }
});

app.get("/customer", async (req, res) => {
    try {

        const customer = await successcustomer();


        if (!customer) {
            return res.status(404).json({ error: "Customer not found" });
        }


        res.send(`<!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Registration Success</title>
                <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-image: url('background.jpg'); /* Path to your background image */
                    background-size: cover; /* Cover the entire viewport */
                }
                
                .container {
                    max-width: 600px;
                    margin: 20px auto;
                    padding: 20px;
                    background-color: rgba(255, 255, 255, 0.9); /* Light background with some opacity */
                    border-radius: 5px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                    
                    h1 {
                        text-align: center;
                        margin-bottom: 20px;
                        font-style: italic; /* Italics for the heading */
                        font-size: 30px; /* Increase font size */
                        color: #333; /* Dark text color */
                    }
                    
                    h2 {
                        font-size: 1.5em; /* Increase font size */
                        color: #333;
                        margin-bottom: 10px;
                    }
                    
                    .customer-details {
                        background-color: #fff;
                        padding: 20px;
                        border-radius: 5px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    }
                    
                    .details p {
                        margin: 10px 0; /* Increase margin for better readability */
                        font-size: 1.1em; /* Increase font size */
                    }
                    
                    .details p strong {
                        margin-right: 15px;
                    }
                </style>
            </head>
            <body>
            
            <div class="container">
                <h1>Customer Details</h1>
                <div class="customer-details">
                    <div class="details">
                        <p><strong>Customer ID:</strong> ${customer[0].Cust_Id}</p>
                        <p><strong>First Name:</strong> ${customer[0].Cust_FName}</p>
                        <p><strong>Last Name:</strong> ${customer[0].Cust_LName}</p>
                        <p><strong>Date of Birth:</strong> ${customer[0].Cust_DOB}</p>
                        <p><strong>Gender:</strong> ${customer[0].Cust_Gender}</p>
                        <p><strong>Address:</strong> ${customer[0].Cust_Address}</p>
                        <p><strong>Mobile Number:</strong> ${customer[0].Cust_MOB_Number}</p>
                        <p><strong>Email:</strong> ${customer[0].Cust_Email}</p>
                        <p><strong>Passport Number:</strong> ${customer[0].Cust_Passport_Number}</p>
                        <p><strong>Marital Status:</strong> ${customer[0].Cust_Marital_Status}</p>
                        <p><strong>PPS Number:</strong> ${customer[0].Cust_PPS_Number}</p>
                    </div>
                </div>
            </div>
            
            </body>
            </html>`);
    } catch (error) {
        console.error("Error fetching customer:", error);
        res.status(500).json({ error: "An error occurred while fetching customer" });
    }
});


app.post("/customers", async (req, res) => {
    try {
        const {
            Cust_FName,
            Cust_LName,
            Cust_DOB,
            Cust_Gender,
            Cust_Address,
            Cust_MOB_Number,
            Cust_Email,
            Cust_Passport_Number,
            Cust_Marital_Status,
            Cust_PPS_Number
        } = req.body;


        if (!Cust_FName || !Cust_LName || !Cust_DOB || !Cust_Gender || !Cust_Address || !Cust_MOB_Number) {
            return res.status(400).json({ error: "Missing required fields" });
        }


        const customer = await createcustomer(
            Cust_FName,
            Cust_LName,
            Cust_DOB,
            Cust_Gender,
            Cust_Address,
            Cust_MOB_Number,
            Cust_Email,
            Cust_Passport_Number,
            Cust_Marital_Status,
            Cust_PPS_Number
        );


        res.status(200).send(``);
    } catch (error) {
        console.error("Error creating customer:", error);
        res.status(500).json({ error: "An error occurred while creating customer" });
    }
});


app.put("/customers", async (req, res) => {
    try {
        const { Cust_Id, Cust_Address } = req.body;


        if (!Cust_Id || !Cust_Address) {
            return res.status(400).json({ error: "Cust_Id and Cust_Address are required fields" });
        }


        const customer = await updatecustomer(Cust_Id, Cust_Address);


        res.status(200).json({ message: "Customer information updated successfully", customer });
    } catch (error) {
        console.error("Error updating customer:", error);
        res.status(500).json({ error: "An error occurred while updating customer information" });
    }
});

app.delete("/customers/:id", async (req, res) => {
    try {
        const cust_id = req.params.id;


        const deletedCustomer = await deletecustomer(cust_id);


        if (!deletedCustomer) {
            return res.status(404).json({ error: "Customer not found" });
        }


        res.status(204).send();
    } catch (error) {
        console.error("Error deleting customer:", error);
        res.status(500).json({ error: "An error occurred while deleting customer" });
    }
});



app.put("/password", async (req, res) => {
    try {
        const {
            Password,
            Confirm_Password
        } = req.body;


        if (!Password || !Confirm_Password) {
            return res.status(400).json({ error: "Missing required fields" });
        }


        const customer = await customerpassword(
            Password,
            Confirm_Password
        );

        res.status(200).send(``);
    } catch (error) {
        console.error("Error creating customer:", error);
        res.status(500).json({ error: "An error occurred while creating customer" });
    }
});


app.get("/submit-incident", async (req, res) => {
    try {
        const result = await createIncidentReport(); // Fetch the pending incidents

        if (!result || result.length === 0) {
            return res.status(404).json({ error: "No pending incidents found" }); // Return a 404 if there's no data
        }

        res.status(200).json({ data: result }); // Return the data as JSON
    } catch (error) {
        console.error("Error fetching incident reports:", error); // Log the error
        res.status(500).json({ error: "An error occurred while fetching incident reports" }); // Return a 500 error response
    }
});

app.put("/incidents/:Id", async (req, res) => {
    const data = req.params.Id;
    try {
        let Desc = req.body.description;
        let Cost = req.body.cost;


        if (!Desc || !Cost) {
            return res.status(400).json({ error: "Missing required fields" });
        }


        const customer = await UpdateIncidentReport(
            Desc,
            Cost,
            data
        );

        res.status(200).send(``);
    } catch (error) {
        console.error("Error creating customer:", error);
        res.status(500).json({ error: "An error occurred while creating customer" });
    }
});






app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Something broke!')
})

app.listen(8080, () => {
    console.log('Server is running on port 8080')
})