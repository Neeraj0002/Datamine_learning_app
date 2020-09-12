import 'dart:convert';

import 'package:datamine/API/purchaseRequest.dart';
import 'package:datamine/Components/CourseCard.dart';
import 'package:datamine/Components/colors.dart';
import 'package:datamine/Components/customButtons.dart';
import 'package:datamine/Components/customTextField.dart';
import 'package:datamine/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnrollScreen extends StatefulWidget {
  int price;
  String thumbnail;
  String courseName;
  String phone;
  String mail;
  var coupon;
  EnrollScreen(
      {@required this.courseName,
      @required this.price,
      @required this.thumbnail,
      @required this.mail,
      @required this.phone,
      @required this.coupon});
  @override
  _EnrollScreenState createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  TextEditingController couponController = TextEditingController();
  bool validated = true;
  Razorpay _razorpay;
  var userData;
  String errorText;
  bool offerFound = false;
  double offerPercentage = 0;
  double total;

  // ignore: unused_element
  _handlePaymentSuccess(PaymentSuccessResponse response) {
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
    purchaseAPI(context, widget.courseName, "razorpay").then((value) {
      Navigator.of(context).pop();
      if (value == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        homeKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Payment Succesful",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 18),
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
                "Please try again later, sorry for the inconvenince.\nIf the money has been deducted it will be credited back to your account in two working days.",
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
  }

  _handlePaymentError(PaymentFailureResponse response) {
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
            "Please try again later, sorry for the inconvenince.\nIf the money has been deducted it will be credited back to your account in two working days.",
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

  _handleExternalWallet(ExternalWalletResponse response) {
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
    purchaseAPI(context, widget.courseName, "razorpay").then((value) {
      Navigator.of(context).pop();
      if (value == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        homeKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Payment Succesful",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
                fontSize: 18),
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
                "Please try again later, sorry for the inconvenince.\nIf the money has been deducted it will be credited back to your account in two working days.",
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
  }

  _openCheckout() async {
    var options = {
      'key': 'rzp_live_PomMEWubUYJHJt',
      'amount': total * 100,
      'name': 'Datamine',
      'description': widget.courseName,
      'prefill': {'contact': "${widget.phone}", 'email': widget.mail}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    total = double.parse(widget.price.toString());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColorlight,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Enroll",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.white,
          bottomSheet: Container(
            height: 70,
            width: screenWidth,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
              child: customButton(
                  action: () {
                    _openCheckout();
                  },
                  color: appBarColorlight,
                  text: "Enroll on the course"),
            ),
          ),
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CourseCard2(
                  action: null,
                  title: widget.courseName,
                  price: widget.price.toString(),
                  imgUrl: widget.thumbnail),
            ),
            widget.coupon != "fail"
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 20.0,
                        ),
                        child: Text(
                          "Do you have a coupon code?",
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            widget.coupon != "fail"
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: constraints.maxWidth * (0.6),
                              child: TextField(
                                controller: couponController,
                                onChanged: (value) {
                                  setState(() {
                                    validated = true;
                                  });
                                },
                                decoration: InputDecoration(
                                  errorText: validated ? null : errorText,
                                  errorStyle: TextStyle(color: Colors.red),
                                  focusedBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: offerFound
                                              ? Colors.green
                                              : appBarColorlight)),
                                  enabledBorder: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: offerFound
                                              ? Colors.green
                                              : Color.fromRGBO(
                                                  98, 98, 96, 1.0))),
                                  hintText: "Enter coupon code here",
                                  labelText: "Coupon Code",
                                  labelStyle: TextStyle(
                                      color: offerFound
                                          ? Colors.green
                                          : appBarColorlight),
                                ),
                              ),
                            ),
                            !offerFound
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        if (couponController.text.isEmpty) {
                                          setState(() {
                                            validated = false;
                                            errorText = "Enter coupon code";
                                          });
                                          return;
                                        }
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            child: AlertDialog(
                                              content: Container(
                                                height: 80,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  appBarColorlight),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                        print(widget.coupon);
                                        for (int i = 0;
                                            i < widget.coupon.length;
                                            i++) {
                                          if (couponController.text ==
                                              widget.coupon[i]["Name"]
                                                  ["en-US"]) {
                                            offerFound = true;
                                            offerPercentage = double.parse(
                                                widget.coupon[i]["Offer"]
                                                    ["en-US"]);
                                            total = widget.price *
                                                (offerPercentage / 100);
                                            break;
                                          } else {
                                            continue;
                                          }
                                        }
                                        if (offerFound) {
                                          Navigator.pop(context);
                                          setState(() {});
                                        } else {
                                          Navigator.pop(context);
                                          setState(() {
                                            errorText = "Offer not applied";
                                            validated = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: constraints.maxWidth * (0.25),
                                        decoration: BoxDecoration(
                                            color: appBarColorlight,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 1),
                                                  color: Colors.black26,
                                                  spreadRadius: 1,
                                                  blurRadius: 2)
                                            ]),
                                        child: Center(
                                          child: Text(
                                            "Apply",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "OpenSans",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Offer Applied",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: "OpenSans",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ],
                        );
                      }),
                    ),
                  )
                : Container(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 20.0,
                  ),
                  child: Text(
                    "Information",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item price:",
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "₹${widget.price}",
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount:",
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "$offerPercentage%",
                        style: TextStyle(
                          color: offerPercentage > 0
                              ? Colors.green
                              : Colors.black38,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "₹$total",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ])),
    );
  }
}
