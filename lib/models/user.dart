import 'dart:convert';

// User userFromJson(String str) => User.fromJson(json.decode(str));
//
// String userToJson(User data) => json.encode(data.toJson());

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? login;
  String? avatarUrl;
  String? htmlUrl;
  String? type;
  String? userViewType;
  String? name;
  String? company;
  String? blog;
  String? location;
  String? email;
  bool? hireable;
  String? bio;
  int? publicRepos;
  int? publicGists;
  int? followers;
  int? following;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.login,
    this.avatarUrl,
    this.htmlUrl,
    this.type,
    this.userViewType,
    this.name,
    this.company,
    this.blog,
    this.location,
    this.email,
    this.hireable,
    this.bio,
    this.publicRepos,
    this.publicGists,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    login: json["login"],
    avatarUrl: json["avatar_url"],
    htmlUrl: json["html_url"],
    type: json["type"],
    userViewType: json["user_view_type"],
    name: json["name"],
    company: json["company"],
    blog: json["blog"],
    location: json["location"],
    email: json["email"],
    hireable: json["hireable"],
    bio: json["bio"],
    publicRepos: json["public_repos"],
    publicGists: json["public_gists"],
    followers: json["followers"],
    following: json["following"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    // createdAt: json["created_at"],
    // updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "avatar_url": avatarUrl,
    "html_url": htmlUrl,
    "type": type,
    "user_view_type": userViewType,
    "name": name,
    "company": company,
    "blog": blog,
    "location": location,
    "email": email,
    "hireable": hireable,
    "bio": bio,
    "public_repos": publicRepos,
    "public_gists": publicGists,
    "followers": followers,
    "following": following,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
