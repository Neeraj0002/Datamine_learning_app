import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'apiConfig.dart';

Future feedbackAPI(
    BuildContext context, String name, String email, String feedback) async {
  final url = "$mainUrl/feedback";

  Map<String, String> body = {
    'name': name,
    'email': email,
    'feedback': feedback,
  };

  Response result;
  result = await post(url,
      body: json.encode(body), headers: {"Content-Type": "application/json"});

  if (result.statusCode == 200) {
    if (result.body != "false") {
      return result.body;
    } else {
      return "fail";
    }
  } else {
    return "fail";
  }
}
