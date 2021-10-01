import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthcheckup/models/data_model.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:healthcheckup/utils/global_methods.dart';
import 'package:healthcheckup/utils/sharedPreference.dart';

import '../global_methods.dart';

class DataProvider extends ChangeNotifier {
  List<DataModel> dataList = [];

  Duration total_deep;
  Duration total_light;
  Duration total_rem;
  Duration total_wake;
  Duration total_bed_time;
  Duration total_sleep_time;

  Duration avgDeep;
  Duration avgLight;
  Duration avgRem;
  Duration avgWake;
  Duration avgTotalBedTime;
  Duration avgTotalSleepTime;
  double avgHeartRate;

  DateTime endDate = new DateTime.now();
  double heartRate= 0;

  String heartRateprediction ="please wait";
  String sleepprediction ="please wait";

  DateTime get endNight => DateTime(endDate.year, endDate.month, endDate.day);
  DateTime get startDate => endNight.subtract(Duration(days: 13));

  void addToDatabase(int day, DatabaseReference databaseReference,int difference) async {

    DateTime current = DateTime.now();

    DateTime endDate = new DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: day));

    DateTime  dateFrom = startDate.subtract(Duration(
      hours: current.hour + 24,
      minutes: current.minute,
      seconds: current.second,
    ));

    DateTime dateTo = dateFrom.add(Duration(
      hours: 23,
      minutes: 59,
      seconds: 59,
    ));


    DateTime startHeartRate = DateTime(startDate.year, startDate.month, startDate.day, 00, 00, 00);

    Duration total_deep = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    Duration total_light = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    Duration total_rem = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    Duration total_wake = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    Duration total_bed_time = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    Duration total_sleep_time = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);

    String date = dateFrom.toString().split(" ").first;

    double heartRate = await getTotalHeart(dateFrom,dateTo);

    final results = await FitKit.read(DataType.SLEEP, dateFrom: dateFrom, dateTo: dateTo);

    for (FitData dataset in results) {
      if(DataType.SLEEP == DataType.SLEEP) {
        total_bed_time = total_bed_time+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);

        if( dataset.source.toString()!="Awake (during sleep)")
          total_sleep_time = total_sleep_time+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);

        if( dataset.source.toString()=="Deep sleep"){
          total_deep = total_deep+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);
        }else if( dataset.source.toString()=="Light sleep"){
          total_light = total_light+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);
        }else if( dataset.source.toString()=="REM sleep"){
          total_rem = total_rem+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);
        }else  if( dataset.source.toString()=="Awake (during sleep)"){
          total_wake = total_wake+timeDifferenceDuration(dataset.dateTo, dataset.dateFrom);
        }
      }
    }

    DataModel appData = DataModel(
        averageHeartRate: heartRate.toStringAsFixed(0),
        totalDeepSleep: timeFormate(total_deep),
        totalLightSleep: timeFormate(total_light),
        totalRemSleep: timeFormate(total_rem),
        totalWakeSleep: timeFormate(total_wake),
        totalBedTime: timeFormate(total_bed_time),
        totalSleepTime: timeFormate(total_sleep_time),
        date: date,
        timestamp: startHeartRate.millisecondsSinceEpoch);

    await databaseReference.child(date).set(<String, dynamic>{
      "averageHeartRate": appData.averageHeartRate,
      "totalDeepSleep": appData.totalDeepSleep,
      "totalLightSleep": appData.totalLightSleep,
      "totalRemSleep": appData.totalRemSleep,
      "totalWakeSleep": appData.totalWakeSleep,
      "totalBedTime": appData.totalBedTime,
      "totalSleepTime": appData.totalSleepTime,
      "timestamp": appData.timestamp,
      "date": appData.date,
    }).whenComplete(() async {
      dataList.add(appData);
      print("DAY: : $day");
      print("DATE: : $dateFrom");
      print("DATE: : $dateTo");

      if (day !=difference)
        addToDatabase(day + 1, databaseReference,difference);
      else {
        getDataFromFirebase(databaseReference);
      }
      notifyListeners();
    });
  }

  void getDataFromFirebase(DatabaseReference databaseReference) async {
    total_deep = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    total_light = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    total_rem = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    total_wake = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    total_bed_time = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    total_sleep_time = Duration(hours: 0, minutes: 0, seconds: 0, days: 0);
    heartRate =0;

    await databaseReference
        .orderByChild("timestamp")
        .startAt(startDate.millisecondsSinceEpoch)
        .once()
        .then((DataSnapshot snapshot) async {

      Map<dynamic, dynamic> values = snapshot.value;
      dataList.clear();
      if(values != null){
        values.forEach((key, values)  async {

          total_deep = total_deep+convertStringToDuration(values["totalDeepSleep"]);
          total_light = total_light + convertStringToDuration(values["totalLightSleep"]);
          total_wake = total_wake + convertStringToDuration(values["totalWakeSleep"]);
          total_rem = total_rem + convertStringToDuration(values["totalRemSleep"]);
          total_bed_time = total_bed_time + convertStringToDuration(values["totalBedTime"]);
          total_sleep_time = total_sleep_time + convertStringToDuration(values["totalSleepTime"]);

          if(values["averageHeartRate"] !="NaN")
            heartRate = heartRate + int.parse(values["averageHeartRate"]);

          dataList.add(DataModel(
              averageHeartRate: values["averageHeartRate"],
              totalDeepSleep: values["totalDeepSleep"],
              totalLightSleep: values["totalLightSleep"],
              totalRemSleep: values["totalRemSleep"],
              totalWakeSleep: values["totalWakeSleep"],
              totalBedTime: values["totalBedTime"],
              totalSleepTime: values["totalSleepTime"],
              date: values["date"],
              timestamp: values["timestamp"]));
        });

        avgHeartRate = heartRate/dataList.length;
        avgDeep = total_deep~/dataList.length;
        avgLight = total_light~/dataList.length;
        avgWake = total_wake~/dataList.length;
        avgRem = total_rem~/dataList.length;
        avgTotalBedTime = total_bed_time~/dataList.length;
        avgTotalSleepTime = total_sleep_time~/dataList.length;

        heartRateprediction =  await getPredictOnHeartRate(avgHeartRate);
        sleepprediction =  await getSleepDataPrediction(avgTotalSleepTime.inMinutes,avgDeep.inMinutes,avgRem.inMinutes,avgLight.inMinutes);

        notifyListeners();
      }

    });
  }

  void deletePreviousData(DatabaseReference databaseReference) async {

    await databaseReference
        .orderByChild("timestamp")
        .endAt(startDate.millisecondsSinceEpoch)
        .once()
        .then((DataSnapshot snapshot) {

      Map<dynamic, dynamic> values = snapshot.value;
      if(values != null){
        values.forEach((key, values)  async {
          await databaseReference.child(values["date"]).remove();
        });
      }

    });
  }


  Future<double> getTotalHeart(DateTime start, DateTime end) async {
    int heartCount = 0;
    int totalItem=0;

    final results = await FitKit.read(DataType.HEART_RATE, dateFrom: start, dateTo: end);
    totalItem = results.length;

    for (FitData dataset in results) {
      heartCount = heartCount + dataset.value.toInt();

    }

    return heartCount/totalItem;
  }

  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    seconds -= minutes*Duration.secondsPerMinute;

    final List<String> tokens = [];
    tokens.add('${days}');
    tokens.add('${hours}');
    tokens.add('${minutes}');
    tokens.add('${seconds}');
    return tokens.join(':');
  }

  Duration timeDifferenceDuration(DateTime end,DateTime start){
    return end.difference(start);
  }
}
