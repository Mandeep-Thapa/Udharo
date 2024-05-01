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
    res.status(400);
    throw new Error("All fields are mandatory");
  } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
    res.status(400);
    throw new Error("Invalid Email Entered!");
  }

  //Checking if user already exists
  const userAvailable = await User.findOne({ email });
  if (userAvailable) {
    res.status(400);
    throw new Error("User already registered");
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
    res.status(201).json({ _id: user.id, email: user.email });
  } else {
    res.status(400);
    throw new Error("User data is not valid");
  }
});

/* 
  @desc Login in the registered user
  @route POST /api/user/login
  @access public
*/
const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email }).select("+password");

  console.log("Password is", password);
  console.log("user password is", user.password);
  console.log("Aba if condition ma chirna lagyo");

  // compare password with hashed password
  if (user && (await bcrypt.compare(password, user.password))) {
    const accessToken = jwt.sign(
      {
        user: {
          email: user.email,
          id: user.id,
        },
      },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "15m" }
    );
    res.status(200).json({ accessToken });
  } else {
    res.status(401);
    throw new Error("Email or Password is not valid ");
  }

  // const correctPassword =
  //   user === null ? false : await bcrypt.compare(password, user.password);

  // if (!(user && correctPassword)) {
  //   console.log("If condition run vayo hai");
  //   return res.status(401).json({
  //     error: "Invalid email or password",
  //   });

  //   const userForToken = {
  //     email: user.email,
  //     id: user._id,
  //   };

  //   const token = jwt.sign(userForToken, process.env.ACCESS_TOKEN_SECRET);
  // }
});

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
