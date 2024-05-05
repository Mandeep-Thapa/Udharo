const cloudinary = require("cloudinary").v2;
const fs = require("fs");

//cloudinary configuration
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const uploadOnCloudinary = async (localFilePath) => {
  try {
    if (!localFilePath) {
      return null;
    }
    // Upload image to cloudinary
    const response = await cloudinary.uploader.upload(localFilePath, {
      resource_type: "auto",
    });
    // file has been uploaded successfully
    console.log("File uploaded successfully");
    console.log("Response is:", response);
    return response;
  } catch (error) {
    fs.unlinkSync(localFilePath); //Remove the locally save temporary file as the upload failed
    return null;
  }
};

module.exports = uploadOnCloudinary;
