import 'dart:async';

import 'package:flutter/services.dart';

class FlutterMyccpp {
  static const MethodChannel _channel =
      const MethodChannel('flutter_myccpp');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future initialize(String privateKey, bool productionMode) async {
    await _channel.invokeMethod('initialize', {
      privateKey: privateKey,
      productionMode: productionMode
    });
  }
}
