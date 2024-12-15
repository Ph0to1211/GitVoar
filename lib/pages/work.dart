import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/common/utils.dart';
import 'package:my_github/pages/user/organizations.dart';
import 'package:my_github/pages/repo/repos.dart';
import 'package:my_github/pages/repo/starred_repos.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  @override
  Widget build (BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text(
            '我的工作',
            style: TextStyle(fontSize: 15),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
            onPressed: () {},
          ),
          onTap: null,
        ),
        ListTile(
          leading: const Icon(Icons.bug_report_rounded, color: Colors.green),
          title: const Text('议题'),
          onTap: () {
            Fluttertoast.showToast(
              msg: "尚在开发中...",
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.merge_rounded, color: Colors.blue),
          title: const Text('拉取请求'),
          onTap: () {
            Fluttertoast.showToast(
              msg: "尚在开发中...",
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.comment_rounded, color: Colors.purple),
          title: const Text('讨论'),
          onTap: () {
            Fluttertoast.showToast(
              msg: "尚在开发中...",
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.view_list_rounded, color: Colors.grey),
          title: const Text('项目'),
          onTap: () {
            Fluttertoast.showToast(
              msg: "尚在开发中...",
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book_rounded, color: Colors.black),
          title: const Text('仓库'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReposPage(userName: Global.profile.lastLogin!)
                )
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.people_rounded, color: Colors.orange),
          title: const Text('组织'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrganizationsPage(userName: Global.profile.lastLogin!)
                )
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_rounded, color: Colors.yellow),
          title: const Text('已加星标'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        StarredReposPage(userName: Global.profile.lastLogin!)
                )
            );
          },
        ),
        const Divider(
          color: Colors.grey,
          height: .0,
          thickness: .0,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
        ListTile(
          title: const Text(
            '收藏夹',
            style: TextStyle(fontSize: 15),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
            onPressed: () {},
          ),
          onTap: null,
        ),
        ListTile(
          leading: Utils().gmAvatar(
            'https://avatars.githubusercontent.com/u/25545225?s=48&v=4',
             borderRadius: BorderRadius.circular(15.0)
          ),
          title: const Text('pilipala'),
          subtitle: const Text('guozigq', style: TextStyle(color: Colors.grey)),
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
          height: .0,
          thickness: .0,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
        ListTile(
          title: const Text(
            '快捷入口',
            style: TextStyle(fontSize: 15),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
            onPressed: () {},
          ),
          onTap: null,
        ),
        Column(
          children: [
            const Text(
              '您需要的内容，一步之遥',
              style: TextStyle(
                fontSize: 16.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                '快速访问您的议题、拉取请求或讨论列表',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600]
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {},
            child: const Text('开始使用'),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20.0)),
      ],
    );
  }
}