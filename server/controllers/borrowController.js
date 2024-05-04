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
const browseBorrowRequsts = asyncHandler(async (req, res) => {
  try {
    const borrowRequest = await BorrowRequest.find({ status: "pending" });

    res.status(200).json({
      stauts: "Success",
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

module.exports = { createBorrowRequest, browseBorrowRequsts };
