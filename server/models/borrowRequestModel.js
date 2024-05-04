const mongoose = require("mongoose");

const borowRequestSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: [true, "User ID is required"],
  },
  amount: {
    type: Number,
    required: [true, "Please specify the amount you want to borrow"],
  },
  purpose: {
    type: String,
    required: [true, "Please specify the purpose of the loan"],
  },
  status: {
    type: String,
    enum: ["pending", "approved", "rejected"],
    default: "pending",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const BorrowRequest = mongoose.model("BorrowRequest", borowRequestSchema);

module.exports = BorrowRequest;
