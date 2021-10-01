
class SensorModel {

  String date;
  String x;
  String y;
  String z;
  int timeStamp;

  SensorModel(this.date, this.x, this.y, this.z, this.timeStamp);

  SensorModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    x = json['x'];
    y = json['y'];
    z = json['z'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['x'] = this.x;
    data['y'] = this.y;
    data['z'] = this.z;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}