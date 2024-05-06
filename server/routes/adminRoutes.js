const express = require("express");
const router = express.Router();
const { registerAdmin, loginAdmin } = require("../controllers/adminController");
const cors = require('cors');
router.use(cors());

router.post("/register", registerAdmin);

router.post("/login", loginAdmin);

module.exports = router;
