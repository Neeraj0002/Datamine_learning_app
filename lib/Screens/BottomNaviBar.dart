import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:datamine/Screens/Profile.dart';
import 'package:datamine/Screens/MyCourses.dart';

//This is the index page

class BottomNaviBar extends StatefulWidget {
  final int indexNo;
  BottomNaviBar({@required this.indexNo});
  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int _index = 0;

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
      default:
    }
  }

  @override
  void initState() {
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
                  fontFamily: "OpenSans",
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
                      fontFamily: "OpenSans",
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
                      fontFamily: "OpenSans",
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
                    style: TextStyle(fontFamily: "OpenSans"),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.library_books),
                  title: Text(
                    "Courses",
                    style: TextStyle(fontFamily: "OpenSans"),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontFamily: "OpenSans"),
                  ))
            ]),
        body: _onChanged(),
      ),
    );
  }
}
