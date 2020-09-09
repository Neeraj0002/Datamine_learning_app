import 'dart:async';
import 'dart:convert';

import 'package:datamine/Components/colors.dart';
import 'package:datamine/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/courseListRequst.dart';
import 'package:datamine/API/sliderImages.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:datamine/Screens/Login.dart';
import 'package:datamine/Screens/appCrashed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  chechId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("userData");

    courseListAPI().then((value) {
      if (value != "fail") {
        prefs.setString("courseListData", jsonEncode(value)).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  settings: RouteSettings(name: "/homeScreen"),
                  builder: (context) => BottomNaviBar(
                    indexNo: 0,
                  ),
                )));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: RouteSettings(name: "/homeScreen"),
          builder: (context) => AppCrashed(),
        ));
      }
    });
    /*sliderListAPI().then((value) {
      prefs
          .setString("sliderList", value != "fail" ? jsonEncode(value) : value)
          .then((value) {
        if (id != null) {
          Timer(
              Duration(milliseconds: 1000),
              () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      settings: RouteSettings(name: "/homeScreen"),
                      builder: (context) => BottomNaviBar(),
                    ))
                  });
        } else {
          Timer(
              Duration(milliseconds: 1000),
              () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      settings: RouteSettings(name: "/loginScreen"),
                      builder: (context) => LoginScreen(),
                    ))
                  });
        }
      });
    });*/
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
        ],
      ),
    );
  }
}
