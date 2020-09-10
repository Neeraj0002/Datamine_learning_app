import 'dart:convert';

import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/CourseDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  List searchResult = List();
  var _data;
  getCourseListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("courseListData");
    var parsedData = jsonDecode(data);
    return parsedData;
  }

  Future sortList(String keyword) async {
    searchResult = List();
    for (int i = 0; i < _data["data"]["All"]["courses"].length; i++) {
      if (_data["data"]["All"]["courses"][i]["Title"]["en-US"]
          .toLowerCase()
          .contains(keyword)) {
        searchResult.add(_data["data"]["All"]["courses"][i]);
      }
    }
    //print(searchResult);
    if (keyword.isEmpty) {
      return null;
    } else {
      return searchResult;
    }
  }

  @override
  void initState() {
    searchNode.requestFocus();
    getCourseListData().then((value) {
      setState(() {
        _data = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          excludeHeaderSemantics: true,
          iconTheme: IconThemeData(color: appbarTextColorLight),
          backgroundColor: appBarColorlight,
          centerTitle: false,
          title: TextField(
            focusNode: searchNode,
            style: TextStyle(color: Colors.white),
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            onEditingComplete: () {
              setState(() {});
            },
            onSubmitted: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              color: appbarTextColorLight,
              onPressed: () {
                setState(() {
                  searchController.clear();
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: sortList(searchController.text.toLowerCase()),
            builder: (context, snapshot) {
              //print(snapshot.data);
              if (snapshot.hasData) {
                return ListView(
                  children: List.generate(snapshot.data.length, (index) {
                    return CourseCard2(
                        action: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            settings: RouteSettings(
                              name: "/CourseDetails",
                            ),
                            builder: (context) => CourseDetails(
                              outcome: snapshot.data[index]["Outcome"]["en-US"],
                              demoVideo: snapshot.data[index]["Demo"]["en-US"],
                              courseName: snapshot.data[index]["Title"]
                                  ["en-US"],
                              price: int.parse(
                                  snapshot.data[index]["Price"]["en-US"]),
                              imgUrl: snapshot.data[index]["Thumbnail"]
                                  ["en-US"],
                              desc: snapshot.data[index]["Details"]["en-US"],
                            ),
                          ));
                        },
                        title: snapshot.data[index]["Title"]["en-US"],
                        price: snapshot.data[index]["Price"]["en-US"],
                        imgUrl: snapshot.data[index]["Thumbnail"]["en-US"]);
                  }),
                );
              } else {
                return searchController.text.length != 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      );
              }
            }),
      ),
    );
  }
}

/** snapshot.data["data"]["All"]["courses"]
                                [index]["Outcome"]["en-US"]*/
