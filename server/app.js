const express = require("express");

const bodyParser = require("body-parser");

const app = express();

// Parse JSON bodies
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: true }));

//application routes
// User Routes
const userRoute = require("./routes/userRoutes");

app.use("/api/user", userRoute);

// Admin routes
const adminRoute = require("./routes/adminRoutes");

app.use("/api/admin", adminRoute);

app.use(express.json());

module.exports = app;
