const express = require("express");
const {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  getUserProfile,
  khaltiPaymentDetails,
} = require("../controllers/userController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/getUnverifiedUsers", getUnverifiedUsers);

router.get("/profile", authenticate, getUserProfile);

router.post("/khaltiDetails", authenticate, khaltiPaymentDetails);

module.exports = router;
