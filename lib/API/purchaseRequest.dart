import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiConfig.dart';

Future purchaseAPI(BuildContext context, String courseName, String mode) async {
  final url = "$mainUrl/purchase";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = prefs.getString("userData");
  var parsedData = jsonDecode(data);

  Map<String, String> body = {
    "name": "${parsedData["fName"]} ${parsedData["lName"]}",
    "mail": parsedData["mail"],
    "mode": mode,
    "course": courseName,
    "id": parsedData["id"]
  };
  print(body);

  Response result;
  result = await post(url,
      body: json.encode(body), headers: {"Content-Type": "application/json"});

  return result.statusCode;
}
