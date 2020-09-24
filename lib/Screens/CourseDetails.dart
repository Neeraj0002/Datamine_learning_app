import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:datamine/API/couponsRequest.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Screens/BottomNaviBar.dart';
import 'package:datamine/Screens/EnrollScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:datamine/API/purchaseRequest.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

GlobalKey<ScaffoldState> courseDetailKey = GlobalKey<ScaffoldState>();

// ignore: must_be_immutable
class CourseDetails extends StatefulWidget {
  String courseName;
  String imgUrl;
  int price;
  String desc;
  String demoVideo;
  List outcome;
  CourseDetails(
      {@required this.courseName,
      @required this.desc,
      @required this.imgUrl,
      @required this.price,
      @required this.demoVideo,
      @required this.outcome});
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  //Razorpay _razorpay;
  var userData;
  bool loggedIn = false;
  VideoPlayerController videoPlayerController;

  int nowPlaying = 0;

  ChewieController chewieController;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      setState(() {
        var parsedData = jsonDecode(data);
        userData = parsedData;
        loggedIn = true;
      });
    } else {
      setState(() {
        loggedIn = false;
      });
    }
  }

  @override
  void initState() {
    userData = getUserData();
    if (widget.demoVideo != null) {
      videoPlayerController = VideoPlayerController.network(widget.demoVideo);
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: 16 / 9,
          autoPlay: false,
          looping: false,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          fullScreenByDefault: false,
          materialProgressColors: ChewieProgressColors(
              playedColor: appBarColorlight,
              handleColor: appBarColorlight,
              bufferedColor: appbarTextColorLight),
          errorBuilder: (context, errorMessage) {
            return CachedNetworkImage(
              imageUrl: widget.imgUrl,
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(appBarColorlight),
                    ),
                  ),
                );
              },
              fit: BoxFit.fill,
            );
          },
          placeholder: Container(),
          overlay: Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Datamine",
                      style: TextStyle(
                          shadows: [
                            Shadow(color: Colors.black26, offset: Offset(1, 1))
                          ],
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: "Roboto",
                          fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
          ));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //_razorpay.clear();
    if (widget.demoVideo != null) {
      videoPlayerController.dispose();
      chewieController.dispose();
    }
  }

  Future getCoupons(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          content: Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(appBarColorlight),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    couponAPI().then((value) {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EnrollScreen(
                coupon: value,
                phone: userData["phone"],
                mail: userData["mail"],
                courseName: widget.courseName,
                thumbnail: widget.imgUrl,
                price: widget.price,
              ),
          settings: RouteSettings(name: "/enroll")));
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: courseDetailKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBarColorlight,
        title: Text(
          "${widget.courseName}",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
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
              Container(
                height: 70,
                width: screenWidth,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                  child: customButton(
                      action: () {
                        chewieController.pause();
                        loggedIn
                            ? getCoupons(context)
                            : showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "ProximaNova",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                    "Please login to buy this course",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "ProximaNova",
                                      fontSize: 14,
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNaviBar(indexNo: 2),
                                                settings: RouteSettings(
                                                    name: "/homwScreen")));
                                      },
                                      child: Text(
                                        "Login Now",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                      },
                      color: appBarColorlight,
                      text: "Buy Course"),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight - 360,
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: screenWidth,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 8.0),
                            child: Text(
                              widget.courseName,
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            child: Text(
                              "₹${widget.price}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Container(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8.0, top: 20),
                          child: Text(
                            "Details",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8.0, top: 20),
                          child: Text(
                            widget.desc,
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Roboto",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8.0, top: 20),
                          child: Text(
                            "Course Outcome",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                          widget.outcome.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.arrow_right, color: Colors.black54),
                                Container(
                                  width: screenWidth * (0.85),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 8.0, top: 0),
                                    child: Text(
                                      widget.outcome[index],
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 0,
                        width: 0,
                        child: Chewie(
                          controller: chewieController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VideoListItem(
                            action: () {
                              print("TOGGLE FULL SCREEN");
                              chewieController.toggleFullScreen();
                            },
                            icon: Icons.play_arrow,
                            title: "Demo Video"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class VideoListItem extends StatelessWidget {
  Function action;
  var icon;
  String title;
  VideoListItem(
      {@required this.action, @required this.icon, @required this.title});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
            color: appBarColorlight, borderRadius: BorderRadius.circular(5)),
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: LayoutBuilder(builder: (context, limits) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: limits.maxWidth * (0.6),
                      child: Text(
                        title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Container()
              ],
            );
          }),
        ),
      ),
    );
  }
}
