const express = require("express");
const {
  createReminder,
  getReminders,
  updateReminder,
  deleteReminder,
} = require("../controllers/reminderController");
const authMiddleware = require("../middlewares/authMiddleware");
const router = express.Router();

router.use(authMiddleware); // Protect all routes
router.post("/", createReminder);
router.get("/", getReminders);
router.put("/:id", updateReminder);
router.delete("/:id", deleteReminder);

module.exports = router;
