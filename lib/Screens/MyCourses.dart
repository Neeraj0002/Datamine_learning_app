import 'dart:convert';
import 'dart:io';

import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/PurchasedCourseDetailWithDownload.dart';
import 'package:datamine/Screens/PurchasedCourseDetails.dart';
import 'package:flutter/material.dart';
import 'package:datamine/API/purchasedCourse.dart';
import 'package:datamine/API/resourcesRequest.dart';
import 'package:datamine/API/testRequest.dart';
import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Screens/Appdrawer.dart';
import 'package:datamine/Screens/CourseDetails.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> myCourses = GlobalKey<ScaffoldState>();

class MainCourses extends StatefulWidget {
  bool fromLogin;
  MainCourses({@required this.fromLogin});
  @override
  _MainCoursesState createState() => _MainCoursesState();
}

class _MainCoursesState extends State<MainCourses> {
  bool _connected = false;
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

  @override
  void initState() {
    checkConnectivity().then((value) {
      setState(() {
        _connected = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.fromLogin ? 1 : 0,
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          key: myCourses,
          drawer: CustomAppDrawer(),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: appBarColorlight,
            leading: _connected
                ? IconButton(
                    icon: Icon(Icons.menu),
                    color: appbarTextColorLight,
                    onPressed: () {
                      myCourses.currentState.openDrawer();
                    },
                  )
                : Container(),
            title: Text(
              "Courses",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              indicatorColor: appbarTextColorLight,
              labelColor: appbarTextColorLight,
              tabs: [
                Tab(
                  text: "All Course",
                ),
                Tab(
                  text: "My Course",
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            FutureBuilder(
                future: checkConnectivity(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return AllCourses();
                    } else {
                      return Center(
                        child: Text("You are not connected"),
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
            MyCourses(this)
          ])),
    );
  }
}

class MyCourses extends StatefulWidget {
  _MainCoursesState parent;
  MyCourses(this.parent);
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool loggedIn = false;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      setState(() {
        loggedIn = true;
      });
    } else {
      setState(() {
        loggedIn = false;
      });
    }
  }

  Future setDir() async {
    var mainDir = await getApplicationDocumentsDirectory();
    return mainDir.path;
  }

  _loginScreen(BuildContext context) {
    return Scaffold(
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
                  fontFamily: "OpenSans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => BottomNaviBar(indexNo: 2),
                  settings: RouteSettings(name: "/homwScreen")));
            },
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
        ],
      ),
    );
  }

  Future getDownloadLog(urlValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkDownload = prefs.getBool(urlValue);
    return checkDownload;
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

  Future getStoredCoursesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("purchasedCourseList");
  }

  Future getStoredResourceList(String keyValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyValue);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? FutureBuilder(
            future: checkConnectivity(),
            builder: (context, connectionSnapshot) {
              if (connectionSnapshot.hasData) {
                if (connectionSnapshot.data) {
                  return FutureBuilder(
                      future: purchasedCourseListAPI(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          if (snapshot.data != 'fail') {
                            if (snapshot.data["data"]["batch"].length != 0) {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  setState(() {});
                                },
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  children: List.generate(
                                      snapshot.data["data"]["batch"].length,
                                      (index) {
                                    return CourseCard3(
                                      action: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            child: AlertDialog(
                                              content: Container(
                                                height: 80,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  appBarColorlight),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                        resourceAPI(
                                                snapshot.data["data"]["course"]
                                                    [index],
                                                snapshot.data["data"]["batch"]
                                                        [index]
                                                    .toString())
                                            .then((value) async {
                                          if (value != "fail") {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            //STORE RESOURCE RESULT
                                            prefs
                                                .setString(
                                                    "${snapshot.data["data"]["course"][index]}_Resources_$index",
                                                    jsonEncode(value))
                                                .then((storedResult) {
                                              testAPI().then((testValue) {
                                                if (testValue != "fail") {
                                                  getDownloadLog(value[0]
                                                          ["UniqueId"]["en-US"])
                                                      .then((downloadValue) {
                                                    setDir()
                                                        .then((mainDirValue) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        settings: RouteSettings(
                                                          name:
                                                              "/mentorProfile",
                                                        ),
                                                        builder: (context) =>
                                                            PurchasedCourseDetailsWithDownload(
                                                          mainDir: mainDirValue,
                                                          courseName: snapshot
                                                                  .data["data"]
                                                              ["course"][index],
                                                          batchNo: snapshot
                                                                  .data["data"]
                                                              ["batch"][index],
                                                          resourceData: value,
                                                          testData: testValue,
                                                          fromDownloads:
                                                              downloadValue ==
                                                                      null
                                                                  ? false
                                                                  : downloadValue,
                                                        ),
                                                      ));
                                                    });
                                                  });
                                                } else {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      child: AlertDialog(
                                                        title: Text(
                                                          "Failed",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontFamily:
                                                                  "OpenSans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                        ),
                                                        content: Text(
                                                          "There are some issues with our server, please try again in a few minutes.",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "OpenSans",
                                                              fontSize: 14),
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: Text(
                                                              "OK",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ));
                                                }
                                              });
                                            });
                                          } else {
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                child: AlertDialog(
                                                  title: Text(
                                                    "Failed",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily: "OpenSans",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                  content: Text(
                                                    "There are some issues with our server, please try again in a few minutes.",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "OpenSans",
                                                        fontSize: 14),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ));
                                          }
                                        });
                                      },
                                      title: snapshot.data["data"]["course"]
                                          [index],
                                    );
                                  }),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                onRefresh: () async {
                                  setState(() {});
                                },
                                child: Stack(
                                  children: [
                                    ListView(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            "No courses purchased",
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "Swipe down to refresh",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return RefreshIndicator(
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: Stack(
                                children: [
                                  ListView(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Something went wrong",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "Swipe down to refresh",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                  return FutureBuilder(
                    future: getStoredCoursesList(),
                    builder: (context, storedSnapshot) {
                      if (storedSnapshot.hasData) {
                        var parsedData = jsonDecode(storedSnapshot.data);
                        return ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: List.generate(
                              parsedData["data"]["batch"].length, (index) {
                            return CourseCard3(
                              action: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: AlertDialog(
                                      content: Container(
                                        height: 80,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          appBarColorlight),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                                getStoredResourceList(
                                        "${parsedData["data"]["course"][index]}_Resources_$index")
                                    .then((value) {
                                  if (value != null) {
                                    var parsedResourceValue = jsonDecode(value);
                                    setDir().then((mainDirValue) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        settings: RouteSettings(
                                          name: "/mentorProfile",
                                        ),
                                        builder: (context) =>
                                            PurchasedCourseDetailsWithDownload(
                                          mainDir: mainDirValue,
                                          courseName: parsedData["data"]
                                              ["course"][index],
                                          batchNo: parsedData["data"]["batch"]
                                              [index],
                                          resourceData: parsedResourceValue,
                                          testData: null,
                                          fromDownloads: false,
                                        ),
                                      ));
                                    });
                                  } else {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          backgroundColor: Colors.red,
                                          title: Text(
                                            "Failed",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "OpenSans",
                                                fontSize: 18),
                                          ),
                                          content: Text(
                                            "No internet connection",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "OpenSans",
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
                                                    fontFamily: "OpenSans",
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  }
                                });
                              },
                              title: parsedData["data"]["course"][index],
                            );
                          }),
                        );
                      } else {
                        return Center(child: Text("You are not connected"));
                      }
                    },
                  );
                }
              } else {
                return Container();
              }
            })
        : _loginScreen(context);
  }
}

class AllCourses extends StatefulWidget {
  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  getCourseListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("courseListData");
    var parsedData = jsonDecode(data);
    return parsedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCourseListData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data != 'fail') {
              return ListView(
                children: List.generate(
                    snapshot.data["data"]["All"]["courses"].length, (index) {
                  return CourseCard2(
                      action: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          settings: RouteSettings(
                            name: "/CourseDetails",
                          ),
                          builder: (context) => CourseDetails(
                            outcome: snapshot.data["data"]["All"]["courses"]
                                [index]["Outcome"]["en-US"],
                            demoVideo: snapshot.data["data"]["All"]["courses"]
                                [index]["Demo"]["en-US"],
                            courseName: snapshot.data["data"]["All"]["courses"]
                                [index]["Title"]["en-US"],
                            price: int.parse(snapshot.data["data"]["All"]
                                ["courses"][index]["Price"]["en-US"]),
                            imgUrl: snapshot.data["data"]["All"]["courses"]
                                [index]["Thumbnail"]["en-US"],
                            desc: snapshot.data["data"]["All"]["courses"][index]
                                ["Details"]["en-US"],
                          ),
                        ));
                      },
                      title: snapshot.data["data"]["All"]["courses"][index]
                          ["Title"]["en-US"],
                      price:
                          "₹${snapshot.data["data"]["All"]["courses"][index]["Price"]["en-US"]}",
                      imgUrl: snapshot.data["data"]["All"]["courses"][index]
                          ["Thumbnail"]["en-US"]);
                }),
              );
            } else {
              return Center(
                child: Text(
                  "No courses available",
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(appBarColorlight),
              ),
            );
          }
        });
  }
}
