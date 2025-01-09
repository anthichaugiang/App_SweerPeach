class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String? avatarPath;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.avatarPath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      avatarPath: json['avatarPath'],
    );
  }
}
