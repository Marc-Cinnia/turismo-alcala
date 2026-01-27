class UserAuth {
  UserAuth({
    required this.user,
    this.userId,
    required this.pwd,
  });

  String user;
  String? userId;
  String pwd;
}
