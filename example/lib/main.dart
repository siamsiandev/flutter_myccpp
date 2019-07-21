import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_myccpp/flutter_myccpp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _privateKey = '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';


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
    await FlutterMyccpp.initialize(_privateKey, false);
  }

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
                        'uniqueTransactionCode': '10150919233',
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
                      print(result);
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
                      await FlutterMyccpp.requestAlternativePayment({
                        'merchantID': '764764000001966',
                        'secretKey': '24ABCC819638916E7DD47D09F2DEA4588FAE70636B085B8DE47A9592C4FD034F',
                        'uniqueTransactionCode': '10050',
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
