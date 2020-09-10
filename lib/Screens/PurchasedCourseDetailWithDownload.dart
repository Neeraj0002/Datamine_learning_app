import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:datamine/Components/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:datamine/Screens/quizScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class PurchasedCourseDetailsWithDownload extends StatefulWidget {
  String batchNo;
  String courseName;
  var resourceData;
  var testData;
  bool fromDownloads;
  PurchasedCourseDetailsWithDownload(
      {@required this.batchNo,
      @required this.courseName,
      @required this.resourceData,
      @required this.testData,
      @required this.fromDownloads});
  @override
  _PurchasedCourseDetailsWithDownloadState createState() =>
      _PurchasedCourseDetailsWithDownloadState();
}

class _PurchasedCourseDetailsWithDownloadState
    extends State<PurchasedCourseDetailsWithDownload> {
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
            iconTheme: IconThemeData(color: appbarTextColorLight),
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
              fromDownloads: widget.fromDownloads,
            ),
            Screen2(currentCourse: widget.courseName, data: widget.testData)
          ])),
    );
  }
}

// ignore: must_be_immutable
class Screen1 extends StatefulWidget {
  var data;
  bool fromDownloads;
  Screen1({@required this.data, @required this.fromDownloads});
  @override
  _Screen1State createState() => _Screen1State(data);
}

class _Screen1State extends State<Screen1> {
  var _data;
  _Screen1State(this._data);

  VideoPlayerController videoPlayerController;

  int nowPlaying = 0;

  ChewieController chewieController;

  List<bool> downloading = List<bool>();
  List<double> progress = List<double>();

  String currentVideo;

  Dio dio = Dio();

  var mainDir;

  setDir() async {
    mainDir = await getApplicationDocumentsDirectory();
    print(mainDir);
  }

  Future<void> downloadVideo(imgUrl, index) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      await dio.download(
          imgUrl, "${dir.path}/${_data[index]["UniqueId"]["en-US"]}.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading[index] = true;
          progress[index] = ((rec / total));
        });
      });
    } catch (e) {
      dio.close();
      showDialog(
          context: context,
          child: AlertDialog(
            backgroundColor: Colors.red,
            title: Text(
              "Failed",
              style: TextStyle(
                  color: Colors.white, fontFamily: "OpenSans", fontSize: 18),
            ),
            content: Text(
              e,
              style: TextStyle(
                  color: Colors.white, fontFamily: "OpenSans", fontSize: 16),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Center(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              )
            ],
          ));
      setState(() {
        downloading[index] = false;
      });
    }

    setState(() {
      downloading[index] = false;
      progress[index] = 1.0;
    });
    print("Download completed");
    addDownloadLog(imgUrl).then((value) => print("set"));
  }

  Future addDownloadLog(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(uid, true);
  }

  Future getDownloadLog(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkDownload = prefs.getBool(uid);
    return checkDownload;
  }

  Future removeDownloadLog(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(uid);
  }

  Future<void> _handleStoragePermission(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  void initState() {
    for (int i = 0; i < _data.length; i++) {
      progress.add(0.0);
      downloading.add(false);
    }
    setDir();
    currentVideo = _data[nowPlaying]["Link"]["en-US"];
    if (widget.fromDownloads == true) {
      videoPlayerController = VideoPlayerController.asset(
          "${mainDir.path}/${_data[nowPlaying]["UniqueId"]["en-US"]}.mp4");
    } else {
      videoPlayerController = VideoPlayerController.network(currentVideo);
    }
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
    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    dio.close();

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
                    bool downloaded;
                    getDownloadLog(_data[index]["Link"]["en-US"]).then((value) {
                      setState(() {
                        downloaded = value;
                        print("VALUE$index = $value");
                      });
                    });
                    return FutureBuilder(
                        future: getDownloadLog(_data[index]["Link"]["en-US"]),
                        builder: (context, snapshot) {
                          return VideoListItem(
                              downloaded: snapshot.data == null ? false : true,
                              action: () {
                                chewieController.pause();
                                if (nowPlaying != index) {
                                  setState(() {
                                    nowPlaying = index;
                                    currentVideo =
                                        _data[nowPlaying]["Link"]["en-US"];
                                    if (snapshot.data == true) {
                                      File _file = File(
                                          '${mainDir.path}/${_data[nowPlaying]["UniqueId"]["en-US"]}.mp4');
                                      videoPlayerController =
                                          VideoPlayerController.file(_file);
                                    } else {
                                      videoPlayerController =
                                          VideoPlayerController.network(
                                              currentVideo);
                                    }
                                    chewieController = ChewieController(
                                        videoPlayerController:
                                            videoPlayerController,
                                        aspectRatio: 16 / 9,
                                        autoPlay: true,
                                        looping: true,
                                        deviceOrientationsAfterFullScreen: [
                                          DeviceOrientation.portraitUp
                                        ],
                                        fullScreenByDefault: false,
                                        materialProgressColors:
                                            ChewieProgressColors(
                                                playedColor: appBarColorlight,
                                                handleColor: appBarColorlight,
                                                bufferedColor:
                                                    appbarTextColorLight),
                                        overlay: Container(
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Datamine",
                                                    style: TextStyle(
                                                        shadows: [
                                                          Shadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 1))
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
                              downloadAction: () async {
                                await _handleStoragePermission(
                                    Permission.storage);
                                if (downloading[index] == false) {
                                  print("DOWNLOADING");
                                  print(_data[index]["Link"]["en-US"]);
                                  downloadVideo(
                                      _data[index]["Link"]["en-US"], index);
                                } else {
                                  print("STOPPED");
                                  dio.close();
                                }
                                setState(() {
                                  downloading[index] = !downloading[index];
                                });
                              },
                              percent: progress[index],
                              download: downloading[index],
                              active: index == nowPlaying ? true : false,
                              icon: MdiIcons.play,
                              title: _data[index]["Title"]["en-US"]);
                        });
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
  bool active;
  bool download;
  Function downloadAction;
  bool downloaded;
  double percent;
  VideoListItem(
      {@required this.action,
      @required this.icon,
      @required this.title,
      @required this.active,
      @required this.download,
      @required this.percent,
      @required this.downloaded,
      @required this.downloadAction});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Column(
        children: [
          Container(
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
                    downloaded
                        ? Container()
                        : IconButton(
                            icon: Icon(
                              download ? Icons.close : Icons.file_download,
                            ),
                            color: active ? Colors.white : Colors.black54,
                            onPressed: downloadAction,
                          ),
                  ],
                );
              }),
            ),
          ),
          download
              ? LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 2.0,
                  padding: EdgeInsets.zero,
                  linearStrokeCap: LinearStrokeCap.butt,
                  percent: percent,
                  backgroundColor: appBarColorlight,
                  progressColor: appbarTextColorLight,
                )
              : Container(),
        ],
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
                            fontFamily: "OpenSans",
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
