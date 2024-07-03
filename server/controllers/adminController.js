const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Admin = require("../models/adminModel");
const User = require("../models/registrationModel");
const Kyc = require("../models/kycModel");
const BorrowFulfillment = require("../models/acceptedBorrowRequestModel");
const BorrowRequest = require("../models/borrowRequestModel");
const Payment = require("../models/khaltiPaymentModel");
const userMethods = require("../utils/userMethods");

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
        occupation: user.occupation,
        hasActiveTransaction: user.hasActiveTransaction,
        isVerified: {
          email: user.is_verifiedDetails.is_emailVerified,
          kyc: user.is_verifiedDetails.is_kycVerified,
          pan: user.is_verifiedDetails.is_panVerified,
        },
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
  @desc Get unverified user details
  @route GET /api/admin/unverifiedUsers
  @access Private
*/

const getUnverifiedUsers = async (req, res) => {
  try {
    const users = await User.find(
      {
        $or: [
          { "is_verifiedDetails.is_emailVerified": false },
          { "is_verifiedDetails.is_kycVerified": false },
          { "is_verifiedDetails.is_panVerified": false },
        ],
      },
      "fullName email riskFactor"
    );

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
  @desc Get Khalti transaction details
  @route GET /api/admin/transactionDetails/:id
  @access Private
*/

const getTransactionDetails = async (req, res) => {
  try {
    const userId = req.params.id;
    console.log("Fetching transactions for user ID:", userId);

    const transactions = await Payment.find({ paidByName: userId }).select(
      "idx amount fee_amount created_on senderName"
    );

    if (transactions.length === 0) {
      return res.status(404).json({
        status: "Failed",
        message: "Transaction details not found",
      });
    }

    res.status(200).json({
      status: "Success",
      message: transactions,
    });
  } catch (error) {
    console.error("Error fetching transaction details:", error);
    res.status(500).json({
      status: "Failed",
      message: "Failed to get transaction details",
      error: error.message,
    });
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

/*
  @desc Verify KYC details
  @route POST /api/admin/verifykyc/:userId
  @access Private
*/

const verifyKYC = async (req, res) => {
  const { userId } = req.params;

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }
    const kyc = await Kyc.findOne({ userId: userId });
    if (!kyc) {
      return res.status(404).json({
        status: "Failed",
        message: "KYC details not found",
      });
    }
    user.is_verifiedDetails.is_kycVerified =
      !user.is_verifiedDetails.is_kycVerified;

    // calling the updateVerificationStatus method
    userMethods.updateVerificationStatus.call(user, user.is_verifiedDetails);

    // call the calculateRiskFactor
    userMethods.calculateRiskFactor.call(user);
    await user.save();
    return res.status(200).json({
      status: "Success",
      message: user.is_verifiedDetails.is_kycVerified
        ? "KYC verified successfully"
        : "KYC unverified!",
      is_kycVerified: user.is_verifiedDetails.is_kycVerified,
    });
  } catch (error) {
    res.status(500).json({
      status: "Failed",
      message: "Failed to verify KYC",
      error: error.message,
    });
  }
};

/*
  desc Verify Pan number
  @route POST /api/admin/verifyPan/:userId
  @access Private
*/

const verifyPan = async (req, res) => {
  const { userId } = req.params;
  console.log(userId);

  try {
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }

    user.is_verifiedDetails.is_panVerified =
      !user.is_verifiedDetails.is_panVerified;

    // calling the updateVerificationStatus method
    userMethods.updateVerificationStatus.call(user, user.is_verifiedDetails);

    // call the calculateRiskFactor
    userMethods.calculateRiskFactor.call(user);
    await user.save();
    return res.status(200).json({
      status: "Success",
      message: user.is_verifiedDetails.is_panVerified
        ? "PAN verified successfully"
        : "PAN unverified successfully",
      is_panVerified: user.is_verifiedDetails.is_panVerified,
    });
  } catch (error) {
    res.status(500).json({
      status: "Failed",
      message: "Internal server error",
    });
  }
};

/*
@desc Get user role by ID
  @route GET /api/user/role/:id
  @access Public
*/

const getUserRoleById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({
      status: "Success",
      userRole: user.userRole,
    });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

/*
  @desc Get details of approved borrow requests
  @routes GET /api/admin/approvedBorrowRequests/:id
  @access Private
*/
const getApprovedBorrowRequests = async (req, res) => {
  try {
    const borrowRequests = await BorrowRequest.find({ status: "approved" });

    if (!borrowRequests || borrowRequests.length === 0) {
      return res.status(404).json({
        status: "Failed",
        message: "No approved borrow requests found",
      });
    }

    const approvedRequestsData = [];

    for (const borrowRequest of borrowRequests) {
      const borrowFulfillment = await BorrowFulfillment.findOne({
        borrowerName: borrowRequest.fullName,
      });

      if (borrowFulfillment) {
        const lenderDetails = [];

        for (const lender of borrowFulfillment.lenders) {
          const lenderRecord = await User.findOne({ fullName: lender.lenderName });

          if (lenderRecord) {
            lenderDetails.push({
              lenderName: lenderRecord.fullName,
              fulfilledAmount: lender.fulfilledAmount,
              returnAmount: lender.returnAmount,
            });
          } else {
            console.log(`Lender with name ${lender.lenderName} not found`);
          }
        }

        const responseData = {
          borrowRequestId: borrowRequest._id,
          borrowerName: borrowRequest.fullName,
          amountRequested: borrowRequest.amount,
          numberOfLenders: lenderDetails.length,
          lenders: lenderDetails,
        };

        approvedRequestsData.push(responseData);
      } else {
        console.log(`No borrow fulfillment found for borrower ${borrowRequest.fullName}`);
      }
    }

    res.status(200).json({
      status: "Success",
      data: approvedRequestsData,
    });
  } catch (error) {
    console.error(`Failed to fetch approved borrow requests: ${error.message}`);
    res.status(500).json({
      status: "Failed",
      message: "Failed to fetch approved borrow requests",
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
  verifyKYC,
  verifyPan,
  getUnverifiedUsers,
  getTransactionDetails,
  getUserRoleById,
  getApprovedBorrowRequests,
};
