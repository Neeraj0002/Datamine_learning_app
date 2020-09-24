import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:datamine/Components/customButtons.dart';

class QuizScreen extends StatefulWidget {
  List question;
  List answers;
  List options;
  QuizScreen(
      {@required this.answers,
      @required this.options,
      @required this.question});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List sortedAns = List();
  Map selectedAnsList = Map();
  List colorList = List();

  sortAnswer() {
    List subList;
    for (int i = 0; i <= 6; i++) {
      print("i = $i");
      if (i % 3 == 0) {
        subList = List();
        for (int j = i; j < i + 3; j++) {
          print("i=$i j = $j");
          subList.add(widget.options[j]);
        }
        sortedAns.add(subList);
      }
    }
    print(sortedAns);
  }

  setAnsList() {
    for (int i = 0; i < widget.question.length; i++) {
      selectedAnsList[widget.question[i]] = "";
    }
  }

  setColorList() {
    List subList;
    for (int i = 0; i <= 6; i++) {
      print("i = $i");
      if (i % 3 == 0) {
        subList = List();
        for (int j = i; j < i + 3; j++) {
          print("i=$i j = $j");
          subList.add(appBarColorlight);
        }
        colorList.add(subList);
      }
    }
    print(sortedAns);
  }

  @override
  void initState() {
    sortAnswer();
    setAnsList();
    setColorList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        showDialog(
            context: context,
            child: AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                "You haven't submitted the test. Are you sure that you want to exit?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: "ProximaNova",
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ProximaNova",
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(
                      color: appBarColorlight,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ProximaNova",
                    ),
                  ),
                )
              ],
            ));
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Test 1',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: appBarColorlight,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: ListView(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select correct answers from below:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 2,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 35, 8, 8),
                                child: Text(
                                  "${widget.question[index]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "ProximaNova",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: 2,
                                color: Colors.black45,
                              ),
                              Text(
                                "Choose an answer",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "ProximaNova",
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  children: List.generate(sortedAns.length,
                                      (mcqIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            for (int i = 0; i < 3; i++) {
                                              if (i == mcqIndex) {
                                                colorList[index][i] =
                                                    Colors.black;
                                              } else {
                                                colorList[index][i] =
                                                    appBarColorlight;
                                              }
                                            }
                                          });

                                          selectedAnsList[
                                                  widget.question[index]] =
                                              widget.options[mcqIndex];
                                          print(selectedAnsList);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: colorList[index][mcqIndex],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 55,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (0.7),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16.0, 8, 16, 8),
                                              child: Text(
                                                "${sortedAns[index][mcqIndex]}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "ProximaNova"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: appBarColorlight,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "ProximaNova",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
              child: customButton(
                  action: () {}, color: appBarColorlight, text: "Submit"),
            )
          ])),
    );
  }
}
