import 'package:blue/locationlogic.dart';
import 'package:blue/pedometere.dart';
import 'package:blue/snsors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:css_colors/css_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getLastLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    print(position);

    return position;
  }

  Future getStreamLocation() async {
    print("Streaming has started");
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      getLastLocation();
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
      var data = {
        "latitude": "${position.latitude.toString()}",
        "longitude": "${position.longitude.toString()}",
        "accuracy": "${position.accuracy}",
      };

      var data2 = json.encode(data);

      print(data2);

      print(data2.runtimeType);

      final http.Response response = await http.post(
        "https://8c9195dafaa7af5485da00552a7e0af1.m.pipedream.net",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data2,
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        throw Exception('Failed to create album.');
      }
    });
  }

  void initState() {
    super.initState();
    this.getStreamLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CSSColors.purple,
        centerTitle: true,
        leading: Icon(Icons.home),
        title: Text(
          "Location",
          style: TextStyle(fontFamily: "Ubuntu"),
        ),
      ),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Divider(
              height: 50,
            ),
            _createDrawerItem(
                icon: Icons.phone,
                text: 'Call Logs',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }),
            _createDrawerItem(
                icon: Icons.location_on,
                text: 'Location',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }),
            _createDrawerItem(
                icon: Icons.crop_square,
                text: 'Pedometer',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pedometere()),
                  );
                }),
            _createDrawerItem(
                icon: Icons.settings,
                text: 'Gyroscope',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }),
            _createDrawerItem(
              icon: Icons.help_outline,
              text: 'Emergency',
            ),
            Divider(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Last Known Location",
                style: TextStyle(
                  fontFamily: "Ubuntu",
                  color: CSSColors.black,
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                ),
              ),
            ),
            Divider(
              height: 30,
            ),
            FutureBuilder(
                future: getLastLocation(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        width: size.width,
                        height: 70,
                        child: Card(
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Latitude",
                                      style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: CSSColors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                    Divider(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data.latitude}",
                                      style: TextStyle(fontFamily: "Ubuntu"),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Longitude",
                                      style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: CSSColors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                    Divider(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data.longitude}",
                                      style: TextStyle(fontFamily: "Ubuntu"),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Accuracy",
                                      style: TextStyle(
                                          fontFamily: "Ubuntu",
                                          color: CSSColors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    ),
                                    Divider(
                                      height: 10,
                                    ),
                                    Text(
                                      "${snapshot.data.accuracy.ceil()} m",
                                      style: TextStyle(fontFamily: "Ubuntu"),
                                    ),
                                  ],
                                )
                              ],
                            )));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Divider(
              height: 100,
            ),
            CupertinoButton(
              color: CSSColors.purple,
              child: Text(
                "Get location",
                style: TextStyle(fontFamily: "Ubuntu"),
              ),
              onPressed: () {
                getStreamLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      title: Container(
          width: size.width,
          child: Card(
              elevation: 3,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 30,
                        color: CSSColors.purple,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          text,
                          style: TextStyle(fontFamily: "Ubuntu"),
                        ),
                      )
                    ],
                  )))),
      onTap: onTap,
    );
  }
}
