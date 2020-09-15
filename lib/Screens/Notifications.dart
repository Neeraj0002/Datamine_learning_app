import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  var data;
  NotificationPage({@required this.data});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  _notificationItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: appBarColorlight,
                  fontFamily: "ProximaNova",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                desc,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "ProximaNova",
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("notificationLength", widget.data.length);
  }

  @override
  void initState() {
    setNotificationCount();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        backgroundColor: appBarColorlight,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return _notificationItem(widget.data[index]["Title"]["en-US"],
              widget.data[index]["Description"]["en-US"]);
        },
      ),
    );
  }
}
