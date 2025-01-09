import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/screens/user/my_profile.dart';
import 'package:sweet_peach_fe/screens/user/password_hashing.dart';
import 'package:sweet_peach_fe/screens/user/validation.dart';

import '../../apis/auth_service.dart';
import 'login_screen.dart';

typedef void LogoutCallback();

class ChangePassword extends StatefulWidget {
  final LogoutCallback? onLogout;

  ChangePassword({Key? key, this.onLogout}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    final auth = AuthService();
    final int? userIdInt = await auth.getUserId();
    final String userId = userIdInt.toString();
    final String currentPassword = PasswordHashing.hashPassword(currentPasswordController.text.trim());
    final String newPassword = PasswordHashing.hashPassword(newPasswordController.text.trim());
    String? currentPasswordError = Validation.validatePassword(currentPassword);
    String? newPasswordError = Validation.validatePassword(newPassword);

    if (currentPasswordError != null || newPasswordError != null) {
      final snackBar = SnackBar(
        content: Text(currentPasswordError ?? newPasswordError!),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final Uri url = Uri.parse('${ApiConst.baseUrl}api/users/${userId}/change-password');
    try {
      final response = await http.put(
        url,
        body: json.encode({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thay đổi mật khẩu thành công'), backgroundColor: Colors.green,),
        );
        widget.onLogout?.call();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('mật khẩu hiện tại không khớp '), backgroundColor: Colors.red,),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset(
                  "images/logo.jpg",
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu hiện tại',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu mới',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: changePassword,
                      child: Text('Đổi Mật Khẩu'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
