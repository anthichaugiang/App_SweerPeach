import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/apis/auth_service.dart';
import '../models/user.dart';
import 'dart:io';
class UserService {
  final authService = AuthService();

  Future<User> fetchUser() async {
    final userId = await authService.getUserId();
    final response = await http.get(Uri.parse('${ApiConst.baseUrl}api/users/$userId'));

    if (response.statusCode == 200) {
      // Decode JSON response
      final jsonData = jsonDecode(response.body);
      // Create a User object from decoded JSON
      final user = User.fromJson(jsonData);
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }
  Future<File?> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<bool> uploadFile(String userId, File file) async {
    try {
      var url = Uri.parse('${ApiConst.baseUrl}api/users/change-avatar');
      var request = http.MultipartRequest('PUT', url);
      request.fields['userId'] = userId;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }

}
