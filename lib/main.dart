import 'package:flutter/material.dart';
import 'package:blue/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blue/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mac Incorporation',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Ubuntu'),
      home: Login(),
    );
  }
}


