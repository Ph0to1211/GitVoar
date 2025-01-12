import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_github/pages/user/followers.dart';
import 'package:my_github/pages/user/followings.dart';
import 'package:my_github/pages/user/organizations.dart';
import 'package:my_github/pages/repo/repos.dart';
import 'package:my_github/pages/repo/starred_repos.dart';
import 'package:my_github/pages/detail/user_datail.dart';
import 'package:provider/provider.dart';

import '../common/global.dart';
import '../common/status.dart';
import '../models/user.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Color _editIconBackgroundColor = Colors.white;
  User user = Global.profile.user!;

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.primary;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: Global.profile.lastLogin!,
                    child: Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailPage(user: Global.profile.user!,)
                              )
                          );
                        },
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                            user.avatarUrl!,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: .0,
                    bottom: .0,
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _editIconBackgroundColor = Colors.grey.shade300;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _editIconBackgroundColor = Colors.white;
                        });
                        _logout();
                      },
                      onTapCancel: () {
                        setState(() {
                          _editIconBackgroundColor = Colors.white;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _editIconBackgroundColor,
                            shape: BoxShape.circle
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: const Icon(
                          Icons.logout_rounded,
                          size: 20.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.login!, style: const TextStyle(fontSize: 30.0)),
                    buildSubItem()
                  ],
                ),
              )
            ],
          ),
        ),
        // const Divider(color: Colors.grey, height: .0, thickness: .0),
        ListTile(
          title: Text('我的工作', style: TextStyle(fontSize: 15, color: textColor))
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
          trailing: Text('1', style: TextStyle(color: Colors.grey, fontSize: 14.0))
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
          // trailing: Text('1', style: TextStyle(color: Colors.grey, fontSize: 14.0))
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
        const Divider(color: Colors.grey, height: .0, thickness: .0),
        ListTile(
          title: Text('收藏夹', style: TextStyle(fontSize: 15, color: textColor)),
          trailing: IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
            onPressed: () {},
          ),
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
                '快速访问您的仓库',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600]
                ),
              ),
            )
          ],
        ),
        const Divider(color: Colors.grey, height: .0, thickness: .0),
        ListTile(
            title: Text('其他', style: TextStyle(fontSize: 15, color: textColor))
        ),
        ListTile(
          leading: const Icon(Icons.settings_rounded),
          title: const Text('设置'),
          onTap: () {
            // Navigator.pushNamed(context, "Setting");
            Get.toNamed('/setting');
          }
        ),
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: const Text('关于'),
          onTap: () {
            // Navigator.pushNamed(context, "About");
            Get.toNamed('/about');
          }
        ),
      ],
    );
  }

  Widget buildSubItem() {
    Color textColor = Theme.of(context).colorScheme.primary;

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FollowersPage(userName: Global.profile.lastLogin!)
                  )
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user.followers!.toString(), style: TextStyle(fontSize: 14.0, color: textColor)),
                Row(
                  children: [
                    Icon(Icons.people_rounded, color: Colors.grey, size: 18.0),
                    Text('关注者'.padLeft(3), style: TextStyle(fontSize: 12.0, color: Colors.grey))
                  ],
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FollowingsPage(userName: Global.profile.lastLogin!)
                  )
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user.following!.toString(), style: TextStyle(fontSize: 14.0, color: textColor)),
                Row(
                  children: [
                    Icon(Icons.emoji_people_rounded, color: Colors.grey, size: 18.0),
                    Text('正在关注'.padLeft(3), style: TextStyle(fontSize: 12.0, color: Colors.grey))
                  ],
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('0', style: TextStyle(fontSize: 14.0, color: textColor)),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.grey, size: 18.0),
                  Text('获得的星标'.padLeft(3), style: TextStyle(fontSize: 12.0, color: Colors.grey))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _logout() {
    final UserController userController = Get.find<UserController>();

    Get.dialog(
      AlertDialog(
        title: const Text('提示'),
        content: const Text('确认注销用户吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              userController.logout();
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }
}