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
      verificationStatus: {
        type: Number,
        default: 1,
        min: 1,
        max: 5,
      },
      moneyInvested: {
        type: Number,
        default: 1,
        min: 1,
        max: 5,
      },
      timelyRepayment: {
        type: Number,
        default: 1,
        min: 1,
        max: 5,
      },
      lateRepayment: {
        type: Number,
        default: 1,
        min: 1,
        max: 5,
      },
    },
    riskFactor: {
      type: Number,
      default: 1,
    },
    is_verifiedDetails: {
      is_emailVerified: {
        type: Boolean,
        default: false,
      },
      is_kycVerified: {
        type: Boolean,
        default: false,
      },
      is_panVerified: {
        type: Boolean,
        default: false,
      },
    },
    moneyInvestedDetails: {
      type: Number,
      default: 0,
    },
    timelyRepaymentDetails: {
      type: Number,
      default: 0,
    },
    lateRepaymentDetails: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
