class DataResponse {
  var averageActivity;
  var averageLids;
  var deepSleepTime;
  var normalSleepTime;
  var totalAccelerometerRecoding;
  var totalSleepTime;
  var wakeTime;
  int heartRate;

  DataResponse(
      {this.averageActivity,
        this.averageLids,
        this.deepSleepTime,
        this.normalSleepTime,
        this.totalAccelerometerRecoding,
        this.totalSleepTime,
        this.wakeTime});

  DataResponse.fromJson(Map<dynamic, dynamic> json) {
    averageActivity = json['average_activity'];
    averageLids = json['average_lids'];
    deepSleepTime = json['deep_sleep_time'];
    normalSleepTime = json['normal_sleep_time'];
    totalAccelerometerRecoding = json['total_accelerometer_recoding'];
    totalSleepTime = json['total_sleep_time'];
    wakeTime = json['wake_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_activity'] = this.averageActivity;
    data['average_lids'] = this.averageLids;
    data['deep_sleep_time'] = this.deepSleepTime;
    data['normal_sleep_time'] = this.normalSleepTime;
    data['total_accelerometer_recoding'] = this.totalAccelerometerRecoding;
    data['total_sleep_time'] = this.totalSleepTime;
    data['wake_time'] = this.wakeTime;
    return data;
  }
}