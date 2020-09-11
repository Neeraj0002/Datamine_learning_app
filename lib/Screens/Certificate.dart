import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';

class Certificate extends StatefulWidget {
  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Certificate"),
        backgroundColor: appBarColorlight,
        iconTheme: IconThemeData(color: appbarTextColorLight),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/img/certificate.jpg"),
      ),
    );
  }
}
