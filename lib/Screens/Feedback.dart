import 'dart:convert';

import 'package:datamine/API/feedbackRequest.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:datamine/Components/customTextField.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:datamine/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _feedback = TextEditingController();
  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _feedbackNode = FocusNode();

  Future setNameAndEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData");
    if (data != null) {
      var parsedData = jsonDecode(data);
      print(parsedData);
      setState(() {
        _name.text = "${parsedData["fName"]} ${parsedData["lName"]}";
        _email.text = parsedData["mail"];
      });
    }
  }

  @override
  void initState() {
    setNameAndEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColorlight,
          centerTitle: true,
          iconTheme: IconThemeData(color: appbarTextColorLight),
          title: Text(
            "Feedback",
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomSheet: Container(
          height: 60,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: customButton(
                action: () {
                  if (_name.text.isNotEmpty) {
                    if (_email.text.isNotEmpty) {
                      if (_feedback.text.isNotEmpty) {
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
                                              new AlwaysStoppedAnimation<Color>(
                                                  appBarColorlight),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                        feedbackAPI(context, _name.text, _email.text,
                                _feedback.text)
                            .then((value) {
                          Navigator.pop(context);
                          if (value != 'fail') {
                            Navigator.pop(context);
                            homeKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Feedback submitted",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ));
                          } else {
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  backgroundColor: Colors.red,
                                  title: Text(
                                    "Failed",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans",
                                    ),
                                  ),
                                  content: Text(
                                    "Please try again later.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "OpenSans",
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "OpenSans",
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          }
                        });
                      } else {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Feedback should not be empty",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "OpenSans",
                                    fontSize: 16),
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
                      }
                    } else {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Email id should not be empty",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "OpenSans",
                                  fontSize: 16),
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
                    }
                  } else {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Name should not be empty",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "OpenSans",
                                fontSize: 16),
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
                  }
                },
                color: appBarColorlight,
                text: "Submit Feedback"),
          ),
        ),
        body: ListView(
          children: [
            customTextField(
              hint: "Enter Name",
              label: "Name",
              hideText: false,
              textController: _name,
              borderColor: appBarColorlight,
              labelColor: appBarColorlight,
              keyboardType: TextInputType.text,
              node: _nameNode,
            ),
            customTextField(
              hint: "Enter Email",
              label: "Email",
              hideText: false,
              textController: _email,
              borderColor: appBarColorlight,
              labelColor: appBarColorlight,
              keyboardType: TextInputType.emailAddress,
              node: _emailNode,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * (0.9),
                    child: TextField(
                      focusNode: _feedbackNode,
                      maxLines: 8,
                      controller: _feedback,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        focusedBorder: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: appBarColorlight)),
                        enabledBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Color.fromRGBO(98, 98, 96, 1.0))),
                        hintText: "Enter feedback",
                        labelText: "Feedback",
                        labelStyle: TextStyle(color: appBarColorlight),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
