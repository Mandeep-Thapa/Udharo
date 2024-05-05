const asyncHandler = require("express-async-handler");
const multer = require("multer");
const cloudinary = require("cloudinary").v2;
const { CloudinaryStorage } = require("multer-storage-cloudinary");
const KYC = require("../models/kycModel");

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "kyc",
    format: async (req, file) => "png",
    public_id: (req, file) => file.fieldname,
  },
});

const upload = multer({ storage: storage });

/*
    @desc Upload KYC
    @route POST /api/kyc/upload
    @access Private
*/

const uploadKYC = asyncHandler(async (req, res) => {
  console.log("file upload fucntion call vayo ");
  await upload.fields([
    { name: "photo", maxCount: 1 },
    { name: "citizenshipFrontPhoto", maxCount: 1 },
    { name: "citizenshipBackPhoto", maxCount: 1 },
  ])(req, res, async function (err) {
    if (err instanceof multer.MulterError) {
      return res.status(400).json({ message: err.message });
    } else if (err) {
      return res.status(500).json({ message: err.message });
    }
    console.log(req.files);

    // Check if files were uploaded
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ message: "No files have been uploaded" });
    }

    const user = new KYC({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      gender: req.body.gender,
      photo: req.files.photo[0].path,
      citizenshipNumber: req.body.citizenshipNumber,
      citizenshipFrontPhoto: req.files.citizenshipFrontPhoto[0].path,
      citizenshipBackPhoto: req.files.citizenshipBackPhoto[0].path,
      panNumber: req.body.panNumber,
    });

    await user.save();
    res.status(201).json({
      status: "Success",
      message: "KYC uploaded successfully",
      data: user,
    });
  });
});

module.exports = { uploadKYC };
