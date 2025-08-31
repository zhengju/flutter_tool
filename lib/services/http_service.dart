import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../models/user.dart';

class HttpService {
  // 基础 URL
  static const String baseUrl = 'https://api.seniverse.com/';

  // 请求头
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 如果需要认证，在这里添加 token
    // 'Authorization': 'Bearer $token',
  };

  // GET 请求
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: _headers);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // POST 请求
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // PUT 请求
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // DELETE 请求
  static Future<ApiResponse<T>> delete<T>(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.delete(uri, headers: _headers);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('网络请求失败: $e');
    }
  }

  // 处理响应
  static ApiResponse<T> _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data);
      } catch (e) {
        return ApiResponse.error('数据解析失败: $e');
      }
    } else {
      return ApiResponse.error('请求失败: ${response.statusCode}');
    }
  }

  // 具体业务方法示例
  static Future<ApiResponse<List<User>>> getUsers() async {
    return await get<List<dynamic>>('/users').then((response) {
      if (response.isSuccess) {
        final users = (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();
        return ApiResponse.success(users);
      } else {
        return ApiResponse.error(response.message);
      }
    });
  }

  static Future<ApiResponse<User>> getUserById(int id) async {
    final response = await HttpService.get<Map<String, dynamic>>('/users/$id');

    if (response.isSuccess) {
      try {
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(user);
      } catch (e) {
        return ApiResponse.error('用户数据解析失败: $e');
      }
    } else {
      return ApiResponse.error(response.message ?? '获取用户失败');
    }
  }

  // static Future<ApiResponse<User>> createUser(User user) async {
  //   return await post<Map<String, dynamic>>('/users', body: user.toJson());
  // }

  // static Future<ApiResponse<User>> updateUser(int id, User user) async {
  //   return await put<Map<String, dynamic>>('/users/$id', body: user.toJson());
  // }

  static Future<ApiResponse<void>> deleteUser(int id) async {
    return await delete<void>('/users/$id');
  }
}
