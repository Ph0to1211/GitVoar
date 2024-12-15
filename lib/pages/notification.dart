import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Center(child: Text('未读')),
        Center(child: Text('已保存')),
        Center(child: Text('已完成'))
      ]
    );
  }
}