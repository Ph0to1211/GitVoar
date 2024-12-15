import 'package:flutter/material.dart';
import 'package:my_github/db/db_helper.dart';
import 'package:my_github/pages/about.dart';
import 'package:my_github/pages/home.dart';
import 'package:my_github/pages/repo/hot_repos.dart';
import 'package:my_github/pages/repo/repos.dart';
import 'package:my_github/pages/search.dart';
import 'package:my_github/pages/setting.dart';
import 'package:my_github/pages/repo/starred_repos.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';
import 'common/status.dart';
import 'pages/login/login.dart';


// void main() {
//   runApp(const MyApp());
// }

// void main() => Global.init().then((e) => runApp(MaterialApp(home: LoginPage())));

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 初始化 Widgets
  await DBHelper.initDB();
  Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModel()),
        ChangeNotifierProvider(create: (_) => UserModel())
      ],
      child: Consumer2<ThemeModel, UserModel>(
        builder: (BuildContext context, ThemeModel themeModel, UserModel userModel, Widget? child) {
          return MaterialApp(
            // theme: ThemeData(
            //   // primarySwatch: themeModel.theme
            //   primaryColor: Colors.blue
            // ),
            // onGenerateTitle: (context) {
            //   return "主页";
            // },
            title: "My Github",
            home: userModel.isLogin ? const HomeRoute() : const LoginPage(),
            routes: <String, WidgetBuilder> {
              "login": (context) => const LoginPage(),
              "Home": (context) => const HomeRoute(),
              // "MyRepos": (context) => const MyReposPage(),
              // "StarredRepos": (context) => const StarredReposPage(),
              "HotRepos": (context) => const HotReposPage(),
              "Search": (context) => SearchPage(),
              "Setting": (context) => SettingPage(),
              "About": (context) => AboutPage(),
            },
          );
        },
      ),
    );
  }
}


