import 'package:flutter/material.dart';

// ignore: must_be_immutable
// ignore: camel_case_types
class customTextField extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController textController;
  final bool hideText;
  var borderColor;
  var labelColor;
  TextInputType keyboardType;
  var inputFormatter;
  FocusNode node;
  customTextField(
      {@required this.hint,
      @required this.label,
      @required this.hideText,
      @required this.textController,
      @required this.borderColor,
      @required this.labelColor,
      @required this.keyboardType,
      this.inputFormatter,
      this.node});
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: screenWidth * (0.9),
            child: TextField(
              focusNode: node,
              inputFormatters: inputFormatter != null ? [inputFormatter] : [],
              keyboardType: keyboardType,
              controller: textController,
              obscureText: hideText,
              decoration: InputDecoration(
                focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: borderColor)),
                enabledBorder: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color.fromRGBO(98, 98, 96, 1.0))),
                hintText: hint,
                labelText: label,
                labelStyle: TextStyle(color: labelColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class customMultiLineTextField extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController textController;
  final bool hideText;
  var borderColor;
  var labelColor;
  TextInputType keyboardType;
  var inputFormatter;
  FocusNode node;
  int lines;
  customMultiLineTextField(
      {@required this.hint,
      @required this.label,
      @required this.hideText,
      @required this.textController,
      @required this.borderColor,
      @required this.labelColor,
      @required this.keyboardType,
      this.inputFormatter,
      @required this.lines,
      this.node});
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: screenWidth * (0.9),
            child: TextField(
              focusNode: node,
              maxLines: lines,
              keyboardType: keyboardType,
              controller: textController,
              obscureText: hideText,
              decoration: InputDecoration(
                focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: borderColor)),
                enabledBorder: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color.fromRGBO(98, 98, 96, 1.0))),
                hintText: hint,
                labelText: label,
                labelStyle: TextStyle(color: labelColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
