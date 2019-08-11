import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_myccpp/flutter_myccpp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _androidPrivateKey = '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';
  String _iosPrivateKey = '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';
  String _privateKey = null;


  @override
  void initState(){
    super.initState();
    initPlatformState();
    initMyCCPP();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterMyccpp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initMyCCPP() async {
    if (Platform.isAndroid) {
      _privateKey = _androidPrivateKey;
    } else if (Platform.isIOS) {
      _privateKey = _iosPrivateKey;
    }

    await FlutterMyccpp.initialize(_privateKey, false);
  }

  // Future<void> initMyCCPP() async {
  //   await FlutterMyccpp.initialize(_privateKey, false);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Text('Running on: $_platformVersion\n'),
                FlatButton(
                  child: Text('Request Credit Card'),
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: () async{
                    try {
                      var result = await FlutterMyccpp.requestPayment({
                        'merchantID': '764764000001966',
                        'secretKey': '24ABCC819638916E7DD47D09F2DEA4588FAE70636B085B8DE47A9592C4FD034F',
                        'uniqueTransactionCode': '10150919236',
                        'desc': 'product1',
                        'amount': 1500.0,
                        'currencyCode': '764' ,
                        'paymentUI': false,

                        'pan': '5105105105105100',
                        'cardExpireMonth':12,
                        'cardExpireYear':2019,
                        'cardHolderName': 'Mr. John',
                        'cardHolderEmail': 'hello@gmail.com',
                        'panCountry': 'TH',
                        'request3DS': 'Y'
                      });
                      print('eiei: $result');
                    } on PlatformException catch(e){
                      print("error");
                      print(e.message);
                    }
                  },
                ),
                FlatButton(
                  child: Text('Request Alternative Payment'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () async{
                    try {
                      // await FlutterMyccpp.requestAlternativePayment({
                      var result = await FlutterMyccpp.requestAlternativePayment({
                        'merchantID': '764764000001966',
                        'secretKey': '24ABCC819638916E7DD47D09F2DEA4588FAE70636B085B8DE47A9592C4FD034F',
                        'uniqueTransactionCode': '10051',
                        'desc': 'product1',
                        'amount': 1.0,
                        'currencyCode': '764' ,
                        'paymentUI': false,
                        'cardHolderName': 'Mr. John',
                        'cardHolderEmail': 'user@domain.com',

                        'paymentChannel': 'ONE_TWO_THREE',
                        'agentCode': 'SCB',
                        'channelCode': 'iBanking',
                      });
                      print('eueu: $result');
                    }on PlatformException catch(e){
                      print("error");
                      print(e.message);
                    }
                  },
                )
              ],
            )
          )
        ),
      ),
    );
  }
}
