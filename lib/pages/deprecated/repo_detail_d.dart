import 'package:flutter/material.dart';

import '../../common/utils.dart';

class RepoDetailPage extends StatefulWidget {
  RepoDetailPage({super.key});

  @override
  _RepoDetailPageState createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage> {
  bool isFork = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Column(
          children: [
            Text(
              'pilipala',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'guozhigq',
              style: TextStyle(fontSize: 12.0),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils().gmAvatar(
                  'https://avatars.githubusercontent.com/u/25545225?v=4',
                  width: 80.0,
                  borderRadius: BorderRadius.circular(50.0)
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                      visible: !isFork,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0)
                      ),
                    ),
                    Text(
                      'Subtitle',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Visibility(
                      visible: isFork,
                      child: Text(
                        'Remark',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('button1'),
                ),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 16.0)
               ),
               ElevatedButton(
                  onPressed: () {},
                  child: Text('button1'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
