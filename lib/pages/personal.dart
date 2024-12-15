import 'package:flutter/material.dart';
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
  PersonalPage({super.key});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  Color _editIconBackgroundColor = Colors.white;
  User user = Global.profile.user!;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.logout_rounded,
                          size: 20.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.login!, style: TextStyle(fontSize: 30.0)),
                    buildSubItem()
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(color: Colors.grey, height: .0, thickness: .0),
        ListTile(
          leading: Icon(Icons.book_rounded, color: Colors.black),
          title: Text('仓库'),
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
          leading: Icon(Icons.people_rounded, color: Colors.orange),
          title: Text('组织'),
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
          leading: Icon(Icons.star_rounded, color: Colors.yellow),
          title: Text('已加星标'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        StarredReposPage(userName: Global.profile.lastLogin!)
                )
            );
          },
        ),
        Divider(color: Colors.grey, height: .0, thickness: .0),
        ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text('设置'),
            onTap: () {
              Navigator.pushNamed(context, "Setting");
            }
        ),
        ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('关于'),
            onTap: () {
              Navigator.pushNamed(context, "About");
            }
        ),
      ],
    );
  }

  Widget buildSubItem() {
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
                Text(user.followers!.toString(), style: TextStyle(fontSize: 14.0)),
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
                Text(user.following!.toString(), style: TextStyle(fontSize: 14.0)),
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
              Text('0', style: TextStyle(fontSize: 14.0)),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认注销用户吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                var userModel = Provider.of<UserModel>(context, listen: false);
                userModel.setLoginStatus(false);
              },
              child: const Text('确认'),
            )
          ],
        );
      }
    );
  }

}