import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHashing {
  static String hashPassword(String password) {
    var bytes = utf8.encode(password); // Chuyển đổi mật khẩu thành mã UTF-8
    var digest = sha256.convert(bytes); // Mã hóa mật khẩu bằng SHA-256
    return digest.toString();
  }
}
