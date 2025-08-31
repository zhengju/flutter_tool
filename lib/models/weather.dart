class Weather {
  final String city;
  final double temperature;
  final String description;
  final String weatherCode;
  final String lastUpdate;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.weatherCode,
    required this.lastUpdate,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      final results = json['results'] as List?;
      if (results == null || results.isEmpty) {
        throw Exception('No results found');
      }

      final result = results[0] as Map<String, dynamic>;
      final location = result['location'] as Map<String, dynamic>?;
      final now = result['now'] as Map<String, dynamic>?;

      if (location == null || now == null) {
        throw Exception('Invalid data structure');
      }

      return Weather(
        city: location['name']?.toString() ?? '未知城市',
        temperature: _safeParseDouble(now['temperature']),
        description: now['text']?.toString() ?? '未知天气',
        weatherCode: now['code']?.toString() ?? '',
        lastUpdate: result['last_update']?.toString() ?? '',
      );
    } catch (e) {
      print('解析天气数据失败: $e');
      // 返回默认值
      return Weather(
        city: '未知城市',
        temperature: 0.0,
        description: '未知天气',
        weatherCode: '',
        lastUpdate: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'description': description,
      'weatherCode': weatherCode,
      'lastUpdate': lastUpdate,
    };
  }

  // 安全的数字解析方法
  static double _safeParseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  @override
  String toString() {
    return 'Weather(city: $city, temperature: $temperature, description: $description, code: $weatherCode)';
  }
}
