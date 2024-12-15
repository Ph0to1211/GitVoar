import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主页'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
        children: [
          SizedBox(height: 100.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('我的工作', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.bug_report, color: Colors.green),
            title: Text('议题'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.merge_type, color: Colors.blue),
            title: Text('拉取请求'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.comment, color: Colors.purple),
            title: Text('讨论'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.view_list, color: Colors.grey),
            title: Text('项目'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.black),
            title: Text('仓库'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.orange),
            title: Text('组织'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.yellow),
            title: Text('已加星标'),
            onTap: () {},
          ),
          SizedBox(height: 20),
          Text('收藏夹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://tiebapic.baidu.com/forum/pic/item/ec124890f603738d1ef68a06f51bb051f819ec6e.jpg?tbpicau=2024-11-24-05_d0338ab84d5809acdc7096f428976818'), // 替换为实际图像 URL
            ),
            title: Text('guozhigg'),
            subtitle: Text('pilipala'),
            onTap: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '通知'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人资料'),
        ],
      ),
    );
  }
}
