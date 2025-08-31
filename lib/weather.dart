import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  List<Weather> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _cityController = TextEditingController();

  // 默认城市
  String _currentCity = 'beijing';

  @override
  void initState() {
    super.initState();
    _cityController.text = _currentCity;
    _loadWeather();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  // 加载天气数据
  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 获取当前天气
      final weatherResponse = await WeatherService.getWeather(_currentCity);

      if (weatherResponse.isSuccess) {
        print(weatherResponse.data);
        setState(() {
          _weather = weatherResponse.data;
          _isLoading = false;
        });

        // 获取天气预报
        _loadForecast();
      } else {
        setState(() {
          _errorMessage = weatherResponse.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
    }
  }

  // 加载天气预报
  Future<void> _loadForecast() async {
    try {
      final forecastResponse = await WeatherService.getForecast(_currentCity);

      if (forecastResponse.isSuccess) {
        setState(() {
          _forecast = forecastResponse.data ?? [];
        });
      }
    } catch (e) {
      print('加载预报失败: $e');
    }
  }

  // 搜索城市
  void _searchCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _currentCity = city;
      });
      _loadWeather();
    }
  }

  // 刷新天气
  Future<void> _refreshWeather() async {
    await _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('天气信息'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshWeather),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeather,
        child: Column(
          children: [
            // 搜索框
            _buildSearchBar(),

            // 内容区域
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: '输入城市名称',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _searchCity(),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(onPressed: _searchCity, child: Text('搜索')),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: SpinKitFadingCircle(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.0, color: Colors.red),
            SizedBox(height: 16.0),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: _loadWeather, child: Text('重试')),
          ],
        ),
      );
    }

    if (_weather == null) {
      return Center(child: Text('暂无天气数据'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 当前天气
          _buildCurrentWeather(),

          SizedBox(height: 24.0),

          // 天气预报
          // if (_forecast.isNotEmpty) _buildForecast(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              _weather!.city,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),

            // 天气图标和温度
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getWeatherIcon(_weather!.weatherCode),
                  size: 80.0,
                  color: Colors.orange,
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_weather!.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _weather!.description,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.0),

            // 天气代码和更新时间
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(Icons.info, '天气代码', _weather!.weatherCode),
                _buildWeatherInfo(
                  Icons.access_time,
                  '更新时间',
                  _formatTime(_weather!.lastUpdate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 格式化时间显示
  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeString;
    }
  }

  // 根据天气代码获取图标
  IconData _getWeatherIcon(String weatherCode) {
    switch (weatherCode) {
      case '0':
        return Icons.wb_sunny; // 晴天
      case '1':
        return Icons.wb_cloudy; // 多云
      case '2':
        return Icons.cloud; // 阴天
      case '3':
        return Icons.grain; // 小雨
      case '4':
        return Icons.cloud; // 多云
      case '5':
        return Icons.opacity; // 中雨
      case '6':
        return Icons.thunderstorm; // 雷阵雨
      case '7':
        return Icons.ac_unit; // 雪
      default:
        return Icons.wb_sunny;
    }
  }

  Widget _buildWeatherInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24.0, color: Colors.blue),
        SizedBox(height: 8.0),
        Text(label, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
