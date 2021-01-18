import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  final String baseurl;
  Api(this.baseurl);
  final String url = "http://192.168.43.24:5005/webhooks/rest/webhook";

  Future chat(String message) async {
    print("Base Url: " + baseurl);
    Map data = {"sender": "test_user", "message": message};
    http.Response response = await http.post(baseurl, body: json.encode(data));
    if (response.statusCode == 200) {
      print(response.body);
      List receivedResponse = json.decode(response.body);
      if (receivedResponse.length != 0) {
        Map receivedData = receivedResponse[0];
        return receivedData['text'];
      } else {
        return "We will reach you soon";
      }
    } else {
      print(response.statusCode);
      print(response.body);
      return "internal error";
    }
  }
}
