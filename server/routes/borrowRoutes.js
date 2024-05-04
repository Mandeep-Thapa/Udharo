const express = require("express");
const {
  createBorrowRequest,
  browseBorrowRequsts,
} = require("../controllers/borrowController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/createBorrowRequest", authenticate, createBorrowRequest);

router.get("/browseBorrowRequests", authenticate, browseBorrowRequsts);

module.exports = router;
