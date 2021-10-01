
import 'package:flutter/material.dart';
import 'package:healthcheckup/models/data_model.dart';

class InvasiveCardWidget extends StatelessWidget {

  DataModel data;
  InvasiveCardWidget({this.data});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              data.date,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              child: Divider(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Heart Rate: "),
                Text("${data.averageHeartRate}"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Deep Sleep: "),
                Text(data.totalDeepSleep),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Light Sleep: "),
                Text(data.totalLightSleep),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Wake Sleep"),
                Text("${data.totalWakeSleep}"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rem Sleep"),
                Text("${data.totalRemSleep}"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Bed Time"),
                Text("${data.totalBedTime}"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Sleep Time"),
                Text("${data.totalSleepTime}"),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
