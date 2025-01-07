import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/pages/commit.dart';
import 'package:my_github/pages/content.dart';
import 'package:my_github/pages/release.dart';
import 'package:my_github/pages/repo/fork_repos.dart';
import 'package:my_github/pages/user/stargazers.dart';
import 'package:my_github/pages/detail/user_datail.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/repo.dart';

class RepoDetailPage extends StatefulWidget {
  final Repo repo;

  const RepoDetailPage({super.key, required this.repo});

  @override
  _RepoDetailPageState createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage> {
  // final ValueNotifier<bool> _starred = ValueNotifier(false);
  late Future<bool> _starred;
  final ScrollController _controller = ScrollController();

  bool showToTopBtn = false;
  bool showTitle = false;

  String mdBase64 = '';

  @override
  void initState() {
    super.initState();
    _starred = Git(context).checkStarred(widget.repo.fullName!);
    // _initializeStarStatus();
    _getMD();

    // 添加滚动监听
    _controller.addListener(() {
      if (_controller.offset >= 300 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      } else if (_controller.offset < 300 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      }

      if (_controller.offset >= 150 && !showTitle) {
        setState(() {
          showTitle = true;
        });
      } else if (_controller.offset < 150 && showTitle) {
        setState(() {
          showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> _initializeStarStatus() async {
  //   bool isStarred = await Git(context).checkStarred(widget.repo.fullName!);
  //   _starred.value = isStarred;
  // }

  Future<void> _getMD() async {
    try {
      mdBase64 = await Git(context).getREADME(widget.repo.fullName);
      setState(() {}); // 更新状态，触发重新构建
    } catch (e) {
      print("Error loading README: $e");
    }
  }

  String formatNumberToK(int number) {
    if (number >= 1000) {
      // 转为千位单位，保留一位小数
      double value = number / 1000;
      return '${value.toStringAsFixed(1)}k';
    }
    return number.toString(); // 小于 1000 的数字直接返回
  }

  @override
  Widget build(BuildContext context) {
    String decodedData = _decodeBase64(mdBase64);
    String starCount = formatNumberToK(widget.repo.stargazersCount!);
    var forkCount = widget.repo.forksCount!.toString();
    var issueCount = widget.repo.openIssuesCount!.toString();

    Color iconColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          FutureBuilder<bool>(
            future: _starred,
            builder: (context, snapshot) {
              bool isStarred;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                isStarred = true;
              } else {
                isStarred = false;
              }
              return IconButton(
                onPressed: () async {
                  bool result;
                  if (isStarred) {
                    result = await Git(context).delStar(widget.repo.fullName!);
                  } else {
                    result = await Git(context).addStar(widget.repo.fullName!);
                  }
                  if (result) {
                    setState(() {
                      _starred = Git(context).checkStarred(widget.repo.fullName!);
                    });
                  }
                },
                icon: Icon(
                  isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isStarred ? Colors.yellow : Colors.black,
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) async {
              // 根据选中的菜单项执行操作
              if (value == 'Option 1') {
                print("分享");
                Share.share(widget.repo.htmlUrl!);
              } else if (value == 'Option 2') {
                await launchUrl(
                  Uri.parse(widget.repo.htmlUrl!),
                  mode: LaunchMode.externalApplication
                );
                print("浏览器打开");
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded),
                      SizedBox(width: 10),
                      Text('分享'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Row(
                    children: const [
                      Icon(Icons.open_in_browser_rounded),
                      SizedBox(width: 10),
                      Text('在浏览器打开'),
                    ],
                  ),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
        title: AnimatedOpacity(
          opacity: showTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.repo.name!,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text(widget.repo.owner!.login!,
                  style: const TextStyle(fontSize: 12.0))
            ],
          ),
        ),
      ),
      body: ListView(
        controller: _controller,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.repo.owner!.login!,
                    style: const TextStyle(fontSize: 16.0)),
                Text(
                  widget.repo.name!,
                  style: const TextStyle(
                      fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.repo.owner!.login!,
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDetailPage(user: widget.repo.owner!)
                                )
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              widget.repo.owner!.avatarUrl!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: (widget.repo.description != null)
                          ? Text(
                              widget.repo.description!,
                              style: const TextStyle(fontSize: 16),
                            )
                          : const Text(
                              "无简介",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                  child: Material(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StargazersPage(repoName: widget.repo.fullName!)
                                )
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Row(children: [
                            Icon(Icons.star_outline_rounded, size: 22.0, color: iconColor),
                            Text(
                              ' $starCount 个星标',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ])
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForkReposPage(repoName: widget.repo.fullName!)
                                )
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Row(children: [
                            Icon(Icons.merge_rounded, size: 22.0, color: iconColor),
                            Text(
                              ' $forkCount 个复刻',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ])
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(15),
                          child: Row(children: [
                            Icon(Icons.bug_report_rounded, size: 22.0, color: iconColor),
                            Text(
                              ' $issueCount 个议题',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ])
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: .0, thickness: .0),
          buildListTile(Icons.folder_rounded, '文件', '', Colors.orange, () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        ContentPage(repoName: widget.repo.fullName!, branch: widget.repo.defaultBranch!)
                )
            );
          }),
          buildListTile(Icons.commit_rounded, '提交', '', Colors.grey, () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommitPage(repoName: widget.repo.fullName!)
                )
            );
          }),
          buildListTile(
              Icons.bug_report_rounded, '议题', issueCount, Colors.green, () {}),
          buildListTile(Icons.new_releases_rounded, '发行版', '', Colors.grey, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReleasePage(repoName: widget.repo.fullName!,)
                )
            );
          }),
          buildListTile(Icons.people_rounded, '关注者', '', Colors.orange, () {}),
          const Divider(color: Colors.grey, height: .0, thickness: .0),
          const Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: .0),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 20.0, color: Colors.grey),
                SizedBox(width: 10.0),
                Text('README.md',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey)),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: MarkdownBody(data: decodedData),
          ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var tween =
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
          var curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        child: !showToTopBtn
            ? null
            : FloatingActionButton(
                child: const Icon(Icons.keyboard_arrow_up_rounded),
                onPressed: () {
                  _controller.animateTo(.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              ),
      ),
    );
  }

  Widget buildListTile(
      IconData icon, String title, String trailing, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      onTap: onTap,
      trailing: Text(trailing,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
    );
  }

  String _decodeBase64(String base64String) {
    try {
      String cleanBase64String = base64String.replaceAll('\n', '');
      List<int> bytes = base64.decode(cleanBase64String);
      var readme = utf8.decode(bytes);
      RegExp exp = RegExp(r'(\[!\[.*?\]\(.*?\)\]\(.*?\))|(!?\[.*?\]\(.*?\))');
      String cleanedReadme = readme.replaceAll(exp, '[]()');
      return cleanedReadme;
    } catch (e) {
      print("Base64 解码失败: $e");
      return '';
    }
  }
}
