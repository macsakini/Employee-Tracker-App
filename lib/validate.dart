import 'package:flutter/material.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({Key key}) : super(key: key);

  @override
  ValidatePageState createState() => ValidatePageState();
}

class ValidatePageState extends State<ValidatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Homepage"),
          centerTitle: true,
        ),
        body: Container(color: Colors.amber, child: Column()));
  }
}
