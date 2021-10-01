import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

var heartRateUrl = "https://apiheartrateinvasive.herokuapp.com/predict";
var sleepPredictUrl = "https://apisleepinvasive.herokuapp.com/predict";
var accelerometerUrl = "https://accelerometer-to-sleep-api.herokuapp.com/upload?";

var startDate = new DateTime.now();

String getDate() {
  return startDate.toString().split(" ").first;
}

int getTimeStamp() {
  return DateTime(startDate.year, startDate.month, startDate.day, 00, 00, 00)
      .millisecondsSinceEpoch;
}

DateTime get newDate =>
    DateTime(startDate.year, startDate.month, startDate.day, 00, 00, 00)
        .subtract(Duration(days: 13));

DateTime get strtDate =>
    DateTime(startDate.year, startDate.month, startDate.day, 00, 01, 00);

DateTime get endDate =>
    DateTime(startDate.year, startDate.month, startDate.day, 12, 00, 00);

Future<String> getPath() async {
  String fileName = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final String directory = (await getExternalStorageDirectory()).path;
  return "$directory/$fileName.csv";
}

bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
  final currentDate = DateTime.now();
  return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
}