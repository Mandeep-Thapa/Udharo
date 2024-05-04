const express = require("express");

const router = express.Router();

router.post("/createBorrowRequest", (req, res) => {
  return res.json({ message: "Endpoint to create borrow request" });
});

module.exports = router;
