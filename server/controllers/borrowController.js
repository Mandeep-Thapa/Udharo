const BorrowRequest = require("../models/borrowRequestModel");
const asyncHandler = require("express-async-handler");

/*
  @desc Create a borrow request
  @routes POST /api/borrow/createBorrowRequest
  @access private
*/
const createBorrowRequest = asyncHandler(async (req, res) => {
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
    const borrowRequest = await BorrowRequest.findById(req.params.id);

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

module.exports = {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
};
