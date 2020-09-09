import 'dart:convert';
import 'package:http/http.dart';
import 'package:datamine/API/apiConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future purchasedCourseListAPI() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = prefs.getString("userData");
  var parsedData = jsonDecode(data);

  final url = "$mainUrl/course/${parsedData["id"]}";

  Response result;
  result = await get(url);

  if (result.statusCode == 200) {
    var parsedResult = jsonDecode(result.body);
    return parsedResult;
  } else {
    return "fail";
  }
}
