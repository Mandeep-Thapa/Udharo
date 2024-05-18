const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Admin = require("../models/adminModel");
const User = require("../models/registrationModel");
const Kyc = require("../models/kycModel");
const { updateMoneyInvested } = require("../utils/userMethods");

/*
  @desc Register an admin
  @routes POST /api/admin/register
  @access public
*/
const registerAdmin = asyncHandler(async (req, res) => {
  let { email, password } = req.body;
  email = email.trim();
  password = password.trim();

  if (email == "" || password == "") {
    res.status(400);
    throw new Error("All fields are mandatory");
  } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    res
      .status(400)
      .json({ status: "Failed", message: "Invalid Email Entered" });
  }

  const adminAvailable = await Admin.findOne({ email });
  if (adminAvailable) {
    res.status(400);
    throw new Error("Admin already registered");
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const newAdmin = await Admin.create({
    email,
    password: hashedPassword,
  });

  console.log(`Admin created ${newAdmin}`);
  if (newAdmin) {
    res.status(201).json({ _id: newAdmin._id, email: newAdmin.email });
  } else {
    res.status(400);
    throw new Error("Admin data is not valid");
  }
});

/*
  @desc Login an admin
  @routes POST /api/admin/login
  @access public
*/
const loginAdmin = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    res.status(400);
    throw new Error("Email and password are required");
  }

  const admin = await Admin.findOne({ email });

  if (!admin) {
    res.status(401);
    throw new Error("Invalid email or password");
  }

  const isMatch = await bcrypt.compare(password, admin.password);

  if (!isMatch) {
    res.status(401);
    throw new Error("Invalid email or password");
  }

  const token = jwt.sign(
    { id: admin._id, email: admin.email },
    process.env.ACCESS_TOKEN_SECRET,
    {
      expiresIn: "1h",
    }
  );

  res.status(200).json({ token });
});

/*
  @desc admin details
  @routes POST /api/admin/admindetails
  @access private
*/
const getAdminDetails = asyncHandler(async (req, res) => {
  console.log(req.user.email);
  const adminEmail = req.user.email;

  const admin = await Admin.findOne({ email: adminEmail });

  if (!admin) {
    res.status(404).json({ message: "Admin not found" });
    return;
  }

  res.status(200).json({
    email: admin.email,
  });
});

/*
  @desc Get all users
  @route GET /api/admin/allUsers
  @access Private
*/
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find({}, "fullName email riskFactor");

    res.status(200).json({
      status: "Success",
      message: users,
    });
  } catch (error) {
    res.status(400).json({
      status: "failure",
      message: "Failed to fetch users",
      error,
    });
  }
};

/*
  @desc Get user details
  @route GET /api/admin/userdetails/:id
  @access Private
*/

const getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
console.log(user);
    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    res.json({
      status: "Success",
      data: {
        userName: user.fullName,
        email: user.email,
        isVerified: user.is_verified,
        riskFactor: user.riskFactor,
        riskFactorDetails: user.riskFactorDetails,
        moneyInvestedDetails: user.moneyInvestedDetails,
        timelyRepaymentDetails: user.timelyRepaymentDetails,
        lateRepaymentDetails: user.lateRepaymentDetails,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

/*
  @desc Get KYC details from user
  @route GET /api/admin/kycdetails/:id
  @access Private
*/
const getKycDetailsFromUser = async (req, res) => {
  try {
    const viewKyc = await Kyc.findOne({ userId: req.params.id });

    if (!viewKyc) {
      return res.status(404).json({
        status: "Failed",
        message: "KYC not found",
      });
    }

    res.status(200).json({
      status: "Success",
      messgae: viewKyc,
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: "Failed to get kyc details",
      error: error.message,
    });
  }
};

module.exports = {
  registerAdmin,
  loginAdmin,
  getAdminDetails,
  getUserById,
  getKycDetailsFromUser,
  getAllUsers,
};
