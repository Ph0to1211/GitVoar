import 'package:flutter/material.dart';
import 'package:my_github/pages/templates/list_template.dart';

import '../../common/widgets/repo_item.dart';
import '../../http/git.dart';
import '../../models/repo.dart';

class ForkReposPage extends StatelessWidget {
  final String repoName;

  const ForkReposPage({super.key, required this.repoName});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<Repo>(
      title: Text(
        '$repoName 的复刻',
        style: TextStyle(fontSize: 18.0),
      ),
      fetchData: (page, refresh) => Git(context).getForks(
        repoName: repoName,
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (repo) => RepoItem(repo),
      actions: const [],
    );
  }
}