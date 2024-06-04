const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const User = require("../models/registrationModel");
const axios = require("axios");
const userMethods = require("../utils/userMethods");

const KhaltiPayment = require("../models/khaltiPaymentModel");
require("dotenv").config();

/*
  @desc Register a user
  @routes POST /api/user/register
  @access public
*/
const registerUser = async (req, res) => {
  const { fullName, email, password, occupation } = req.body;

  try {
    // checking if full name is empty
    if (!fullName) {
      return res.stauts(400).json({
        status: "Failed",
        message: "Full name is required",
      });
    }

    // checking if occupation is empty
    if (!occupation) {
      return res.status(400).json({
        status: "Failed",
        message: "Occupation is required",
      });
    }

    if (email == "" || password == "" || fullName == "" || occupation == "") {
      return res.status(400).json({
        status: "Failed",
        message: "Eamil, password, full name and occupation are required",
      });
    } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
      return res.status(400).json({
        status: "Failed",
        message: "Invalid email address",
      });
    }

    // checking if user already exists
    const userAvailable = await User.findOne({ email });
    if (userAvailable) {
      return res.status(400).json({
        status: "Failed",
        message: "User with the same email address already exists",
      });
    }

    // Hashing password
    const hashedPassword = await bcrypt.hash(password, 10);
    console.log("Hashed password:", hashedPassword);

    // creating new user
    const user = await User.create({
      email,
      password: hashedPassword,
      fullName,
      occupation,
    });

    console.log(`User created: ${user}`);

    if (user) {
      res.status(200).json({
        stauts: "Success",
        data: {
          _id: user.id,
        },
      });
    } else {
      res.stauts(400).json({
        status: "Failed",
        message: "User data is not valid",
      });
    }
  } catch (error) {
    console.log(error);
    res.stauts(500).json({
      status: "Failed",
      message: "Error in registering user",
      error: error.message,
    });
  }
};

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
    // update the verification status to 2
    user.riskFactorDetails.verificationStatus = 2;

    // using the userMethods to update the risk factor
    userMethods.updateVerificationStatus.call(user, user.is_verifiedDetails);
    userMethods.calculateRiskFactor.call(user);

    console.log("User updated to verified:", user);

    await user.save();
    console.log("User updated to verified:", user);

    res.status(200).json({ message: "Email verified successfully" });
  } catch (error) {
    console.error("Error verifying email:", error);

    if (error.response && error.response.includes("5.1.1")) {
      return res.status(400).json({ message: "Email address does not exist" });
    }

    res.status(500).json({ message: "Internal server error" });
  }
};

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
        hasActiveTransaction: user.hasActiveTransaction,
        riskFactor: user.riskFactor,
        totalMoneyInvested: user.totalMoneyInvested,
        successfulRepayment: user.successfulRepayment,
        lateRepayment: user.lateRepayment,
        moneyInvestedDetails: user.moneyInvestedDetails,
      },
    });
  } else {
    return res.status(404).json({ message: "User not found" });
  }
});

/*
  @desc Post Khalti payment details
  @route POST /api/user/khaltiPaymentInitialization
  @access private
*/
// const khaltiPaymentInitialization = async (req, res) => {
//   try {
//     const payload = req.body;

//     const khaltiResponse = await axios.post(
//       "https://a.khalti.com/api/v2/epayment/initiate/",
//       payload,
//       {
//         headers: {
//           Accept: "application/json, text/plain, */*",
//           "Content-Type": "application/json",
//           Authorization: `Key ${process.env.KHALTI_SECRET_KEY}`,
//           "User-Agemt": "axios/1.6.8",
//           "Content-Length": "519",
//           "Accept-Encoding": "gzip,compress, deflate, br ",
//         },
//       }
//     );

//     console.log(khaltiResponse.data);

//     res.status(200).json({
//       status: "Success",
//       message: "Khalti payment details retrived successfully",
//       data: khaltiResponse.data,
//     });
//   } catch (error) {
//     res.status(400).json({
//       status: "Failed",
//       message: "Error in khalti payment details",
//       error: error.message,
//     });
//     console.log(error);
//   }
// };

/*
  @desc Khalti payment verification
  @route POST /api/user/khaltiPaymentVerification
  @access private
*/
const paymentVerification = async (req, res) => {
  try {
    const { token, amount } = req.body;

    const data = {
      token,
      amount,
    };

    const config = {
      headers: {
        Authorization: `Key ${process.env.KHALTI_TEST_SECRET_KEY}`,
      },
    };

    const khaltiResponse = await axios.post(
      "https://khalti.com/api/v2/payment/verify/",
      data,
      config
    );

    console.log(khaltiResponse.data);

    res.status(200).json({
      status: "Success",
      message: "Khalti payment details verified successfully",
      data: khaltiResponse.data,
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({
      status: "Failed",
      message: "Error in verifying khalti payment details",
      error: error.message,
    });
  }
};

/*
  @desc Save Khalti payment after verification
  @route POST /api/user/saveKhaltiPayment
  @access Private
*/
const savePayment = async (req, res) => {
  try {
    const { idx, amount, fee_amount, created_on, senderName, receiverName } =
      req.body;
    const paidById = req.user._id;

    // check if a payment with the same idx already exists
    const existingPayment = await KhaltiPayment.findOne({ idx: idx });
    if (existingPayment) {
      return res.status(400).json({
        status: "Failed",
        message: "Payment with the same idx already exists",
      });
    }

    // Saving the payment details
    const payment = new KhaltiPayment({
      idx,
      amount,
      fee_amount,
      created_on,
      senderName,
      receiverName,
    });

    console.log("Payment: ", payment);

    await payment.save();

    // update user's moneyInvestedDetail
    await User.findOneAndUpdate(
      {
        _id: paidById,
      },
      { $inc: { moneyInvestedDetails: amount } },
      { new: true, userFindAndModify: false }
    );

    res.status(200).json({
      status: "Success",
      message: "Khalti Payment Saved Successfully",
      data: { payment },
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: "Error in saving the transaction details",
      error: error.message,
    });
  }
};

module.exports = {
  registerUser,
  loginUser,
  getUserProfile,
  sendVerificationEmail,
  verifyEmail,
  paymentVerification,
  savePayment,
};
