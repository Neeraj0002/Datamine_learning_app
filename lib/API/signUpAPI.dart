import 'dart:convert';
import 'package:http/http.dart';

import 'apiConfig.dart';

Future signUpAPI(Map<String, dynamic> body) async {
  final url = "$mainUrl/register";

  Response result;
  result = await post(url,
      body: json.encode(body), headers: {"Content-Type": "application/json"});

  if (result.statusCode == 200) {
    return result.body;
  } else {
    return "fail";
  }
}
