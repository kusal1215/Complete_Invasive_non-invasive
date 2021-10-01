import 'dart:convert';
import 'dart:io';

import 'package:healthcheckup/models/data_response.dart';
import 'package:healthcheckup/utils/constants.dart';
import 'package:http/http.dart' as http;



Future<String> getPredictOnHeartRate(double heartRate) async {

  Map map = {
    "Age": 25,
    "Gender": 0,
    "Heart_rate": heartRate,
  };
  try {
    var response = await http.post(Uri.parse(heartRateUrl),
        headers: {
          "accept": "application/json",
        },
        body: json.encode(map));

    if (response.statusCode == 200) {
      var data_api = jsonDecode(response.body);
      var data = data_api['prediction'];
      return data;
    }
  } catch (e) {
    print("ERROR:predict  ${e}");
  }

  return "please wait";
}

Future<String> getSleepDataPrediction(int totalSleep,int deepSleep,int remSleep, int lightSleep) async {

  Map map = {
    "Age": 25,
    "Gender": 0,
    "Totaltimef":(totalSleep/60).toStringAsFixed(1),
    "Deepsleepf": deepSleep,
    "REMSf": remSleep,
    "LightSleepf": lightSleep,
  };

  print("DATA: ${map.toString()}");
  try {
    var response = await http.post(Uri.parse(sleepPredictUrl),
        headers: {
          "accept": "application/json",
        },
        body: json.encode(map));

    if (response.statusCode == 200) {
      var data_api = jsonDecode(response.body);
      var data = data_api['prediction'];
      return data;
    }
  } catch (e) {
    print("ERROR:predict  ${e}");
  }

  return "please wait";
}

Future<String> getSleepDataPredictionCSV(int totalSleep,int deepSleep,int remSleep, int lightSleep) async {

  Map map = {
    "Age": 25,
    "Gender": 0,
    "Totaltimef":totalSleep,
    "Deepsleepf": deepSleep,
    "REMSf": remSleep,
    "LightSleepf": lightSleep,
  };

  print("DATA: ${map.toString()}");
  try {
    var response = await http.post(Uri.parse(sleepPredictUrl),
        headers: {
          "accept": "application/json",
        },
        body: json.encode(map));

    if (response.statusCode == 200) {
      var data_api = jsonDecode(response.body);
      var data = data_api['prediction'];
      return data;
    }
  } catch (e) {
    print("ERROR:predict  ${e}");
  }

  return "please wait";
}


Future<DataResponse> getSleepDataFromCSV(var filePath) async {
  DataResponse data;
  try {
    var response = await http.MultipartRequest('POST',Uri.parse(accelerometerUrl));

    response.files.add( await http.MultipartFile.fromPath('file', filePath));

    var res = await response.send();


    var responseData = await res.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("DATA $responseString");
    data =  DataResponse.fromJson(json.decode(responseString));

  } catch (e) {
    print("ERROR:predict  ${e}");
  }

  return data;
}
