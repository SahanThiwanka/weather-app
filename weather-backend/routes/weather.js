const express = require("express");
const { getWeather, getWeatherByLocation, getWeatherForecast } = require("../controllers/weatherController");
const router = express.Router();

// Define /location route first
router.get("/location", getWeatherByLocation);

// Define /:city route next
router.get("/:city", getWeather);

// Define /forecast/:city route
router.get("/forecast/:city", getWeatherForecast);

module.exports = router;
