import 'package:flutter/material.dart';
import 'second_page.dart'; // 导入second_page.dart

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
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/second'); // 使用路由跳转
          },
          child: Text('跳转到页面B'),
        ),
      ),
    );
  }
}
