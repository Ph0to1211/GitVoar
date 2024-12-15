import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_github/models/user.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/status.dart';
import '../../http/git.dart';

class OauthLoginPage extends StatefulWidget {
  OauthLoginPage({super.key});

  @override
  _OauthLoginPageState createState() => _OauthLoginPageState();
}

class _OauthLoginPageState extends State<OauthLoginPage> {
  late WebViewController _controller;
  double _progress = 0;

  final _oauthLink = 'https://github.com/login/oauth/authorize?client_id=Ov23li095SyVH3RL5xo1';
  // final _oauthLink = 'https://www.baidu.com';
  String _code = '';

  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          setState(() {
            _progress = progress / 100.0;
          });
        },
        onNavigationRequest: (request) {
          final Uri uri = Uri.parse(request.url);
          if (uri.queryParameters.containsKey('code')) {
            setState(() {
              _code = uri.queryParameters['code']!;
            });
            login();
            return NavigationDecision.prevent;
          }
          // 默认行为：继续加载请求的页面
          return NavigationDecision.navigate;
        },
      ))
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(_oauthLink));
    super.initState();
  }

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
            onPressed: _controller.reload,
            icon: Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          _progress < 1.0 ? LinearProgressIndicator(value: _progress) : Container(),
          Expanded(
            child: WebViewWidget(
              controller: _controller,
            ),
          )
        ],
      ),
    );
  }

  void login() async {
    await Git(context).oauthLogin(_code, context);
    // await _controller.clearCache();
    // await _controller.clearLocalStorage();
    Fluttertoast.showToast(
      msg: "登录成功~",
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.of(context).pop();
  }

}