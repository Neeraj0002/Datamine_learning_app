import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  @override
  void initState() {
    searchNode.requestFocus();
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
          body:
              Container() /*FutureBuilder(
            future: searchDataAPI(searchController.text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (CourseListModel.fromJson(snapshot.data).status == "1") {
                  if (CourseListModel.fromJson(snapshot.data).data.length !=
                      0) {
                    return searchController.text.length != 0
                        ? ListView(
                            children: List.generate(
                                CourseListModel.fromJson(snapshot.data)
                                    .data
                                    .length, (index) {
                              return CourseCard2(
                                action: () {},
                                title: CourseListModel.fromJson(snapshot.data)
                                    .data[index]
                                    .title,
                                price:
                                    "₹${CourseListModel.fromJson(snapshot.data).data[index].price}",
                                time: CourseListModel.fromJson(snapshot.data)
                                    .data[index]
                                    .duration
                                    .toString(),
                                imgUrl: CourseListModel.fromJson(snapshot.data)
                                    .data[index]
                                    .thumbnail,
                              );
                            }),
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          );
                  } else {
                    return Center(
                      child: Text("No results found"),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No results found"),
                  );
                }
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
            }),*/
          ),
    );
  }
}
