import 'package:flutter/material.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/db/db_helper.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('删除数据'),
            onTap: () async {
              await DBHelper.deleteAllUser();
              Global.profile.lastLogin = null;
            },
          )
        ],
      ),
    );
  }
}