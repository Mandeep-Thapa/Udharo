const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/registrationModel");
require("dotenv").config();

/*
  @desc Register a user
  @routes POST /api/user/register
  @access public
*/
const registerUser = asyncHandler(async (req, res) => {
  let { email, password } = req.body;
  email = email.trim();
  password = password.trim();

  if (email == "" || password == "") {
    res.status(400).json({ message: "Email and password are required" });
  } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    res.status(400).json({ message: "Invalid email address" });
  }

  //Checking if user already exists
  const userAvailable = await User.findOne({ email });
  if (userAvailable) {
    res.status(400).json({ message: "User already exists" });
  }

  //Hash Password
  const hashedPassword = await bcrypt.hash(password, 10);
  console.log("Hashed Password: ", hashedPassword);
  const user = await User.create({
    email,
    password: hashedPassword,
  });

  console.log(`User created ${user}`);
  if (user) {
    res
      .status(201)
      .json({ _id: user.id, email: user.email, password: user.password });
  } else {
    res.status(400).json({ message: "User data is not valid" });
  }
});

/* 
  @desc Login in the registered user
  @route POST /api/user/login
  @access public
*/
const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email }).select("+password");

    if (!user) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    console.log("Is Password Valid: ", isPasswordValid);

    if (!isPasswordValid) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    const token = jwt.sign(
      { userId: user._id },
      "placeholder aile ko lagi config ma replace garne pachi",
      {
        expiresIn: "1h",
      }
    );

    res.json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});
/*
const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email }).select("+password");

  if (!user) {
    return res.status(401).json({ message: "Invalid email or password" });
  }

  const trimmedPassword = password.trim();
  console.log("User: ", trimmedPassword);

  console.log("Encrpyted passowrd is", user.password);

  const hashedPassword = user.password;
  const validPassword = await bcrypt.compare(trimmedPassword, hashedPassword);
  console.log("Valid Password: ", validPassword);

  if (!validPassword) {
    return res.status(401).json({ message: "Invalid email or password" });
  }

  // If the password is correct then
  const userForToken = {
    email: user.email,
    id: user._id,
  };

  const token = jwt.sign(userForToken, process.env.JWT_SECRET);

  res.json({ token, email: user.email, id: user._id });
});
*/

/*
  @desc Get all unverified users user
  @route GET /api/user/unverified
  @access Public
*/
const getUnverifiedUsers = asyncHandler(async (req, res) => {
  res.json("This is the get unverified user controller");
});

/*
  @desc Get all users
  @route GET /api/user/allUsers
  @access Public
*/
const allUser = asyncHandler(async (req, res) => {
  res.json("This is the get all user api");
});

module.exports = { registerUser, loginUser, getUnverifiedUsers, allUser };
