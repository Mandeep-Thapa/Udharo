const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const User = require("../models/registrationModel");
const axios = require("axios");
const Payment = require("../models/khaltiPaymentModel");
require("dotenv").config();

/*
  @desc Register a user
  @routes POST /api/user/register
  @access public
*/
const registerUser = asyncHandler(async (req, res) => {
  let { fullName, email, password, occupation } = req.body;

  if (!fullName) {
    res.status(400).json({ message: "Full name is required" });
  }

  if (email == "" || password == "" || fullName == "" || occupation == "") {
    res.status(400).json({
      message: "Email, password, full name and occupations  are required",
    });
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
    occupation,
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
const loginUser = async (req, res) => {
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
};

/*  
  @desc Send verification email
  @route POST /api/user/sendVerificationEmail
  @access Public
*/

const sendVerificationEmail = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const token = jwt.sign(
      { email: user.email, userId: user._id },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "2h" }
    );

    const mailOptions = {
      from: process.env.EMAIL,
      to: email,
      subject: "Account Verification",
      html: `<h2>Click on the link below to verify your account</h2>
<p>${process.env.BACKEND_URL}/api/user/verify-email/${token}</p>`,
    };

    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL,
        pass: process.env.PASSWORD,
      },
    });

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Verification email sent successfully" });
  } catch (error) {
    console.error("Error sending verification email:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const verifyEmail = async (req, res) => {
  try {
    console.log("Request params:", req.params);

    let { token } = req.params;
    console.log("Token received:", token);
    token = token.trim();
    if (!token) {
      return res.status(400).json({ message: "Invalid token" });
    }

    const decodedToken = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    console.log("Decoded token:", decodedToken);

    const { userId } = decodedToken;
    console.log("User ID from token:", userId);

    const user = await User.findById(userId);
    console.log("User found:", user);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.is_emailVerified) {
      console.log("Email already verified");
      return res.status(400).json({ message: "Email already verified" });
    }

    user.is_verifiedDetails.is_emailVerified = true;
    await user.save();
    console.log("User updated to verified:", user);

    res.status(200).json({ message: "Email verified successfully" });
  } catch (error) {
    console.error("Error verifying email:", error);
    res.status(500).json({ message: "Internal server error" });
  }
};

/*
@desc pan verficication
@route POST /api/user/panVerification
@access private
*/
const panVerification = asyncHandler(async (req, res) => {
  try {
    const { panNumber } = req.body;

    const panPattern = /^[A-Z]{5}[0-9]{4}[A-Z]{1}$/;
    if (!panPattern.test(panNumber)) {
      return res.status(400).json({ message: "Invalid PAN format" });
    }

    const user = await User.findById(req.user._id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.is_verifiedDetails.is_panVerified) {
      return res.status(400).json({ message: "PAN already verified" });
    }

    user.is_verifiedDetails.is_panVerified = true;
    await user.save();

    res.status(200).json({ message: "PAN verified successfully" });
  } catch (error) {
    console.error("Error verifying PAN:", error);
    res.status(500).json({ message: "Internal server error" });
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
        isVerified: user.is_verifiedDetails,
        riskFactor: user.riskFactor,
        totalMoneyInvested: user.totalMoneyInvested,
        successfulRepayment: user.successfulRepayment,
        lateRepayment: user.lateRepayment,
      },
    });
  } else {
    return res.status(404).json({ message: "User not found" });
  }
});

/*
  @desc Post Khalti payment details
  @route POST /api/user/khaltiDetails
  @access private
*/
const khaltiPaymentDetails = async (req, res) => {
  try {
    const payload = req.body;

    const khaltiResponse = await axios.post(
      "https://a.khalti.com/api/v2/epayment/initiate/",
      payload,
      {
        headers: {
          Accept: "application/json, text/plain, */*",
          "Content-Type": "application/json",
          Authorization: `Key ${process.env.KHALTI_SECRET_KEY}`,
          "User-Agemt": "axios/1.6.8",
          "Content-Length": "519",
          "Accept-Encoding": "gzip,compress, deflate, br ",
        },
      }
    );

    console.log(khaltiResponse.data);

    res.status(200).json({
      status: "Success",
      message: "Khalti payment details retrived successfully",
      data: khaltiResponse.data,
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: "Error in khalti payment details",
      error: error.message,
    });
    console.log(error);
  }
};

/*
  @desc Khalti payment verification
  @route POST /api/user/khaltiPaymentVerification
  @access private
*/
const paymentVerification = async (req, res) => {
  try {
    const pidx = req.body;

    const khaltiResponse = await axios.post(
      "https://a.khalti.com/api/v2/epayment/lookup/",
      pidx,
      {
        headers: {
          Accept: "application/json, text/plain, */*",
          "Content-Type": "application/json",
          Authorization: `Key ${process.env.KHALTI_SECRET_KEY}`,
        },
      }
    );

    console.log(khaltiResponse.data);

    res.status(200).json({
      status: "Success",
      message: "Khalti payment verification successful",
      data: khaltiResponse.data,
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: "Error in khalti payment verification",
      error: error.message,
    });
    console.log(error);
  }
};

/*
  @desc Save Khalti payment after verification
  @route POST /api/user/saveKhaltiPayment
  @access Private
*/
const savePayment = async (req, res) => {
  try {
    const { pidx, total_amount, status, transaction_id, fee, refunded } =
      req.body;
    // const paidById=req.user._id,
    // const paidToId=...,

    const payment = new Payment({
      pidx,
      total_amount,
      status,
      transaction_id,
      fee,
      refunded,
    });

    await payment.save();

    res.status(200).json({
      status: "Success",
      message: "Khalti payment details saved successfully",
      data: { payment },
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: "Error in saving khalti payment details",
      error: error.message,
    });
  }
};

module.exports = {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  getUserProfile,
  khaltiPaymentDetails,
  sendVerificationEmail,
  verifyEmail,
  paymentVerification,
  panVerification,
  savePayment,
};
