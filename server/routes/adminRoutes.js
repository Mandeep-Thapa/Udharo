const express = require("express");
const router = express.Router();
const cors = require('cors');
router.use(cors());
const {
  registerAdmin,
  loginAdmin,
  getAdminDetails,
} = require("../controllers/adminController");
const authenticate = require("../middleware/adminVerification");

router.post("/register", registerAdmin);

router.post("/login", loginAdmin);

router.get("/details", authenticate, getAdminDetails);

module.exports = router;
