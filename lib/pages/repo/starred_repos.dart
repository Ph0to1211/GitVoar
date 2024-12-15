import 'package:flutter/material.dart';
import 'package:my_github/pages/templates/list_template.dart';

import '../../common/widgets/repo_item.dart';
import '../../http/git.dart';
import '../../models/repo.dart';

class StarredReposPage extends StatelessWidget {
  final String userName;

  const StarredReposPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<Repo>(
      title: Text('$userName 的标星'),
      fetchData: (page, refresh) => Git(context).getStarred(
        userName: userName,
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (repo) => RepoItem(repo),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined))
      ],
    );
  }
}
