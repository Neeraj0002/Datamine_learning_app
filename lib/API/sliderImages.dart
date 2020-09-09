import 'dart:convert';
import 'package:http/http.dart';
import 'package:datamine/API/apiConfig.dart';

Future sliderListAPI() async {
  final url = "$mainUrl/slider";

  Response result;
  result = await get(url);

  if (result.statusCode == 200) {
    var parsedResult = jsonDecode(result.body);
    return parsedResult;
  } else {
    return "fail";
  }
}
