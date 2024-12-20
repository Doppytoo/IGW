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

  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          username: json['username'],
          isAdmin: json['is_admin'],
        );

  Map<String, Object> toJson() => {
        'id': id,
        'username': username,
        'is_admin': isAdmin,
      };
}
