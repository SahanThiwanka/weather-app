const Reminder = require("../models/Reminder");

// Create a new reminder
const createReminder = async (req, res) => {
  try {
    const { title, date } = req.body;
    const newReminder = await Reminder.create({
      userId: req.user.id,
      title,
      date,
    });
    res.status(201).json(newReminder);
  } catch (error) {
    res.status(500).json({ error: "Failed to create reminder" });
  }
};

// Get all reminders for a user
const getReminders = async (req, res) => {
  try {
    const reminders = await Reminder.find({ userId: req.user.id });
    res.json(reminders);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch reminders" });
  }
};

// Update a reminder
const updateReminder = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedReminder = await Reminder.findByIdAndUpdate(
      id,
      { ...req.body },
      { new: true }
    );

    if (!updatedReminder) {
      return res.status(404).json({ error: "Reminder not found" });
    }

    res.json(updatedReminder);
  } catch (error) {
    console.error("Error updating reminder:", error);
    res.status(500).json({ error: "Failed to update reminder" });
  }
};

// Delete a reminder
const deleteReminder = async (req, res) => {
  try {
    const { id } = req.params;
    await Reminder.findByIdAndDelete(id);
    res.json({ message: "Reminder deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete reminder" });
  }
};

module.exports = {
  createReminder,
  getReminders,
  updateReminder,
  deleteReminder,
};
