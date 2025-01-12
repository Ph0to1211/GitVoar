import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/about.dart';
import '../pages/home.dart';
import '../pages/login/login.dart';
import '../pages/repo/hot_repos.dart';
import '../pages/search.dart';
import '../pages/setting.dart';

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/home', page: () => const HomeRoute()),
    GetPage(name: '/hotrepos', page: () => const HotReposPage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/setting', page: () => SettingPage()),
    GetPage(name: '/about', page: () => AboutPage()),
  ];
}
