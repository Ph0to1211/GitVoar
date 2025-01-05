import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:my_github/pages/detail/user_datail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/release.dart';

class ReleaseDetailPage extends StatefulWidget {
  final Release release;

  const ReleaseDetailPage({super.key, required this.release});

  @override
  _ReleaseDetailPageState createState() => _ReleaseDetailPageState();
}

class _ReleaseDetailPageState extends State<ReleaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          widget.release.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    DateFormat dateFormat = DateFormat('M月d日');
    String publishDate = dateFormat.format(widget.release.publishedAt);

    return Builder(
      builder: (context) {
        List<Widget> items = [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage: NetworkImage(
                    widget.release.author.avatarUrl!,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailPage(user: widget.release.author)
                        )
                    );
                  },
                  child: Text(widget.release.author.login!),
                ),
                Text('发布于 $publishDate'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 5.0, bottom: 15.0),
            child: MarkdownBody(data: widget.release.body, selectable: true),
          ),
          const Divider(color: Colors.grey, height: .0, thickness: .0),
          const ListTile(
            title: Text('信息', style: TextStyle(fontSize: 15),
            ),
            onTap: null,
          ),
          ListTile(
            leading: const Icon(Icons.label_rounded, color: Colors.grey),
            title: Text(widget.release.tagName),
            onTap: () {},
          ),
          const Divider(color: Colors.grey, height: .0, thickness: .0),
        ];
        if (widget.release.assets.isNotEmpty) {
          items.add(const ListTile(
            title: Text('资源', style: TextStyle(fontSize: 15),
            ),
            onTap: null,
          ));
          for (int i = 0; i < widget.release.assets.length; i++) {
            items.add(_buildAsset(widget.release.assets[i]));
          }
        }
        return ListView(
          children: items,
        );
      },
    );
  }

  Widget _buildAsset(Asset asset) {
    return ListTile(
      leading: const Icon(Icons.file_copy_rounded, color: Colors.grey),
      title: Text(asset.name),
      subtitle: Text('${asset.size ~/ 1048576} MB'),
      trailing: IconButton(
        onPressed: () async {
          await launchUrl(
              Uri.parse(asset.browserDownloadUrl),
              mode: LaunchMode.externalApplication
          );
        },
        icon: const Icon(Icons.download_rounded, color: Colors.grey),
      ),
      onTap: () {},
    );
  }
}
