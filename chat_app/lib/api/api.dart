import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  final String baseurl;
  Api(this.baseurl);
  final String url = "http://192.168.43.24:5005/webhooks/rest/webhook";
  List list = [];

  Future chat(String message) async {
    print("Base Url: " + baseurl);
    Map data = {"sender": "test_user", "message": message};
    http.Response response = await http.post(baseurl + '/webhooks/rest/webhook',
        body: json.encode(data));
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

  Future startForm(String label) async {
    print("Start Base Url: " + baseurl);
    Map labelMap = {
      'પ્લાન્ટ પ્રોટેક્શન': '/start_farmer_form',
      'ખાતર': '/start_fertilizer_form',
      'બજાર માહિતી': '/start_market_form',
      'Restart': '/restart'
    };
    String message = labelMap[label];
    print(message);
    Map data = {"sender": "test_user", "message": message};
    http.Response response = await http.post(baseurl + '/webhooks/rest/webhook',
        body: json.encode(data));
    if (response.statusCode == 200) {
      //print("Body: "+response.body);
      List receivedResponse = json.decode(response.body);
      print(receivedResponse.length);
      if (receivedResponse.length > 1) {
        this.list = receivedResponse[1]['custom']['data'];
        return receivedResponse[0]['text'];
      } else if (receivedResponse.length == 1) {
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

  List getList() {
    return this.list;
  }
}
