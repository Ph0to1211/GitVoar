import 'package:flutter/material.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/models/repo.dart';

import '../../common/widgets/repo_item.dart';

class MyRepoPage extends StatefulWidget {
  const MyRepoPage({super.key});

  @override
  _MyRepoPageState createState() => _MyRepoPageState();
}

class _MyRepoPageState extends State<MyRepoPage> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //   GlobalKey<RefreshIndicatorState>();
  static const loadingTag = '##loading##';
  var _items = <Repo>[Repo()..name = loadingTag];
  bool hasMore = true;
  int page = 1;

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
        title: const Text('我的仓库'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
          IconButton(onPressed: _refreshData, icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      key: Key('refresh_indicator'),
      onRefresh: _refreshData,
      child: ListView.separated(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          if (_items[index].name == loadingTag) {
            if (hasMore) {
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
          return RepoItem(_items[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.white30,
            height: .0,
            thickness: .0,
          );
        },
      ),
    );
  }

  void _getData({bool refresh = false}) async {
    var repos = await Git(context).getMyRepos(
      queryParameters: {
        'page': page,
        'per_page': 5
      },
      refresh: refresh
    );
    hasMore = repos.length > 0 && repos.length % 5 == 0;

    // setState(() {
    //   _items.insertAll(repos.length - 1, repos);
    //   page++;
    // });
    setState(() {
      if (_items.isNotEmpty) {
        _items.insertAll(_items.length - 1, repos);
      } else {
        _items.addAll(repos);
      }
      page++;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      page = 1;
      _items = <Repo>[Repo()..name = loadingTag];
      hasMore = true;
    });
    _getData(refresh: true);
  }
}
