import 'package:flutter/material.dart';
import 'package:my_github/common/widgets/user_item.dart';
import 'package:my_github/http/git.dart';
import 'package:my_github/models/user.dart';
import 'package:my_github/pages/templates/list_template.dart';

class StargazersPage extends StatelessWidget {
  final String repoName;

  const StargazersPage({super.key, required this.repoName});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<User>(
      title: const Text('标星用户'),
      fetchData: (page, refresh) => Git(context).getStargazers(
        repoName: repoName,
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (user) => UserItem(user),
      actions: const [],
    );
  }
}

