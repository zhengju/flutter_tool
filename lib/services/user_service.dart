import '../models/api_response.dart';
import '../models/user.dart';
import 'http_service.dart';

class UserService {
  // 获取用户列表
  static Future<ApiResponse<List<User>>> getUsers() async {
    return await HttpService.getUsers();
  }

  // 根据 ID 获取用户
  static Future<ApiResponse<User>> getUserById(int id) async {
    return await HttpService.getUserById(id);
  }

  // // 创建用户
  // static Future<ApiResponse<User>> createUser(User user) async {
  //   return await HttpService.createUser(user);
  // }

  // // 更新用户
  // static Future<ApiResponse<User>> updateUser(int id, User user) async {
  //   return await HttpService.updateUser(id, user);
  // }

  // 删除用户
  static Future<ApiResponse<void>> deleteUser(int id) async {
    return await HttpService.deleteUser(id);
  }

  // 搜索用户
  static Future<ApiResponse<List<User>>> searchUsers(String query) async {
    final response = await HttpService.get<List<dynamic>>('/users');

    if (response.isSuccess) {
      final allUsers = (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();

      final filteredUsers = allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      return ApiResponse.success(filteredUsers);
    } else {
      return ApiResponse.error(response.message ?? '搜索失败');
    }
  }
}
