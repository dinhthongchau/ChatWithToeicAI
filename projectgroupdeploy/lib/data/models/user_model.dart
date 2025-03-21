class User {
  int? userid;
  String username;
  String password;

  User({this.userid, required this.username, required this.password});

  // Chuyển đối tượng thành Map (dùng để lưu vào SQLite)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userid,
      'username': username,
      'password': password,
    };
  }

  // Chuyển từ Map (SQLite) thành đối tượng User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userid: map['user_id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
