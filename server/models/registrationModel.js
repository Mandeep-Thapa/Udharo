const mongoose = require("mongoose");
const userMethods = require("../utils/userMethods");

const { Schema } = mongoose;

const userSchema = new Schema(
  {
    fullName: {
      type: String,
      required: [true, "Please provide your full name"],
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
    occupation: {
      type: String,
      required: [true, "Please specify your occupation"],
      trim: true,
    },
    rewardPoints: {
      type: Number,
      default: 0,
    },
    phoneNumber: {
      type: Number,
      minlength: 10,
      required: [true, "Please provide your phone number"],
      unique: true,
    },
    resetPasswordToken: {
      type: String,
      required: false,
    },
    resetPasswordExpires: {
      type: Date,
      required: false,
    },
    totalTransactions: {
      type: Number,
      default: 0,
    },
    hasActiveTransaction: {
      type: Boolean,
      default: false,
    },
    userRole: {
      type: String,
      default: "User",
      enum: ["User", "Borrower", "Lender"],
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

userSchema.methods = userMethods;

const User = mongoose.model("User", userSchema);

module.exports = User;
