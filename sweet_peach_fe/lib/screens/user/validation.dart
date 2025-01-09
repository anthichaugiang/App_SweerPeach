class Validation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }
    if (!value.contains('@')) {
      return 'Email không hợp lệ';
    }
    return null;
  }
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username không được để trống';
    }
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    // Kiểm tra điều kiện khác cho mật khẩu nếu cần
    return null; // Mật khẩu hợp lệ
  }
}
