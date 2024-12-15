import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:my_github/common/global.dart';

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().microsecondsSinceEpoch;

  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 请求信息
    print('Request [${options.method}] => URL: ${options.uri} => Query Parameters: ${options.queryParameters}');
    // print('Request [${options.method}] => URL: ${options.uri}');
    // print('Headers: ${options.headers}');
    // print('Query Parameters: ${options.queryParameters}');
    // print('Body: ${options.data}');

    // 如果缓存功能未启用，直接跳过缓存逻辑
    if (!(Global.profile.cache.enable ?? false)) {
      return handler.next(options);
    }

    bool refresh = options.extra['refresh'] == true;
    if (refresh) {
      // 如果 `refresh` 为 true，根据 `list` 参数决定是否清除相关缓存
      if (options.extra['list'] == true) {
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        delete(options.uri.toString());
      }
      return handler.next(options);
    }

    // 检查是否应从缓存中获取数据
    if (options.extra['noCache'] != true && options.method == 'GET') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var cachedObject = cache[key];
      if (cachedObject != null) {
        // 检查缓存是否过期
        if ((DateTime.now().microsecondsSinceEpoch - cachedObject.timeStamp) / 1e6 < Global.profile.cache.maxAge) {
          return handler.resolve(cachedObject.response);
        } else {
          cache.remove(key);
        }
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
    handler.next(response);
  }

  void _saveCache(Response response) {
    RequestOptions options = response.requestOptions;
    // 确保只缓存 GET 请求且未被标记为 `noCache`
    if (options.extra['noCache'] != true && options.method == "GET") {
      // 如果缓存达到最大限制，删除最早的缓存项
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache.keys.first);
      }
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      cache[key] = CacheObject(response);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}
