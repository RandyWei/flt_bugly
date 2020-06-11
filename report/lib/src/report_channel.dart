import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Report {
  static const MethodChannel _channel =
      const MethodChannel('plugin.bughub.dev/report');

  static Future<void> init(String appId, bool debug) {
    return _channel.invokeMethod('init', {"appId": appId, "debug": debug});
  }

  static Future<void> setUserId(String userId) {
    return _channel.invokeMethod('setUserId', {"userId": userId});
  }

  static Future<void> setUserData(List<Map<String, String>> userData) {
    return _channel
        .invokeMethod('setUserId', {"userData": jsonEncode(userData)});
  }

  static void catchException<T>(
    T callback(), {
    FlutterExceptionHandler handler, //异常捕捉，用于自定义打印异常
    String filterRegExp, //异常上报过滤正则，针对message
  }) {
    bool _isDebug = false;
    assert(_isDebug = true);
    // This captures errors reported by the Flutter framework.
    FlutterError.onError = (details) {
      _filterAndUploadException(_isDebug, handler, filterRegExp, details);
    };

    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) {
      var isolateError = pair as List<dynamic>;
      var _error = isolateError.first;
      var _stackTrace = isolateError.last;
      Zone.current.handleUncaughtError(_error, _stackTrace);
    }).sendPort);

    // This creates a [Zone] that contains the Flutter application and stablishes
    // an error handler that captures errors and reports them.
    //
    // Using a zone makes sure that as many errors as possible are captured,
    // including those thrown from [Timer]s, microtasks, I/O, and those forwarded
    // from the `FlutterError` handler.
    //
    // More about zones:
    //
    // - https://api.dartlang.org/stable/1.24.2/dart-async/Zone-class.html
    // - https://www.dartlang.org/articles/libraries/zones

    runZonedGuarded<Future<Null>>(() async {
      callback();
    }, (error, stackTrace) {
      _filterAndUploadException(
        _isDebug,
        handler,
        filterRegExp,
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    });
  }

  static void _filterAndUploadException(
    _isDebug,
    handler,
    filterRegExp,
    FlutterErrorDetails details,
  ) {
    if (!_filterException(
      _isDebug,
      handler,
      filterRegExp,
      details,
    )) {
      String detail = "";
      if (details.stack == null) {
        detail = details.toString();
      } else {
        detail = details.stack.toString();
      }
      uploadException(message: details.exception.toString(), detail: detail);
    }
  }

  static bool _filterException(bool _isDebug, FlutterExceptionHandler handler,
      String filterRegExp, FlutterErrorDetails details) {
    //默认debug下打印异常，不上传异常
    if (_isDebug) {
      handler == null
          ? FlutterError.dumpErrorToConsole(details)
          : handler(details);
      return true;
    }
    //异常过滤
    if (filterRegExp != null) {
      RegExp reg = new RegExp(filterRegExp);
      Iterable<Match> matches = reg.allMatches(details.exception.toString());
      if (matches.length > 0) {
        return true;
      }
    }
    return false;
  }

  ///上报自定义异常信息，data为文本附件
  ///Android 错误分析=>跟踪数据=>extraMessage.txt
  ///iOS 错误分析=>跟踪数据=>crash_attach.log
  static Future<Null> uploadException(
      {@required String message, @required String detail, Map data}) async {
    var map = {};
    map.putIfAbsent("message", () => message);
    map.putIfAbsent("detail", () => detail);
    if (data != null) map.putIfAbsent("data", () => data);
    await _channel.invokeMethod('postException', map);
  }
}
