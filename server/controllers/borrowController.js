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
      borrower: req.user._id,
      fullName: req.user.fullName,
      amount,
      purpose,
      interestRate,
      paybackPeriod,
    });

    await borrowRequest.save();

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
});

/*
  @desc Get all borrow requests
  @routes GET /api/borrow/getBorrowRequests
  @access private
*/
const browseBorrowRequests = async (req, res) => {
  try {
    const userBorrowRequest = await BorrowRequest.findOne({
      borrower: req.user._id,
    });

    if (userBorrowRequest) {
      const borrowRequests = await BorrowRequest.find({
        borrower: { $ne: req.user._id },
      });

      return res.status(200).json({
        status: "Success",
        data: {
          borrowRequests,
        },
      });
    }

    const borrowRequests = await BorrowRequest.find({ stauts: "pending" });

    res.status(200).json({
      stuatus: "Success",
      data: {
        borrowRequests,
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
});

module.exports = {
  createBorrowRequest,
  browseBorrowRequests,
  approveBorrowRequest,
  rejectBorrowRequest,
  borrowRequestHistory,
};
