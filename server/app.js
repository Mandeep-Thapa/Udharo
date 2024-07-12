const express = require("express");
const cors = require('cors');
const bodyParser = require("body-parser");

require("dotenv").config();

/*
    import Routes
*/
const corsOptions = {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  };
  
const userRoute = require("./routes/userRoutes");
const adminRoute = require("./routes/adminRoutes");
const borrowRoute = require("./routes/borrowRoutes");
const kycRoute = require("./routes/kycRoute");

const app = express();
app.use(cors(corsOptions));

// Parse JSON bodies
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: true }));

app.use("/api/user", userRoute);
app.use("/api/admin", adminRoute);
app.use("/api/borrow", borrowRoute);
app.use("/api/kyc", kycRoute);

app.use(express.json());

module.exports = app;
