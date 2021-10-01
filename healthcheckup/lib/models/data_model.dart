
class DataModel {

  String averageHeartRate;
  String totalDeepSleep;
  String totalLightSleep;
  String totalRemSleep;
  String totalWakeSleep;
  String totalBedTime;
  String totalSleepTime;
  int timestamp;
  String date;

  DataModel({
    this.averageHeartRate,
    this.totalDeepSleep,
    this.totalLightSleep,
    this.totalRemSleep,
    this.totalWakeSleep,
    this.totalBedTime,
    this.totalSleepTime,
    this.date,
    this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "averageHeartRate": averageHeartRate,
      "totalDeepSleep": totalDeepSleep,
      "totalLightSleep": totalLightSleep,
      "totalRemSleep": totalRemSleep,
      "totalWakeSleep": totalWakeSleep,
      "totalBedTime": totalBedTime,
      "totalSleepTime": totalSleepTime,
      "timestamp": timestamp,
      "date": date,
    };
  }
}