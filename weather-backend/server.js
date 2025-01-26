require("dotenv").config();
const express = require("express");
const connectDB = require("./config/db");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.use("/auth", require("./routes/auth"));
app.use("/reminders", require("./routes/reminders"));
app.use("/weather", require("./routes/weather"));

// Connect to MongoDB
connectDB();

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
