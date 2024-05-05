const express = require("express");
const router = express.Router();
const { upload } = require("../middleware/multerMiddleware");
const { uploadKyc } = require("../controllers/kycController");
const authenticate = require("../middleware/verification");

router.post(
  "/kycUpload",
  authenticate,
  upload.fields([
    { name: "photo", maxCount: 1 },
    { name: "citizenshipFrontPhoto", maxCount: 1 },
    { name: "citizenshipBackPhoto", maxCount: 1 },
  ]),
  uploadKyc
);

module.exports = router;
