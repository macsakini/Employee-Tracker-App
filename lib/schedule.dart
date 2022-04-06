import 'package:blue/maps.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:css_colors/css_colors.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var data = [];

  Future<List> getJSONData() async {
    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return 0.
    final empcode = prefs.getString('empcode') ?? 0;

    Map request = {"empcode": empcode};

    final response = await http.post(
        Uri.parse('http://dummyprojects.xyz/js/tasks.json'),
        headers: {"Accept": "application/json"},
        body: request);
    print(response.body);

    data.add(json.decode(response.body));

    print(data);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Homepage"),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(),
      body: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Row(children: [
            CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(
                    'https://www.w3schools.com/howto/img_avatar2.png')),
            Padding(
              child: Text(
                "Hello Mac",
                style: TextStyle(fontSize: 25),
              ),
              padding: EdgeInsets.all(10.0),
            )
          ]),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Center(
            child: Text("Your schedule for today is: ",
                style: TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          FutureBuilder<List>(
              future: getJSONData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: SizedBox(
                      height: 200,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                height: 15.0,
                              ),
                          shrinkWrap: true,
                          itemCount: snapshot.data[0].length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 230,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  elevation: 4.0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MapPage(
                                                  taskName: snapshot.data[0]
                                                      [index]["taskName"],
                                                  taskCode: snapshot.data[0]
                                                      [index]["taskCode"],
                                                  latitude: snapshot.data[0]
                                                      [index]["latitude"],
                                                  longitude: snapshot.data[0]
                                                      [index]["longitude"])));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            snapshot.data[0][index]["taskName"],
                                            style: TextStyle(
                                                color: CSSColors.black,
                                                fontSize: 22),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: NetworkImage(
                                                        'https://media.istockphoto.com/photos/unrecognizable-supermarket-aisle-as-background-picture-id1265272573?b=1&k=20&m=1265272573&s=170667a&w=0&h=vnTLsLiki_HxXVr8MlQBKOqTn8rLx30M63_-2XNVroc=')),
                                              ),
                                              Padding(
                                                child: Text(
                                                  snapshot.data[0][index]
                                                      ["taskCode"],
                                                  style: TextStyle(
                                                      color: CSSColors.black),
                                                ),
                                                padding: EdgeInsets.all(7.0),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ]),
      ),
    );
  }
}
