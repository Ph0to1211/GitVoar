import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.primary;

    return ListView(
      children: [
        ListTile(
          title: Text(
            '发现',
            style: TextStyle(fontSize: 15, color: textColor),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
            onPressed: () {},
          ),
          onTap: null,
        ),
        ListTile(
          leading: Icon(Icons.local_fire_department_rounded, color: Colors.red),
          title: Text('热门仓库'),
          onTap: () {
            Navigator.pushNamed(context, "HotRepos");
          },
        ),
        ListTile(
          leading: Icon(Icons.tag_faces_rounded, color: Colors.deepPurpleAccent),
          title: Text('精选列表'),
          onTap: () {},
        ),
        const Divider(color: Colors.grey, height: .0, thickness: .0,
        ),
        ListTile(
          title: Text(
            '动态',
            style: TextStyle(fontSize: 15, color: textColor),
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
              '查看您的仓库最新动态',
              style: TextStyle(
                  fontSize: 16.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                '往收藏夹添加些什么...',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600]
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
