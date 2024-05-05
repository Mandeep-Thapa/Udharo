const fs = require("fs");
const path = require("path");
const cloudinary = require("cloudinary");

// Configuration for cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Helper function to create temporaty file on disk
const createTempFile = (fileBuffer, fileName) => {
  const tempFilePath = path.join(__dirname, fileName);
  fs.writeFileSync(tempFilePath, fileBuffer);
  return tempFilePath;
};

// Helper function to upload file to Cloudinary
const uploadToCloudinary = async (filePath, folder, publicId) => {
  const uploadResult = await cloudinary.v2.uploader.upload(filePath, {
    folder: folder,
    public_id: publicId,
  });
  return uploadResult;
};

// Helper function to handle file upload and cleanup
const handleCloudinaryUpload = async (
  fileBuffer,
  fileName,
  folder,
  publicId
) => {
  const tempFilePath = createTempFile(fileBuffer, fileName);
  const uploadFileUrl = await uploadToCloudinary(
    tempFilePath,
    folder,
    publicId
  );
  fs.unlinkSync(tempFilePath, (err) => {
    if (err) {
      console.log(`Error deleting file: ${tempFilePath}`);
    }
  });
  return uploadFileUrl;
};

// For Deleting file from CLoudinary

// Helper function to extract public_id from Cloudinary URL
const getPublicIdFromUrl = (fileUrl) => {
  const publicId = fileUrl.substring(
    fileUrl.lastIndexOf("/") + 1,
    fileUrl.lastIndexOf(".")
  );
  return publicId;
};

// Helper function to delete file from Cloudinary
const deleteFromCloudinary = async (fileUrl) => {
  const publicId = getPublicIdFromUrl(fileUrl);
  const deleteResult = await cloudinary.v2.uploader.destroy(publicId);
  return deleteResult.result === "ok";
};

module.exports = {
  handleCloudinaryUpload,
  deleteFromCloudinary,
};
