class DbUser {
  final String login;
  final String? token;
  final String? avatarUrl;
  final int rememberPwd;

  DbUser({required this.login,
          this.token,
          this.avatarUrl,
          required this.rememberPwd,
        });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'token': token,
      'avatarUrl': avatarUrl,
      'rememberPwd': rememberPwd,
    };
  }

  factory DbUser.fromMap(Map<String, dynamic> map) {
    return DbUser(
      login: map['login'],
      token: map['token'],
      avatarUrl: map['avatarUrl'],
      rememberPwd: map['rememberPwd'],
    );
  }
}
