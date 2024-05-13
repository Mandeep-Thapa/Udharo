const app = require("./app");
const http = require("http");
const WebSocket = require("ws");
const { PORT } = require("./config");

// connect to db
require("./dbConnection/dbConnection").connect();

// creating server
const server = http.createServer(app);

// Create WebSocket server
const wss = new WebSocket.Server({ server: server });

wss.on("connection", (ws) => {
  console.log("New Client connected");
  ws.send("Welcome to Udharo Server");

  ws.on("message", function incomig(message) {
    console.log("received: %s", message);
    ws.send(`You sent -> ${message}`);
  });
});

server.listen(PORT, () =>
  console.log(`Udharo Server is running on port:${PORT}`)
);
