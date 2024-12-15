import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/common/status.dart';
import 'package:my_github/db/db_helper.dart';
import 'package:my_github/db/db_models/db_user.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/models/user.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_github/pages/login/oauth.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameCont = TextEditingController();
  final TextEditingController _pwdCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DbUser> _users = [];

  bool showPwd = false;
  bool _nameAutoFocus = true;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _getUsers();

    if (_users.isNotEmpty) {
      var matchingUser = _users.firstWhere(
              (user) => user.login == Global.profile.lastLogin,
          orElse: () => DbUser(login: '', rememberPwd: 0)
      );

      if (matchingUser.login != '') {
        _usernameCont.text = matchingUser.login;
        _pwdCont.text = matchingUser.token!;

        setState(() {
          _isChecked = (matchingUser.rememberPwd == 1) ? true : false;
        });

        if (_usernameCont.text.isNotEmpty) {
          setState(() {
            _nameAutoFocus = false;
          });
        }
      }
    }
  }

  Future<void> _getUsers() async {
    var users = await DBHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  void _newUser(
      String login, String? token, String? avatarUrl, int rememberPwd) async {
    DbUser user = DbUser(
        login: login,
        token: token,
        avatarUrl: avatarUrl,
        rememberPwd: rememberPwd);
    await DBHelper.insertUser(user);
    _getUsers();
  }

  void _updateUser(
      String login, String? token, String? avatarUrl, int rememberPwd) async {
    DbUser user = DbUser(
      login: login,
      token: token,
      avatarUrl: avatarUrl,
      rememberPwd: rememberPwd,
    );
    await DBHelper.updateUser(user);
    _getUsers();
  }

  void _insertUser(String userName, String? token, String? avatarUrl) {
    bool exists = _users.any((u) => u.login == userName);
    if (exists) {
      (_isChecked)
          ? _updateUser(userName, token, avatarUrl, 1)
          : _updateUser(userName, '', avatarUrl, 0);
    } else {
      (_isChecked)
          ? _newUser(userName, token, avatarUrl, 1)
          : _newUser(userName, '', avatarUrl, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("登录"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              // CircleAvatar(
              //   radius: 60.0,
              //   backgroundImage: AssetImage(
              //     'assets/img/Octocat.png'
              //   ),
              // ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _usernameCont,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "用户名",
                    // hintText: "用户名",
                    prefixIcon: Icon(Icons.person)
                ),
                validator: (v) {
                  return v==null||v.trim().isNotEmpty ? null : "请输入用户名";
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              TextFormField(
                controller: _pwdCont,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "密码",
                    // hintText: "密码",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          showPwd ? Icons.visibility_off : Icons.visibility
                      ),
                      onPressed: () {
                        setState(() {
                          showPwd = !showPwd;
                        });
                      },
                    )
                ),
                obscureText: !showPwd,
                validator: (v) {
                  return v==null||v.trim().isNotEmpty ? null : "请输入密码";
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  Text('记住密码')
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OauthLoginPage()),
                      );
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
                    onPressed: _onLogin,
                    child: const Text("登录"),
                  )
                ],
              ),
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

  void _onLogin() async {
    var userModel = Provider.of<UserModel>(context, listen: false);
    bool isLogin = userModel.isLogin;

    if (_formKey.currentState!.validate()) {
      User? user;
      try {
        user = await Git(context)
            .login(_usernameCont.text, _pwdCont.text, context);
      } on DioException catch(e) {
        Response<dynamic>? r = e.response;
        if (r?.statusCode == 401) {
          print("用户名/密码错误");
          Fluttertoast.showToast(
            msg: "用户名/密码错误",
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          Fluttertoast.showToast(
            msg: e.toString(),
            gravity: ToastGravity.BOTTOM,
          );
        }
      } finally {
        if (user != null && user.login == _usernameCont.text) {
          print("登录成功");
          _insertUser(_usernameCont.text, _pwdCont.text, user.avatarUrl);
          Global.profile.user = user;
          userModel.lastLogin = user.login!;
          userModel.user = user;
          Fluttertoast.showToast(
            msg: "登录成功",
            gravity: ToastGravity.BOTTOM,
          );
          if (isLogin) {
            Navigator.pop(context);
          }
        } else {
          print("用户名/密码错误");
          Fluttertoast.showToast(
            msg: "用户名/密码错误",
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } else {
      print("请正确输入用户名/密码");
      Fluttertoast.showToast(
        msg: "请正确输入用户名/密码",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
