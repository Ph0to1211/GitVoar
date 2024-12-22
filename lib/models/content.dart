import 'dart:convert';


List<Content> repoFromJson(String str) => List<Content>.from(json.decode(str).map((x) => Content.fromJson(x)));

String repoToJson(List<Content> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Content {
  String name;
  String path;
  String? download_url;
  String type;

  Content({
    required this.name,
    required this.path,
    this.download_url,
    required this.type
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    name: json['name'],
    path: json['path'],
    download_url: json['download_url'],
    type: json['type']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "path": path,
    "download_url": download_url,
    "type": type
  };

}