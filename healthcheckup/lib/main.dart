import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthcheckup/models/sensor_model.dart';
import 'package:healthcheckup/providers/data_provider.dart';
import 'package:healthcheckup/providers/non_invasive_provider.dart';
import 'package:healthcheckup/screens/home_page.dart';
import 'package:healthcheckup/utils/constants.dart';
import 'package:healthcheckup/utils/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors/sensors.dart';

void onStart() {
  //FlutterBackgroundService().sendData({"action": "setAsForeground"});
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  String x = "";
  String y = "";
  String z = "";

  service.onDataReceived.listen((event) {
    if (event["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 30), (timer) async {

    print("TESTING");

    if (!(await service.isServiceRunning())) timer.cancel();

    var event = (AccelerometerEvent event) async {
      var start = strtDate;
      var end = endDate;

      if (isCurrentDateInRange(start, end)) {
        DateTime now = DateTime.now();

        String formattedDate = DateFormat('MM/dd/yyyy HH:mm:ss a').format(now);

        SensorModel model = SensorModel(
            formattedDate,
            event.x.toStringAsFixed(10).toString(),
            event.y.toStringAsFixed(10).toString(),
            event.z.toStringAsFixed(10).toString(),
            now.millisecondsSinceEpoch);

        if (model.x != x || model.y != y || model.z != z) {
          x = model.x;
          y = model.y;
          z = model.z;
          DbHelper.dbHelper.addValuesToDatabase(model);
        }
      }
    };
    accelerometerEvents.listen(event);

    service.setNotificationInfo(
      title: "Health App",
      content: "Click for more details",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}

int helloAlarmID = 1;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<DataProvider>(
            create: (context) => DataProvider(),
          ),
          ChangeNotifierProvider<NonInvasiveProvider>(
            create: (context) => NonInvasiveProvider(),
          ),
        ],
        child: MyApp(
          app: app,
        )),
  );

  await FlutterBackgroundService.initialize(onStart);
  await AndroidAlarmManager.periodic(
      const Duration(hours: 1), helloAlarmID, onStart);
}

class MyApp extends StatelessWidget {
  FirebaseApp app;
  MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sleep and Heart Rate analysis'),
        ),
        body: HomePage(app),
      ),
    );
  }
}
