import 'dart:convert';

import 'package:my_github/models/cache_config.dart';
import 'package:my_github/models/user.dart';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  User? user;
  String? token;
  int theme;
  CacheConfig cache;
  String? lastLogin;
  String? locale;

  Profile({
    this.user,
    this.token,
    this.theme = 0,
    required this.cache,
    this.lastLogin,
    this.locale,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    token: json["token"],
    theme: json["theme"],
    cache: CacheConfig.fromJson(json["cache"]),
    lastLogin: json["lastLogin"],
    locale: json["locale"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "theme": theme,
    "cache": cache.toJson(),
    "lastLogin": lastLogin,
    "locale": locale,
  };
}
