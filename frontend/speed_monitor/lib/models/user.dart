class LoginDetails {
  final String username;
  final String password;

  LoginDetails({required this.username, required this.password});

  Map<String, String> toJson() => {'username': username, 'password': password};
}

class User {
  final int id;
  final String username;
  final bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        isAdmin: json['is_admin'],
      );
}
