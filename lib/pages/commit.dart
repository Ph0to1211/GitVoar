import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../http/git.dart';

class CommitPage extends StatefulWidget {
  final String repoName;

  const CommitPage({super.key, required this.repoName});

  @override
  _CommitPageState createState() => _CommitPageState();
}

class _CommitPageState extends State<CommitPage> {
  List<dynamic> _items = [];
  bool _hasMore = true;
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _items.add(null);
  }

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
        title: Text('${widget.repoName} 的提交'),
      ),
      body: ListView.builder(
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
                  child: CircularProgressIndicator(strokeWidth: 2.0),
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
          return _items[index];
        },
      ),
    );
  }

  void _getData() async {
    if (_isLoading) return;
    _isLoading = true;
    List<dynamic> items;

    items = await Git(context).getCommits(
        repoName: widget.repoName,
        queryParameters: {
          'page': _page,
          'per_page': 10
        }
    );

    _hasMore = items.isNotEmpty && items.length % 10 == 0;

    String? lastPublishDate;  // 用于保存最后一次的提交日期

    setState(() {
      for (int i = 0; i < items.length; i++) {
        DateFormat dateFormat = DateFormat('yyyy年MM月dd日');
        String publishDate = dateFormat.format(items[i].commit.author.date);

        if (lastPublishDate != publishDate) {
          // 如果日期不同，添加新的日期项
          _items.insert(_items.length - 1, ListTile(
            title: Text(
              publishDate,
              style: const TextStyle(fontSize: 15),
            ),
          ));
          lastPublishDate = publishDate; // 更新最后一次的日期
        }

        // 添加提交项
        _items.insert(_items.length - 1, ListTile(
          leading: const Icon(Icons.commit_rounded),
          title: Text(items[i].commit.message, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12.0,
                backgroundImage: NetworkImage(
                  items[i].author.avatarUrl!,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(items[i].author.login!),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text('提交'),
              ),
            ],
          ),
          onTap: () {
            _showMessage(items[i].commit.message);
          }
        ));
      }
      _page++;  // 每次加载数据后，页数加一
    });

    _isLoading = false;
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提交内容'),
          content: SelectableText(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }
}
