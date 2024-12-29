import 'dart:convert';

import 'package:my_github/models/user.dart';

List<Release> releaseFromJson(String str) => List<Release>.from(json.decode(str).map((x) => Release.fromJson(x)));

String releaseToJson(List<Release> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Release {
  String htmlUrl;
  int id;
  User author;
  String tagName;
  String targetCommitish;
  String name;
  bool prerelease;
  DateTime createdAt;
  DateTime publishedAt;
  List<Asset> assets;
  String tarballUrl;
  String zipballUrl;
  String body;
  Reactions? reactions;

  Release({
    required this.htmlUrl,
    required this.id,
    required this.author,
    required this.tagName,
    required this.targetCommitish,
    required this.name,
    required this.prerelease,
    required this.createdAt,
    required this.publishedAt,
    required this.assets,
    required this.tarballUrl,
    required this.zipballUrl,
    required this.body,
    this.reactions,
  });

  factory Release.fromJson(Map<String, dynamic> json) => Release(
    htmlUrl: json["html_url"],
    id: json["id"],
    author: User.fromJson(json["author"]),
    tagName: json["tag_name"],
    targetCommitish: json["target_commitish"],
    name: json["name"],
    prerelease: json["prerelease"],
    createdAt: DateTime.parse(json["created_at"]),
    publishedAt: DateTime.parse(json["published_at"]),
    assets: List<Asset>.from(json["assets"].map((x) => Asset.fromJson(x))),
    tarballUrl: json["tarball_url"],
    zipballUrl: json["zipball_url"],
    body: json["body"],
    reactions: json["reactions"] != null ? Reactions.fromJson(json["reactions"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "html_url": htmlUrl,
    "id": id,
    "author": author.toJson(),
    "tag_name": tagName,
    "target_commitish": targetCommitish,
    "name": name,
    "prerelease": prerelease,
    "created_at": createdAt.toIso8601String(),
    "published_at": publishedAt.toIso8601String(),
    "assets": List<dynamic>.from(assets.map((x) => x.toJson())),
    "tarball_url": tarballUrl,
    "zipball_url": zipballUrl,
    "body": body,
    "reactions": reactions?.toJson(),
  };
}

class Asset {
  int id;
  String name;
  String? label;
  User uploader;
  String? contentType;
  String? state;
  int size;
  int? downloadCount;
  DateTime createdAt;
  DateTime updatedAt;
  String browserDownloadUrl;

  Asset({
    required this.id,
    required this.name,
    this.label,
    required this.uploader,
    this.contentType,
    this.state,
    required this.size,
    this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    id: json["id"],
    name: json["name"],
    label: json["label"],
    uploader: User.fromJson(json["uploader"]),
    contentType: json["content_type"],
    state: json["state"],
    size: json["size"],
    downloadCount: json["download_count"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    browserDownloadUrl: json["browser_download_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label": label,
    "uploader": uploader.toJson(),
    "content_type": contentType,
    "state": state,
    "size": size,
    "download_count": downloadCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "browser_download_url": browserDownloadUrl,
  };
}

class Reactions {
  String url;
  int? totalCount;
  int? the1;
  int? reactions1;
  int? laugh;
  int? hooray;
  int? confused;
  int? heart;
  int? rocket;
  int? eyes;

  Reactions({
    required this.url,
    this.totalCount,
    this.the1,
    this.reactions1,
    this.laugh,
    this.hooray,
    this.confused,
    this.heart,
    this.rocket,
    this.eyes,
  });

  factory Reactions.fromJson(Map<String, dynamic> json) => Reactions(
    url: json["url"],
    totalCount: json["total_count"],
    the1: json["+1"],
    reactions1: json["-1"],
    laugh: json["laugh"],
    hooray: json["hooray"],
    confused: json["confused"],
    heart: json["heart"],
    rocket: json["rocket"],
    eyes: json["eyes"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "total_count": totalCount,
    "+1": the1,
    "-1": reactions1,
    "laugh": laugh,
    "hooray": hooray,
    "confused": confused,
    "heart": heart,
    "rocket": rocket,
    "eyes": eyes,
  };
}
