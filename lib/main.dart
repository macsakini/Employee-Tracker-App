import 'package:blue/maps.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

import 'pedometere.dart';

import 'snsors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp2());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
