import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_github/db/db_helper.dart';
import 'package:my_github/pages/home.dart';
import 'package:my_github/route/routes.dart';

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
  await Global.init();
  Get.put(UserController());
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final UserController userController = Get.find<UserController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeController.theme.value),
      ),
      title: "GitVoar",
      home: userController.isLogged.value ? const HomeRoute() : LoginPage(),
      getPages: Routes.getPages,
    ));
  }
}
