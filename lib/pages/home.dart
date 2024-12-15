import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_github/pages/login/login.dart';
import 'package:my_github/pages/notification.dart';
import 'package:my_github/pages/personal.dart';
import 'package:my_github/pages/search.dart';
import 'package:my_github/pages/work.dart';
import 'package:my_github/pages/explore.dart';
import 'package:provider/provider.dart';

import '../common/status.dart';
import 'repo/repos.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int _selectIndex = 3;

  DateTime? _lastPressedAt;

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return WorkPage();
      case 1:
        return NotificationPage();
      case 2:
        return ExplorePage();
      case 3:
        return PersonalPage();
      default:
        return const LoginPage();
    }
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "主页";
     case 1:
        return "通知";
     case 2:
        return "探索";
     case 3:
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
    if (_selectIndex == 0) {
      return [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {},
        ),
       IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () {},
        ),
       IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ];
    }
    if (_selectIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            Navigator.pushNamed(context, 'Search');
          },
        ),
      ];
    }
    if (_selectIndex == 3) {
      return [
        IconButton(
          icon: const Icon(Icons.compare_arrows_rounded),
          onPressed: () {
            Navigator.pushNamed(context, "login");
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
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
            NavigationDestination(
              icon: Icon(_selectIndex == 0 ? Icons.home_rounded : Icons.home_outlined),
              label: "主页",
            ),
            NavigationDestination(
              icon: Icon(_selectIndex == 1 ? Icons.notifications_rounded : Icons.notifications_outlined),
              label: "通知",
            ),
            NavigationDestination(
              icon: Icon(_selectIndex == 2 ? Icons.explore_rounded : Icons.explore_outlined),
              label: "探索",
            ),
            NavigationDestination(
              icon: Icon(_selectIndex == 3 ? Icons.account_circle_rounded : Icons.account_circle_outlined),
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
