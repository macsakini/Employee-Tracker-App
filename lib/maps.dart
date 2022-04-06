import 'package:css_colors/css_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:math' show cos, sqrt, asin;

class MapPage extends StatefulWidget {
  final String title;
  final String taskName;
  final String latitude;
  final String longitude;
  final String taskCode;

  const MapPage(
      {Key key,
      this.title,
      this.taskName,
      this.taskCode,
      this.latitude,
      this.longitude})
      : super(key: key);

  @override
  MapPageState createState() =>
      MapPageState(this.taskName, this.taskCode, this.latitude, this.longitude);
}

class MapPageState extends State<MapPage> {
  final String taskName;
  final String latitude;
  final String longitude;
  final String taskCode;

  MapPageState(this.taskName, this.taskCode, this.latitude, this.longitude);

  void initState() {
    super.initState();
  }

  //mapController.dispose();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  MapController mapController = MapController(
      initMapWithUserPosition: true,
      initPosition: GeoPoint(latitude: -1.2921, longitude: 36.8219));

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<String> start() async {
    GeoPoint col = await mapController.myLocation();
    GeoPoint newcoord = GeoPoint(
        latitude: double.parse(latitude), longitude: double.parse(longitude));

    mapController.changeLocation(newcoord);

    RoadInfo roadInfo = await mapController.drawRoad(col, newcoord);
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");

    return "${roadInfo.distance}km";
  }

  bool hasStarted = false;

  var distance = 0.0;

  Future<double> calculateDistance(lat2, lon2) async {
    GeoPoint loc = await mapController.myLocation();
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - loc.latitude) * p) / 2 +
        c(loc.latitude * p) *
            c(lat2 * p) *
            (1 - c((lon2 - loc.longitude) * p)) /
            2;
    double val = 12742 * asin(sqrt(a));

    if (val < 2) {
      print("Access Allowed");

      start();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text('Task Started successfully.'),
        duration: new Duration(seconds: 10),
      ));


      //This is under testing.....setState makes the app crash
      setState(() {
        hasStarted = true;
        distance = val;
      });
    } else {
      print("Access Denied");

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text('Error: Cannot start Task: Location Mismatch.'),
        duration: new Duration(seconds: 10),
      ));

      start();
    }

    print(val);

    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mac Maps'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 8,
              child: OSMFlutter(
                controller: mapController,
                trackMyPosition: true,
                initZoom: 16,
                stepZoom: 1.0,
                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                road: Road(
                  startIcon: MarkerIcon(
                    icon: Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.brown,
                    ),
                  ),
                  roadColor: CSSColors.red,
                ),
                markerOption: MarkerOption(
                    defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
              )),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      taskName,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("$distance Km", style: TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: CSSColors.black,
                      child: Text(
                        'Check In',
                        style:
                            TextStyle(fontSize: 20.0, color: CSSColors.white),
                      ),
                      onPressed: () {
                        calculateDistance(
                            double.parse(latitude), double.parse(longitude));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
