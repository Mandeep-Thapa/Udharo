const express = require("express");
const {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
  rejectBorrowRequest,
  borrowRequestHistory,
  returnMoney,
} = require("../controllers/borrowController");
const authenticate = require("../middleware/verification");

const router = express.Router();

router.post("/createBorrowRequest", authenticate, createBorrowRequest);

router.get("/browseBorrowRequests", authenticate, browseBorrowRequests);

router.put("/approveBorrowRequest/:id", authenticate, approveBorrowRequest);

router.put("/rejectBorrowRequest/", authenticate, rejectBorrowRequest);

router.get("/borrowRequestHistory", authenticate, borrowRequestHistory);

router.put("/returnMoney", returnMoney);

module.exports = router;
