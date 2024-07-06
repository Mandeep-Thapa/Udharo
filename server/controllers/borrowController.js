const BorrowRequest = require("../models/borrowRequestModel");
const User = require("../models/registrationModel");
const userMethods = require("../utils/userMethods");
const BorrowFulfillment = require("../models/acceptedBorrowRequestModel");

// create a map to store the cron jobs
const borrowRequestJobs = new Map();

/*
  @desc Create a borrow request
  @routes POST /api/borrow/createBorrowRequest
  @access private
*/
const createBorrowRequest = async (req, res) => {
  const { amount, purpose, interestRate, paybackPeriod } = req.body;

  // check if user is verified or not
  if (!req.user.is_verifiedDetails.is_kycVerified) {
    return res.status(400).json({
      status: "Failed",
      message:
        "Your KYC is not verified. Please verify before creating a borrow request.",
    });
  }

  // Check if the user already has an active transaction
  if (req.user.hasActiveTransaction) {
    return res.status(400).json({
      status: "Failed",
      message:
        "You cannot create a new borrow request while having an active transaction",
    });
  }

  try {
    const borrowRequest = new BorrowRequest({
      borrower: req.user._id,
      fullName: req.user.fullName,
      riskFactor: req.user.riskFactor,
      phoneNumber: req.user.phoneNumber,
      amount,
      purpose,
      interestRate,
      paybackPeriod,
      amountRemaining: amount,
    });

    await borrowRequest.save();

    await User.findByIdAndUpdate(req.user._id, {
      hasActiveTransaction: true,
      userRole: "Borrower",
    });

    // Schedule the job to run 10 minutes after the borrow request is created
    const tenMinutesInMilliseconds = 10 * 60 * 1000;
    const scheduleTime = new Date(Date.now() + tenMinutesInMilliseconds);

    const job = async () => {
      const updateBorrowRequest = await BorrowRequest.findById(
        borrowRequest._id
      );
      if (!updateBorrowRequest.isAccepted) {
        updateBorrowRequest.isLocked = true;
        updateBorrowRequest.status = "expired";
        await updateBorrowRequest.save();

        await User.findByIdAndUpdate(req.user._id, {
          hasActiveTransaction: false,
          userRole: "User",
        });
      }
      console.log(
        "Ten minutes are over for borrow request:",
        borrowRequest._id
      );
    };

    // Using setTimeout instead of cron to schedule a single delayed job
    const timeoutId = setTimeout(job, tenMinutesInMilliseconds);

    // Optionally, store the timeoutId if you need to cancel the job later
    borrowRequestJobs.set(borrowRequest._id.toString(), timeoutId);

    res.status(200).json({
      status: "Success",
      data: {
        borrowRequest,
      },
    });
  } catch (error) {
    res.status(400).json({
      status: "Failed",
      message: error.message,
    });
  }
};

/*
  @desc Get all borrow requests
  @routes GET /api/borrow/getBorrowRequests
  @access private
*/
const browseBorrowRequests = async (req, res) => {
  try {
    // Simplified query to exclude borrow request with status expired or fully funded
    const query = {
      borrower: { $ne: req.user._id },
      status: { $nin: ["expired", "fully funded", "returned"] },
    };

    const borrowRequests = await BorrowRequest.find(query);

    res.status(200).json({
      status: "Success",
      data: {
        borrowRequests,
      },
    });
  } catch (error) {
    res.status(500).json({
      status: "Failed",
      message: error.message,
    });
  }
};

