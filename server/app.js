const express = require("express");

const bodyParser = require("body-parser");

const userRoute = require("./routes/userRoutes");

const adminRoute = require("./routes/adminRoutes");

const app = express();

// Parse JSON bodies
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: true }));

//application routes
// User Routes

app.use("/api/user", userRoute);

// Admin routes

// app.use("/api/admin", adminRoute);

app.use(express.json());

module.exports = app;
