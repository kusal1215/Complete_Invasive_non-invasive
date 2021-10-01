import 'dart:convert';
//
// import 'package:app_usage/app_usage.dart';
// import 'package:http/http.dart' as http;

String urlPredict = 'https://testphoneusage.herokuapp.com/predict';
String url = 'https://app-category-api.herokuapp.com/api/test/';

String timeFormate(Duration info) {
  String hours;
  String minutes;
  String seconds;

  if (info != null) {
    print("${info.inHours}  :  ${info.inMinutes} :  ${info.inSeconds}");

    if (info.inHours < 10) {
      hours = "0${info.inHours}";
    } else {
      hours = "${info.inHours}";
    }

    if (info.inMinutes.remainder(60) < 10) {
      minutes = "0${info.inMinutes.remainder(60)}";
    } else {
      minutes = "${info.inMinutes.remainder(60)}";
    }

    if (info.inSeconds.remainder(60) < 10) {
      seconds = "0${info.inSeconds.remainder(60)}";
    } else {
      seconds = "${info.inSeconds.remainder(60)}";
    }

    return "$hours:$minutes:$seconds";
  }
  return "please wait";
}



String checkCategoryType(String value) {
  if (value.contains("Communication") ||
      value.contains("Social") ||
      value.contains("Video Players & Editors") ||
      value.contains("Entertainment")) {
    return "Social";
  } else if (value.contains("Arcade") ||
      value.contains("Action") ||
      value.contains("Adventure") ||
      value.contains("Puzzle") ||
      value.contains("Strategy") ||
      value.contains("Casual") ||
      value.contains("Board")) {
    return "Game";
  }

  return "unknown";
}
//
// Future<String> getData(url) async {
//   try {
//     var response = await http.get(Uri.encodeFull(url),
//         //only accept json response
//         headers: {"Accept": "application/json"});
//
//     if (response.statusCode == 200) {
//       var data_api = jsonDecode(response.body);
//       var data = data_api['category'];
//
//       return data;
//     } else {
//       return 'System App';
//     }
//   } catch (e) {
//     print("ERROR: ${e}");
//   }
// }
//
// Future<String> getPredictData(double avgTotalAps, Duration socialAppAverage,
//     Duration gamingAppAverage, Duration nightAppAverage) async {
//   Map map = {
//     "Age": 25,
//     "Gender": 0,
//     "No_Of_Social_Media_Apps": avgTotalAps.round(),
//     "Social_Media_App_Usage": convertStringToDouble(socialAppAverage),
//     "Gaming_App_usage": convertStringToDouble(gamingAppAverage),
//     "Night_Time_Use": convertStringToDouble(nightAppAverage),
//   };
//   try {
//     var response = await http.post(Uri.parse(urlPredict),
//         headers: {
//           "accept": "application/json",
//         },
//         body: json.encode(map));
//
//     if (response.statusCode == 200) {
//       var data_api = jsonDecode(response.body);
//       var data = data_api['prediction'];
//       return data;
//     }
//   } catch (e) {
//     print("ERROR:predict  ${e}");
//   }
//
//   return "please wait";
// }

Duration convertStringToDuration(String duration) {
  List<String> social = duration.split(":");
  return Duration(
      hours: int.parse(social[0]),
      minutes: int.parse(social[1]),
      seconds: int.parse(social[2]));
}

double convertStringToDouble(Duration socialAppAverage) {
  return double.parse(
      "${socialAppAverage.inHours}.${socialAppAverage.inMinutes}");
}
