const mongoose = require("mongoose");

const { Schema } = mongoose;

const userSchema = new Schema(
  {
    fullName: {
      type: String,
      required: [true, "Please provide your full name"],
      unique: true,
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
    riskFactor: {
      type: Number,
      default: 1, //First time users tend to have high risk attached with them
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
