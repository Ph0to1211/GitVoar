import 'dart:convert';

List<RepoAbbr> repoAbbrFromJson(String str) => List<RepoAbbr>.from(json.decode(str).map((x) => RepoAbbr.fromJson(x)));

String repoAbbrToJson(List<RepoAbbr> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RepoAbbr {
  int id;
  String nodeId;
  String name;
  String fullName;
  bool private;
  String htmlUrl;
  String description;
  bool fork;
  String url;
  int stargazersCount;
  int watchersCount;
  String? language;
  int forksCount;

  RepoAbbr({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.fullName,
    required this.private,
    required this.htmlUrl,
    required this.description,
    required this.fork,
    required this.url,
    required this.stargazersCount,
    required this.watchersCount,
    this.language,
    required this.forksCount,
  });

  factory RepoAbbr.fromJson(Map<String, dynamic> json) => RepoAbbr(
    id: json["id"],
    nodeId: json["node_id"],
    name: json["name"],
    fullName: json["full_name"],
    private: json["private"],
    htmlUrl: json["html_url"],
    description: json["description"],
    fork: json["fork"],
    url: json["url"],
    stargazersCount: json["stargazers_count"],
    watchersCount: json["watchers_count"],
    language: json["language"],
    forksCount: json["forks_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "node_id": nodeId,
    "name": name,
    "full_name": fullName,
    "private": private,
    "html_url": htmlUrl,
    "description": description,
    "fork": fork,
    "url": url,
    "stargazers_count": stargazersCount,
    "watchers_count": watchersCount,
    "language": language,
    "forks_count": forksCount,
  };
}