/*
  @desc Accept the Borrow request
  @routes PUT /api/borrow/acceptBorrowRequest/:id
  @access private
*/
const approveBorrowRequest = async (req, res) => {
  try {
    const { amountToBeFulfilled } = req.body;
    const borrowRequest = await BorrowRequest.findOne({ _id: req.params.id });

    if (!borrowRequest) {
      return res
        .status(404)
        .json({ status: "fail", message: "Borrow request not found" });
    }

    if (!req.user.is_verifiedDetails.is_kycVerified) {
      return res.status(400).json({
        status: "Failed",
        message:
          "Your KYC is not verified. Please verify before accepting the borrow request.",
      });
    }
    if (borrowRequest.status === "expired") {
      return res.status(400).json({
        status: "Failed",
        message: "Borrow request has expired and cannot be accepted",
      });
    }

    const minAmount = borrowRequest.amount * 0.2;
    const maxAmount = borrowRequest.amount * 0.4;

    if (amountToBeFulfilled < minAmount || amountToBeFulfilled > maxAmount) {
      return res.status(400).json({
        status: "Failed",
        message:
          "Amount to be fulfilled must be between 20% and 40% of the requested amount",
      });
    }

    if (borrowRequest.numberOfLenders >= 5) {
      borrowRequest.status = "fully funded";
    } else {
      borrowRequest.status = "approved";
    }

    let borrowFulfillment = await BorrowFulfillment.findOne({
      borrowerName: borrowRequest.fullName,
      borrowRequest: borrowRequest._id,
    });

    if (
      borrowFulfillment &&
      borrowFulfillment.lenders.some(
        (lender) => lender.lenderName === req.user.fullName
      )
    ) {
      return res.status(400).json({
        status: "Failed",
        message: "You have already fulfilled this borrow request",
      });
    }

    if (!borrowFulfillment) {
      borrowFulfillment = new BorrowFulfillment({
        borrowRequestStatus: borrowRequest.status,
        borrowerName: borrowRequest.fullName,
        borrowerId: borrowRequest.borrower._id,
        remainingAmount: borrowRequest.amountRemaining - amountToBeFulfilled,
        lenders: [],
        borrowRequest: borrowRequest._id,
      });
    }

    if (borrowFulfillment.lenders.length < 5) {
      borrowFulfillment.lenders.push({
        lenderId: req.user._id,
        lenderName: req.user.fullName,
        fulfilledAmount: amountToBeFulfilled,
        phoneNumber: req.user.phoneNumber,
        returnAmount:
          amountToBeFulfilled +
          (amountToBeFulfilled * (borrowRequest.interestRate + 1)) / 100,
      });
      borrowRequest.numberOfLenders += 1;
      borrowRequest.amountRemaining -= amountToBeFulfilled;
    }

    await borrowRequest.save();
    await borrowFulfillment.save();

    // Update user's money invested and risk factor
    const user = await User.findById(req.user._id);
    user.moneyInvestedDetails += amountToBeFulfilled;
    userMethods.updateMoneyInvested.call(user, user.moneyInvestedDetails);
    userMethods.calculateRiskFactor.call(user);
    await user.save();

    // Remove the timer for the borrow request
    const job = borrowRequestJobs.get(req.params.id.toString());
    if (job) {
      clearTimeout(job);
      borrowRequestJobs.delete(req.params.id.toString());
    }

    res.status(200).json({ status: "success", data: { borrowFulfillment } });
  } catch (error) {
    res.status(400).json({ status: "fail", message: error.message });
  }
};

/*
  @desc Reject borrow request
  @routes PUT /api/borrow/rejectBorrowRequest/:id
  @access private
*/
const rejectBorrowRequest = async (req, res) => {
  // doing same as approveBorrowRequest the difference is only in status
  try {
    const borrowRequest = await BorrowRequest.findById(req.params.id);

    if (!borrowRequest) {
      return res.status(404).json({
        status: "fail",
        message: "Borrow request not found",
      });
    }
    borrowRequest.status = "rejected";
    await borrowRequest.save();
    res.status(200).json({
      status: "success",
      data: {
        borrowRequest,
      },
    });
  } catch (error) {
    res.status(400).json({
      status: "fail",
      message: error.message,
    });
  }
};

/*
  @desc Borrow Request History
  @routes GET /api/borrow/borrowRequestHistory
  @access private
*/
const borrowRequestHistory = async (req, res) => {
  try {
    // Get the user ID from the request user
    const userId = req.user._id;

    // filtering by id and will show all the borrow requests. it does not matter whether they are approved or pending or rejected.
    const borrowRequest = await BorrowRequest.find({
      $or: [{ borrower: userId }, { lender: userId }],
      status: { $in: ["approved", "pending"] },
    });

    if (borrowRequest.length === 0) {
      return res.status(404).json({
        status: "fail",
        message: "Borrow request history does not exist",
      });
    }

    res.json(borrowRequest);
  } catch (error) {
    res.status(500).json({
      status: "Failed",
      message: error.message,
    });
  }
};

