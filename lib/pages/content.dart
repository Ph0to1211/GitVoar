import 'dart:convert';

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
  String _fileContent = '';

  bool _isLoading = false;
  bool _fileView = false;

  @override
  void initState() {
    super.initState();
    _replaceItems(_navigation.first);
  }

  void _replaceItems(String path) async {
    setState(() {
      _isLoading = true;
    });
    var data = await Git(context).getContent(
        repoName: widget.repoName,
        path: path,
        branch: widget.branch
    );
    setState(() {
      _items = data as List<Content>;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_navigation.length > 1) ? _buildTitle(_navigation.last) : const Text('文件'),
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
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
      if (_fileView) {
        return _buildFileView();
      } else {
        return ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return _buildItem(_items[index]);
          },
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator()
      );
    }
  }

  Widget _buildFileView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: .0),
      child: SelectableText(_fileContent),
    );
  }

  Widget _buildTitle(String title) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SelectableText(title),
      ),
    );
  }
  
  Widget _buildItem(Content content) {
    return ListTile(
      leading: (content.type == 'dir')
          ? const Icon(Icons.folder_rounded, color: Colors.orange)
          : const Icon(Icons.insert_drive_file_rounded, color: Colors.grey),
      title: Text(content.name),
      onTap: () {
        if (content.type == 'dir') {
          _replaceItems(content.path);
          setState(() {
            _navigation.add(content.path);
          });
        } else if (content.type == 'file') {
          _parseFileContent(content);
        }
      },
    );
  }

  Future<bool> _pop() {
    if (_fileView) {
      setState(() {
        _fileView = false;
        _navigation.removeLast();
      });
      return Future.value(false);
    } else if (_navigation.length > 1) {
      _replaceItems(_navigation[_navigation.length-2]);
      setState(() {
        _navigation.removeLast();
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _parseFileContent(Content content) async {
    setState(() {
      _isLoading = true;
    });
    var response = await Git(context).getContent(
      repoName: widget.repoName,
      path: content.path,
      branch: widget.branch
    );
    var contentEncoded = response as Content;
    String str = contentEncoded.content!.replaceAll('\n', '');
    List<int> bytes = base64.decode(str);
    var contentDecoded = utf8.decode(bytes);
    setState(() {
      _navigation.add(content.path);
      _fileContent = contentDecoded;
      _fileView = true;
      _isLoading = false;
    });
  }

}
