const mongoose = require("mongoose");
const type = require("mongoose/lib/schema/operators/type");

const { Schema } = mongoose;

const userSchema = new Schema(
  {
    fullName: {
      type: String,
      required: [true, "Please provide your full name"],
      unique: false,
      trim: true,
    },
    email: {
      type: String,
      lowercase: true,
      required: [true, "Please enter your email address"],
      unique: true,
      trim: true,
    },
    password: {
      type: String,
      required: [true, "Please provide a password"],
      minlength: [8, "Password must be atleast 8 characters long"],
      select: false,
    },
    riskFactorDetails: {
      verificationStatus: { type: Number, min: 1, max: 5, default: 1 },
      moneyInvested: { type: Number, default: 1, min: 1, max: 5 },
      timelyRepayment: { type: Number, default: 1, min: 1, max: 5 },
      lateRepayment: { type: Number, default: 1, min: 1, max: 5 },
    },
    riskFactor: {
      type: Number,
      default: 1,
    },
    is_verified: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
