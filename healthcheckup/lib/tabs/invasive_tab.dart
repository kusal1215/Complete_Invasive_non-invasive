import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthcheckup/global_methods.dart';
import 'package:healthcheckup/models/data_model.dart';
import 'package:healthcheckup/providers/data_provider.dart';
import 'package:healthcheckup/widgets/invasive_card_widget.dart';
import 'package:provider/provider.dart';

class InvasiveTab extends StatefulWidget {
  FirebaseApp app;
  InvasiveTab(this.app);

  @override
  _InvasiveTabState createState() => _InvasiveTabState();
}

class _InvasiveTabState extends State<InvasiveTab> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DataProvider>(builder: (_, vlue, __) {
        return ListView(
          children: [
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
                        Text(vlue.avgHeartRate != null?"${vlue.avgHeartRate.toStringAsFixed(0)}":"please wait"),
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
                        vlue.heartRateprediction,
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
                        Text("${timeFormate(vlue.avgDeep)}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Light Sleep: "),
                        Text("${timeFormate(vlue.avgLight)}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Wake Sleep:"),
                        Text("${timeFormate(vlue.avgWake)}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rem Sleep:"),
                        Text("${timeFormate(vlue.avgRem)}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Bed Time:"),
                        Text("${timeFormate(vlue.avgTotalBedTime)}"),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Sleep Time:"),
                        Text("${timeFormate(vlue.avgTotalSleepTime)}"),
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
                        vlue.sleepprediction,
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
              itemCount: vlue.dataList.length,
              itemBuilder: (context, index) {
                DataModel _data = vlue.dataList[index];
                return InvasiveCardWidget(data: _data);
              },
            ),
          ],
        );
      }),
    );
  }

}
