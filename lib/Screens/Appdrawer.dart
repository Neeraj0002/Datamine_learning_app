import 'package:cached_network_image/cached_network_image.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/Feedback.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Screens/AboutUs.dart';
import 'package:datamine/Screens/ContactUs.dart';
import 'package:launch_review/launch_review.dart';

class CustomAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://eruditegroup.co.nz/wp-content/uploads/2016/07/profile-dummy3.png",
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return Center(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  appBarColorlight),
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
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
                      "Download Datamine now",
                      "Download Datamine from the playstore now, follow this link\n https://google.com",
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
                  LaunchReview.launch(
                      androidAppId: "com.torcinfotech.datamine",
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
    );
  }
}
