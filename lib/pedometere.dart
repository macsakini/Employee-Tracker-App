import 'package:css_colors/css_colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

class Pedometere extends StatefulWidget {
  Pedometere({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Pedometere> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  String _stepCountValue = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(int stepCountValue) {
    print(stepCountValue);
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onData(int newValue) async {
    print('New step count value: $newValue');
    setState(() => _stepCountValue = "$newValue");
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: CSSColors.purple,
            centerTitle: true,
            title: const Text('Step Counter',
                style: TextStyle(
                  fontFamily: "Ubuntu",
                )),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.directions_walk,
                size: 90,
                color: CSSColors.black,
              ),
              new Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30, fontFamily: "Ubuntu"),
              ),
              new Text(
                '$_stepCountValue',
                style: TextStyle(
                  fontSize: 100,
                  color: CSSColors.purple,
                  fontFamily: "Ubuntu",
                ),
              )
            ],
          ))),
    );
  }
}
