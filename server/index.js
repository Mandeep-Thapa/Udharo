const app = require("./app");
const http = require("http");
const { PORT } = require("./config");

// connect to db
require("./dbConnection/dbConnection").connect();

// creating server
const server = http.createServer(app);

server.listen(process.env.PORT, () =>
  console.log(`Udharo Server is running on port:${PORT}`)
);
