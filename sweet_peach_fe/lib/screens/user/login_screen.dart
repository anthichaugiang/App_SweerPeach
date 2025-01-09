import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/screens/user/password_hashing.dart';
import 'package:sweet_peach_fe/screens/user/register_screen.dart';
import 'package:sweet_peach_fe/screens/user/validation.dart';
import '../../apis/auth_service.dart';
import '../index.dart';
import 'my_profile.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String email = emailController.text;
    String password = PasswordHashing.hashPassword(passwordController.text);
    String? emailError = Validation.validateEmail(email);
    String? passwordError = Validation.validatePassword(password);

    if (emailError != null || passwordError != null) {
      final snackBar = SnackBar(
        content: Text(emailError ?? passwordError!),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // Dữ liệu hợp lệ, gọi service để đăng nhập
    String? token = await AuthService().login(email, password);
    if (token != null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IndexController()),
      );
    } else {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đăng nhập thất bại'),
            content: Text('Email hoặc mật khẩu không chính xác. Vui lòng thử lại.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildLoginForm(context),
          _buildSkipButton(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
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
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
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
                      'Đăng Nhập',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                    SizedBox(height: 40),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu của bạn',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Xử lý khi nhấn vào "Quên mật khẩu"
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Đăng Nhập'),
                    ),
                    SizedBox(height: 20),
                    _buildDivider(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text('Đăng Ký'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Hoặc',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IndexController()),
          );
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
