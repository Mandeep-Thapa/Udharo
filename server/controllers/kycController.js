const Kyc = require("../models/kycModel");
const uploadOnCloudinary = require("../utils/cloudinary");

/*
  @desc Upload KYC
  @rotues POST /api/kyc/upload
  @access private
*/
const uploadKyc = async (req, res) => {
  try {
    const photoResponse = await uploadOnCloudinary(req.files.photo[0].path);
    const citizenshipFrontPhotoResponse = await uploadOnCloudinary(
      req.files.citizenshipFrontPhoto[0].path
    );
    const citizenshipBackPhotoResponse = await uploadOnCloudinary(
      req.files.citizenshipBackPhoto[0].path
    );

    if (
      photoResponse &&
      citizenshipFrontPhotoResponse &&
      citizenshipBackPhotoResponse
    ) {
      const kyc = new Kyc({
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        gender: req.body.gender,
        photo: photoResponse.secure_url,
        citizenshipNumber: req.body.citizenshipNumber,
        citizenshipFrontPhoto: citizenshipFrontPhotoResponse.secure_url,
        citizenshipBackPhoto: citizenshipBackPhotoResponse.secure_url,
        panNumber: req.body.panNumber,
      });

      const savedKyc = await kyc.save();

      res.status(201).json({
        message: "KYC uploaded successfully",
        data: savedKyc,
      });
    } else {
      res.status(500).json({
        message: "Failed to upload KYC",
        error: error.message,
      });
    }
  } catch (error) {
    res.status(500).json({
      message: "Failed to upload KYC",
      error: error.message,
    });
  }
};

module.exports = { uploadKyc };
