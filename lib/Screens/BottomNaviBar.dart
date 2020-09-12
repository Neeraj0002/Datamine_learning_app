import 'dart:convert';

import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/ChatScreen2.dart';
import 'package:datamine/Screens/chatrooms.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:datamine/Screens/Profile.dart';
import 'package:datamine/Screens/MyCourses.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This is the index page

class BottomNaviBar extends StatefulWidget {
  final int indexNo;
  BottomNaviBar({@required this.indexNo});
  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int _index = 0;
  bool userLoggedIn = false;
  Future checkUserLoggedIn() async {
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

  showChat() {
    checkUserLoggedIn();
    if (userLoggedIn) {
      if (Constants.email == "admin.torc@gmail.com") {
        return ChatRoom();
      } else {
        DatabaseMethods databaseMethods = DatabaseMethods();
        List<String> users = [Constants.myName, "Admin"];

        String chatRoomId = "${Constants.id}_Admin";

        Map<String, dynamic> chatRoom = {
          "users": users,
          "chatRoomId": chatRoomId,
        };

        databaseMethods.addChatRoom(chatRoom, chatRoomId);

        return Chat(
          chatRoomId: chatRoomId,
          name: "Chat",
        );
      }
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Chat",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: appBarColorlight,
        ),
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
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => BottomNaviBar(indexNo: 2),
                    settings: RouteSettings(name: "/homeScreen")));
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
  }

  _onChanged() {
    switch (_index) {
      case 0:
        return HomeScreen();
        break;
      case 1:
        return MainCourses(
          fromLogin:
              widget.indexNo != null && widget.indexNo == 1 ? true : false,
        );
        break;
      case 2:
        return Profile();
        break;
      case 3:
        return showChat();
        break;
      default:
    }
  }

  @override
  void initState() {
    checkUserLoggedIn();
    if (widget.indexNo != null) {
      setState(() {
        _index = widget.indexNo;
      });
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: appBarColorlight,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            child: AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                "Are you sure that you want to exit?",
                textAlign: TextAlign.center,
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
                    SystemNavigator.pop();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            backgroundColor: Colors.white,
            selectedItemColor: appBarColorlight,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: TextStyle(fontFamily: "ProximaNova"),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books),
                  title: Text(
                    "Courses",
                    style: TextStyle(fontFamily: "ProximaNova"),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontFamily: "ProximaNova"),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  title: Text(
                    "Chat",
                    style: TextStyle(fontFamily: "ProximaNova"),
                  ))
            ]),
        body: _onChanged(),
      ),
    );
  }
}
