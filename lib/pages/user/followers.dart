import 'package:flutter/material.dart';
import 'package:my_github/pages/templates/list_template.dart';

import '../../common/widgets/user_item.dart';
import '../../http/git.dart';
import '../../models/user.dart';

class FollowersPage extends StatelessWidget {
  final String userName;

  const FollowersPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ListTemplate<User>(
      title: const Text('关注者'),
      fetchData: (page, refresh) => Git(context).getFollowers(
        userName: userName,
        queryParameters: {'page': page, 'per_page': 10},
        refresh: refresh,
      ),
      itemBuilder: (user) => UserItem(user),
      actions: const [],
    );
  }
}