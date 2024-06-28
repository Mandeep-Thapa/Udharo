const express = require("express");
const {
  registerUser,
  loginUser,
  getUserProfileWithTransactions,
  sendVerificationEmail,
  verifyEmail,
  paymentVerification,
  panVerification,
  savePayment,
} = require("../controllers/userController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/profile", authenticate, getUserProfileWithTransactions);

router.post("/send-verification-email", sendVerificationEmail);

router.get("/verify-email/:token", verifyEmail);

router.post("/khaltiPaymentVerification", authenticate, paymentVerification);

router.post("/saveKhaltiPaymentDetails", authenticate, savePayment);

module.exports = router;
