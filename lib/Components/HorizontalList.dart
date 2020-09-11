import 'package:flutter/material.dart';
import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Screens/CourseDetails.dart';

// ignore: must_be_immutable
class HorizontalDataList extends StatelessWidget {
  final String title;
  List dataList;
  HorizontalDataList({@required this.dataList, @required this.title});
  @override
  Widget build(BuildContext context) {
    return dataList.length != 0
        ? Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: List.generate(dataList.length, (index) {
                        return CourseCard(
                          action: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              settings: RouteSettings(
                                name: "/mentorProfile",
                              ),
                              builder: (context) => CourseDetails(
                                outcome: dataList[index]["Outcome"]["en-US"],
                                demoVideo: dataList[index]["Demo"] != null
                                    ? dataList[index]["Demo"]["en-US"]
                                    : null,
                                courseName: dataList[index]["Title"]["en-US"],
                                price: int.parse(
                                    dataList[index]["Price"]["en-US"]),
                                imgUrl: dataList[index]["Thumbnail"]["en-US"],
                                desc: dataList[index]["Details"]["en-US"],
                              ),
                            ));
                          },
                          title: dataList[index]["Title"]["en-US"],
                          price: "₹${dataList[index]["Price"]["en-US"]}",
                          imgUrl: dataList[index]["Thumbnail"]["en-US"],
                        );
                      })),
                ),
              )
            ],
          )
        : Container(
            height: 0,
            width: 0,
          );
  }
}
