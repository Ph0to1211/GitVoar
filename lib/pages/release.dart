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

  @override
  _ReleasePageState createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  List<dynamic> _items = [];

  bool _hasMore = true;
  bool _isLoading = false;
  int _page = 1;

  final DateFormat _dateFormat = DateFormat('M月d日');
  final DateFormat _fullDateFormat = DateFormat('yyyy年M月d日');
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _items.add(null);
    // _initializeData();
  }

  Future<void> _initializeData() async {
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        if (_items[index] == null) {
          if (_hasMore) {
            _getData();
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0,),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        Release release = _items[index];
        if (index == 0) {
          return _buildPrimaryItem(release); // 第一个项作为主项
        } else if (index == 1) {
          return const Divider(color: Colors.grey, height: .0, thickness: .0);
        } else {
          return _buildItem(release); // 其他项作为普通项
        }
      },
    );
  }

  Widget _buildPrimaryItem(Release release) {
    String publishDate;
    if (release.publishedAt.year == currentYear) {
      publishDate = _dateFormat.format(release.publishedAt);  // 如果是今年，只显示月份和日期
    } else {
      publishDate = _fullDateFormat.format(release.publishedAt);  // 否则，显示完整日期（包括年份）
    }

    const int maxLength = 100;

    String bodyPreview = release.body.length > maxLength
        ? '${release.body.substring(0, maxLength)}...'
        : release.body;

    return InkWell(
      onTap: () => _navigateToDetailPage(release),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    release.name,
                    style: const TextStyle(fontSize: 24.0),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10.0),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200], // 按钮的背景色
                  ),
                  child: const Text('最新发行版'),
                ),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage: NetworkImage(release.author.avatarUrl!),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(release.author.login!),
                ),
                Text('发布于 $publishDate'),
              ],
            ),
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MarkdownBody(data: bodyPreview),
            ),),
          ],
        ),
      ),
    );
  }


  Widget _buildItem(Release release) {
    String publishDate;
    if (release.publishedAt.year == currentYear) {
      publishDate = _dateFormat.format(release.publishedAt);  // 如果是今年，只显示月份和日期
    } else {
      publishDate = _fullDateFormat.format(release.publishedAt);  // 否则，显示完整日期（包括年份）
    }

    return ListTile(
      title: Text(release.name),
      subtitle: Text(publishDate),
      onTap: () => _navigateToDetailPage(release),
    );
  }

  // 提取出导航跳转逻辑，避免代码重复
  void _navigateToDetailPage(Release release) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReleaseDetailPage(release: release),
      ),
    );
  }

  void _getData() async {
    if (_isLoading) return;
    _isLoading = true;
    List<dynamic> items;

    items = await Git(context).getReleases(
      repoName: widget.repoName,
      queryParameters: {'page': _page, 'per_page': 10},
    );

    _hasMore = items.isNotEmpty && items.length % 10 == 0;

    setState(() {
      if (_items.isNotEmpty) {
        _items.insertAll(_items.length - 1, items);
      } else {
        _items.addAll(items);
      }
      _page++;
      _isLoading = false;
    });
  }
}
