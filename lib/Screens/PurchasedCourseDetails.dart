import 'package:chewie/chewie.dart';
import 'package:datamine/Components/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:datamine/Screens/quizScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class PurchasedCourseDetails extends StatefulWidget {
  String batchNo;
  String courseName;
  var resourceData;
  var testData;
  PurchasedCourseDetails(
      {@required this.batchNo,
      @required this.courseName,
      @required this.resourceData,
      @required this.testData});
  @override
  _PurchasedCourseDetailsState createState() => _PurchasedCourseDetailsState();
}

class _PurchasedCourseDetailsState extends State<PurchasedCourseDetails> {
  bool downloading = false;
  var progressString = "";

  Future<void> downloadFile(imgUrl) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      await dio.download(imgUrl, "${dir.path}/demo.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: appBarColorlight,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              widget.courseName,
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              labelColor: appbarTextColorLight,
              indicatorColor: appbarTextColorLight,
              tabs: [
                Tab(
                  text: "Videos",
                ),
                Tab(
                  text: "Quiz",
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            Screen1(
              data: widget.resourceData,
            ),
            Screen2(currentCourse: widget.courseName, data: widget.testData)
          ])),
    );
  }
}

// ignore: must_be_immutable
class Screen1 extends StatefulWidget {
  var data;
  Screen1({@required this.data});
  @override
  _Screen1State createState() => _Screen1State(data);
}

class _Screen1State extends State<Screen1> {
  var _data;
  _Screen1State(this._data);

  VideoPlayerController videoPlayerController;

  int nowPlaying = 0;

  ChewieController chewieController;

  String currentVideo;

  @override
  void initState() {
    currentVideo = _data[nowPlaying]["Link"]["en-US"];
    videoPlayerController = VideoPlayerController.network(currentVideo);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        fullScreenByDefault: false,
        materialProgressColors: ChewieProgressColors(
            playedColor: appBarColorlight,
            handleColor: appBarColorlight,
            bufferedColor: appbarTextColorLight),
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
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Chewie(
          controller: chewieController,
        ),
        Column(
          children: [
            Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Text(
                        _data[0]["Title"]["en-US"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.timer,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    " ${_data[0]["StartDate"]["en-US"].toString().substring(0, 10)} ${_data[0]["StartDate"]["en-US"].toString().substring(11)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.timerOff,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    " ${_data[0]["EndDate"]["en-US"].toString().substring(0, 10)} ${_data[0]["EndDate"]["en-US"].toString().substring(11)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Roboto",
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
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
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 8.0, top: 20),
                    child: Text(
                      "Videos",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(_data.length, (index) {
                    return VideoListItem(
                        action: () {
                          if (nowPlaying != index) {
                            setState(() {
                              nowPlaying = index;
                              currentVideo = _data[nowPlaying]["Link"]["en-US"];
                              videoPlayerController =
                                  VideoPlayerController.network(currentVideo);
                              chewieController = ChewieController(
                                  videoPlayerController: videoPlayerController,
                                  aspectRatio: 16 / 9,
                                  autoPlay: true,
                                  looping: true,
                                  deviceOrientationsAfterFullScreen: [
                                    DeviceOrientation.portraitUp
                                  ],
                                  fullScreenByDefault: false,
                                  materialProgressColors: ChewieProgressColors(
                                      playedColor: appBarColorlight,
                                      handleColor: appBarColorlight,
                                      bufferedColor: appbarTextColorLight),
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
                                                    Shadow(
                                                        color: Colors.black26,
                                                        offset: Offset(1, 1))
                                                  ],
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontFamily: "Roboto",
                                                  fontSize: 12),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            });
                          }
                        },
                        active: index == nowPlaying ? true : false,
                        duration: "",
                        icon: MdiIcons.play,
                        title: _data[index]["Title"]["en-US"]);
                  }),
                )
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class VideoListItem extends StatelessWidget {
  Function action;
  var icon;
  String title;
  String duration;
  bool active;
  VideoListItem(
      {@required this.action,
      @required this.duration,
      @required this.icon,
      @required this.title,
      @required this.active});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        color: active ? appBarColorlight : Colors.transparent,
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
                      color: active ? Colors.white : Colors.black,
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
                          color: active ? Colors.white : Colors.black54,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  duration,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.black45,
                    fontFamily: "Roboto",
                    fontSize: 14,
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Screen2 extends StatefulWidget {
  String currentCourse;
  var data;
  Screen2({@required this.currentCourse, @required this.data});
  @override
  _Screen2State createState() => _Screen2State(data);
}

class _Screen2State extends State<Screen2> {
  List _sortedList = List();
  var _data;
  _Screen2State(this._data);
  _sortList() {
    for (int i = 0; i < _data.length; i++) {
      print(widget.currentCourse);

      if (_data[i]["Course"]["en-US"] == widget.currentCourse) {
        _sortedList.add(_data[i]);
      }
    }
  }

  @override
  void initState() {
    _sortList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _sortedList.length != 0
        ? ListView.builder(
            itemCount: _sortedList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.black)),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => QuizScreen(
                          question: _sortedList[index]["Questions"]["en-US"],
                          answers: _sortedList[index]["Answers"]["en-US"],
                          options: _sortedList[index]["Options"]["en-US"],
                        ),
                      ));
                    },
                    child: Center(
                      child: Text(
                        "Quiz ${index + 1}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "ProximaNova",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            })
        : Center(
            child: Text("No test available"),
          );
  }
}
