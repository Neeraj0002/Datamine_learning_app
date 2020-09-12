import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  var color;
  var text;
  Function action;
  customButton(
      {@required this.action, @required this.color, @required this.text});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "ProximaNova",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class customTextButton extends StatelessWidget {
  final String text;
  Function action;
  var textColor;
  customTextButton(
      {@required this.action, @required this.text, @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: action,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontFamily: "ProximaNova",
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ));
  }
}
