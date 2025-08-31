import 'package:flutter/material.dart';
import 'second_page.dart'; // 导入second_page.dart
import 'weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter页面ASS',
      initialRoute: '/',
      routes: {
        '/': (context) => FlutterPageA(),
        '/second': (context) => WebpageScreenshotApp(),
        '/weather': (context) => WeatherPage(),
      },
      onGenerateRoute: (settings) {
        print('路由生成: ${settings.name}');
        return null;
      },
      navigatorObservers: [RouteObserver()],
    );
  }
}

class FlutterPageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter页面AAA')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather'); // 使用路由跳转
              },
              child: Text('查询5天内天气'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/weather'); // 使用路由跳转
              },
              child: Text('跳转到页面B'),
            ),
          ],
        ),
      ),
    );
  }
}
