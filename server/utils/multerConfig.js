const multer = require("multer");
const { CreateError } = require("./createError");

// Create multer storage configuration
const multerStorage = multer.memoryStorage();

// Multer filter for filtering only images
const multerFilter = (req, file, cb) => {
  if (file.mimetype.startsWith("image")) {
    cb(null, true);
  } else {
    cb(CreateError("Please upload only images", 400), false);
  }
};

// upload for multer
const upload = multer({
  storage: multerStorage,
  fileFilter: multerFilter,
});

module.exports = upload;
