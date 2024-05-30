const mongoose = require("mongoose");

const borowRequestSchema = new mongoose.Schema({
  borrower: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "User ID is required"],
  },
  lender: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  fullName: {
    type: String,
    required: true,
  },
  riskFactor: {
    type: Number,
    required: [true, "Please specify the risk factor"],
    default: 1,
  },
  amount: {
    type: Number,
    required: [true, "Please specify the amount you want to borrow"],
  },
  purpose: {
    type: String,
    required: [true, "Please specify the purpose of the loan"],
  },
  interestRate: {
    type: Number,
    required: [true, "Please specify the interest rate"],
  },
  paybackPeriod: {
    type: Number,
    required: [true, "Please specify the payback period in days"],
  },
  status: {
    type: String,
    enum: ["pending", "approved", "returned"],
    default: "pending",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const BorrowRequest = mongoose.model("BorrowRequest", borowRequestSchema);

module.exports = BorrowRequest;
