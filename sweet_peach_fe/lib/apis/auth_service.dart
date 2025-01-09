import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';
import '../models/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class AuthService {
  // Hàm đăng nhập trả về token
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConst.baseUrl}api/users/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về từ API để lấy token
      final responseData = jsonDecode(response.body);
      String? token = responseData['token'];
      String userId = responseData['userId'];
      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      await prefs.setString('userId', userId);
      return token; // Trả về token nếu đăng nhập thành công
    } else {
      // Đăng nhập thất bại
      return null;
    }
  }
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');
    // Kiểm tra nếu userIdString không null và không rỗng trước khi chuyển đổi
    if (userIdString != null && userIdString.isNotEmpty) {
      return int.parse(userIdString); // Chuyển đổi từ String sang int
    } else {
      return null; // Trả về null nếu không thể chuyển đổi hoặc không có giá trị
    }
  }
  Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      return token;
    } else {
      return null;
    }
  }
}
