import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/pages/login/login.dart';
import 'package:my_github/pages/notification.dart';
import 'package:my_github/pages/personal.dart';
import 'package:my_github/pages/explore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/status.dart';
import 'repo/repos.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectIndex = 2;

  DateTime? _lastPressedAt;

  Widget getPage(int index) {
    switch (index) {
      // case 0:
      //   return WorkPage();
      case 0:
        return ExplorePage();
      case 1:
        return NotificationPage();
      case 2:
        return PersonalPage();
      default:
        return LoginPage();
    }
  }

  String getTitle(int index) {
    switch (index) {
      // case 0:
      //   return "主页";
     case 0:
        return "探索";
     case 1:
        return "通知";
     case 2:
        return "个人";
     default:
        return "登录";
    }
  }

  void _switchPage(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  TextEditingController _searchCtr = TextEditingController();

  List<Widget> _buildActions() {
    // if (_selectIndex == 0) {
    //   return [
    //     IconButton(
    //       icon: const Icon(Icons.search_rounded),
    //       onPressed: () {},
    //     ),
    //    IconButton(
    //       icon: const Icon(Icons.add_circle_outline_rounded),
    //       onPressed: () {},
    //     ),
    //    IconButton(
    //       icon: const Icon(Icons.more_vert_rounded),
    //       onPressed: () {},
    //     ),
    //   ];
    // }
    if (_selectIndex == 0) {
      return [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            Get.toNamed('/search');
          },
        ),
      ];
    }
    if (_selectIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.compare_arrows_rounded),
          onPressed: () {
            Get.toNamed('/login');
          },
        ),
        PopupMenuButton<String>(
          onSelected: (String value) async {
            // 根据选中的菜单项执行操作
            if (value == 'Option 1') {
              print("分享");
              Share.share("https://github.com/${Global.profile.lastLogin}");
            } else if (value == 'Option 2') {
              await launchUrl(
                  Uri.parse("https://github.com/${Global.profile.lastLogin}"),
                  mode: LaunchMode.externalApplication
              );
              print("浏览器打开");
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'Option 1',
                child: Row(
                  children: [
                    Icon(Icons.share_rounded),
                    SizedBox(width: 10),
                    Text('分享'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Option 2',
                child: Row(
                  children: const [
                    Icon(Icons.open_in_browser_rounded),
                    SizedBox(width: 10),
                    Text('在浏览器打开'),
                  ],
                ),
              ),
            ];
          },
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ];
    }
    else {
      return [];
    }
  }

  PreferredSizeWidget _buildTabBar() {
    if (_selectIndex == 1) {
      return const TabBar(
        tabs: [
          Tab(text: '未读'),
          Tab(text: '已保存'),
          Tab(text: '已完成'),
        ],
      );
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(getTitle(_selectIndex)),
          actions: _buildActions(),
          bottom: _buildTabBar(),
        ),
        body: WillPopScope(
          onWillPop: _exitApp,
          child: getPage(_selectIndex),
        ),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _selectIndex,
          onDestinationSelected: _switchPage,
          destinations: [
            // NavigationDestination(
            //   icon: Icon(_selectIndex == 0 ? Icons.home_rounded : Icons.home_outlined),
            //   label: "主页",
            // ),
            NavigationDestination(
              icon: Icon(_selectIndex == 0 ? Icons.explore_rounded : Icons.explore_outlined),
              label: "探索",
            ),
            NavigationDestination(
              icon: Icon(_selectIndex == 1 ? Icons.notifications_rounded : Icons.notifications_outlined),
              label: "通知",
            ),
            NavigationDestination(
              icon: Icon(_selectIndex == 2 ? Icons.account_circle_rounded : Icons.account_circle_outlined),
              label: "个人",
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp() {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
      Fluttertoast.showToast(
        msg: "再按一次退出应用",
        gravity: ToastGravity.BOTTOM,
      );
      _lastPressedAt = DateTime.now();
      return Future.value(false);
    }
    return Future.value(true);
  }

}
