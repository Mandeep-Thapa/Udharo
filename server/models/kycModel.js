const mongoose = require("mongoose");

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
  photo: {},
  citizenshipNumber: {},
  citizenshipFrontPhoto: {},
  citizenshipBackPhoto: {},
  panNumber: {},
});
