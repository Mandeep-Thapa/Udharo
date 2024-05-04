const express = require("express");
const {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
} = require("../controllers/borrowController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/createBorrowRequest", authenticate, createBorrowRequest);

router.get("/browseBorrowRequests", authenticate, browseBorrowRequests);

router.put("/approveBorrowRequest/:id", authenticate, approveBorrowRequest);

module.exports = router;
