import 'dart:convert';
import 'package:http/http.dart';
import 'package:datamine/API/apiConfig.dart';

Future couponAPI() async {
  final url = "$mainUrl/coupon";

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
