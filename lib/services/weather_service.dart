import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/weather.dart';

class WeatherService {
  // 使用 OpenWeatherMap API (免费)
  static const String apiKey = 'S1PprKeWg4CtxoJ8s'; // 需要注册获取
  static const String baseUrl = 'https://api.seniverse.com/v3';
  // 获取天气信息--天气实况
  static Future<ApiResponse<Weather>> getWeather(String city) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/weather/now.json?location=$city&key=$apiKey&language=zh-Hans&unit=c',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = Weather.fromJson(data);
        return ApiResponse.success(weather);
      } else if (response.statusCode == 404) {
        return ApiResponse.error('城市未找到: $city');
      } else {
        return ApiResponse.error('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // 根据坐标获取天气
  static Future<ApiResponse<Weather>> getWeatherByLocation(
    double lat,
    double lon,
  ) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=zh_cn',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = Weather.fromJson(data);
        return ApiResponse.success(weather);
      } else {
        return ApiResponse.error('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // 获取未来5天天气预报
  static Future<ApiResponse<List<Weather>>> getForecast(String city) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/weather/daily.json?location=$city&key=$apiKey&language=zh-Hans&unit=c&start=0&days=5',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'] ?? [];

        final weatherList = list.map((item) {
          return Weather.fromJson({
            'name': city,
            'main': item['main'],
            'weather': item['weather'],
            'wind': item['wind'],
          });
        }).toList();

        return ApiResponse.success(weatherList);
      } else {
        return ApiResponse.error('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }
}
