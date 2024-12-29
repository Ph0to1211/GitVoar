import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/pages/detail/release_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/release.dart';

class ReleasePage extends StatefulWidget {
  final String repoName;

  const ReleasePage({super.key, required this.repoName});

  _ReleasePageState createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  bool _isLoading = false;
  int _page = 1;

  List<Release> _items = [];

  @override
  void initState() {
    super.initState();
    initializeData();

  }

  Future<void> initializeData() async {
    setState(() {
      _isLoading = true;
    });
    List<Release> data = await Git(context).getReleases(
      repoName: widget.repoName,
      queryParameters: {'page': _page, 'per_page': 10},
    );
    setState(() {
      _items = data;
      _page += 1;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repoName}的发行版'),
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isLoading) {
      return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildPrimaryItem(_items[index]);
          } else {
            return _buildItem(_items[index]);
          }
          // return _buildItem(_items[index]);
        },
      );
    } else {
      return const Center(
          child: CircularProgressIndicator()
      );
    }
  }

  Widget _buildPrimaryItem(Release release) {
    DateFormat dateFormat = DateFormat('M月d日');
    String publishDate = dateFormat.format(release.publishedAt);

    return Container(
      height: 350.0,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReleaseDetailPage(release: release)
              )
          );
        },
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        release.name,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      const SizedBox(width: 10.0),
                      TextButton(
                        onPressed: () {},
                        child: Text('最新发行版'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200], // 按钮的背景色
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                          release.author.avatarUrl!,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(release.author.login!),
                      ),
                      Text('发布于 $publishDate'),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: MarkdownBody(data: release.body),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Release release) {
    DateFormat dateFormat = DateFormat('M月d日');
    String publishDate = dateFormat.format(release.publishedAt);

    return ListTile(
      title: Text(release.name),
      subtitle: Text(publishDate),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) =>
                  ReleaseDetailPage(release: release)
            )
        );
      },
    );
  }

}
