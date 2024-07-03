const express = require("express");
const router = express.Router();
const cors = require("cors");
router.use(cors());
const {
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
  userRole,
  lenderRole,
  borrowerRole,
} = require("../controllers/adminController");
const authenticate = require("../middleware/adminVerification");

router.post("/register", registerAdmin);

router.post("/login", loginAdmin);

router.get("/admindetails", authenticate, getAdminDetails);

router.get("/allUsers", authenticate, getAllUsers);

router.get("/userdetails/:id", authenticate, getUserById);

router.get("/kycDetails/:id", authenticate, getKycDetailsFromUser);

router.put("/verifyKYC/:userId", authenticate, verifyKYC);

router.put("/verifyPan/:userId", authenticate, verifyPan);

router.get("/unverifiedUsers", authenticate, getUnverifiedUsers);

router.get("/transactionDetails/:id", authenticate, getTransactionDetails);

router.get("/role/:id", authenticate, getUserRoleById);

router.get("/userRole", authenticate, userRole);

router.get("/lenderRole", authenticate, lenderRole);

router.get("/borrowerRole", authenticate, borrowerRole);

router.get(
  "/approvedBorrowRequests",
  authenticate,
  getApprovedBorrowRequests
);

module.exports = router;
