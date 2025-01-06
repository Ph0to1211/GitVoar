import 'package:flutter/material.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/db/db_helper.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('外观', style: TextStyle(fontSize: 15, color: textColor)),
          ),
          ListTile(
            title: const Text('主题模式'),
            subtitle: const Text('跟随系统'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('主题颜色'),
            subtitle: const Text('当前主题: 蓝色'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('纯黑深色模式'),
            subtitle: const Text('深色模式时使用纯黑色背景'),
            trailing: Switch(value: false, onChanged: null),
          ),
          ListTile(
            title: Text('个性化', style: TextStyle(fontSize: 15, color: textColor)),
          ),
          ListTile(
            title: const Text('使用内置浏览器打开链接'),
            trailing: Switch(value: false, onChanged: null),
          ),
          ListTile(
            title: Text('其他', style: TextStyle(fontSize: 15, color: textColor)),
          ),
          ListTile(
            title: const Text('删除数据'),
            subtitle: const Text('删除缓存及本地数据'),
            onTap: () async {
              // 显示对话框前，立即获取 context
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('确认'),
                    content: const Text('您确定要删除所有数据吗？'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(); // 先关闭对话框
                          await DBHelper.deleteAllUser();
                          Global.profile.lastLogin = null;
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('关于此应用'),
            onTap: () {
              Navigator.pushNamed(context, "About");
            }
          ),
        ],
      ),
    );
  }
}