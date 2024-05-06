const express = require("express");
const {
  registerAdmin,
  loginAdmin,
  getAdminDetails,
} = require("../controllers/adminController");
const authenticate = require("../middleware/adminVerification");
const router = express.Router();

router.post("/register", registerAdmin);

router.post("/login", loginAdmin);

router.get("/details", authenticate, getAdminDetails);

module.exports = router;
