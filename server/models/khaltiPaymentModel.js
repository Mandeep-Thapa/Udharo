const mongoose = require("mongoose");

const khaltiPaymentDetails = new mongoose.Schema({
  idx: String,
  amount: Number,
  mobile: String,
  product_identity: String,
  product_name: String,
  product_url: String,
  token: String,
});

module.exports = khaltiPaymentDetails;
