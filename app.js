import express, { response } from 'express'
import cors from 'cors';
import {
    UpdateIncidentReport,
    GetAllCustomers,
    getcustomer,
    createcustomer,
    deletecustomer,
    updatecustomer,
    customerpassword,
    successcustomer,
    logincustomer,
    createIncidentReport,
    loginstaff,
    incidenthistory,
    UpdateApplicationStatus,
    GetReceipts,
    Getpolicies,
    RegisterIncident,
    RegisterNok,
    RegisterVehicle,
    RegisterApp,
    payGate,
    show_receipt,
    prepay,
    claimAmount,
    CreateQuote,
    successquote,
    getrenewable,
    RegisterAppRenew,
    custvehicle,
    cust_claim_his,
    setVCookie,
    getfname
    //GetApplicationId
} from './database.js'
import cookieParser from 'cookie-parser';

const app = express();

app.use(express.static('./staff_confirm_application'));
app.use(cookieParser());
app.use(express.json())
app.use(cors({
    origin: '*'
}));
app.get("/firstname",async(req,res)=>{
    const id = req.cookies.userId;
    const result = await getfname(id);
    res.status(200).json({result: result[0]});
})
app.get('/cust_claim_history', async (req,res)=>{

    const id = req.cookies.userId;
    const result = await cust_claim_his(id);
    res.status(200).json({data:result});
})
app.get('/', (req, res) => {
    res.sendFile(import.meta.dirname + '/staff_confirm_application/index.html');
    // res.send('aaa');
})

app.get("/customers", async (req, res) => {
    try {
        const customers = await GetAllCustomers();
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
        if (customer.Cust_Email === Cust_Email && customer.Password === Password) {
            res.cookie('userId', customer.Cust_Id, { httpOnly: true, maxAge: new Date(Date.now() + 60 * 60 * 1000) });
            res.status(200).send("Authentication successful");
        } else {

            res.status(401).json({ error: "Invalid credentials" });
        }
    } catch (error) {
        console.error("Error fetching customers:", error);
        res.status(500).json({ error: "An error occurred while logging in" });
    }
});

app.post("/stafflogin", async (req, res) => {
    try {
        const { Staff_Email, Password } = req.body;

        if (!Staff_Email || !Password) {
            return res.status(400).json({ error: "Missing email or password" });
        }

        const staff = await loginstaff(Staff_Email, Password);


        if (staff.length === 0) {
            return res.status(401).json({ error: "Invalid credentials" });
        }


        const staffs = staff[0];
        if (staffs.Staff_Email === Staff_Email && staffs.Password === Password) {
            res.cookie('userId', staffs.Staff_Id, { httpOnly: true, maxAge: new Date(Date.now() + 60 * 60 * 1000) });
            res.status(200).end();
        } else {

            res.status(401).json({ error: "Invalid credentials" });
        }
    } catch (error) {
        console.error("Error fetching staff:", error);
        res.status(500).json({ error: "An error occurred while logging in" });
    }
});

app.get("/customer", async (req, res) => {
    try {
        const id = req.cookies.userId;


        const customer = await getcustomer(id);


        if (!customer) {
            return res.status(404).json({ error: "Customer not found" });
        }


        res.status(200).json({ data: customer });
    } catch (error) {
        console.error("Error fetching customer:", error);
        res.status(500).json({ error: "An error occurred while fetching customer" });
    }
});

