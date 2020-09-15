import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DownloadedVideos extends StatefulWidget {
  @override
  _DownloadedVideosState createState() => _DownloadedVideosState();
}

class _DownloadedVideosState extends State<DownloadedVideos> {
  Future setDir() async {
    var mainDir = await getApplicationDocumentsDirectory();
    return mainDir.path;
  }

  Future getStoredList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedList = prefs.getStringList("storedList");
    return storedList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColorlight,
        title: Text(
          "DATAMINE",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: setDir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getStoredList(),
              builder: (context, videoSnapshot) {
                if (videoSnapshot.hasData) {
                  if (videoSnapshot.data.length != 0) {
                    return ListView(
                      children:
                          List.generate(videoSnapshot.data.length, (index) {
                        var _parsed = jsonDecode(videoSnapshot.data[index]);
                        return CourseCard3(
                            action: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DownloadedVideoPlayer(
                                            url:
                                                "${snapshot.data}/${_parsed["video_url"]}",
                                          )));
                            },
                            title: _parsed["video_name"]);
                      }),
                    );
                  } else {
                    return Center(
                      child: Text("No videos downloaded yet."),
                    );
                  }
                } else {
                  return Center(
                    child: Text("No videos downloaded yet."),
                  );
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DownloadedVideoPlayer extends StatefulWidget {
  final String url;
  DownloadedVideoPlayer({this.url});
  @override
  _DownloadedVideoPlayerState createState() => _DownloadedVideoPlayerState();
}

class _DownloadedVideoPlayerState extends State<DownloadedVideoPlayer> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    File _file = File(widget.url);
    videoPlayerController = VideoPlayerController.file(_file);
    chewieController = ChewieController(
        allowFullScreen: true,
        videoPlayerController: videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
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
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }
}
