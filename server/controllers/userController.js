const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/registrationModel");
require("dotenv").config();

/*
  @desc Register a user
  @routes POST /api/user/register
  @access public
*/
const registerUser = asyncHandler(async (req, res) => {
  let { fullName, email, password } = req.body;

  if (!fullName) {
    res.status(400).json({ message: "Full name is required" });
  }

  if (email == "" || password == "" || fullName == "") {
    res
      .status(400)
      .json({ message: "Email, password and full name  are required" });
  } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    res.status(400).json({ message: "Invalid email address" });
  }

  //Checking if user already exists
  const userAvailable = await User.findOne({ email });
  if (userAvailable) {
    res.status(400).json({ message: "User already exists" });
  }

  //Hash Password
  const hashedPassword = await bcrypt.hash(password, 10);
  console.log("Hashed Password: ", hashedPassword);
  const user = await User.create({
    email,
    password: hashedPassword,
    fullName,
  });

  console.log(`User created ${user}`);
  if (user) {
    res.status(201).json({
      status: "Success",
      data: {
        _id: user.id,
      },
    });
  } else {
    res.status(400).json({
      status: "Failed",
      message: "User data is not valid",
    });
  }
});

/* 
  @desc Login in the registered user
  @route POST /api/user/login
  @access public
*/
const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  // Aba email bata user nikalne
  try {
    const user = await User.findOne({ email }).select("+password");

    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    // compairing unencrypted password with encrypted password from database
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    // Generating jsonwebtoken
    const token = jwt.sign(
      {
        email: user.email,
        userId: user._id,
      },
      process.env.ACCESS_TOKEN_SECRET,
      {
        expiresIn: "60m",
      }
    );

    res.json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

/*
  @desc Get all unverified users user
  @route GET /api/user/unverified
  @access Public
*/
const getUnverifiedUsers = asyncHandler(async (req, res) => {
  res.json("This is the get unverified user controller");
});

/*
  @desc Get current users
  @route GET /api/user/profile
  @access Private
*/
const getUserProfile = asyncHandler(async (req, res) => {
  console.log("User: ", req.user);
  if (!req.user) {
    return res.status(401).json({ message: "Not authorized, token failed" });
  }

  const user = await User.findById(req.user._id);

  if (user) {
    res.json({
      status: "Success",
      data: {
        userName: user.fullName,
        userId: user._id,
        email: user.email,
        isVerified: user.is_verified,
        riskFactor: user.riskFactor,
      },
    });
  } else {
    return res.status(404).json({ message: "User not found" });
  }
});

module.exports = {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  getUserProfile,
};
