import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/status.dart';
import '../../http/git.dart';
import '../../models/user.dart';

class OauthController extends GetxController {
  final UserController userController = Get.find<UserController>();

  final progress = 0.0.obs;

  late WebViewController controller;
  final oauthLink = 'https://github.com/login/oauth/authorize?client_id=Ov23li095SyVH3RL5xo1';
  String code = '';

  @override
  void onInit() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int prg) {
          progress.value = prg / 100.0;
        },
        onNavigationRequest: (request) {
          final Uri uri = Uri.parse(request.url);
          if (uri.queryParameters.containsKey('code')) {
            code = uri.queryParameters['code']!;
            login();
            return NavigationDecision.prevent;
          }
          // 默认行为：继续加载请求的页面
          return NavigationDecision.navigate;
        },
      ))
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(oauthLink));
    super.onInit();
  }

  void login() async {
    User user = await Git(Get.context!).oauthLogin(code);
    userController.login(user);
    // await _controller.clearCache();
    // await _controller.clearLocalStorage();
    Fluttertoast.showToast(
      msg: "登录成功~",
      gravity: ToastGravity.BOTTOM,
    );
    Get.back();
  }
}

class OauthLoginPage extends StatelessWidget {
  final OauthController oauthController = Get.put(OauthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            onPressed: oauthController.controller.reload,
            icon: Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Obx(() => Column(
        children: [
          oauthController.progress.value < 1.0 ? LinearProgressIndicator(value: oauthController.progress.value) : Container(),
          Expanded(
            child: WebViewWidget(
              controller: oauthController.controller,
            ),
          )
        ],
      )),
    );
  }
}
