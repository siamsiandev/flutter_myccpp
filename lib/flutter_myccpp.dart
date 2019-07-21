import 'dart:async';
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
    await _channel.invokeMethod('initialize', <String, dynamic>{
      'privateKey': privateKey,
      'productionMode': productionMode
    });
  }
  static Future requestPayment(Map<String, dynamic> params) async {
    return await _channel.invokeMethod('requestPayment', params);
  }
  static Future requestAlternativePayment(Map<String, dynamic> params) async {
    return await _channel.invokeMethod('requestAlternativePayment', params);
  }
}
