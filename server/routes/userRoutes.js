const express = require("express");
const {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  getUserProfile,
} = require("../controllers/userController");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/getUnverifiedUsers", getUnverifiedUsers);

router.get("/profile", getUserProfile);

module.exports = router;
