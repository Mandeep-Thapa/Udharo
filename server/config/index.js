require("dotenv").config();

module.exports = {
  PORT: process.env.PORT,
  DB_URL: process.env.DB_URL,
  ACCESS_TOKEN_SECRET: process.env.ACCESS_TOKEN_SECRET,
};
