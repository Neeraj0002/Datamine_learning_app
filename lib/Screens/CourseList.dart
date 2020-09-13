import 'dart:convert';

import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/CourseDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseList extends StatefulWidget {
  List data;
  final String categoryName;
  CourseList({@required this.categoryName, @required this.data});
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  List _dataList;

  getCourseListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("courseListData");
    var parsedData = jsonDecode(data);
    return parsedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColorlight,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: List.generate(widget.data.length, (index) {
          return CourseCard2(
              action: () {
                Navigator.of(context).push(MaterialPageRoute(
                  settings: RouteSettings(
                    name: "/CourseDetails",
                  ),
                  builder: (context) => CourseDetails(
                    outcome: widget.data[index]["Outcome"]["en-US"],
                    demoVideo: widget.data[index]["Demo"] != null
                        ? widget.data[index]["Demo"]["en-US"]
                        : null,
                    courseName: widget.data[index]["Title"]["en-US"],
                    price: int.parse(widget.data[index]["Price"]["en-US"]),
                    imgUrl: widget.data[index]["Thumbnail"]["en-US"],
                    desc: widget.data[index]["Details"]["en-US"],
                  ),
                ));
              },
              title: widget.data[index]["Title"]["en-US"],
              price: "₹${widget.data[index]["Price"]["en-US"]}",
              imgUrl: widget.data[index]["Thumbnail"]["en-US"]);
        }),
      ),
    );
  }
}
