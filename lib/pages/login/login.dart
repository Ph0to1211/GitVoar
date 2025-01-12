import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/db/db_helper.dart';
import 'package:my_github/db/db_models/db_user.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_github/pages/login/oauth.dart';

import '../../common/status.dart';

class LoginController extends GetxController {
  final UserController userController = Get.find<UserController>();

  var usernameCont = TextEditingController();
  var pwdCont = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var users = <DbUser>[].obs;
  var showPwd = false.obs;
  var nameAutoFocus = true.obs;
  var isChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    if (Global.profile.lastLogin != null) {
      nameAutoFocus.value = false;
    }
  }

  Future<void> _initialize() async {
    await _getUsers();
    if (users.isNotEmpty) {
      var matchingUser = users.firstWhere(
            (user) => user.login == Global.profile.lastLogin,
        orElse: () => DbUser(login: '', rememberPwd: 0),
      );
      if (matchingUser.login != '') {
        usernameCont.text = matchingUser.login;
        pwdCont.text = matchingUser.token ?? '';
        isChecked.value = matchingUser.rememberPwd == 1;
      }
    }
  }

  Future<void> _getUsers() async {
    var fetchedUsers = await DBHelper.getUsers();
    users.assignAll(fetchedUsers);
  }

  void insertOrUpdateUser(String login, String? token, String? avatarUrl) async {
    bool exists = users.any((u) => u.login == login);
    DbUser user = DbUser(
      login: login,
      token: isChecked.value ? token : '',
      avatarUrl: avatarUrl,
      rememberPwd: isChecked.value ? 1 : 0,
    );
    exists ? await DBHelper.updateUser(user) : await DBHelper.insertUser(user);
    _getUsers();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        User? user = await Git(Get.context!)
            .login(usernameCont.text, pwdCont.text);

        if (user.login == usernameCont.text) {
          insertOrUpdateUser(usernameCont.text, pwdCont.text, user.avatarUrl);
          userController.login(user);
          Fluttertoast.showToast(msg: "登录成功");
          // Get.back();
        } else {
          Fluttertoast.showToast(msg: "用户名/密码错误");
        }
      } on DioException catch (e) {
        Fluttertoast.showToast(msg: "网络错误: ${e.message}");
      }
    }
  }
}

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Obx(() => TextFormField(
                  controller: controller.usernameCont,
                  autofocus: controller.nameAutoFocus.value,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "用户名",
                      prefixIcon: Icon(Icons.person)),
                  validator: (v) {
                    return v==null||v.trim().isNotEmpty ? null : "请输入用户名";
                  }
              )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                  controller: controller.pwdCont,
                  obscureText: !controller.showPwd.value,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "密码",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(controller.showPwd.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          controller.showPwd.toggle();
                        },
                      )),
                  validator: (v) {
                    return v==null||v.trim().isNotEmpty ? null : "请输入密码";
                  }
              )),
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.isChecked.value,
                    onChanged: (value) {
                      controller.isChecked.value = value!;
                    },
                  )),
                  const Text('记住密码')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(135, 45)
                    ),
                    onPressed: () {
                      Get.to(() => OauthLoginPage());
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.public_rounded, size: 20.0),
                        SizedBox(width: 4.0),
                        Text('授权登录'),
                        SizedBox(width: 4.0)
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(135, 45)
                    ),
                    onPressed: controller.login,
                    child: const Text("登录"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('注册'),
        icon: const Icon(Icons.person_add_rounded),
      ),
    );
  }
}
