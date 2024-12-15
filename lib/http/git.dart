import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_github/common/global.dart';
import 'package:my_github/models/repo.dart';
import 'package:my_github/models/user.dart';
import 'package:provider/provider.dart';

import '../common/status.dart';

class Git {
  Git(this.context) {
    _options = Options(extra: {'Context': context});
  }

  BuildContext? context;
  late Options _options;

  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'https://api.github.com/',
    headers: {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28'
    }
  ));


  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers['Authorization'] = Global.profile.token;
  }


  Future<User> login(String login, String pwd, BuildContext context) async {
    var token = 'Bearer $pwd';
    var response = await dio.get(
      '/user',
      options: _options.copyWith(headers: {
        'Authorization': token
      }, extra: {
        'noCache': true
      }),
    );

    // 设置全局token
    dio.options.headers['Authorization'] = token;
    Global.netCache.cache.clear();
    Global.profile.token = token;

    // 更新用户信息
    var user = User.fromJson(response.data);
    // Global.profile.user = user;

    // 更新userModel
    // var userModel = Provider.of<UserModel>(context, listen: false);
    // userModel.user = user;
    // userModel.setLoginStatus(true);

    print("用户 $login 登录成功~");
    return user;
  }

  Future<User> oauthLogin(String code, BuildContext context) async {
    final dioOauth = Dio();

    var data = {
      "client_id": "Ov23li095SyVH3RL5xo1",
      "client_secret": "d7d7b438dd273f412608b82337e28f86fb0b1897",
      "code": code,
      "redirect_uri": "http://localhost:8080",
    };

    var responseOauth = await dioOauth.post(
      'https://github.com/login/oauth/access_token',
      data: data,
      options: Options(headers: {"Accept": "application/json"})
    );
    var token = responseOauth.data!['access_token'];

    var user = login('oauthUser', token, context);
    return user;
  }

  Future<User> getUser(String login) async {
    var response = await dio.get(
      'users/$login',
      options: _options
    );
    return User.fromJson(response.data);
  }

  Future<String> getParent(String repoName) async {
    var response = await dio.get(
      'repos/$repoName',
      options: _options
    );
    return response.data['parent']['full_name'];
  }

  Future<List<Repo>> getMyRepos({
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'fresh': true, 'list': true});
    }
    var response = await dio.get<List>(
      'user/repos',
      queryParameters: queryParameters,
      options: _options,
    );
    var repos = await addOwner(response.data!);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }


  Future<List<Repo>> getMyStarred({
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'refresh': true, 'list': true});
    }
    var response = await dio.get<List>(
      'user/starred',
      queryParameters: queryParameters,
      options: _options,
    );
    var repos = await addOwner(response.data!);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }

  Future<List<Repo>> getRepos({
    required String userName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'refresh': true, 'list': true});
    }
    var response = await dio.get(
      'users/$userName/repos',
      queryParameters: queryParameters,
      options: _options,
    );
    // return response.data!.map((e) => Repo.fromJson(e)).toList();
    var repos = await addOwner(response.data!);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }

  Future<List<Repo>> getStarred({
    required String userName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'refresh': true, 'list': true});
    }
    var response = await dio.get(
      'users/$userName/starred',
      queryParameters: queryParameters,
      options: _options,
    );
    // var repos = await addParent(response.data!);
    var repos = await addOwner(response.data!);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }

  Future<List<Repo>> getForks({
    required String repoName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'refresh': true, 'list': true});
    }
    var response = await dio.get<List>(
      'repos/$repoName/forks',
      queryParameters: queryParameters,
      options: _options,
    );
    var repos = await addOwner(response.data!);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }

  Future<List<Repo>> getHot({
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    // 生成用于查询的随机star数
    Random random = Random();
    int randomStar = (5 + random.nextInt(396)) * 1000;

    if (refresh) {
      _options.extra!.addAll({'refresh': true, 'list': true});
    }
    var response = await dio.get(
      'search/repositories?q=stars:>$randomStar&sort=stars&order=desc',
      queryParameters: queryParameters,
      options: _options,
    );
    // return response.data['items'].map<Repo>((e) => Repo.fromJson(e)).toList();
    var repos = await addOwner(response.data['items']);
    return repos.map((e) => Repo.fromJson(e)).toList();
  }

  Future<String> getREADME(repoName) async {
    var response = await dio.get(
      'repos/$repoName/readme',
      options: _options
    );
    return response.data['content'];
}

  Future<List<Repo>> searchRepo({
    required String keyword,
    Map<String, dynamic>? queryParameters
  }) async {
    queryParameters!['q'] = keyword.replaceAll(RegExp(r'\s+'), '+');

    var response = await dio.get(
      '/search/repositories',
      queryParameters: queryParameters,
      options: _options.copyWith(
          extra: {
          'noCache': true
        })
    );
    return (response.data!['items'] as List<dynamic>).map((e) => Repo.fromJson(e)).toList();
  }

  Future<List<User>> searchUser({
    required String keyword,
    Map<String, dynamic>? queryParameters
  }) async {
    queryParameters!['q'] = keyword.replaceAll(RegExp(r'\s+'), '+');

    var response = await dio.get(
        '/search/users',
        queryParameters: queryParameters,
        options: _options.copyWith(
            extra: {
              'noCache': true
            })
    );
    List<User> users = [];
    for (int i=0; i<response.data!['items'].length; i++) {
      String login = response.data!['items'][i]['login'];
      User user = await getUser(login);
      users.add(user);
    }
    return users;
  }

  Future<List<User>> getStargazers({
    required String repoName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'fresh': true, 'list': true});
    }
    var response = await dio.get<List>(
      'repos/$repoName/stargazers',
      queryParameters: queryParameters,
      options: _options,
    );
    List<User> users = [];
    for (int i=0; i<response.data!.length; i++) {
      String login = response.data![i]['login'];
      User user = await getUser(login);
      users.add(user);
    }
    return users;
  }

  Future<List<User>> getFollowers({
    required String userName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'fresh': true, 'list': true});
    }
    var response = await dio.get(
      'users/$userName/followers',
      queryParameters: queryParameters,
      options: _options,
    );
    List<User> users = [];
    for (int i=0; i<response.data!.length; i++) {
      String login = response.data![i]['login'];
      User user = await getUser(login);
      users.add(user);
    }
    return users;
  }

  Future<List<User>> getFollowing({
    required String userName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'fresh': true, 'list': true});
    }
    var response = await dio.get(
      'users/$userName/following',
      queryParameters: queryParameters,
      options: _options,
    );
    List<User> users = [];
    for (int i=0; i<response.data!.length; i++) {
      String login = response.data![i]['login'];
      User user = await getUser(login);
      users.add(user);
    }
    return users;
  }

  Future<List<User>> getOrgs({
    required String userName,
    Map<String, dynamic>? queryParameters,
    refresh = false
  }) async {
    if (refresh) {
      _options.extra!.addAll({'fresh': true, 'list': true});
    }
    var response = await dio.get(
      'users/$userName/orgs',
      queryParameters: queryParameters,
      options: _options,
    );
    List<User> users = [];
    for (int i=0; i<response.data!.length; i++) {
      String login = response.data![i]['login'];
      User user = await getUser(login);
      users.add(user);
    }
    return users;
  }

  Future<List> addOwner(List repos) async {
    for (int i=0; i<repos.length; i++) {
      Map repo = repos[i];
      User owner = await getUser(repo['owner']['login']);
      repo['owner'] = owner.toJson();
      if (repo['fork']) {
        repo['parent'] = await getParent(repo['full_name']);
      }
    }
    return repos;
  }

}
