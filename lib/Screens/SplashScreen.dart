import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Login.dart';
import 'package:datamine/Screens/onBoarding.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/courseListRequst.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/appCrashed.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String currentUserId;

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(
          msg: err.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.torcinfotech.datamine'
          : 'com.torcinfotech.datamine',
      'Datamine',
      'Datamine',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

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

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
                        /*registerNotification();
                        configLocalNotification();*/
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
                                  fromAppDrawer: false,
                                  fromProfile: false,
                                  fromSignUp: false,
                                  parent: null,
                                  fromMyCourse: false,
                                  fromSplashScreen: true,
                                )));
                      }
                    });
                  } else {
                    prefs.setInt("notificationLength", 0).then((value) {
                      prefs.setBool("firstTime", false).then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            settings: RouteSettings(name: "/onboardingScreen"),
                            builder: (context) => OnBoardingPage()));
                      });
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
        systemNavigationBarColor: Colors.white,
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
          /*Column(
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
          ),*/
          Container(
            height: MediaQuery.of(context).size.height,
            width: screenWidth,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/img/no-bg.png",
                  width: screenWidth,
                ),
              ),
              Center(
                child: Text(
                  "Datamine",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "ProximaNova",
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
                      fontFamily: "ProximaNova",
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Torc Infotech",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54,
                        fontFamily: "ProximaNova",
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
