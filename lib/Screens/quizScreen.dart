import 'package:datamine/Components/colors.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  List question;
  QuizScreen({@required this.question});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List answers;
  bool evaluated = false;
  List colorList = List();
  int score = 0;
  List correctAns;
  setColorList() {
    List subList;
    colorList = List();
    for (int i = 0; i < widget.question.length; i++) {
      subList = List();
      for (int j = 0; j < widget.question[i]['option'].length; j++) {
        subList.add(appBarColorlight);
      }
      colorList.add(subList);
    }
  }

  setCorectAnsColorList() {
    for (int i = 0; i < widget.question.length; i++) {
      for (int j = 0; j < widget.question[i]['option'].length; j++) {
        if (widget.question[i]['option'][j] == correctAns[i]) {
          setState(() {
            colorList[i][j] = Colors.green;
          });
        }
      }
    }
  }

  setAnswerList() {
    answers = List();
    for (int i = 0; i < widget.question.length; i++) {
      answers.add("");
    }
  }

  setCorrectAns() {
    correctAns = List();
    for (int i = 0; i < widget.question.length; i++) {
      correctAns.add(widget.question[i]["answer"]);
    }
  }

  calculateScore() {
    for (int i = 0; i < widget.question.length; i++) {
      if (answers[i] == correctAns[i]) {
        score++;
      }
    }
  }

  @override
  void initState() {
    setColorList();
    setAnswerList();
    setCorrectAns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (evaluated == false) {
          showDialog(
              context: context,
              child: AlertDialog(
                backgroundColor: Colors.white,
                content: Text(
                  "You haven't submitted the quiz. Are you sure that you want to exit?",
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
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Quiz 1',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: appBarColorlight,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: ListView(shrinkWrap: true, children: <Widget>[
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
              children: List.generate(widget.question.length, (index) {
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
                                  "${widget.question[index]['question']}",
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
                                  children: List.generate(
                                      widget.question[index]['option'].length,
                                      (mcqIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (evaluated == false) {
                                            setState(() {
                                              for (int i = 0;
                                                  i <
                                                      widget
                                                          .question[index]
                                                              ['option']
                                                          .length;
                                                  i++) {
                                                if (i == mcqIndex) {
                                                  answers[index] =
                                                      widget.question[index]
                                                          ['option'][i];
                                                  colorList[index][i] =
                                                      Colors.black;
                                                } else {
                                                  colorList[index][i] =
                                                      appBarColorlight;
                                                }
                                              }
                                            });
                                          }
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
                                                "${widget.question[index]['option'][mcqIndex]}",
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
            evaluated
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: score <= 0 ? Colors.red : Colors.green,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 2),
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Score: $score",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 16, 40, 16),
              child: customButton(
                  action: () {
                    if (evaluated == false) {
                      setCorectAnsColorList();
                      calculateScore();
                      setState(() {
                        evaluated = true;
                      });
                    }
                  },
                  color: appBarColorlight,
                  text: "Submit Quiz"),
            )
          ])),
    );
  }
}
