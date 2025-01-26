const axios = require("axios");

// Helper function to handle API requests
const fetchWeatherData = async (url) => {
  try {
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    console.error(`Error fetching data from ${url}:`, error.message);
    throw new Error("Failed to fetch weather data.");
  }
};

// Fetch weather by city name
const getWeather = async (req, res) => {
  const city = req.params.city;
  const apiKey = process.env.WEATHER_API_KEY;

  try {
    const data = await fetchWeatherData(
      `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric`
    );

    const { name, main, weather, wind } = data;

    res.json({
      city: name,
      temperature: main?.temp,
      description: weather?.[0]?.description,
      humidity: main?.humidity,
      windSpeed: wind?.speed,
      icon: weather[0].icon, 
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch weather by city." });
  }
};

// Fetch weather by latitude and longitude
const getWeatherByLocation = async (req, res) => {
  const { lat, lon } = req.query;
  const apiKey = process.env.WEATHER_API_KEY;

  try {
    const data = await fetchWeatherData(
      `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric`
    );

    const { main, weather, wind, sys, visibility } = data;

    res.json({
      temperature: main?.temp,
      feelsLike: main?.feels_like,
      description: weather?.[0]?.description,
      icon: weather?.[0]?.icon,
      humidity: main?.humidity,
      windSpeed: wind?.speed,
      windDirection: wind?.deg,
      pressure: main?.pressure,
      visibility: visibility,
      sunrise: sys?.sunrise
        ? new Date(sys.sunrise * 1000).toLocaleTimeString("en-US", {
            hour: "2-digit",
            minute: "2-digit",
          })
        : "N/A",
      sunset: sys?.sunset
        ? new Date(sys.sunset * 1000).toLocaleTimeString("en-US", {
            hour: "2-digit",
            minute: "2-digit",
          })
        : "N/A",
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch location-based weather." });
  }
};

// Fetch 5-day weather forecast
const getWeatherForecast = async (req, res) => {
  const city = req.params.city;
  const apiKey = process.env.WEATHER_API_KEY;

  try {
    const data = await fetchWeatherData(
      `https://api.openweathermap.org/data/2.5/forecast?q=${city}&appid=${apiKey}&units=metric`
    );

    const forecast = data?.list?.map((item) => ({
      date: item.dt_txt,
      temperature: item.main?.temp,
      description: item.weather?.[0]?.description,
      icon: item.weather?.[0]?.icon,
    }));

    res.json({
      city: data.city?.name,
      country: data.city?.country,
      forecast: forecast,
    });
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch 5-day forecast." });
  }
};

module.exports = {
  getWeather,
  getWeatherByLocation,
  getWeatherForecast,
};
