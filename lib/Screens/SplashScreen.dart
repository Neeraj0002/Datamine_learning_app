import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Login.dart';
import 'package:datamine/Screens/onBoarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/courseListRequst.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/appCrashed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      var parsedData = jsonDecode(data);
      return parsedData;
    } else {
      return "notLoggedIn";
    }
  }

  Future checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("firstTime");
  }

  chechId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("userData");

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        prefs.setBool("connected", true).then((value) {
          courseListAPI().then((value) {
            if (value != "fail") {
              prefs
                  .setString("courseListData", jsonEncode(value))
                  .then((value) {
                checkFirstTime().then((firstTime) {
                  if (firstTime != null) {
                    getUserData().then((value) {
                      if (value != "notLoggedIn") {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          settings: RouteSettings(name: "/homeScreen"),
                          builder: (context) => BottomNaviBar(
                            indexNo: 0,
                          ),
                        ));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            settings: RouteSettings(name: "/loginScreen"),
                            builder: (context) => LoginScreen(
                                  fromProfile: false,
                                  fromSignUp: false,
                                  parent: null,
                                  fromMyCourse: false,
                                  fromSplashScreen: true,
                                )));
                      }
                    });
                  } else {
                    prefs.setBool("firstTime", false).then((value) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          settings: RouteSettings(name: "/homeScreen"),
                          builder: (context) => OnBoardingPage()));
                    });
                  }
                });
              });
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                settings: RouteSettings(name: "/homeScreen"),
                builder: (context) => AppCrashed(),
              ));
            }
          });
        });
      }
    } on SocketException catch (_) {
      prefs.setBool("connected", false).then((value) {
        Timer(
            Duration(
              seconds: 2,
            ), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            settings: RouteSettings(name: "/homeScreen"),
            builder: (context) => BottomNaviBar(
              indexNo: 0,
            ),
          ));
        });
      });
      print('not connected');
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: splashScreenColor1,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: splashScreenColor2,
        systemNavigationBarIconBrightness: Brightness.dark));
    chechId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: screenWidth,
                color: splashScreenColor1,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: screenWidth,
                color: splashScreenColor2,
              ),
            ],
          ),
          Center(
            child: Image.asset(
              "assets/img/Logo.jpg",
              width: screenWidth,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //color: Colors.red,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Powered by",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontFamily: "OpenSans",
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Torc Infotech",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "OpenSans",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
