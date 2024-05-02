const express = require("express");
const config = require("./config/index");

const bodyParser = require("body-parser");

/*
    import Routes
*/
const userRoute = require("./routes/userRoutes");
const adminRoute = require("./routes/adminRoutes");

const app = express();

// Parse JSON bodies
app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: true }));

//application routes
app.use("/api/user", userRoute);
app.use("/api/admin", adminRoute);

app.use(express.json());

module.exports = app;
