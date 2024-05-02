const jwt = require("jsonwebtoken");
const User = require("../models/registrationModel");

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
      req.user = await User.findById(decoded.id).select("-password");
      next();
    } catch (error) {
      console.log(error);
      res.status(401).json({ message: "Not authorized, token failed" });
    }

    if (!token) {
      res.status(401).json({ message: "Unauthorized token" });
    }
  }
});

module.exports = authenticate;
