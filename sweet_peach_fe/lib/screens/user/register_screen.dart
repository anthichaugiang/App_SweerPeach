import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/screens/user/password_hashing.dart';
import 'package:sweet_peach_fe/screens/user/validation.dart';

import 'login_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    final String userName = userNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = PasswordHashing.hashPassword(passwordController.text.trim());
    String? emailError = Validation.validateEmail(email);
    String? userNameError = Validation.validateUsername(userName);
    String? passwordError = Validation.validatePassword(password);

    if (emailError != null || userNameError != null || passwordError != null) {
      final snackBar = SnackBar(
        content: Text(emailError ?? userNameError ?? passwordError!),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final Uri url = Uri.parse('${ApiConst.baseUrl}api/users/register');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'username': userName,
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successfully')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed Email already exists!')),
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
                    Text(
                      'Đăng Kí',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email của bạn',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu của bạn',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      child: Text('Đăng Kí'),
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
  Widget _buildSkipButton(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Bỏ qua',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}