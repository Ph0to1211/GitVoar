import 'package:flutter/material.dart';
import 'package:my_github/common/widgets/user_item.dart';
import 'package:my_github/http/git.dart';

import '../common/widgets/repo_item.dart';
import '../models/repo.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showToTopBtn = false;

  final TextEditingController _searchController = TextEditingController();
  var _historyItems = <String>[''];
  bool _hasText = false;
  String _keyword = '';
  bool _isSearch = false;

  bool _isSearchRepo = true;

  static const loadingTag = '##loading##';
  // var _resultItems = <Repo>[Repo()..name = loadingTag];
  List<dynamic> _resultItems = [];
  bool _hasMore = true;
  bool isLoading = false;
  int page = 1;

  void initState() {
    super.initState();
    _resultItems.add(null);
    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
    });

    _scrollController.addListener(() {
      // print(_controller.offset);
      if (_scrollController.offset < 300 && _showToTopBtn) {
        setState(() {
          _showToTopBtn = false;
        });
      }else if (_scrollController.offset >= 300 && !_showToTopBtn) {
        setState(() {
          _showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    if (_keyword != '') {
      // 执行搜索逻辑
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜索内容: $_keyword')),
      );
      String type = (_isSearchRepo) ? '仓库: ' : '用户: ';
      setState(() {
        if (!_historyItems.contains(_keyword)) {
          _historyItems.insert(0, type + _keyword);
        } else if (_historyItems.length <= 21 ) {
          _historyItems.remove(_keyword);
          _historyItems.insert(0, type +_keyword);
        } else {
          _historyItems.removeAt(-1);
          _historyItems.insert(0, type + _keyword);
        }
        _isSearch = true;

        _resultItems = [];
        _resultItems.add(null);
        _hasMore = true;
        page = 1;
        _getData();
      });
    }
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
        title: TextField(
          controller: _searchController,
          onChanged: (text) {
            setState(() {
              _keyword = text;
            });
          },
          onSubmitted: (value) => _submitSearch(),
          textInputAction: TextInputAction.search,
          autofocus: !_isSearch,
          decoration: InputDecoration(
            // labelText: '搜索',
            hintText: '搜索...',
            border: UnderlineInputBorder(),
            suffixIcon: _hasText ? IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _keyword = '';
                  _isSearch = false;
                });
              },
              icon: Icon(Icons.clear_rounded, size: 22.0),
            ) : null
          ),
        ),
        actions: [
          IconButton(
            onPressed: _submitSearch,
            icon: Icon(Icons.search_rounded),
          )
        ],
      ),
      body: _getContent(),
      floatingActionButton: _isSearch ? AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
          var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        child: !_showToTopBtn ? null : FloatingActionButton(
          child: const Icon(Icons.keyboard_arrow_up_rounded),
          onPressed: () {
            _scrollController.animateTo(.0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ) : null,
    );
  }

  Widget _getContent() {
    if (!_isSearch) {
      if (_keyword.isEmpty) {
        return _history();
      } else {
        return _options();
      }
    } else {
      if (_keyword.isEmpty) {
        return _history();
      } else {
        return _searchResult();
      }
    }
  }

  Widget _options() {
    return ListView(
      children: [
        ListTile(
          leading: Text('搜索仓库：$_keyword', style: TextStyle(fontSize: 15.0)),
          trailing: const Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
          onTap: () {
            setState(() {
              _isSearchRepo = true;
              _isSearch = true;
            });
            _submitSearch();
          },
        ),
       ListTile(
          leading: Text('搜索用户：$_keyword', style: TextStyle(fontSize: 15.0)),
          trailing: const Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
         onTap: () {
           setState(() {
             _isSearchRepo = false;
             _isSearch = true;
           });
           _submitSearch();
         },
        ),
      ],
    );
  }

  Widget _history() {
    if (_historyItems.length > 1) {
      return ListView.builder(
        itemCount: _historyItems.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
                leading: Text(
                    '搜索历史：',
                    style: TextStyle(fontSize: 15.0)
                ),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _historyItems = [''];
                      });
                    },
                    icon: Icon(Icons.cleaning_services_rounded, size: 22.0, color: Colors.grey)
                )
            );
          } else {
            return ListTile(
              leading: Text(
                  _historyItems[index - 1],
                  style: TextStyle(fontSize: 16.0)
              ),
              trailing: Icon(Icons.arrow_forward_rounded, size: 22.0, color: Colors.grey),
              onTap: () {
                setState(() {
                  _searchController.text = RegExp(r'(?<=: ).*').stringMatch(_historyItems[index - 1]) ?? '';
                  _keyword = RegExp(r'(?<=: ).*').stringMatch(_historyItems[index - 1]) ?? '';
                  _isSearch = true;
                  _resultItems = [null];
                  _hasMore = true;
                  page = 1;
                  _getData();
                });
              },
            );
          }
        },
      );
    } else {
      return const Center(
        child: Text('它需要做点什么...', style: TextStyle(fontSize: 18.0))
      );
    }
  }

  Widget _searchResult() {
    return (_resultItems.length >= 1) ? Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: _resultItems.length,
        itemBuilder: (context, index) {
          if (_resultItems[index] == null) {
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
          return (_isSearchRepo) ? RepoItem(_resultItems[index]) : UserItem(_resultItems[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            height: .0,
            thickness: .0,
          );
        },
      ),
    ) : const Center(child: Text(
      '你似乎来到了荒芜之地...',
      style: TextStyle(fontSize: 18.0)
    ));
  }

  void _getData() async {
    if (isLoading) return;
    isLoading = true;
    List<dynamic> items;

    if (_isSearchRepo) {
      items = await Git(context).searchRepo(
          keyword: _keyword,
          queryParameters: {
            'page': page,
            'per_page': 10
          }
      );
    } else {
      items = await Git(context).searchUser(
          keyword: _keyword,
          queryParameters: {
            'page': page,
            'per_page': 10
          }
      );
    }

    _hasMore = items.isNotEmpty && items.length % 10 == 0;

    setState(() {
      if (_resultItems.isNotEmpty) {
        _resultItems.insertAll(_resultItems.length - 1, items);
      } else {
        _resultItems.addAll(items);
      }
      page++;
      isLoading = false;
    });
  }

}