const jwt = require("jsonwebtoken");
const User = require("../models/registrationModel");
const asyncHandler = require("express-async-handler");

// Middleware to authenticate the user
const authenticate = asyncHandler(async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      token = req.headers.authorization.split(" ")[1];
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
      req.user = await User.findById(decoded.userId);

      if (!req.user) {
        return res.status(401).json({ message: "User not found" });
      }

      next();
    } catch (error) {
      console.log(error);
      return res.status(401).json({ message: "Not authorized, token failed" });
    }

    if (!token) {
      return res.status(401).json({ message: "Unauthorized token" });
    }
  }
});

module.exports = authenticate;
