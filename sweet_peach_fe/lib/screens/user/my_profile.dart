import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import '../../apis/auth_service.dart';
import '../../apis/user_service.dart';
import 'change_password.dart';
import 'login_screen.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String username = "";
  String? avatarPath;
  final userService = UserService();

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = await userService.fetchUser();
      setState(() {
        username = user.username;
        avatarPath = user.avatarPath;
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _changePassword() async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePassword(onLogout: _logout))
    );

  }

  Future<void> _changeAvatar() async {
    try {
      var fileService = userService;
      var file = await fileService.pickImageFromGallery(); // Chọn hình ảnh từ thư viện
      if (file != null) {
        var userId = await  AuthService().getUserId();
        var success = await fileService.uploadFile(userId.toString(), file); // Gửi file lên server
        if (success) {
          if (kDebugMode) {
            print('Avatar changed successfully');
          }
          await _fetchUserInfo();
        } else {
          if (kDebugMode) {
            print('Failed to change avatar');
          }
        }
      } else {
        print('No image selected');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // Gọi API khi màn hình được tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatarPath != null
                  ? NetworkImage('${ApiConst.baseUrl}images/$avatarPath')
                  : null,
              child: avatarPath == null
                  ? Text(
                username.isNotEmpty ? username[0].toUpperCase() : '',
                style: TextStyle(fontSize: 36),
              )
                  : null,
            ),
          ),
          TextButton(
            onPressed: _changeAvatar, // Gọi hàm để thay đổi avatar
            child: const Text(
              'Change Avatar',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$username',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

              ],
            ),
          ),
          Spacer(),
          ListTile(
            onTap: _logout,
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
          Divider(),
          ListTile(
            onTap: _changePassword,
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
          ),
          Divider(),
        ],
      ),
    );
  }
}
