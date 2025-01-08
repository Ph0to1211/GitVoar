import 'package:flutter/material.dart';
import 'package:my_github/pages/repo/repos.dart';
import 'package:my_github/pages/repo/starred_repos.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user.dart';
import '../user/organizations.dart';

class UserDetailPage extends StatefulWidget {
  final User user;
  
  const UserDetailPage({super.key, required this.user});
  
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Option 1') {
                Share.share(widget.user.htmlUrl!);
              } else if (value == 'Option 2') {
                await launchUrl(
                    Uri.parse(widget.user.htmlUrl!),
                    mode: LaunchMode.externalApplication
                );
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
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: _buildInfo(),
          ),
          // Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          const Divider(
            color: Colors.grey,
            height: .0,
            thickness: .0,
          ),
          ListTile(
            leading: const Icon(Icons.book_rounded, color: Colors.black),
            title: const Text('仓库'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReposPage(userName: widget.user.login!)
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_rounded, color: Colors.orange),
            title: const Text('组织'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrganizationsPage(userName: widget.user.login!)
                  )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star_rounded, color: Colors.yellow),
            title: const Text('已加星标'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StarredReposPage(userName: widget.user.login!)
                  )
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Builder(
      builder: (context) {
        var items = <Widget>[
          Hero(
            tag: widget.user.login!,
            child: CircleAvatar(
              radius: 80.0,
              backgroundImage: NetworkImage(
                widget.user.avatarUrl!,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                widget.user.login!,
                style: (widget.user.name != null) ?
                const TextStyle(fontSize: 25.0) :
                const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)
            ),
          )
        ];
        if (widget.user.name != null) {
          items.insert(2, FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 9.0),
                  child: Text(
                    '#',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey, fontStyle: FontStyle.italic,),
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                    widget.user.name!,
                    style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)
                ),
                const SizedBox(width: 16.0)
              ],
            ),
          ));
        }
        if (widget.user.bio != null) {
          items.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2.0),
            child: Text(
                widget.user.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15.0, color: Colors.grey)
            ),
          ));
        }
        items.add(const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)));
        if (widget.user.company != null) {
          items.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.business_rounded, color: Colors.grey,),
              const SizedBox(width: 5.0),
              Text(
                widget.user.company!,
                style: const TextStyle(fontSize: 14.0),
              )
            ],
          ));
        }
        if (widget.user.location != null) {
          items.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.grey, size: 20.0),
              const SizedBox(width: 5.0),
              Text(
                widget.user.location!,
                style: const TextStyle(fontSize: 14.0),
              )
            ],
          ));
        }
        if (widget.user.email != null) {
          items.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_rounded, color: Colors.grey, size: 20.0),
              const SizedBox(width: 5.0),
              Text(
                widget.user.email!,
                style: const TextStyle(fontSize: 14.0),
              )
            ],
          ));
        }
        if (widget.user.blog != '') {
          items.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.link_rounded, color: Colors.grey, size: 20.0),
              const SizedBox(width: 5.0),
              Text(
                widget.user.blog!,
                style: const TextStyle(fontSize: 14.0),
              )
            ],
          ));
        }

        return Column(
          children: items,
        );
      },
    );
  }

}
