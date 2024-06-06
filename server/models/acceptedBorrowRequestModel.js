const mongoose = require("mongoose");

const BorrowFulfillmentSchema = new mongoose.Schema({
  borrowerName: {
    type: String,
    required: true,
  },
  lenderName: {
    type: String,
    required: true,
  },
  fulfilledAmount: {
    type: Number,
    required: true,
    min: 0,
  },
  returnAmount: {
    type: Number,
    min: 0,
  },
});
