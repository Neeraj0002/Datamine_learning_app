import 'package:cached_network_image/cached_network_image.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Certificate.dart';
import 'package:datamine/Screens/ChatScreen2.dart';
import 'package:datamine/Screens/Feedback.dart';
import 'package:datamine/Screens/chatrooms.dart';
import 'package:datamine/constants.dart';
import 'package:datamine/services/database.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Screens/AboutUs.dart';
import 'package:datamine/Screens/ContactUs.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    if (await canLaunch("https://torcinfotech.in/")) {
                      await launch("https://torcinfotech.in/");
                    }
                  },
                  child: Container(
                    //color: Colors.red,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Powered by",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: "OpenSans",
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Torc Infotech",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "OpenSans",
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: constraints.maxHeight - 60,
                //color: Colors.red,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              color: appBarColorlight,
                              height: 100,
                              width: constraints.maxWidth,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: appbarTextColorLight,
                                height: 22,
                                width: constraints.maxWidth,
                              ),
                            ),
                            Center(
                              child: Image.asset(
                                "assets/img/Logo.jpg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ExpansionTile(
                        title: Text(
                          "Settings",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "OpenSans",
                          ),
                        ),
                        children: [
                          ListTile(
                            onTap: () {
                              if (Constants.email == "admin.torc@gmail.com") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatRoom()));
                              } else {
                                DatabaseMethods databaseMethods =
                                    DatabaseMethods();
                                List<String> users = [
                                  Constants.myName,
                                  "Admin"
                                ];

                                String chatRoomId = "${Constants.id}_Admin";

                                Map<String, dynamic> chatRoom = {
                                  "users": users,
                                  "chatRoomId": chatRoomId,
                                };

                                databaseMethods.addChatRoom(
                                    chatRoom, chatRoomId);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                              chatRoomId: chatRoomId,
                                              name: "Chat",
                                            )));
                              }
                            },
                            title: Text(
                              "Chat with us",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              LaunchReview.launch(
                                  androidAppId: "com.torcinfotech.Yourguru",
                                  writeReview: false);
                            },
                            title: Text(
                              "Rate This App",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: Text(
                              "Refund Policy",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Certificate(),
                                  settings:
                                      RouteSettings(name: "/certificate")));
                            },
                            title: Text(
                              "Certificate",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutUs(),
                              settings: RouteSettings(name: "/aboutUs")));
                        },
                        title: Text(
                          "About Us",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactUs(),
                              settings: RouteSettings(name: "/contactUs")));
                        },
                        title: Text(
                          "Contact Us",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          final RenderBox box = context.findRenderObject();
                          Share.text(
                              "Download Yourguru now",
                              "Download Yourguru from the playstore now, follow this link\n https://google.com",
                              "text/plain");
                        },
                        title: Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FeedbackPage(),
                              settings: RouteSettings(name: "/feedback")));
                        },
                        title: Text(
                          "Feedback",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "OpenSans",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
