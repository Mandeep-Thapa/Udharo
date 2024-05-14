const WebSocekt = require("ws");
require("dotenv").config();

const port = process.env.PORT;

const wss = new WebSocekt.Server({ port });

wss.on("connection", (ws) => {
  console.log("A new webSocket connection has been established");

  ws.on("message", (message) => {
    console.log("Received:", message);
  });

  ws.send("Help from server!");
});
