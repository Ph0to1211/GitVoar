import 'package:flutter/material.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/models/content.dart';

class ContentPage extends StatefulWidget {
  final String repoName;
  final String branch;

  const ContentPage({super.key, required this.branch, required this.repoName});

  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final List<String> _navigation = [''];
  List<Content> _items = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    replaceItems(_navigation.first);
  }

  void replaceItems(String path) async {
    setState(() {
      _isLoading = true;
    });
    var data = await Git(context).getContent(
        repoName: widget.repoName,
        path: path,
        branch: widget.branch
    );
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_navigation.length > 1) ? _buildTitle(_navigation.last) : const Text('文件'),
        leading: IconButton(
          onPressed: (_navigation.length > 1) ? _pop : () {Navigator.pop(context);},
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fork_left_rounded),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: _pop,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (!_isLoading) {
      return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return _buildItem(_items[index]);
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator()
      );
    }
  }

  Widget _buildItem(Content content) {
    return ListTile(
      leading: (content.type == 'dir')
          ? const Icon(Icons.folder_rounded, color: Colors.orange)
          : const Icon(Icons.insert_drive_file_rounded, color: Colors.grey),
      title: Text(content.name),
      onTap: () {
        if (content.type == 'dir') {
          replaceItems(content.path);
          setState(() {
            _navigation.add(content.path);
          });
        }
      },
    );
  }

  Widget _buildTitle(String title) {
    return FittedBox(
      fit: BoxFit.scaleDown,  // 自动缩小文字，直到适应空间
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,  // 超长时水平滚动
        child: Text(title),
      ),
    );
  }

  Future<bool> _pop() {
    if (_navigation.length > 1) {
      replaceItems(_navigation[_navigation.length-2]);
      setState(() {
        _navigation.removeLast();
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
