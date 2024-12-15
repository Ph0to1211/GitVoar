import 'package:flutter/material.dart';
import 'package:my_github/models/user.dart';
import 'package:my_github/pages/detail/user_datail.dart';

class UserItem extends StatefulWidget {
  UserItem(this.user) : super(key: ValueKey(user.login));

  final User user;

  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetailPage(user: widget.user)
              )
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: widget.user.login!,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      widget.user.avatarUrl!
                  ),
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(child: _buildInfo())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Builder(
      builder: (context) {
        var items = <Widget>[
          Text(widget.user.login!)
        ];
        if (widget.user.name != null) {
          items.insert(0, Text(
            widget.user.name!,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // 防止长文本溢出
            maxLines: 1, // 限制最大行数
          ));
        }
        if (widget.user.bio != null) {
          items.add(Text(
            widget.user.bio!,
            style: TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        );
      },
    );
  }

}