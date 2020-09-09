import 'dart:convert';
import 'package:http/http.dart';
import 'package:datamine/API/apiConfig.dart';

Future resourceAPI(String courseName, String batchNo) async {
  print(courseName);
  print(batchNo);
  final url = "$mainUrl/resource/${courseName.toLowerCase()}/$batchNo";

  Response result;
  result = await get(url);
  print(result.body);
  if (result.statusCode == 200) {
    var parsedResult = jsonDecode(result.body);
    return parsedResult;
  } else {
    return "fail";
  }
}
