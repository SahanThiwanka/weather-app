const mongoose = require("mongoose");

const ReminderSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  title: { type: String, required: true },
  date: { type: Date, required: true },
});

module.exports = mongoose.model("Reminder", ReminderSchema);
