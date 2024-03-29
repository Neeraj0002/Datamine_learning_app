import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Appdrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/Screens/SignUp.dart';
import 'package:datamine/services/auth.dart';
import 'package:datamine/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datamine/Screens/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _mobNo = TextEditingController();
  TextEditingController _adLine1 = TextEditingController();
  TextEditingController _adLine2 = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  bool isLoading = false;
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool login = true;
  GlobalKey<ScaffoldState> profileKey = GlobalKey<ScaffoldState>();
  bool connected;
  Future checkConnectivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool connection;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connection = true;
        prefs.setBool("connected", true).then((value) {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      connection = false;
      prefs.setBool("connected", false).then((value) {
        setState(() {
          connected = false;
        });
      });
      print('not connected');
    }
    return connection;
  }

  Future singUpFirebase() async {
    String status = "fail";
    await authService
        .signUpWithEmailAndPassword(_username.text, _password.text)
        .then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          "userName": "${_fname.text} ${_lname.text}",
          "userEmail": _username.text
        };

        databaseMethods.addUserInfo(userDataMap, result.uid);
        status = "success";
      }
    });
    return status;
  }

  Future signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = "fail";
    await authService
        .signInWithEmailAndPassword(_username.text, _password.text)
        .then((result) async {
      if (result != null) {
        DocumentSnapshot userInfoSnapshot =
            await DatabaseMethods().getUserInfo(_username.text);
        print("done");
        status = "success";
        prefs.setString("firebaseId", result.uid);
      } else {
        status = "fail";
      }
    });
    return status;
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      var parsedData = jsonDecode(data);
      return parsedData;
    } else {
      return "notLoggedIn";
    }
  }

  _profileScreen(BuildContext context) {
    return Scaffold(
      key: profileKey,
      drawer: CustomAppDrawer(),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: appBarColorlight,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: connected
            ? IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  profileKey.currentState.openDrawer();
                },
              )
            : Container(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            color: Colors.white,
            tooltip: "Logout",
            onPressed: () async {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    content: Text(
                      "Are you sure?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove("userData");
                          Navigator.of(context).pop();
                          await FirebaseAuth.instance.signOut();
                          setState(() {});
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: appBarColorlight,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      )
                    ],
                  ));
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                              child: Image.asset(
                            "assets/img/logo-1.jpg",
                            fit: BoxFit.contain,
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10, 8, 10),
                      child: Text(
                        "Hello,",
                        style: TextStyle(
                            color: Colors.black54,
                            fontFamily: "ProximaNova",
                            fontSize: 18),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 8, 10),
                      child: Text(
                        "${snapshot.data["fName"]} ${snapshot.data["lName"]}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "ProximaNova",
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),

                    //width: MediaQuery.of(context).size.width,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.black87,
                            size: 20,
                          ),
                          Text(
                            "  ${snapshot.data["phone"]}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "ProximaNova",
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.black87,
                            size: 20,
                          ),
                          Text(
                            "  ${snapshot.data["mail"]}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "ProximaNova",
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Icon(
                              Icons.home,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "${snapshot.data["address"]["line1"]}\n${snapshot.data["address"]["line2"]}\n${snapshot.data["address"]["line3"]}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "ProximaNova",
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: 0,
                width: 0,
              );
            }
          }),
    );
  }

  _loginScreen(BuildContext context) {
    return Scaffold(
      key: profileKey,
      drawer: CustomAppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: connected
            ? IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  profileKey.currentState.openDrawer();
                },
              )
            : Container(),
        backgroundColor: appBarColorlight,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "You are not logged in",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "ProximaNova",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(
                      fromAppDrawer: false,
                      fromSplashScreen: false,
                      fromMyCourse: false,
                      fromProfile: true,
                      fromSignUp: false,
                      parent: this,
                    ),
                settings: RouteSettings(name: "/login"))),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * (0.5),
              decoration: BoxDecoration(
                  color: appBarColorlight,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        spreadRadius: 1,
                        blurRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "--OR--",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "ProximaNova",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SignUpScreen(
                      fromLogin: false,
                      fromProfile: true,
                      fromMyCourse: false,
                      parent: this,
                    ),
                settings: RouteSettings(name: "/signup"))),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * (0.5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        spreadRadius: 1,
                        blurRadius: 2)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: appBarColorlight, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkConnectivity(),
        builder: (context, connectionSnapshot) {
          if (connectionSnapshot.hasData) {
            if (connectionSnapshot.data) {
              return FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == "notLoggedIn") {
                        return _loginScreen(context);
                      } else {
                        return _profileScreen(context);
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              appBarColorlight),
                        ),
                      );
                    }
                  });
            } else {
              return Center(
                child: Text(
                  "You are not connected",
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }
}

// ignore: must_be_immutable
class ProfileItem extends StatelessWidget {
  String type;
  String data;
  ProfileItem({
    @required this.data,
    @required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              type,
              style: TextStyle(
                  color: appBarColorlight,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    child: Text(
                      data,
                      style: TextStyle(
                          fontFamily: "Jost",
                          fontSize: 16.0,
                          color: appBarColorlight),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
