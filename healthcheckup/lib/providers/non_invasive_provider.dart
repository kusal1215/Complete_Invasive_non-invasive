import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthcheckup/models/data_model.dart';
import 'package:healthcheckup/models/data_response.dart';
import 'package:healthcheckup/models/sensor_model.dart';
import 'package:healthcheckup/utils/constants.dart';
import 'package:healthcheckup/utils/db_helper.dart';
import 'package:healthcheckup/utils/global_methods.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';

class NonInvasiveProvider extends ChangeNotifier {
  List<DataModel> dataList = [];
  List<List<dynamic>> dataITems = [];
  ReceivePort _port = ReceivePort();

  FirebaseDatabase database;
  DatabaseReference _databaseReference;

  double averageHeartRate = 0;
  double totalHeartRate = 0;
  double totalDeepSleep = 0;
  double totalLightSleep = 0;
  double totalWakeSleep = 0;
  double totalSleepTime = 0;

  double averageDeepSleep = 0;
  double averageLightSleep = 0;
  double averageSleepTime = 0;
  double averageWakeSleep = 0;

  String heartRateprediction = "please wait";
  String sleepprediction = "please wait";

  bool updateValueStatues = true;

  void initializeProvider(FirebaseApp app) {
    database = FirebaseDatabase(app: app);

    String uId = FirebaseAuth.instance.currentUser.uid;
    _databaseReference = database.reference().child('Non_Invasive').child(uId);
  }

  void addHeartRate(double heartRate) {
    String date = getDate();
    int timeStamp = getTimeStamp();
    _databaseReference.child(date).update(<String, dynamic>{
      "heartRate": heartRate,
      "timeStamp": timeStamp,
      "date": date,
    });

    getData();
  }

  void getData() async {
    _databaseReference
        .orderByChild("timeStamp")
        .startAt(newDate.millisecondsSinceEpoch)
        .onValue
        .listen((event) async {
      Map<dynamic, dynamic> values = event.snapshot.value;

      if (values != null) {
        dataList.clear();

        totalHeartRate = 0;
        averageHeartRate = 0;
        totalDeepSleep = 0;
        totalLightSleep = 0;
        totalWakeSleep = 0;
        totalSleepTime = 0;

        dynamic heartRate = 0;
        values.forEach((key, value) async {
          if (value["heartRate"] != null) {
            heartRate = value["heartRate"];
            totalHeartRate = totalHeartRate + heartRate;
          }

          if (value["total_accelerometer_recoding"] != null) {
            totalDeepSleep = totalDeepSleep + value["deep_sleep_time"];
            totalLightSleep = totalLightSleep + value["normal_sleep_time"];
            totalWakeSleep = totalWakeSleep + value["wake_time"];
            totalSleepTime = totalSleepTime + value["total_sleep_time"];

            dataList.add(DataModel(
                averageHeartRate: heartRate.toString(),
                totalDeepSleep: value["deep_sleep_time"].toStringAsFixed(2),
                totalLightSleep: value["normal_sleep_time"].toStringAsFixed(2),
                totalWakeSleep: value["wake_time"].toStringAsFixed(2),
                totalSleepTime: value["total_sleep_time"].toStringAsFixed(2),
                date: value["date"].toString(),
                timestamp: value["timestamp"]));
          } else {
            dataList.add(DataModel(
                averageHeartRate: heartRate.toString(),
                totalDeepSleep: "0",
                totalLightSleep: "0",
                totalWakeSleep: "0",
                totalSleepTime: "0",
                date: value["date"].toString(),
                timestamp: value["timestamp"]));
          }
        });
        averageHeartRate = totalHeartRate / values.length;
        averageDeepSleep = totalDeepSleep / values.length;
        averageLightSleep = totalLightSleep / values.length;
        averageSleepTime = totalSleepTime / values.length;
        averageWakeSleep = totalWakeSleep / values.length;

        heartRateprediction = await getPredictOnHeartRate(averageHeartRate);
        sleepprediction = await getSleepDataPredictionCSV(
            averageSleepTime.toInt(),
            averageDeepSleep.toInt(),
            0,
            averageLightSleep.toInt());

        notifyListeners();
      } else {
        heartRateprediction = "DATA EMPTY";
      }
    });
  }

  void checkFileExists() async {
    String path = await getPath();
    bool isExist = await File(path).exists();
    if (isExist)
      updateValues();
    else
      convertData();
  }

  convertData() async {

  }

  void updateValues() async {

    List<SensorModel> values = await DbHelper.dbHelper.getProductList();
    print("DATA: ${values}");

    if(values != null){
      for (var element in values) {
        var item = [
          element.date,
          element.x,
          element.y,
          element.z,
        ];
        dataITems.add(item);
      }
      generateCsv();
    }
  }

  // void updateValue() {
  //   updateValueStatues =false;
  //   notifyListeners();
  //   Future.delayed(const Duration(minutes: 1), () {
  //     generateCsv();
  //   });
  // }

  generateCsv() async {
    String csvData = ListToCsvConverter().convert(dataITems);
    final path = await getPath();
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    DataResponse response = await getSleepDataFromCSV(file.path);


    if (response != null)
      await addSleepData(response);

    updateValueStatues =true;
    notifyListeners();
  }

  Future<void> addSleepData(DataResponse data) async {
    String date = getDate();
    int timeStamp = getTimeStamp();
    print("DATA::: ${data.totalAccelerometerRecoding}");
    print("DATA::: ${date}");

    await _databaseReference.child(date).update(<String, dynamic>{
      "timeStamp": timeStamp,
      "date": date,
    });
    await _databaseReference.child(date).update(data.toJson());

    getData();
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(),
        )
        .toList();
  }
}
