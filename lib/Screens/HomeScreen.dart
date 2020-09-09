import 'dart:convert';

import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/courseListRequst.dart';
import 'package:datamine/API/sliderImages.dart';
import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Components/HorizontalList.dart';
import 'package:datamine/Components/ImageSlider.dart';
import 'package:datamine/Components/ImageSliderPlaceHolder.dart';
import 'package:datamine/Models/CourseModel.dart';
import 'package:datamine/Screens/Appdrawer.dart';
import 'package:datamine/Screens/ChatScreen2.dart';
import 'package:datamine/Screens/CourseDetails.dart';
import 'package:datamine/Screens/chatrooms.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool userLoggedIn = false;
  Future setNameAndID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      var parsedData = jsonDecode(data);
      print(parsedData);
      Constants.myName = "${parsedData["fName"]} ${parsedData["lName"]}";
      Constants.id = parsedData["id"];
    }
  }

  sendMessage() {
    List<String> users = [Constants.myName, "Admin"];

    String chatRoomId = "${Constants.id}_Admin";

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                  name: "Chat",
                )));
  }

  checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");

    setState(() {
      if (data != null) {
        userLoggedIn = true;
        var parsedData = jsonDecode(data);
        Constants.id = parsedData['id'];
        Constants.myName = "${parsedData["fName"]} ${parsedData["lName"]}";
        Constants.email = parsedData["mail"];
      } else {
        userLoggedIn = false;
      }
    });
  }

  getCourseListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("courseListData");
    var parsedData = jsonDecode(data);
    return parsedData;
  }

  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeKey,
      drawer: CustomAppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColorlight,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: appbarTextColorLight,
          onPressed: () {
            homeKey.currentState.openDrawer();
          },
        ),
        title: Text(
          "Datamine",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          /*userLoggedIn
              ? */
          IconButton(
            color: appbarTextColorLight,
            icon: Icon(Icons.notifications),
            onPressed: () {
              if (Constants.email == "admin.torc@gmail.com") {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ChatRoom()));
              } else {
                sendMessage();
              }
            },
          )
          /*: Container(
                  height: 0,
                  width: 0,
                )*/
          ,
          IconButton(
            color: appbarTextColorLight,
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                settings: RouteSettings(name: "/search"),
                builder: (context) => Search(),
              ));
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getCourseListData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data != 'fail') {
                return ListView(
                  children: [
                    FutureBuilder(
                      future: sliderListAPI(),
                      builder: (context, imageSnapshot) {
                        if (imageSnapshot.connectionState ==
                                ConnectionState.done &&
                            imageSnapshot.hasData) {
                          return ImageSlider(
                              imgUrls: imageSnapshot.data["data"]["images"]);
                        } else {
                          return ImageSliderPlaceHolder();
                        }
                      },
                    ),
                    Column(children: [
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["Web Development"],
                          title: "Web Development"),
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["App Development"],
                          title: "App Development"),
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["Blockchain"],
                          title: "Blockchain"),
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["ML & AI"],
                          title: "ML & AI"),
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["Data Science"],
                          title: "Data Science"),
                      HorizontalDataList(
                          dataList: snapshot.data["data"]["Categories"]
                              ["Others"],
                          title: "Others")
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          LaunchReview.launch(
                              androidAppId: "com.torcinfotech.datamine",
                              writeReview: false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            Icons.star,
                                            color: appbarTextColorLight,
                                            size: 30,
                                          )),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: appBarColorlight,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rate this app   ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        ":)",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "Something went wrong",
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(appBarColorlight),
                ),
              );
            }
          }),
    );
  }
}
