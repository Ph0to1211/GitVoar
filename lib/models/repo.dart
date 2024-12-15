import 'dart:convert';

import 'package:my_github/models/user.dart';

List<Repo> repoFromJson(String str) => List<Repo>.from(json.decode(str).map((x) => Repo.fromJson(x)));

String repoToJson(List<Repo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Repo {
  int? id;
  String? name;
  String? fullName;
  bool? private;
  User? owner;
  String? htmlUrl;
  String? description;
  bool? fork;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? pushedAt;
  int? size;
  int? stargazersCount;
  int? watchersCount;
  String? language;
  int? forksCount;
  int? openIssuesCount;
  dynamic license;
  bool? allowForking;
  String? visibility;
  int? forks;
  int? openIssues;
  int? watchers;
  String? defaultBranch;
  // int? networkCount;
  int? subscribersCount;
  String? parent;

  Repo({
    this.id,
    this.name,
    this.fullName,
    this.private,
    this.owner,
    this.htmlUrl,
    this.description,
    this.fork,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.size,
    this.stargazersCount,
    this.watchersCount,
    this.language,
    this.forksCount,
    this.openIssuesCount,
    this.license,
    this.allowForking,
    this.visibility,
    this.forks,
    this.openIssues,
    this.watchers,
    this.defaultBranch,
    // this.networkCount,
    this.subscribersCount,
    this.parent,
  });

  // factory Repo.fromJson(Map<String, dynamic> json) => Repo(
  //   id: json["id"],
  //   name: json["name"],
  //   fullName: json["full_name"],
  //   private: json["private"],
  //   owner: User.fromJson(json["owner"]),
  //   htmlUrl: json["html_url"],
  //   description: json["description"],
  //   fork: json["fork"],
  //   url: json["url"],
  //   createdAt: DateTime.parse(json["created_at"]),
  //   updatedAt: DateTime.parse(json["updated_at"]),
  //   pushedAt: DateTime.parse(json["pushed_at"]),
  //   size: json["size"],
  //   stargazersCount: json["stargazers_count"],
  //   watchersCount: json["watchers_count"],
  //   language: json["language"],
  //   forksCount: json["forks_count"],
  //   openIssuesCount: json["open_issues_count"],
  //   license: json["license"],
  //   allowForking: json["allow_forking"],
  //   visibility: json["visibility"],
  //   forks: json["forks"],
  //   openIssues: json["open_issues"],
  //   watchers: json["watchers"],
  //   defaultBranch: json["default_branch"],
  //   networkCount: json["network_count"],
  //   subscribersCount: json["subscribers_count"],
  // );

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
    id: json["id"],
    name: json["name"],
    fullName: json["full_name"],
    private: json["private"],
    // owner: json["owner"] != null ? User.fromJson(json["owner"]) : null,
    owner: User.fromJson(json["owner"]),
    htmlUrl: json["html_url"],
    description: json["description"],
    fork: json["fork"],
    url: json["url"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    pushedAt: json["pushed_at"] != null ? DateTime.parse(json["pushed_at"]) : null,
    size: json["size"],
    stargazersCount: json["stargazers_count"],
    watchersCount: json["watchers_count"],
    language: json["language"] ?? '',
    forksCount: json["forks_count"],
    openIssuesCount: json["open_issues_count"],
    license: json["license"] ?? '',
    allowForking: json["allow_forking"],
    visibility: json["visibility"],
    forks: json["forks"],
    openIssues: json["open_issues"],
    watchers: json["watchers"],
    defaultBranch: json["default_branch"],
    // networkCount: json["network_count"],
    subscribersCount: json["subscribers_count"],
    parent: json["parent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "full_name": fullName,
    "private": private,
    "owner": owner?.toJson(),
    "html_url": htmlUrl,
    "description": description,
    "fork": fork,
    "url": url,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pushed_at": pushedAt?.toIso8601String(),
    "size": size,
    "stargazers_count": stargazersCount,
    "watchers_count": watchersCount,
    "language": language,
    "forks_count": forksCount,
    "open_issues_count": openIssuesCount,
    "license": license,
    "allow_forking": allowForking,
    "visibility": visibility,
    "forks": forks,
    "open_issues": openIssues,
    "watchers": watchers,
    "default_branch": defaultBranch,
    // "network_count": networkCount,
    "subscribers_count": subscribersCount,
    "parent": parent,
  };
}
