import 'dart:convert';

CacheConfig cacheConfigFromJson(String str) => CacheConfig.fromJson(json.decode(str));

String cacheConfigToJson(CacheConfig data) => json.encode(data.toJson());

class CacheConfig {
  bool enable;
  int maxAge;
  int maxCount;

  CacheConfig({
    this.enable = true,
    this.maxAge= 3600,
    this.maxCount = 100,
  });

  factory CacheConfig.fromJson(Map<String, dynamic> json) => CacheConfig(
    enable: json["enable"] ?? true,
    maxAge: json["maxAge"] ?? 3600,
    maxCount: json["maxCount"] ?? 100,
  );

  Map<String, dynamic> toJson() => {
    "enable": enable,
    "maxAge": maxAge,
    "maxCount": maxCount,
  };
}