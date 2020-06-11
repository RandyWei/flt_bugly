import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:report/report.dart';

void main() {
  Report.catchException(() => runApp(MyApp()));

//  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    Future((){
      HttpClient httpClient ;
      httpClient.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Row(children: <Widget>[
            Text('Plugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appPlugin example appRunning on: $_platformVersion\n')
          ],),
        ),
      ),
    );
  }
}
