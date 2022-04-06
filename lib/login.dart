import 'package:flutter/material.dart';
import 'package:blue/schedule.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    // checkLogin();
    // getLoginDetails();
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController empcodeController = new TextEditingController();
  var data = [];

  void checkLogin(BuildContext context) async {
    await SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return 0.
    final empcode = prefs.getString('empcode') ?? 0;

    if (empcode != 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Not logged In");
    }
  }

  Future<List> getLoginDetails(
      BuildContext context, String email, String code) async {
    Map request = {"email": email, "emp_code": code};
    print(request);

    // final response = await http.post(
    //     Uri.parse('https://enlvmbmfmv71xyk.m.pipedream.net'),
    //     headers: {"Accept": "application/json"},
    //     body: request);

    // if (response.statusCode == 200) {
    //   data.add(json.decode(response.body));
    // } else {
    //   print("False Request");
    // }

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // set value
    prefs.setString('empcode', code);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://www.w3schools.com/howto/img_avatar2.png')),
                  ),
                )),
            SizedBox(
              height: 60,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: empcodeController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Employee Code',
                    hintText: 'Enter Code'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  getLoginDetails(
                      context, emailController.text, empcodeController.text);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
