const express = require("express");
const {
  registerUser,
  loginUser,
  getUnverifiedUsers,
  allUser,
} = require("../controllers/userController");

const router = express.Router();

router.post("/register", registerUser);

router.post("/login", loginUser);

router.get("/getUnverifiedUsers", getUnverifiedUsers);

router.get("/allUser", allUser);

module.exports = router;
