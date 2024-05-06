const jwt = require("jsonwebtoken");
const asyncHandler = require("express-async-handler");
const Admin = require("../models/adminModel");

// Admin protect middleware
const authenticateAdmin = asyncHandler(async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      token = req.headers.authorization.split(" ")[1];
      console.log(token);
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
      console.log(decoded);

      req.user = await Admin.findOne({ email: decoded.email });

      if (!req.user) {
        return res.status(401).json({ message: "Admin not found" });
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

module.exports = authenticateAdmin;
