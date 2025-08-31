import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebpageScreenshotApp extends StatelessWidget {
  const WebpageScreenshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const WebpageScreenshotPage());
  }
}

class WebpageScreenshotPage extends StatefulWidget {
  const WebpageScreenshotPage({super.key});

  @override
  State<WebpageScreenshotPage> createState() => _WebpageScreenshotPageState();
}

class _WebpageScreenshotPageState extends State<WebpageScreenshotPage> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();

  // 创建MethodChannel
  static const MethodChannel _channel = MethodChannel('webpage_screenshot');

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openWebpage() async {
    String url = _urlController.text.trim();

    if (url.isEmpty) {
      _showSnackBar('请输入网址');
      return;
    }

    // 如果没有协议，添加https://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      // 调用iOS原生方法
      final result = await _channel.invokeMethod('openWebpage', {'url': url});
      print('iOS返回结果: $result');

      if (result == 'success') {
        _showSnackBar('正在打开网页: $url');
      } else {
        _showSnackBar('打开网页失败');
      }
    } catch (e) {
      print('调用iOS方法错误: $e');
      _showSnackBar('打开网页出错: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网页截图'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            try {
              // 调用iOS原生方法
              final result = await _channel.invokeMethod('dismiss', {
                'url': "",
              });
              print('iOS返回结果: $result');
            } catch (e) {
              print('调用iOS方法错误: $e');
              // Navigator.pop(context);
            }
          },
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            // URL输入框
            Container(
              // height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft, // 居左对齐
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 5,
                        bottom: 5,
                      ), // 四周都是20像素外边距
                      child: Container(
                        // color: Colors.blue, // 背景色
                        child: Text(
                          '请输入网址。。。。。。',
                          style: TextStyle(color: Colors.black, fontSize: 19),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ), // 四周都是20像素外边距
                    child: TextField(
                      maxLines: 3,
                      controller: _urlController,
                      focusNode: _urlFocusNode,
                      decoration: InputDecoration(
                        filled: true, // 启用填充
                        fillColor: Colors.green,
                        hintText: '请输入网址 https://...ww',
                        hintStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 1), // 向下移动图标
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            onPressed: () {
                              _urlController.clear();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _openWebpage(),
                    ),
                  ),

                  // const SizedBox(height: 60),
                  // const SizedBox(height: 40),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 打开网页按钮
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _openWebpage,
                  child: const Center(
                    child: Text(
                      '打开网页',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
