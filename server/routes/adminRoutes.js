const express = require("express");

const router = express.Router();

router.post("/register", (req, res) => {
  res.json("This is the admin register route");
});

router.post("/login", (req, res) => {
  res.json("This is the admin login route");
});

router.get("/allUser", (req, res) => {
  res.json("This is the get all user API");
});

module.exports = router;
