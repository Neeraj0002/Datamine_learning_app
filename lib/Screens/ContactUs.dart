import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:datamine/API/detailsAPI.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColorlight,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Contact Us",
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: detailsAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data != "fail") {
                return Stack(
                  children: [
                    Align(
                      child: Container(
                        height: (MediaQuery.of(context).size.height) -
                            (MediaQuery.of(context).padding.top + 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                onPressed: () async {
                                  var whatsappUrl =
                                      "whatsapp://send?phone=${snapshot.data["data"]["contact"]["Whatsapp"]["en-US"]}";
                                  if (await canLaunch(whatsappUrl)) {
                                    launch(whatsappUrl);
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(80)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 2)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.whatsapp,
                                        color: Colors.green,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data["data"]["contact"]
                                            ["Whatsapp"]["en-US"],
                                        style: TextStyle(
                                          fontFamily: "ProximaNova",
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                onPressed: () async {
                                  launch(
                                      "tel:${snapshot.data["data"]["contact"]["Mobile"]["en-US"]}");
                                },
                                child: Container(
                                  width: 180,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(80)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 2)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.phone,
                                        color: appBarColorlight,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data["data"]["contact"]
                                            ["Mobile"]["en-US"],
                                        style: TextStyle(
                                          fontFamily: "ProximaNova",
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 260,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 1,
                                          blurRadius: 2)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: appBarColorlight,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        child: Text(
                                          "${snapshot.data["data"]["contact"]["Address"]["en-US"]}",
                                          style: TextStyle(
                                            fontFamily: "ProximaNova",
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(appBarColorlight),
                ),
              );
            }
          }),
    );
  }
}
