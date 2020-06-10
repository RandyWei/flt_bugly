import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Report {
  static const MethodChannel _channel =
      const MethodChannel('plugin.bughub.dev/report');

  static Future<void> init(String appId,bool debug) async {
    return _channel.invokeMethod('init', {"appId": appId,"debug":debug});
  }

  static void catchException<T>(T callback(),
      {@required String appId, bool debug = false}) {

    // This captures errors reported by the Flutter framework.
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
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
      print("object1");
//      init(appId,debug);
      print("object2");
    }, (error, stackTree) {});
  }
}
