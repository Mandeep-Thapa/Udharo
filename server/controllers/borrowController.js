const cron = require("node-cron");
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
  // if (
  //   !req.user.is_verifiedDetails.is_emailVerified ||
  //   !req.user.is_verifiedDetails.is_kycVerified
  // ) {
  //   return res.status(400).json({
  //     status: "Failed",
  //     message:
  //       "Your email and KYC is not verified. Please verify before creating a borrow request.",
  //   });
  // }

  try {
    const borrowRequest = new BorrowRequest({
      borrower: req.user._id,
      fullName: req.user.fullName,
      riskFactor: req.user.riskFactor,
      amount,
      purpose,
      interestRate,
      paybackPeriod,
    });

    await borrowRequest.save();

    await User.findByIdAndUpdate(req.user._id, {
      hasActiveTransaction: true,
      userRole: "Borrower",
    });

    const userId = req.user._id;
    const borrowRequestId = borrowRequest._id;

    const job = () => async () => {
      const updateBorrowRequest = await BorrowRequest.findById(borrowRequestId);
      if (!updateBorrowRequest.isAccepted) {
        updateBorrowRequest.isLocked = true;
        // change the status to expired
        updateBorrowRequest.status = "expired";
        await updateBorrowRequest.save();

        await User.findByIdAndUpdate(userId, {
          hasActiveTransaction: false,
          userRole: "User",
        });
      }
      console.log("Ten minutes are over");
    };

    const scheduledJob = cron.schedule("*/10 * * * *", job(), {
      scheduled: true,
      timezone: "Asia/Kathmandu",
    });

    borrowRequestJobs.set(borrowRequest._id.toString(), scheduledJob);

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
      status: { $nin: ["expired", "fully funded"] },
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
    const borrowRequest = await BorrowRequest.findOne({
      _id: req.params.id,
    });

    if (!borrowRequest) {
      return res.status(404).json({
        status: "fail",
        message: "Borrow request not found",
      });
    }

    if (borrowRequest.status === "expired") {
      return res.status(400).json({
        status: "Failed",
        message: "Borrow request has expired and cannot be accepted",
      });
    }

    const minAmount = borrowRequest.amount * 0.25;
    const maxAmount = borrowRequest.amount * 0.4;

    if (amountToBeFulfilled < minAmount || amountToBeFulfilled > maxAmount) {
      return res.status(400).json({
        status: "Failed",
        message:
          "Amount to be fulfilled must be between 25% and 40% of the requested amount",
      });
    }

    if (borrowRequest.numberOfLenders >= 4) {
      borrowRequest.status = "fully funded";
    } else {
      borrowRequest.status = "approved";
    }

    // Check if the user has already fulfilled the borrow request
    let borrowFulfillment = await BorrowFulfillment.findOne({
      borrowerName: borrowRequest.fullName,
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
        borrowerName: borrowRequest.fullName,
        lenders: [],
      });
    }

    if (borrowFulfillment.lenders.length < 4) {
      borrowFulfillment.lenders.push({
        lenderName: req.user.fullName,
        fulfilledAmount: amountToBeFulfilled,
        returnAmount:
          amountToBeFulfilled +
          (amountToBeFulfilled * (borrowRequest.interestRate + 1)) / 100,
      });
      borrowRequest.numberOfLenders += 1;
    } else {
      console.log("Maximum number of lenders reached");
    }

    await borrowRequest.save();
    await borrowFulfillment.save();

    await User.findByIdAndUpdate(req.user._id, {
      hasActiveTransaction: true,
      userRole: "Lender",
    });

    const job = borrowRequestJobs.get(req.params.id);
    if (job) {
      job.stop();
      borrowRequestJobs.delete(req.params.id);
    }

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
    // finding the borrow request by id
    const borrowRequest = await BorrowRequest.findById(req.params.id);

    // if id not found
    if (!borrowRequest) {
      return res.status(404).json({
        status: "Failed",
        message: "Borrow request not found",
      });
    }

    // if borrow request is not approved
    if (borrowRequest.status !== "approved") {
      return res.status(400).json({
        status: "Failed",
        message: "Borrow request is not approved",
      });
    }

    // retrive the user
    const user = await User.findById(req.user._id);

    // checking if the payback period has expired
    const paybackDedline = new Date(borrowRequest.createdAt);
    paybackDedline.setDate(
      paybackDedline.getDate() + borrowRequest.paybackPeriod
    );

    if (new Date() > paybackDedline) {
      // if the payback period has expired, update the lateRepaymentDetail field
      user.lateRepaymentDetails += 1;
      userMethods.updateLateRepayment.call(user, user.lateRepaymentDetails);
    } else {
      // if the payback period has not expired, update the timelyRepaymentDetail field
      user.timelyRepaymentDetails += 1;
      userMethods.updateTimelyRepayment.call(user, user.timelyRepaymentDetails);
    }

    // Update the user's risk factor
    userMethods.calculateRiskFactor.call(user);

    await user.save();

    borrowRequest.status = "returned";
    await borrowRequest.save();

    // calculate the amount to be returned with interest
    const amountToBeReturned =
      borrowRequest.amount +
      (borrowRequest.amount * (borrowRequest.interestRate + 1)) / 100;

    res.status(200).json({
      status: "Success",
      message: "Money returned successfully",
      amountToBeReturned: amountToBeReturned,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      status: "Failed",
      message: error.message,
    });
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
