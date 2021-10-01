import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthcheckup/models/data_model.dart';
import 'package:healthcheckup/providers/non_invasive_provider.dart';
import 'package:healthcheckup/widgets/heart_rate_wight.dart';
import 'package:healthcheckup/widgets/non_invasive_card_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:csv/csv.dart';

class NonInvasiveTab extends StatefulWidget {

  FirebaseApp app;
  NonInvasiveTab(this.app);

  @override
  _NonInvasiveTabState createState() => _NonInvasiveTabState();
}

class _NonInvasiveTabState extends State<NonInvasiveTab> {


  @override
  Widget build(BuildContext context) {
    return Consumer<NonInvasiveProvider>(builder: (context,provider,child){

      return ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (context)=>HeartRateWidgt()));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Click here to give us your heart rate",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Heart Rate Total Average Of 2 Weeks",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Heart Rate: "),
                      Text(provider.averageHeartRate != null?"${provider.averageHeartRate.toStringAsFixed(0)}":"please wait"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Mental Health Summary For Heart Rate",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      provider.heartRateprediction,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Sleep Total Average Of 2 Weeks",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Deep Sleep: "),
                      Text("${provider.averageDeepSleep.toStringAsFixed(2)}"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Light Sleep: "),
                      Text("${provider.averageLightSleep.toStringAsFixed(2)}"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Wake Sleep:"),
                      Text("${provider.averageWakeSleep.toStringAsFixed(2)}"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Sleep Time:"),
                      Text("${provider.averageSleepTime.toStringAsFixed(2)}"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Mental Health Summary For Sleep",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "${provider.sleepprediction}",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.dataList.length,
            itemBuilder: (context, index) {
              DataModel _data = provider.dataList[index];
              return NonInvasiveCardWidget(data: _data);
            },
          ),
        ],
      );
    });
  }
}
