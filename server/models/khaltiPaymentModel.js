const mongoose = require("mongoose");

const paymentDetailsSchema = new mongoose.Schema({
  idx: String,
  amount: Number,
  fee_amount: Number,
  created_on: String,
  senderName: String,
  receiverName: String,
});

const KhaltiPayment = mongoose.model("KhaltiPayment", paymentDetailsSchema);

module.exports = KhaltiPayment;
