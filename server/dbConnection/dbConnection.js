const mongoose = require("mongoose");

const { DB_URL } = require("../config");

exports.connect = () => {
  mongoose.set("strictQuery", true);
  mongoose
    .connect(DB_URL)
    .then((res) =>
      console.log(
        `Database is connected on ${res.connection.host}:${res.connection.port}`
      )
    )
    .catch((error) => {
      console.log(error);
      process.exit(1);
    });
};
