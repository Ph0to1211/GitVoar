import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_github/http/cache.dart';
import 'package:my_github/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http/git.dart';
import '../models/cache_config.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.green,
  Colors.purple
];

class Global {
  static late SharedPreferences _prefs;
  static Profile profile = Profile(cache: CacheConfig());
  static NetCache netCache = NetCache();
  static List<MaterialColor> get themes => _themes;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print("错误信息为:$e");
      }
    } else {
      profile = Profile(cache: CacheConfig())..theme=0;
    }

    profile.cache = profile.cache
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    Git.init();
  }

  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}