import 'dart:async';

import 'package:flutter/services.dart';

class Report {
  static const MethodChannel _channel =
      const MethodChannel('report');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
