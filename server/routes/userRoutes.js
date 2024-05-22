const express = require("express");
const {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  getUserProfile,
  khaltiPaymentDetails,
  sendVerificationEmail,
  verifyEmail,
  paymentVerification,
  panVerification,
} = require("../controllers/userController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/getUnverifiedUsers", getUnverifiedUsers);

router.get("/profile", authenticate, getUserProfile);

router.post("/send-verification-email", sendVerificationEmail);

router.get("/verify-email/:token", verifyEmail);

router.post("/khaltiDetails", authenticate, khaltiPaymentDetails);

router.post("/khaltiPaymentVerification", authenticate, paymentVerification);

module.exports = router;
