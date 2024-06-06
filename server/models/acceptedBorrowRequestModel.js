const mongoose = require("mongoose");

const BorrowFulfillmentSchema = new mongoose.Schema({
  borrowerName: {
    type: String,
  },
  lenders: [
    {
      lenderName: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
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
    },
  ],
});

module.exports = mongoose.model("BorrowFulfillment", BorrowFulfillmentSchema);
