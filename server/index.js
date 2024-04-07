const app = require("./app");
const http = require("http");
const { PORT } = require("./config");

// creating server
const server = http.createServer(app);

server.listen(process.env.PORT, () =>
  console.log(`App is running on port:${PORT}`)
);
