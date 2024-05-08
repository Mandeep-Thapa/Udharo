const express = require("express");
const router = express.Router();
const cors = require("cors");
router.use(cors());
const {
  registerAdmin,
  loginAdmin,
  getAdminDetails,
  getUserById,
} = require("../controllers/adminController");
const authenticate = require("../middleware/adminVerification");

router.post("/register", registerAdmin);

router.post("/login", loginAdmin);

router.get("/admindetails", authenticate, getAdminDetails);

router.get("/userdetails/:id", authenticate, getUserById);

module.exports = router;
