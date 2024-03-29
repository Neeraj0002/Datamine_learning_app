import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/loginRequest.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:datamine/Components/customTextField.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/SignUp.dart';
import 'package:datamine/services/auth.dart';
import 'package:datamine/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  bool fromProfile;
  bool fromSignUp;
  bool fromMyCourse;
  bool fromSplashScreen;
  bool fromAppDrawer;
  var parent;
  LoginScreen(
      {@required this.fromProfile,
      @required this.fromSignUp,
      @required this.parent,
      @required this.fromMyCourse,
      @required this.fromSplashScreen,
      @required this.fromAppDrawer});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future singUpFirebase(String fname, String lname) async {
    String status = "fail";
    await authService
        .signUpWithEmailAndPassword(_username.text, _password.text)
        .then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          'nickname': "$fname $lname",
          'email': _username.text,
          'id': result.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        };

        databaseMethods
            .addUserInfo(userDataMap, result.uid)
            .then((value) => status = "success");
      }
    });
    return status;
  }

  Future signIn(String fname, String lname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = "fail";
    await authService
        .signInWithEmailAndPassword(_username.text, _password.text)
        .then((result) async {
      if (result != null) {
        status = "success";
        prefs.setString("firebaseId", result.uid).then((value) => print("Set"));
      }
      /*else {
        print("signing up");
        await singUpFirebase(fname, lname).then((value) {
          status = value;
          print(value);
        });
        print(status);
      }*/
    });
    return status;
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
              color: widget.fromSplashScreen ? Colors.white : Colors.black87),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              color: Colors.black26)
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset(
                            "assets/img/logo-1.jpg",
                            height: 100,
                          ),
                        ),
                        Column(
                          children: [
                            customTextField(
                              keyboardType: TextInputType.emailAddress,
                              textController: _username,
                              hint: "Enter email",
                              label: "Email",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.visiblePassword,
                              textController: _password,
                              hint: "Enter Password",
                              label: "Password",
                              hideText: true,
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 20),
                          child: customButton(
                            text: "Login",
                            color: appBarColorlight,
                            action: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              if (_username.text.length != 0 &&
                                  _password.text.length != 0) {
                                setState(() {
                                  isLoading = true;
                                });
                                loginAPI(
                                        context, _username.text, _password.text)
                                    .then((value) async {
                                  if (value != "fail") {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var parsedValue = jsonDecode(value);
                                    print("API LOGIN DONE");
                                    signIn(
                                            parsedValue["data"]["details"]
                                                ["FirstName"]["en-US"],
                                            parsedValue["data"]["details"]
                                                ["LastName"]["en-US"])
                                        .then((secondvalue) async {
                                      if (secondvalue != "fail") {
                                        print("FIREBASE LOGIN DONE");
                                        Map data = {
                                          "id": parsedValue["data"]["id"],
                                          "fName": parsedValue["data"]
                                              ["details"]["FirstName"]["en-US"],
                                          "lName": parsedValue["data"]
                                              ["details"]["LastName"]["en-US"],
                                          "mail": parsedValue["data"]["details"]
                                              ["MailId"]["en-US"],
                                          "phone": parsedValue["data"]
                                              ["details"]["Contact"]["en-US"],
                                          "address": {
                                            "line1": parsedValue["data"]
                                                    ["details"]["Address"]
                                                ["en-US"][0],
                                            "line2": parsedValue["data"]
                                                    ["details"]["Address"]
                                                ["en-US"][1],
                                            "line3": parsedValue["data"]
                                                    ["details"]["Address"]
                                                ["en-US"][2]
                                          }
                                        };

                                        prefs
                                            .setString(
                                                "userData", jsonEncode(data))
                                            .then((value) {
                                          if (widget.fromProfile) {
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              settings: RouteSettings(
                                                  name: "/indexPage"),
                                              builder: (context) =>
                                                  BottomNaviBar(
                                                indexNo: 2,
                                              ),
                                            ));
                                          } else if (widget.fromSignUp) {
                                            Navigator.pop(context);
                                            widget.parent.setState(() {});
                                          } else if (widget.fromMyCourse) {
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              settings: RouteSettings(
                                                  name: "/indexPage"),
                                              builder: (context) =>
                                                  BottomNaviBar(
                                                indexNo: 1,
                                              ),
                                            ));
                                          } else if (widget.fromSplashScreen ||
                                              widget.fromAppDrawer) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              settings: RouteSettings(
                                                  name: "/indexPage"),
                                              builder: (context) =>
                                                  BottomNaviBar(
                                                indexNo: 0,
                                              ),
                                            ));
                                          }
                                        });
                                      } else {
                                        singUpFirebase(
                                                parsedValue["data"]["details"]
                                                    ["FirstName"]["en-US"],
                                                parsedValue["data"]["details"]
                                                    ["LastName"]["en-US"])
                                            .then((thirdvalue) {
                                          if (thirdvalue != 'fail') {
                                            print("FIREBASE SIGNUP DONE");
                                            signIn(
                                                    parsedValue["data"]
                                                            ["details"]
                                                        ["FirstName"]["en-US"],
                                                    parsedValue["data"]
                                                            ["details"]
                                                        ["LastName"]["en-US"])
                                                .then((fourthvalue) {
                                              if (fourthvalue != "fail") {
                                                print("FIREBASE LOGIN DONE");
                                                Map data = {
                                                  "id": parsedValue["data"]
                                                      ["id"],
                                                  "fName": parsedValue["data"]
                                                          ["details"]
                                                      ["FirstName"]["en-US"],
                                                  "lName": parsedValue["data"]
                                                          ["details"]
                                                      ["LastName"]["en-US"],
                                                  "mail": parsedValue["data"]
                                                          ["details"]["MailId"]
                                                      ["en-US"],
                                                  "phone": parsedValue["data"]
                                                          ["details"]["Contact"]
                                                      ["en-US"],
                                                  "address": {
                                                    "line1": parsedValue["data"]
                                                            ["details"]
                                                        ["Address"]["en-US"][0],
                                                    "line2": parsedValue["data"]
                                                            ["details"]
                                                        ["Address"]["en-US"][1],
                                                    "line3": parsedValue["data"]
                                                            ["details"]
                                                        ["Address"]["en-US"][2]
                                                  }
                                                };

                                                prefs
                                                    .setString("userData",
                                                        jsonEncode(data))
                                                    .then((value) {
                                                  print("DATA SAVED");
                                                  if (widget.fromProfile) {
                                                    Navigator.pop(context);
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                      settings: RouteSettings(
                                                          name: "/indexPage"),
                                                      builder: (context) =>
                                                          BottomNaviBar(
                                                        indexNo: 2,
                                                      ),
                                                    ));
                                                  } else if (widget
                                                      .fromSignUp) {
                                                    Navigator.pop(context);
                                                    widget.parent
                                                        .setState(() {});
                                                  } else if (widget
                                                      .fromMyCourse) {
                                                    Navigator.pop(context);
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                      settings: RouteSettings(
                                                          name: "/indexPage"),
                                                      builder: (context) =>
                                                          BottomNaviBar(
                                                        indexNo: 1,
                                                      ),
                                                    ));
                                                  } else if (widget
                                                          .fromSplashScreen ||
                                                      widget.fromAppDrawer) {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                      settings: RouteSettings(
                                                          name: "/indexPage"),
                                                      builder: (context) =>
                                                          BottomNaviBar(
                                                        indexNo: 0,
                                                      ),
                                                    ));
                                                  }
                                                });
                                              } else {
                                                print("FIREBASE LOGIN FAILED");
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                showDialog(
                                                    context: context,
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          Colors.red,
                                                      title: Text(
                                                        "Failed",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "ProximaNova",
                                                            fontSize: 18),
                                                      ),
                                                      content: Text(
                                                        "Please check your email id and password",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "ProximaNova",
                                                            fontSize: 16),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Center(
                                                            child: Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "ProximaNova",
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ));
                                              }
                                            });
                                          } else {
                                            print("FIREBASE SIGNUP FAILED");
                                            setState(() {
                                              isLoading = false;
                                            });
                                            showDialog(
                                                context: context,
                                                child: AlertDialog(
                                                  backgroundColor: Colors.red,
                                                  title: Text(
                                                    "Failed",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "ProximaNova",
                                                        fontSize: 18),
                                                  ),
                                                  content: Text(
                                                    "Please check your email id and password",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "ProximaNova",
                                                        fontSize: 16),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Center(
                                                        child: Text(
                                                          "OK",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "ProximaNova",
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ));
                                          }
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          backgroundColor: Colors.red,
                                          title: Text(
                                            "Failed",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "ProximaNova",
                                                fontSize: 18),
                                          ),
                                          content: Text(
                                            "Please check your email id and password",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "ProximaNova",
                                                fontSize: 16),
                                          ),
                                          actions: [
                                            FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Center(
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "ProximaNova",
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  }
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      backgroundColor: Colors.red,
                                      title: Text(
                                        "Failed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "ProximaNova",
                                            fontSize: 18),
                                      ),
                                      content: Text(
                                        "Please enter your username and password",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "ProximaNova",
                                            fontSize: 16),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Center(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "ProximaNova",
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                customTextButton(
                  textColor: appBarColorlight,
                  text: "Don't have an account? Sign Up",
                  action: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen(
                              fromLogin: true,
                              fromProfile: false,
                              fromMyCourse: false,
                              parent: widget.parent,
                            ),
                        settings: RouteSettings(name: "/signup")));
                  },
                ),
                widget.fromSplashScreen
                    ? customTextButton(
                        textColor: appBarColorlight.withOpacity(0.8),
                        text: "Skip Login",
                        action: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BottomNaviBar(indexNo: 0),
                              settings: RouteSettings(name: "/homeScreen")));
                        },
                      )
                    : Container()
              ],
            ),
            isLoading
                ? Container(
                    height: screenHeight,
                    width: screenWidth,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.8)),
                    child: Center(
                      child: Container(
                          child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(appBarColorlight),
                      )),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }
}
