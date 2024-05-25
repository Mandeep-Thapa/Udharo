const mongoose = require("mongoose");

const khaltiPaymentSchema = new mongoose.Schema({
  pidx: String,
  total_amount: Number,
  status: String,
  transaction_id: String,
  fee: Number,
  refunded: Boolean,
  paid_at: { type: Date, default: Date.now() },
  //   paidBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  //   paidTo: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
});

const Payment = mongoose.model("Payment", khaltiPaymentSchema);

module.exports = Payment;
