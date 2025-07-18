import 'package:dio/dio.dart';
import 'package:weather_app/common/constants/constants.dart';
import 'package:weather_app/common/services/geo_locator.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weekly_weather.dart';

class ApiHelper {
  static const baseurl = "https://api.openweathermap.org/data/2.5";
  static const weeklyWeatherUrl =
      "https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto";

  static final dio = Dio();
  static double lat = 0.0;
  static double lon = 0.0;
  //Get lat and lon
  static Future<void> fetchLocation() async {
    //static method can only access the static variable
    final location = await getLocation();
    lat = location.latitude;
    lon = location.longitude;
  }

  //build url
  static String _constructionWeatherUrl() {
    return "$baseurl/weather?lat=$lat&lon=$lon&appid=${Constants.apiKey}&units=metric";
  }

  static String _constructForecastUrl() {
    return "$baseurl/forecast?lat=$lat&lon=$lon&appid=${Constants.apiKey}&units=metric";
  }

  static String _constructWeatherByCityName(String city_name) {
    return "$baseurl/weather?q=$city_name&appid=${Constants.apiKey}&units=metric";
  }

  static String _constructWeeklyForecastUrl() {
    return "$weeklyWeatherUrl&latitude=$lat&longitude=$lon";
  }

  //fetch data for a url
  static Future<Map<String, dynamic>> fetchdata(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Error fetching data");
      }
    } catch (e) {
      print("Error fetching data from a $url :$e");
      throw Exception("Error fetching data");
    }
  }

  //current weather
  static Future<Weather> getCurrentWeather() async {
    await fetchLocation();
    final url = _constructionWeatherUrl();
    final response = await fetchdata(url);

    return Weather.fromJson(response);
  }

  static Future<HourlyWeather> getHourlyForecast() async {
    await fetchLocation();
    final url = _constructForecastUrl();
    final response = await fetchdata(url);
    print(response);
    return HourlyWeather.fromJson(response);
  }

  static Future<WeeklyWeather> getWeeklyForecast() async {
    await fetchLocation();
    final url = _constructWeeklyForecastUrl();
    final response = await fetchdata(url);
    print(response);
    return WeeklyWeather.fromJson(response);
  }

  static Future<Weather> getWeatherByCityName({
    required String city_name,
  }) async {
    await fetchLocation();
    final url = _constructWeatherByCityName(city_name);
    final response = await fetchdata(url);
    print(response);
    return Weather.fromJson(response);
  }
}
