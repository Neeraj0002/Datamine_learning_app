import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/Certificate.dart';
import 'package:datamine/Screens/ChatScreen2.dart';
import 'package:datamine/Screens/DownloadedVideos.dart';
import 'package:datamine/Screens/Feedback.dart';
import 'package:datamine/Screens/Login.dart';
import 'package:datamine/Screens/OfferZone.dart';
import 'package:datamine/Screens/SignUp.dart';
import 'package:datamine/Screens/chatrooms.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Screens/AboutUs.dart';
import 'package:datamine/Screens/ContactUs.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppDrawer extends StatefulWidget {
  @override
  _CustomAppDrawerState createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  bool userLoggedIn = true;
  ScrollController _scrollController = ScrollController();
  checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");

    setState(() {
      if (data != null) {
        userLoggedIn = true;
        var parsedData = jsonDecode(data);
        Constants.id = parsedData['id'];
        Constants.myName = "${parsedData["fName"]}";
        Constants.email = parsedData["mail"];
      } else {
        userLoggedIn = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedIn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userLoggedIn);
    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  userLoggedIn
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNaviBar(indexNo: 2)));
                          },
                          child: Container(
                            height: 140,
                            width: constraints.maxWidth,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 60,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Constants.myName,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Profile",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black54,
                                            size: 14,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 180,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                color: appBarColorlight,
                                height: 180,
                                width: constraints.maxWidth,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: appbarTextColorLight,
                                  height: 39.4,
                                  width: constraints.maxWidth,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  "assets/img/Logo.jpg",
                                  height: 170,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: appbarTextColorLight,
                                  height: 50,
                                  width: constraints.maxWidth,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(
                                                        fromAppDrawer: true,
                                                        fromSplashScreen: false,
                                                        fromMyCourse: false,
                                                        fromProfile: false,
                                                        fromSignUp: false,
                                                        parent: this,
                                                      ),
                                                  settings: RouteSettings(
                                                      name: "/login")));
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 1,
                                                blurRadius: 2,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Sign In",
                                              style: TextStyle(
                                                  color: appBarColorlight,
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpScreen(
                                                        fromLogin: false,
                                                        fromProfile: true,
                                                        fromMyCourse: false,
                                                        parent: null,
                                                      ),
                                                  settings: RouteSettings(
                                                      name: "/signup")));
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: appBarColorlight,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 1,
                                                blurRadius: 2,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: appbarTextColorLight,
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DownloadedVideos(),
                          settings: RouteSettings(name: "/downloads")));
                    },
                    title: Text(
                      "My Downloads",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.file_download,
                      color: appBarColorlight,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AboutUs(),
                          settings: RouteSettings(name: "/aboutUs")));
                    },
                    title: Text(
                      "About Us",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.info,
                      color: appBarColorlight,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContactUs(),
                          settings: RouteSettings(name: "/contactUs")));
                    },
                    title: Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.call,
                      color: appBarColorlight,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      final RenderBox box = context.findRenderObject();
                      Share.text(
                          "Download Yourguru now",
                          "Download Yourguru from the playstore now, follow this link\n https://google.com",
                          "text/plain");
                    },
                    title: Text(
                      "Share",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.share,
                      color: appBarColorlight,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FeedbackPage(),
                          settings: RouteSettings(name: "/feedback")));
                    },
                    title: Text(
                      "Feedback",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.feedback,
                      color: appBarColorlight,
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: "ProximaNova",
                      ),
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: appBarColorlight,
                    ),
                    children: [
                      /*ListTile(
                        onTap: () {
                          if (Constants.email == "admin.torc@gmail.com") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatRoom()));
                          } else {
                            DatabaseMethods databaseMethods =
                                DatabaseMethods();
                            List<String> users = [
                              Constants.myName,
                              "Admin"
                            ];

                            String chatRoomId = "${Constants.id}_Admin";

                            Map<String, dynamic> chatRoom = {
                              "users": users,
                              "chatRoomId": chatRoomId,
                            };

                            databaseMethods.addChatRoom(
                                chatRoom, chatRoomId);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                          chatRoomId: chatRoomId,
                                          name: "Chat",
                                        )));
                          }
                        },
                        leading: Icon(
                          Icons.chat,
                          color: appBarColorlight,
                        ),
                        title: Text(
                          "Chat with us",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),*/
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          LaunchReview.launch(
                              androidAppId: "com.torcinfotech.Yourguru",
                              writeReview: false);
                        },
                        leading: Icon(
                          Icons.rate_review,
                          color: appBarColorlight,
                        ),
                        title: Text(
                          "Rate This App",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.assignment,
                          color: appBarColorlight,
                        ),
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.swap_horizontal_circle,
                          color: appBarColorlight,
                        ),
                        title: Text(
                          "Refund Policy",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Certificate(),
                              settings: RouteSettings(name: "/certificate")));
                        },
                        leading: Icon(
                          Icons.assignment_turned_in,
                          color: appBarColorlight,
                        ),
                        title: Text(
                          "Certificate Model",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: "ProximaNova",
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunch("https://torcinfotech.in/")) {
                              await launch("https://torcinfotech.in/");
                            }
                          },
                          child: Container(
                            //color: Colors.red,
                            height: 60,
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
