//torcapi.herokuapp.com/general

import 'dart:convert';
import 'package:http/http.dart';
import 'package:datamine/API/apiConfig.dart';

Future generalAPI() async {
  final url = "$mainUrl/general";

  Response result;
  result = await get(url);

  if (result.statusCode == 200) {
    var parsedResult = jsonDecode(result.body);
    return parsedResult;
  } else {
    return "fail";
  }
}
