import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';

class OfferZone extends StatefulWidget {
  @override
  _OfferZoneState createState() => _OfferZoneState();
}

class _OfferZoneState extends State<OfferZone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColorlight,
        title: Text(
          "Offer Zone",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
