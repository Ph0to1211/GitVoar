class DbInfo {
  final String login;
  final String? history; //map

  DbInfo({required this.login, this.history});

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'history': history,
    };
  }

  factory DbInfo.fromMap(Map<String, dynamic> map) {
    return DbInfo(
      login: map['login'],
      history: map['history'],
    );
  }
}
