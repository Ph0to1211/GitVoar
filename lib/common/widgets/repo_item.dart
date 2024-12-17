import 'package:flutter/material.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/pages/detail/repo_detail.dart';

import '../../models/repo.dart';

class RepoItem extends StatefulWidget {
  RepoItem(this.repo) : super(key: ValueKey(repo.id));

  final Repo repo;

  @override
  _RepoItemState createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    var subtitle;
    return Material(
      child: InkWell(
        onTap: () async {
          Repo repo = await Git(context).addOwner(widget.repo);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RepoDetailPage(repo: repo)
              )
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                  dense: true,
                  leading: Hero(
                    tag: widget.repo.owner!.login!,
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(
                        widget.repo.owner!.avatarUrl!,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.repo.owner!.login!,
                    // textScaler: .9,
                  ),
                  subtitle: subtitle,
                  trailing: Text(widget.repo.language!)
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.repo.name!,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: widget.repo.fork!
                              ? FontStyle.italic
                              : FontStyle.normal
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 8.0),
                        child: widget.repo.description == null
                            ? Text(
                            "无简介",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[700]
                            )
                        )
                            : Text(
                          widget.repo.description!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.blueGrey[700],
                              fontSize: 13.0
                          ),
                        )
                    ),
                    _buildBottom()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    const paddingWidth = 10;
    return IconTheme(
      data: const IconThemeData(
        color: Colors.grey,
        size: 15.0
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.grey, fontSize: 12.0),
        child: Builder(
          builder: (context) {
            var children = <Widget>[
              Row(children: [
                Icon(Icons.star_rounded, color: Colors.grey, size: 20.0),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Text(widget.repo.stargazersCount.toString())
              ],),
              Row(children: [
                Icon(Icons.info_outline_rounded, size: 20.0),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Text(widget.repo.openIssuesCount.toString())
              ],),
              Row(children: [
                Icon(Icons.fork_right_rounded, color: Colors.grey, size: 20.0),
                Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                Text(widget.repo.forksCount.toString())
              ],),
              _parent()
            ];

            // if (widget.repo.fork!) {
            //   children.add(Text("分支".padRight(paddingWidth)));
            // }

            if (widget.repo.private!) {
              children.insertAll(
                  children.length - 1,
                  <Widget>[
                    Row(children: [
                      Icon(Icons.lock_rounded, color: Colors.grey, size: 18.0),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                      Text('私人')
                    ],)
                  ]
              );
            }
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children
            );
          },
        ),
      ),
    );
  }

  Widget _parent() {
    if (widget.repo.fork!) {
      var parentName = widget.repo.parent;
      return Text(
        "复刻自: $parentName"
      );
    } else {
      return Padding(padding: EdgeInsets.symmetric(horizontal: 60.0));
    }
  }

  Widget _languageText(String content) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.grey,
        border: Border.all(color: Colors.grey, width: 1.0), // 设置边框颜色和宽度
        borderRadius: BorderRadius.circular(10.0), // 可选，设置圆角
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0), // 可选，增加内边距
        child: Text(content),
      ),
    );
  }
}

