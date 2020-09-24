import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datamine/API/generalRequest.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/ChatUser.dart';
import 'package:datamine/Screens/CourseList.dart';
import 'package:datamine/Screens/Notifications.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:launch_review/launch_review.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> homeKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool userLoggedIn = false;
  bool connected = false;
  var notificationData;
  sendMessage() {
    List<String> users = [Constants.myName, "Admin"];

    String chatRoomId = "${Constants.id}_Admin";

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    //databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatUser(
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

  getNotificationLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("notificationLength");
  }

  Future getCourseListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("courseListData");
    var parsedData = jsonDecode(data);
    return parsedData;
  }

  Future checkConnectivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool connection;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connection = true;
        prefs.setBool("connected", true).then((value) {});
      }
    } on SocketException catch (_) {
      connection = false;
      prefs.setBool("connected", false).then((value) {
        setState(() {});
      });
      print('not connected');
    }
    return connection;
  }

  Future setNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("notificationLength",
        notificationData["data"]["Notification"]["notifications"].length);
    setState(() {});
    return "done";
  }

  @override
  void initState() {
    checkUserLoggedIn();
    checkConnectivity().then((value) {
      setState(() {
        connected = value;
      });
      getCourseListData().then((value) {
        setState(() {
          notificationData = value;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeKey,
      drawer: CustomAppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColorlight,
        leading: connected
            ? IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                onPressed: () {
                  homeKey.currentState.openDrawer();
                },
              )
            : Container(),
        title: Text(
          "Datamine",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "ProximaNova",
              fontWeight: FontWeight.bold),
        ),
        actions: [
          /*userLoggedIn
              ? */
          connected
              ? Stack(
                  children: [
                    FutureBuilder(
                      future: getNotificationLength(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (notificationData["data"]["Notification"]
                                      ["notifications"]
                                  .length ==
                              snapshot.data) {
                            return Center(
                              child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.notifications),
                                onPressed: () {
                                  if (notificationData != null) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      settings:
                                          RouteSettings(name: "/notifications"),
                                      builder: (context) => NotificationPage(
                                          data: notificationData["data"]
                                                  ["Notification"]
                                              ["notifications"]),
                                    ));
                                  }
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: AvatarGlow(
                                glowColor: Colors.white,
                                endRadius: 30.0,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration:
                                    Duration(milliseconds: 100),
                                child: IconButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.notifications),
                                  onPressed: () {
                                    if (notificationData != null) {
                                      setNotificationCount().then((value) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          settings: RouteSettings(
                                              name: "/notifications"),
                                          builder: (context) =>
                                              NotificationPage(
                                                  data: notificationData["data"]
                                                          ["Notification"]
                                                      ["notifications"]),
                                        ));
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                )
              : Container(),
          connected
              ? IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      settings: RouteSettings(name: "/search"),
                      builder: (context) => Search(),
                    ));
                  },
                )
              : Container(),
        ],
      ),
      body: FutureBuilder(
          future: checkConnectivity(),
          builder: (context, connectionSnapshot) {
            if (connectionSnapshot.hasData) {
              if (connectionSnapshot.data) {
                return FutureBuilder(
                    future: getCourseListData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        if (snapshot.data != 'fail') {
                          return ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 55,
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          snapshot
                                              .data["data"]["CList"]
                                                  ["allCategory"]
                                              .length, (index) {
                                        List _courseList = List();
                                        for (int i = 0;
                                            i <
                                                snapshot
                                                    .data["data"]["All"]
                                                        ["courses"]
                                                    .length;
                                            i++) {
                                          if (snapshot.data["data"]["All"]
                                                      ["courses"][i]["Category"]
                                                      ["en-US"]
                                                  .toString()
                                                  .toLowerCase() ==
                                              snapshot.data["data"]["CList"]
                                                      ["allCategory"][index]
                                                  .toString()
                                                  .toLowerCase()) {
                                            _courseList.add(
                                                snapshot.data["data"]["All"]
                                                    ["courses"][i]);
                                          }
                                        }
                                        return CategoryCard(
                                          action: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              settings: RouteSettings(
                                                  name: "/courseList"),
                                              builder: (context) => CourseList(
                                                data: _courseList,
                                                categoryName: snapshot
                                                        .data["data"]["CList"]
                                                    ["allCategory"][index],
                                              ),
                                            ));
                                          },
                                          title: snapshot.data["data"]["CList"]
                                              ["allCategory"][index],
                                        );
                                      })),
                                ),
                              ),
                              FutureBuilder(
                                future: sliderListAPI(),
                                builder: (context, imageSnapshot) {
                                  if (imageSnapshot.connectionState ==
                                          ConnectionState.done &&
                                      imageSnapshot.hasData) {
                                    /*return Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Swiper(
                                        itemCount: imageSnapshot
                                            .data["data"]["images"].length,
                                        autoplay: true,
                                        itemBuilder: (context, index) {
                                          return CachedNetworkImage(
                                            imageUrl: imageSnapshot.data["data"]
                                                ["images"][index],
                                            errorWidget: (context, url, error) {
                                              return Center(
                                                child: Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              );
                                            },
                                            progressIndicatorBuilder:
                                                (context, url, progress) {
                                              return Center(
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            appBarColorlight),
                                                  ),
                                                ),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    );*/
                                    return ImageSlider(
                                        imgUrls: imageSnapshot.data["data"]
                                            ["images"]);
                                  } else {
                                    return Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  appBarColorlight),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              Column(children: [
                                HorizontalDataList(
                                    dataList: snapshot.data["data"]["Trending"]
                                        ["courses"],
                                    title: "Trending")
                              ]),
                              /*Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 8.0, bottom: 8),
                                    child: Text(
                                      "Trending",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "ProximaNova",
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Swiper(
                                  itemCount: snapshot
                                      .data["data"]["Trending"]["courses"]
                                      .length,
                                  autoplay: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          settings: RouteSettings(
                                            name: "/mentorProfile",
                                          ),
                                          builder: (context) => CourseDetails(
                                            outcome: snapshot.data["data"]
                                                    ["Trending"]["courses"]
                                                [index]["Outcome"]["en-US"],
                                            demoVideo: snapshot.data["data"]
                                                                ["Trending"]
                                                            ["courses"][index]
                                                        ["Demo"] !=
                                                    null
                                                ? snapshot.data["data"]
                                                        ["Trending"]["courses"]
                                                    [index]["Demo"]["en-US"]
                                                : null,
                                            courseName: snapshot.data["data"]
                                                    ["Trending"]["courses"]
                                                [index]["Title"]["en-US"],
                                            price: int.parse(
                                                snapshot.data["data"]
                                                        ["Trending"]["courses"]
                                                    [index]["Price"]["en-US"]),
                                            imgUrl: snapshot.data["data"]
                                                    ["Trending"]["courses"]
                                                [index]["Thumbnail"]["en-US"],
                                            desc: snapshot.data["data"]
                                                    ["Trending"]["courses"]
                                                [index]["Details"]["en-US"],
                                          ),
                                        ));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data["data"]
                                                ["Trending"]["courses"][index]
                                            ["Thumbnail"]["en-US"],
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Center(
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        appBarColorlight),
                                              ),
                                            ),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Achieve your goals with datamine",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "ProximaNova",
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        MdiIcons.brain,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                    Text(
                                      "Learn the latest skills",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        MdiIcons.teach,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                    Text(
                                      "Get Ready for a career",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        MdiIcons.certificate,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                    Text(
                                      "Earn a certificate",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.people_outline,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                    Text(
                                      "Upskill your organization",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    LaunchReview.launch(
                                        androidAppId:
                                            "com.torcinfotech.datamine",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                                5,
                                                (index) => Icon(
                                                      Icons.star,
                                                      color:
                                                          appbarTextColorLight,
                                                      size: 30,
                                                    )),
                                          ),
                                        ),
                                        Container(
                                          height: 60,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: appBarColorlight,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Center(
                                              child: Text(
                                                "Hope you enjoyed learning with us.\nRate us on Play Store",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "ProximaNova",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
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
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                appBarColorlight),
                          ),
                        );
                      }
                    });
              } else {
                return Center(
                  child: Text(
                    "You are not connected.",
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  Function action;
  final String title;
  CategoryCard({this.action, this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: action,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 3,
                  color: Colors.black12,
                )
              ]),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "ProximaNova",
                    fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GeneralItem extends StatelessWidget {
  String rating;
  String courses;
  String reviews;
  String users;
  GeneralItem(
      {@required this.courses,
      @required this.rating,
      @required this.reviews,
      @required this.users});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * (0.75),
                  child: Text(
                    rating,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "ProximaNova",
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.rate_review,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * (0.75),
                  child: Text(
                    reviews,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "ProximaNova",
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.people,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * (0.75),
                  child: Text(
                    users,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "ProximaNova",
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.video_library,
                  color: Colors.amber,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * (0.75),
                  child: Text(
                    courses,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "ProximaNova",
                      fontSize: 12,
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
