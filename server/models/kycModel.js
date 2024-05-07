const mongoose = require("mongoose");
const type = require("mongoose/lib/schema/operators/type");

const kycSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: [true, "Please provide your first name"],
  },
  lastName: {
    type: String,
    required: [true, "Please provide your last name"],
  },
  gender: {
    type: String,
    required: [true, "Please specify your gender"],
  },
  photo: {
    type: String,
    required: [true, "Please provide your photo"],
  },
  citizenshipNumber: {
    type: Number,
    required: [true, "Please provide your citizenship number"],
  },
  citizenshipFrontPhoto: {
    type: String,
    required: [true, "Please provide your citizenship front photo"],
  },
  citizenshipBackPhoto: {
    type: String,
    required: [true, "Please provide your citizenship back photo"],
  },
  panNumber: {
    type: String,
  },
  isKYCVerified: {
    type: Boolean,
    default: false,
  },
});

module.exports = mongoose.model("Kyc", kycSchema);
