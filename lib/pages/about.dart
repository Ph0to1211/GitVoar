import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
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
        title: Text('关于'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80.0,
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/171119474?v=4'
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            Text(
                'GitVoar 是使用Flutter开发的第三方github，旨在新手学习与探索移动开发，还在不断开发中，欢迎star',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0)
            )
          ],
        ),
      ),
    );
  }
}