/*
  @desc Trasnsaction history based on their role
  @route GET /api/borrow/transactionHistory/:id
  @access private
*/
const getTransactionHistory = async (req, res) => {
  try {
    const userId = req.user._id;
    const userName = req.user.fullName;

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        status: "Failed",
        message: "User not found",
      });
    }

    if (user.userRole === "Lender") {
      const transactions = await BorrowFulfillment.find({
        "lender.lendername": userName,
      });

      const formattedTransactions = transactions.map((transaction) => {
        const lender = transaction.lenders.find(
          (l) => l.lenderName === userName
        );
        return {
          borrowerName: transaction.borrowerName,
          fulfilledAmount: lender ? lender.fulfilledAmount : undefined,
          returnAmount: lender ? lender.returnAmount : undefined,
        };
      });

      res.json({
        status: "Success",
        data: formattedTransactions,
      });
    } else if (user.userRole === "Borrower") {
      const borrowRequests = await BorrowRequest.find({ borrower: userId });

      const formattedBorrowRequests = borrowRequests.map((borrowRequest) => {
        const amountToBeReturned =
          borrowRequest.amount +
          (borrowRequest.amount * (borrowRequest.interestRate + 1)) / 100;

        return {
          amount: borrowRequest.amount,
          interestRate: borrowRequest.interestRate,
          paybackPeriod: borrowRequest.paybackPeriod,
          returnAmount: amountToBeReturned,
        };
      });

      res.json({
        status: "Success",
        data: formattedBorrowRequests,
      });
    } else {
      return res.status(400).json({
        status: "Failed",
        message: "User role is not supported for this operation",
      });
    }
  } catch (error) {
    res.status(500).json({
      status: "Failed",
      error: error.message,
    });
  }
};

/*
  @desc Return money
  @routes PUT /api/borrow/returnMoney/:id
  @access private
*/
const returnMoney = async (req, res) => {
  try {
    const { amountReturned } = req.body;
    const borrowRequestId = req.params.id;
    const userId = req.user._id;

    if (!req.user.is_verifiedDetails.is_kycVerified) {
      return res
        .status(400)
        .json({ status: "Failed", message: "Kyc not verified" });
    }

    const borrowRequest = await BorrowRequest.findById(borrowRequestId);
    if (!borrowRequest) {
      return res
        .status(404)
        .json({ status: "Failed", message: "Borrow request not found" });
    }

    if (!["fully funded"].includes(borrowRequest.status)) {
      return res.status(400).json({
        status: "Failed",
        message: "Borrow request is not fully funded",
      });
    }

    const borrowFulfillment = await BorrowFulfillment.findOne({
      borrowRequestId: borrowRequestId,
    });
    if (!borrowFulfillment) {
      return res
        .status(404)
        .json({ status: "Failed", message: "Borrow fulfillment not found" });
    }

    if (
      amountReturned <= 0 ||
      amountReturned > borrowFulfillment.returnAmount
    ) {
      return res
        .status(400)
        .json({ status: "Failed", message: "Invalid amount returned" });
    }

    const timeDifference = Math.floor(
      (new Date() - borrowRequest.createdAt) / (1000 * 60 * 60)
    );

    const user = await User.findById(userId);
    if (user) {
      user.totalTransactions += 1;
      user.hasActiveTransaction = false;

      if (timeDifference > borrowRequest.paybackPeriod) {
        user.lateRepaymentDetails += 1;
        userMethods.updateLateRepayment.call(user, user.lateRepaymentDetails);
      } else {
        user.timelyRepaymentDetails += 1;
        userMethods.updateTimelyRepayment.call(
          user,
          user.timelyRepaymentDetails
        );
      }

      userMethods.calculateRiskFactor.call(user);
      await user.save();
    }

    borrowRequest.status = "returned";
    await borrowRequest.save();

    res.status(200).json({
      status: "Success",
      message: "Amount returned successfully",
      daysLate:
        timeDifference > borrowRequest.paybackPeriod
          ? timeDifference - borrowRequest.paybackPeriod
          : 0,
    });
  } catch (error) {
    res.status(500).json({ status: "Failed", message: error.message });
  }
};

module.exports = {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
  rejectBorrowRequest,
  borrowRequestHistory,
  returnMoney,
  getTransactionHistory,
};
