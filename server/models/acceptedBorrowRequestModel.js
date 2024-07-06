const mongoose = require("mongoose");

const BorrowFulfillmentSchema = new mongoose.Schema({
  borrowerName: {
    type: String,
  },
  borrowRequestStatus: {
    type: String,
  },
  borrowerId: {
    type: String,
  },
  lenders: [
    {
      lenderId: {
        type: String,
      },
      lenderName: {
        type: String,
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
      phoneNumber: {
        type: Number,
      },
    },
  ],
  borrowRequest: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "BorrowRequest",
    required: true,
  },
});

module.exports = mongoose.model("BorrowFulfillment", BorrowFulfillmentSchema);
