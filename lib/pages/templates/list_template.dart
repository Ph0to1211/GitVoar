import 'package:flutter/material.dart';
import 'package:my_github/models/repo.dart';
import 'package:my_github/pages/detail/repo_detail.dart';

class ListTemplate<T> extends StatefulWidget {
  final Widget title;
  final PreferredSizeWidget? bottom;
  final List<IconButton>? actions;
  final Widget? customFloatingActionButton;
  final Future<List<T>> Function(int page, bool refresh) fetchData;
  final Widget Function(T item) itemBuilder;
  final int? maxPage;

  const ListTemplate({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.customFloatingActionButton,
    required this.fetchData,
    required this.itemBuilder,
    this.maxPage
  });

  @override
  _ListTemplateState<T> createState() => _ListTemplateState<T>();
}

class _ListTemplateState<T> extends State<ListTemplate<T>> {
  // static const loadingTag = '##loading##';
  final ScrollController _controller = ScrollController();
  bool showToTopBtn = false;
  bool isLoading = false;
  var _items = <T?>[];
  bool hasMore = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _items.add(null);
    _getData();
    _controller.addListener(() {
      // print(_controller.offset);
      if (_controller.offset < 300 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      }else if (_controller.offset >= 300 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  // T _createLoadingItem() {
  //   return loadingTag as T;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: (widget.actions ?? []) + [
          IconButton(onPressed: _refreshData, icon: const Icon(Icons.refresh_rounded))
        ],
        bottom: widget.bottom,
      ),
      body: (_items.length >= 1) ? RefreshIndicator(
        onRefresh: _refreshData,
        child: Scrollbar(
          controller: _controller,
          child: ListView.separated(
            controller: _controller,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              if (_items[index] == null) {
                if (hasMore) {
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
              return widget.itemBuilder(_items[index] as T);
              // T item = _items[index] as T;
              // return InkWell(
              //   onTap: () {
              //     if (item is Repo) {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => RepoDetailPage()
              //           )
              //       );
              //     }
              //   },
              //   child: widget.itemBuilder(item),
              // );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              height: .0,
              thickness: .0,
            ),
          ),
        ),
      ) : const Center(child: Text(
        '你似乎来到了荒芜之地...',
        style: TextStyle(fontSize: 18.0)
      ),),
      floatingActionButton: AnimatedSwitcher(
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
        child: !showToTopBtn ? null : FloatingActionButton(
          child: const Icon(Icons.keyboard_arrow_up_rounded),
          onPressed: () {
            _controller.animateTo(.0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  void _getData({bool refresh = false}) async {
    if (widget.maxPage != null && page > widget.maxPage!) {
      setState(() {
        hasMore = false; // 达到页数上限，停止请求
      });
      return;
    }

    if (isLoading) return;
    isLoading = true;

    var newData = await widget.fetchData(page, refresh);
    hasMore = newData.isNotEmpty && newData.length % 10 == 0;

    setState(() {
      if (refresh) {
        _items = <T?>[null];
      }
      if (_items.isNotEmpty && _items.last == null) {
        _items.removeLast();
      }
      _items.addAll(newData);
      if (hasMore) {
        _items.add(null);
      }
      page++;
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      page = 1;
      _items = <T?>[null];
      hasMore = true;
    });
    _getData(refresh: true);
  }
}
