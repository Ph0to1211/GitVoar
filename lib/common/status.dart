import 'package:flutter/material.dart';
import 'package:my_github/common/global.dart';

import '../models/profile.dart';
import '../models/user.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user ?? User();

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => _profile.user != null;

  // 用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User? newUser) {
    _profile.user = newUser;
    notifyListeners();
  }

  set lastLogin(String userName) {
    _profile.lastLogin = userName;
    notifyListeners();
  }

  // 设置登录状态
  void setLoginStatus(bool status) {
    if (status) {
      // 登录状态为 true 时，不做任何更改，仅触发更新
      notifyListeners();
    } else {
      // 退出登录时，清空用户信息
      _profile.user = null;
      notifyListeners(); // 通知UI更新
    }
  }
}

class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果未设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500]!.value;
      notifyListeners();
    }
  }
}

// class LocaleModel extends ProfileChangeNotifier {
//   // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
//   Locale getLocale() {
//     if (_profile.locale == null) return null;
//     var t = _profile.locale.split("_");
//     return Locale(t[0], t[1]);
//   }
//
//   // 获取当前Locale的字符串表示
//   String get locale => _profile.locale;
//
//   // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
//   set locale(String locale) {
//     if (locale != _profile.locale) {
//       _profile.locale = locale;
//       notifyListeners();
//     }
//   }
// }
