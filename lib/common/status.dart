import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_github/common/global.dart';

import '../models/profile.dart';
import '../models/user.dart';

class UserController extends GetxController {
  var isLogged = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Global.profile.user != null && Global.profile.lastLogin != null) {
      isLogged.value = true;
    } else {
      isLogged.value = false;
    }
  }

  void login(User newUser) {
    Global.profile.user = newUser;
    Global.profile.lastLogin = newUser.login;
    Global.saveProfile();
    isLogged.value = true;
  }

  void logout() {
    Global.profile.user = null;
    Global.saveProfile();
    isLogged.value = false;
  }
}

class ThemeController extends GetxController {
  var theme = Global.themes.first.obs;

  void setTheme(MaterialColor newTheme) {
    theme.value = newTheme;
    Global.saveProfile();
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
