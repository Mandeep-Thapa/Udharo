const express = require("express");

const { uploadKYC } = require("../controllers/kycController");

const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/upload", authenticate, uploadKYC);

module.exports = router;
