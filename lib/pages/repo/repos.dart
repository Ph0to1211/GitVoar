import 'package:flutter/material.dart';
import 'package:my_github/pages/templates/list_template.dart';

import '../../common/widgets/repo_item.dart';
import '../../http/git.dart';
import '../../models/repo.dart';

class ReposPage extends StatelessWidget {
  final String userName;

  const ReposPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<Repo>(
      title: Text('$userName 的仓库'),
      fetchData: (page, refresh) => Git(context).getRepos(
        userName: userName,
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (repo) => RepoItem(repo),
      actions: const [],
    );
  }
}
