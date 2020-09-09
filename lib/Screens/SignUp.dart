import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datamine/API/signUpAPI.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:datamine/Components/customTextField.dart';
import 'package:datamine/Screens/Login.dart';
import 'package:datamine/services/auth.dart';
import 'package:datamine/services/database.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  bool fromProfile;
  bool fromLogin;
  bool fromMyCourse;
  var parent;
  SignUpScreen(
      {@required this.fromLogin,
      @required this.fromMyCourse,
      @required this.fromProfile,
      @required this.parent});
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _mobNo = TextEditingController();
  TextEditingController _adLine1 = TextEditingController();
  TextEditingController _adLine2 = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool termsAgreed = false;
  Future singUpFirebase() async {
    String status = "fail";
    await authService
        .signUpWithEmailAndPassword(_username.text, _password.text)
        .then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          "userName": "${_fname.text} ${_lname.text}",
          "userEmail": _username.text
        };

        databaseMethods.addUserInfo(userDataMap);
        status = "success";
      }
    });
    return status;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black87,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              color: Colors.black26)
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                          child: Image.asset(
                            "assets/img/Logo.jpg",
                            height: 100,
                          ),
                        ),
                        Column(
                          children: [
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _fname,
                              hint: "Enter First Name",
                              label: "Firstname",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _lname,
                              hint: "Enter Last Name",
                              label: "Last Name",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.phone,
                              textController: _mobNo,
                              inputFormatter:
                                  LengthLimitingTextInputFormatter(10),
                              hint: "Enter phone number",
                              label: "Phone No",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.emailAddress,
                              textController: _username,
                              hint: "Enter email id",
                              label: "Email",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _adLine1,
                              hint: "Enter House Name/No.",
                              label: "House Name/No.",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _adLine2,
                              hint: "Enter Area",
                              label: "Area",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _city,
                              hint: "Enter City",
                              label: "City",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.text,
                              textController: _state,
                              hint: "Enter State",
                              label: "State",
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                              hideText: false,
                            ),
                            customTextField(
                              keyboardType: TextInputType.visiblePassword,
                              textController: _password,
                              hint: "Enter Password",
                              label: "Password",
                              hideText: true,
                              borderColor: appBarColorlight,
                              labelColor: Colors.black,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: termsAgreed,
                              onChanged: (value) {
                                setState(() {
                                  termsAgreed = !termsAgreed;
                                });
                              },
                              checkColor: appbarTextColorLight,
                              activeColor: appBarColorlight,
                            ),
                            Text(
                              "I agree to the ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans"),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "terms and conditions",
                                style: TextStyle(
                                    color: appBarColorlight,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "OpenSans"),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                          child: customButton(
                            text: "Sign Up",
                            color: appBarColorlight,
                            action: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              if (termsAgreed) {
                                if (_username.text.isNotEmpty &&
                                    _password.text.isNotEmpty &&
                                    _fname.text.isNotEmpty &&
                                    _lname.text.isNotEmpty &&
                                    _mobNo.text.isNotEmpty &&
                                    _adLine1.text.isNotEmpty &&
                                    _adLine2.text.isNotEmpty &&
                                    _city.text.isNotEmpty &&
                                    _state.text.isNotEmpty) {
                                  print("Here 1");
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Map<String, dynamic> argBody = {
                                    "firstName": _fname.text,
                                    "lastName": _lname.text,
                                    "pass": _password.text,
                                    "mail": _username.text,
                                    "mobile": _mobNo.text,
                                    "address": [
                                      _adLine1.text,
                                      _adLine2.text,
                                      _city.text,
                                      _state.text
                                    ]
                                  };
                                  signUpAPI(argBody).then((value) async {
                                    print("Here 2");
                                    if (value != "fail") {
                                      print("Here 3");
                                      singUpFirebase().then((value) {
                                        if (value != "fail") {
                                          if (widget.fromLogin) {
                                            Navigator.pop(context);
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen(
                                                              fromMyCourse:
                                                                  false,
                                                              fromProfile:
                                                                  false,
                                                              fromSignUp: true,
                                                              parent:
                                                                  widget.parent,
                                                            ),
                                                        settings: RouteSettings(
                                                            name: "/login")));
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Text(
                                                  "Success",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontFamily: "OpenSans",
                                                      fontSize: 18),
                                                ),
                                                content: Text(
                                                  "Signup successful, please login.",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "OpenSans",
                                                      fontSize: 16),
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color:
                                                              appBarColorlight,
                                                          fontFamily:
                                                              "OpenSans",
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          print("Here 4");
                                          setState(() {
                                            isLoading = false;
                                          });
                                          showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                backgroundColor: Colors.red,
                                                title: Text(
                                                  "Failed",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "OpenSans",
                                                      fontSize: 18),
                                                ),
                                                content: Text(
                                                  "Something went wrong, please try again",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "OpenSans",
                                                      fontSize: 16),
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Center(
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              "OpenSans",
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ));
                                        }
                                      });
                                    } else {
                                      print("Here 4");
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            backgroundColor: Colors.red,
                                            title: Text(
                                              "Failed",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "OpenSans",
                                                  fontSize: 18),
                                            ),
                                            content: Text(
                                              "Something went wrong, please try again",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "OpenSans",
                                                  fontSize: 16),
                                            ),
                                            actions: [
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        backgroundColor: Colors.red,
                                        title: Text(
                                          "Failed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "OpenSans",
                                              fontSize: 18),
                                        ),
                                        content: Text(
                                          "All fields are required",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "OpenSans",
                                              fontSize: 16),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                      title: Text(
                                        "Failed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "OpenSans",
                                            fontSize: 18),
                                      ),
                                      content: Text(
                                        "Please agree to the terms and conditions.",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "OpenSans",
                                            fontSize: 16),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                customTextButton(
                  textColor: appBarColorlight,
                  text: "Already have an account? Log In",
                  action: () async {
                    if (widget.fromLogin) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                fromMyCourse: false,
                                fromProfile: false,
                                fromSignUp: true,
                                parent: widget.parent,
                              ),
                          settings: RouteSettings(name: "/login")));
                    }
                  },
                )
              ],
            ),
            isLoading
                ? Container(
                    height: screenHeight,
                    width: screenWidth,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.8)),
                    child: Center(
                      child: Container(
                          child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(appBarColorlight),
                      )),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }
}