app.get("/customer_success", async (req, res) => {
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
            background-image: url('image7.jpg'); /* Path to your background image */
            background-size: cover; /* Cover the entire viewport */
        }
        
        .navbar {
            
            margin: 30px auto; /* Center the navigation bar horizontally */
            padding: 10px 20px;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-left: 80px;
            margin-bottom: 40px;
            margin-bottom: 30px;

        }

        
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 5px solid #ff7200; /* Light background with some opacity */
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(30px);
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
            backdrop-filter: blur(30px);
            color: white ;
            /* background-color: #fff; Background color for the form */
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

        .up_bar{
            color: white;
            text-decoration: none;
            font-size: large;
            font-family: Arial, Helvetica, sans-serif;
            font-weight: bold;
            margin-right: 40px;
            
            
        }

        .logo{
            color:#ff7200;
            font-size: larger;
            
        }

    </style>
            </head>
            <body>
            <div class="navbar">

    <h2  class="logo"> Mobi</h2>
    <div>
        <a href="index.html" class="up_bar">HOME <id=home #home{margin-left:10px}></id></a>
        <a href="about" class="up_bar">ABOUT</a>
        <a href="#" class="up_bar">SERVICE</a>
        
        <a href="#" class="up_bar">CONTACT</a>
    </div>
    <a href="#" class="up_bar">Logout</a>
    </div>
            
            
            <div class="container">
                <h1 style="color: white">Customer Details</h1>
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

app.get("/getCookieVehId/:id",async (req,res)=> {
    const id = req.params.id;
    try{
        const results = await setVCookie(id);
        //const result = results.data[0];
        if(results.length>0){
            res.cookie('vehId', results.Vehicle_Id, { httpOnly: true, maxAge: new Date(Date.now() + 60 * 60 * 1000) });
        }
    }catch(error){
        console.log(error);
    }
})

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

app.post('/logout', (req, res) => {
    res.clearCookie('userId', { httpOnly: true });
    res.json({ message: 'ok' });
})

app.get("/submit-incident", async (req, res) => {
    const userId = req.cookies.userId;
    console.log('userId:', userId);
    try {
        const result = await createIncidentReport(); // Fetch the pending incidents

        // if (!result || result.length === 0) {
        //     return res.status(404).json({ error: "No pending incidents found" }); // Return a 404 if there's no data
        // }

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
        console.error("Error creating customer:" + error);
        res.status(500).json({ error: "An error occurred while creating customer" + error });
    }
});

// app.get('/userInfo', async (req, res) => {
//     const userId = req.cookies.userId;
//     if(!userId) {
//         res.status(403).json({ error: 'Not logged in' });
//         return;
//     }

//     try {
//         const customer = await getcustomer(userId);
//         if(!customer) throw "Customer not found";

//         console.log('customer:', customer);
//         res.json({ data: customer });
//     } catch(err) {
//         res.status(500).json({ error: err });
//     }
// });

app.get('/incidenthistory', async (req, res) => {
    const id = req.cookies.userId;
    try {
        const result = await incidenthistory(id);
        if (!result) throw "History Not Found";
        res.status(200).json({ data: result });
    } catch (error) {
        res.status(500).json({ error: "An error occured" });
    }
})

app.post('/update-status', async (req, res) => {
    const { appId, status } = req.body;
    try {
        const results = await UpdateApplicationStatus(appId, status);
        res.json({ success: true, message: `Application status updated to ${status}` });
    } catch (error) {
        res.status(500).json({ success: false, message: "Internal server error" });
    }
})



app.get('/get-receipts', async (req, res) => {

    const id = req.cookies.userId;

    try {
        const result = await GetReceipts(id);


        res.status(200).json({ data: result }); // Sending back the data as JSON

    } catch (error) {
        console.error("Database error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
})
app.get('/get-policies', async (req, res) => {
    const id = req.cookies.userId;
    try {
        const result = await Getpolicies(id);
        res.status(200).json({ data: result })

    } catch (error) {
        res.status(500).json({ error: "This is a server error" })
    }
})

app.post('/register-incident', async (req, res) => {
    const userId = req.cookies.userId;

    try {
        const {
            Vehicle_Number,
            Incident_Type,
            Incident_Date,
            Description
        } = req.body;

        if (!Vehicle_Number || !Incident_Type || !Incident_Date || !Description) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        res.cookie('Vehicle_Number', req.body.Vehicle_Number, {
            httpOnly: true,
            maxAge: 60 * 60 * 1000, // 1 hour in milliseconds
        });

        // Register the incident and get the Incident_Id
        const { Incident_Id } = await RegisterIncident(
            Vehicle_Number,
            Incident_Type,
            Incident_Date,
            Description,
            userId
        );

        // Set the cookie with the Incident_Id
        res.cookie('Incident_Id', Incident_Id, {
            httpOnly: true,
            maxAge: 60 * 60 * 1000, // 1 hour
        });

        

        res.status(200).json({ success: true, message: 'Incident registered successfully', Incident_Id }); // Return success message
    } catch (error) {
        console.error("Error registering incident:", error); // Log the error
        res.status(500).json({ error: "An internal server error occurred" }); // Return a 500 error response
    }
});

app.post('/register-nok', async (req, res) => {
    const id = req.cookies.userId;
    const application_id = req.cookies.Application_Id;
    try {
        const {
            Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status
        } = req.body;


        if (!Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || !Nok_Marital_Status || !id) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        const result = await RegisterNok(Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, id, application_id);
        res.status(200).json({});
    } catch (error) {
        res.status(500).json({ error: "This is server error " + error })
    }
})

app.post('/register-vehicle', async (req, res) => {
    const id = req.cookies.userId;
    try {
        const {
            Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number, Vehicle_Model_Number
        } = req.body;


        // if ( !Nok_Id || ! Nok_Name || !Nok_Address || !Nok_Phone_Number || !Nok_Gender || ! Nok_Marital_Status || !id) {
        //     return res.status(400).json({ error: "Missing required fields" });
        // }

        const result = await RegisterVehicle(Vehicle_Registration_Number,
            Vehicle_Value,
            Vehicle_Type,
            Vehicle_Manufacturer,
            Vehicle_Engine_Number,
            Vehicle_Chasis_Number,
            Vehicle_Model_Number,
            id);
        if (result.affectedRows > 0) {
            // Setting the cookie with the vehicle value
            res.cookie('Vehicle_Value', Vehicle_Value, {
                httpOnly: true, // Cookie cannot be accessed by JavaScript
                maxAge: 60 * 60 * 1000, // 1 hour in milliseconds // SameSite policy
            });
            res.cookie('Vehicle_Registration_Number', Vehicle_Registration_Number, {
                httpOnly: true,
                maxAge: 60 * 60 * 1000, // 1 hour
            });
            res.status(200).json({ data: result });
        }
        //  res.cookie('Vehicle_Value', results.Vehicle_Value, { httpOnly: true, maxAge: new Date(Date.now() + 60 * 60 * 1000) });
    } catch (error) {
        res.status(500).json({ error: "This is server error" + error })
    }
})


app.post('/register-app', async (req, res) => {
    const id = req.cookies.userId; // Get the user ID from cookies
    const Vehicle_Registration_Number = req.cookies.Vehicle_Registration_Number; 

    try {
        const { Product_Id, Coverage_Level } = req.body;

        const { insertResult, Application_Id } = await RegisterApp(Vehicle_Registration_Number, Product_Id, Coverage_Level, id);

        if (insertResult.affectedRows > 0) {
            // Set the Application_Id cookie
            res.cookie('Application_Id', Application_Id, {
                httpOnly: true, // Cookie cannot be accessed by JavaScript
                maxAge: 60 * 60 * 1000, // 1 hour in milliseconds
            });
            res.cookie('Product_Id', req.body.Product_Id ,{
                httpOnly: true,
                maxAge: 60 * 60 * 1000,
            });

            res.status(200).json({ success: true, message: 'Application registered successfully', Application_Id }); // Return success and Application_Id
        } else {
            throw new Error('Failed to register application');
        }
    } catch (error) {
        console.error('Error in /register-app:', error); // Log error
        res.status(500).json({ error: "An internal server error occurred" }); // Send error response
    }
});

app.post('/register-app-renew', async (req, res) => {
    const id = req.cookies.userId; // Get the user ID from cookies
    const VehId = req.cookies.vehicleId; 

    try {
        const { Product_Id, Coverage_Level } = req.body;

        const { insertResult, Application_Id } = await RegisterAppRenew(VehId, Product_Id, Coverage_Level, id);

        if (insertResult.affectedRows > 0) {
            // Set the Application_Id cookie
            res.cookie('Application_Id', Application_Id, {
                httpOnly: true, // Cookie cannot be accessed by JavaScript
                maxAge: 60 * 60 * 1000, // 1 hour in milliseconds
            });
            res.cookie('Product_Id', req.body.Product_Id ,{
                httpOnly: true,
                maxAge: 60 * 60 * 1000,
            });

            res.status(200).json({ success: true, message: 'Application registered successfully', Application_Id }); // Return success and Application_Id
        } else {
            throw new Error('Failed to register application');
        }
    } catch (error) {
        console.error('Error in /register-app:', error); // Log error
        res.status(500).json({ error: "An internal server error occurred" }); // Send error response
    }
});


app.post('/register-quote', async (req, res) => {
    const { Product_Id, Coverage_Level } = req.body; // Get parameters from the query string
    const id = req.cookies.userId;
    const Vehicle_value = req.cookies.Vehicle_Value;

    try {
        const result = await CreateQuote(id, Vehicle_value, Product_Id, Coverage_Level);
        res.status(200).json({ data: result });
    } catch (error) {
        res.status(500).json({ error: "This is a server error" + error});
    }
});




app.get('/pay', async (req, res) => {
    const id = req.cookies.userId;
    try {
        const result = await payGate(id);
        if (result.length == 0) throw "Nothing Found"
        res.status(200).json({ data: result[0] });
    } catch (error) {
        res.status(500).json({ error: "This is Server Error" })
    }

})

app.get('/showReceipt', async (req, res) => {
    const id = req.cookies.userId;
    try {
        const result = await show_receipt(id);
        if (result.length == 0) throw "Nothing Found"
        res.status(200).json({ data: result[0] });
    } catch (error) {
        res.status(500).json({ error: "This is Server Error" })
    }

})

app.post("/insert_prepay", async (req, res) => {
    const id = req.cookies.userId;
    const prodId = req.cookies.Product_Id;

    try {
        const data = await prepay(id,prodId);
        res.status(200).json({});
    } catch (error) {
        res.status(500).json({ error: "This is Server Error" })
    }
})
app.post("/amount-claim", async (req, res) => {
    const id = req.cookies.userId;
    const vehId = req.cookies.Vehicle_Number;
    const inc_id = req.cookies.Incident_Id;
    try {
        const {
            Claim_Amount
        } = req.body;
        const result = await claimAmount(id, vehId, inc_id, Claim_Amount);
        res.status(200).send(``);
    } catch (error) {
        res.status(500).json({ error: "This is Server Error" + error})
    }
})

app.get("/success_quote", async (req, res) => {
    const id = req.cookies.userId;
    try {

        const quote = await successquote(id);


        if (!quote) {
            return res.status(404).json({ error: "quote not found" });
        }

        res.status(200).json({data: quote})
        
        
    } catch (error) {
        console.error("Error fetching quote:", error);
        res.status(500).json({ error: "An error occurred while fetching quote" });
    }
});

// app.get("/policy-renew", async (req, res) => {
//     const id = req.cookies.userId;
//     try {

//         const renew = await getrenewable(id);


//         if (!renew) {
//             return res.status(404).json({ error: "renew not found" });
//         }

//         res.status(200).json({data: renew})
        
        
//     } catch (error) {
//         console.error("Error fetching renew:", error);
//         res.status(500).json({ error: "An error occurred while fetching renew" });
//     }
// });


app.get('/policy-renew', async (req, res) => {
    const id = req.cookies.userId; // Retrieve user ID from cookies
    try {
        const renewables = await getrenewable(id); // Fetch renewable policies

        if (!renewables || renewables.length === 0) {
            return res.status(404).json({ error: "Renewable policy not found" });
        }

        // Set the cookie with the Agreement_id (you can set multiple cookies)
        res.cookie('Agreement_id', renewables[0].Agreement_id, {
            httpOnly: true, // Make it HTTP-only
            maxAge: 60 * 60 * 1000, // 1 hour lifespan
        });

        // Return the data with the HTTP response
        res.status(200).json({ data: renewables });
        
    } catch (error) {
        console.error("Error fetching renew:", error);
        res.status(500).json({ error: "An error occurred while fetching renewable policies" });
    }
});


app.post('/set_cookies', (req, res) => {
    const { agreementId, vehicleId } = req.body; // Extract data from the request body

    try {
        // Set the cookies
        res.cookie('agreementId', agreementId, { httpOnly: true, maxAge: 3600000 }); // 1 hour expiration
        res.cookie('vehicleId', vehicleId, { httpOnly: true, maxAge: 3600000 });

        res.status(200).send('Cookies set successfully'); // Success response
    } catch (error) {
        console.error("Error setting cookies:", error);
        res.status(500).send('Failed to set cookies'); // Error response
    }
});

app.get('/custvehicle-history', async (req, res) => {

    const id = req.cookies.userId;

    try {
        const result = await custvehicle(id);


        res.status(200).json({ data: result }); // Sending back the data as JSON

    } catch (error) {
        console.error("Database error:", error);
        res.status(500).json({ error: "Internal server error" + error });
    }
})

app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Something broke!')
})

app.listen(8080, () => {
    console.log('Server is running on port 8080')
})