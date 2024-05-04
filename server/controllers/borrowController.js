const BorrowRequest = require("../models/borrowRequestModel");
const asyncHandler = require("express-async-handler");

/*
  @desc Create a borrow request
  @routes POST /api/borrow/createBorrowRequest
  @access private
*/
const createBorrowRequest = asyncHandler(async (req, res) => {
  // declaring the variables which will be sent in the request body
  const { amount, purpose, interestRate, paybackPeriod } = req.body;

  try {
    const borrowRequest = new BorrowRequest({
      userId: req.user._id,
      amount,
      purpose,
      interestRate,
      paybackPeriod,
    });

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
});

/*
  @desc Get all borrow requests
  @routes GET /api/borrow/getBorrowRequests
  @access private
*/
const browseBorrowRequests = asyncHandler(async (req, res) => {
  try {
    // checking if the user has already created a borrow request
    const userBorrowRequest = await BorrowRequest.findOne({
      userId: req.user._id,
    });

    if (userBorrowRequest) {
      return res.status(403).json({
        status: "fail",
        message:
          "User who creates a borrow request cannot browse borrow requests",
      });
    }

    // if not then checking all the borrow request with stauts pending
    const borrowRequests = await BorrowRequest.find({
      status: "pending",
      userId: { $ne: req.user._id },
    });

    res.status(200).json({
      status: "Success",
      data: {
        borrowRequests,
      },
    });
  } catch (error) {
    res.status(400).json({
      status: "fail",
      message: error.message,
    });
  }
});

/*
  @desc Accept the Borrow request
  @routes PUT /api/borrow/acceptBorrowRequest/:id
  @access private
*/
const approveBorrowRequest = asyncHandler(async (req, res) => {
  try {
    // finding the borrow request by id
    const borrowRequest = await BorrowRequest.findById(req.params.id);

    // if id not found
    if (!borrowRequest) {
      return res.status(404).json({
        status: "fail",
        message: "Borrow request not found",
      });
    }

    borrowRequest.status = "approved";
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
});

/*
  @desc Reject borrow request
  @routes PUT /api/borrow/rejectBorrowRequest/:id
  @access private
*/
const rejectBorrowRequest = asyncHandler(async (req, res) => {
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
});
/*
  @desc Borrow Request History
  @routes GET /api/borrow/borrowRequestHistory
  @access private
*/
const borrowRequestHistory = asyncHandler(async (req, res) => {
  try {
    const userId = req.params.userId;
    const borrowRequest = await BorrowRequest.find({
      $or: [{ borrower: userId }, { lender: userId }],
      status: { $in: ["approved", "rejected", "pending"] },
    });
    res.json(borrowRequest);
  } catch (error) {
    re.status(500).json({
      status: "Failed",
      message: error.message,
    });
  }
});

module.exports = {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
  rejectBorrowRequest,
  borrowRequestHistory,
};
