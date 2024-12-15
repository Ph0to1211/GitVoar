import 'package:flutter/material.dart';
import 'package:my_github/pages/templates/list_template.dart';

import '../../common/widgets/repo_item.dart';
import '../../http/git.dart';
import '../../models/repo.dart';

class HotReposPage extends StatelessWidget {
  const HotReposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<Repo>(
      title: const Text('热门仓库'),
      fetchData: (page, refresh) => Git(context).getHot(
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (repo) => RepoItem(repo),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined))
      ],
      maxPage: 2,
    );
  }
}
