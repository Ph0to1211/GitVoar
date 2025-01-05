import 'dart:convert';

import 'package:my_github/models/user.dart';

List<Commit> commitFromJson(String str) => List<Commit>.from(json.decode(str).map((x) => Commit.fromJson(x)));

String commitToJson(List<Commit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Commit {
  String sha;
  String nodeId;
  CommitClass commit;
  String htmlUrl;
  User author;

  Commit({
    required this.sha,
    required this.nodeId,
    required this.commit,
    required this.htmlUrl,
    required this.author,
  });

  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
    sha: json["sha"],
    nodeId: json["node_id"],
    commit: CommitClass.fromJson(json["commit"]),
    htmlUrl: json["html_url"],
    author: User.fromJson(json['author']),
  );

  Map<String, dynamic> toJson() => {
    "sha": sha,
    "node_id": nodeId,
    "commit": commit.toJson(),
    "html_url": htmlUrl,
    "author": author.toJson(),
  };
}

class CommitClass {
  Author author;
  Author committer;
  String message;

  CommitClass({
    required this.author,
    required this.committer,
    required this.message,
  });

  factory CommitClass.fromJson(Map<String, dynamic> json) => CommitClass(
    author: Author.fromJson(json["author"]),
    committer: Author.fromJson(json["committer"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "author": author.toJson(),
    "committer": committer.toJson(),
    "message": message,
  };
}

class Author {
  String name;
  String email;
  DateTime date;

  Author({
    required this.name,
    required this.email,
    required this.date,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    name: json["name"],
    email: json["email"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "date": date.toIso8601String(),
  };
}
