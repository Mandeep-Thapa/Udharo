const asyncHandler = require("express-async-handler");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Admin = require("../models/adminModel");

const registerAdmin = asyncHandler(async (req, res) => {
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

  const adminAvailable = await Admin.findOne({ email });
  if (adminAvailable) {
    res.status(400);
    throw new Error("Admin already registered");
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  console.log("Hashed Password: ", hashedPassword);

  const newAdmin = await Admin.create({
    email,
    password: hashedPassword,
  });

  console.log(`Admin created ${newAdmin}`);
  if (newAdmin) {
    res.status(201).json({ _id: newAdmin._id, email: newAdmin.email });
  } else {
    res.status(400);
    throw new Error("Admin data is not valid");
  }
});

const loginAdmin = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    res.status(400);
    throw new Error("Email and password are required");
  }

  const admin = await Admin.findOne({ email });

  if (!admin) {
    res.status(401);
    throw new Error("Invalid email or password");
  }

  const isMatch = await bcrypt.compare(password, admin.password);

  if (!isMatch) {
    res.status(401);
    throw new Error("Invalid email or password");
  }

  const token = jwt.sign({ id: admin._id }, process.env.JWT_SECRET, {
    expiresIn: "1h",
  });

  res.status(200).json({ token });
});

module.exports = { registerAdmin, loginAdmin };
