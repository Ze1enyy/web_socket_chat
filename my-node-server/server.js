const WebSocket = require("ws");
const express = require("express");
const http = require("http");
const jwt = require("jsonwebtoken");
const cors = require("cors");
const crypto = require("crypto");

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

const JWT_SECRET = crypto.randomBytes(64).toString("hex");
const clients = new Map();
const messageHistory = [];
const MAX_MESSAGES = 50;

app.use(cors());
app.use(express.json());

app.post("/login", (req, res) => {
  const { username } = req.body;

  if (!username) {
    return res.status(400).json({
      success: false,
      message: "Username is required",
    });
  }

  const token = jwt.sign({ username }, JWT_SECRET);
  res.json({ success: true, token });
});

// WebSocket connection handler
wss.on("connection", (ws) => {
  let username = null;

  ws.on("message", (message) => {
    try {
      const data = JSON.parse(message);

      if (data.type === "auth") {
        handleAuthentication(ws, data.token);
        return;
      }

      if (!username) {
        sendError(ws, "Not authenticated");
        return;
      }

      if (data.type === "message") {
        broadcastMessage(username, data.message);
      }
    } catch (e) {
      console.error("Error processing message:", e);
    }
  });

  ws.on("close", () => {
    if (username) {
      clients.delete(username);
    }
  });

  // Helper functions for WebSocket operations
  function handleAuthentication(ws, token) {
    try {
      const decoded = jwt.verify(token, JWT_SECRET);
      username = decoded.username;
      clients.set(username, ws);

      sendMessageHistory(ws);
      sendAuthSuccess(ws);
    } catch (e) {
      sendAuthError(ws);
    }
  }

  function sendMessageHistory(ws) {
    ws.send(
      JSON.stringify({
        type: "history",
        messages: messageHistory,
      })
    );
  }

  function sendAuthSuccess(ws) {
    ws.send(
      JSON.stringify({
        type: "auth",
        success: true,
        message: "Authenticated successfully",
      })
    );
  }

  function sendAuthError(ws) {
    ws.send(
      JSON.stringify({
        type: "auth",
        success: false,
        message: "Invalid token",
      })
    );
  }

  function sendError(ws, message) {
    ws.send(
      JSON.stringify({
        type: "error",
        message,
      })
    );
  }

  function broadcastMessage(username, message) {
    const messageData = {
      type: "message",
      username,
      message,
      timestamp: new Date().toISOString(),
    };

    messageHistory.push(messageData);
    if (messageHistory.length > MAX_MESSAGES) {
      messageHistory.shift();
    }

    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(messageData));
      }
    });
  }
});

const PORT = 3001;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`WebSocket server is ready`);
});
