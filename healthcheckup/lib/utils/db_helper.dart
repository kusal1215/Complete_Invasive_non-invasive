
import 'package:healthcheckup/models/sensor_model.dart';
import 'package:healthcheckup/utils/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper dbHelper = DbHelper._();
  Future<Database> _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'Sensor.db');
    final Future<Database> database = openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE Sensor( date TEXT, x TEXT, y TEXT, z TEXT, timeStamp INTEGER)",
      );

    });
    return database;
  }


  Future<List<SensorModel>> getProductList() async {

    var start = strtDate.millisecondsSinceEpoch;
    var end = endDate.millisecondsSinceEpoch;

    final db = await database;
    var result = await db.query("Sensor",where: "timeStamp >=? and timeStamp <=? ", whereArgs: [start,end]);
    return result.isNotEmpty
        ? result
            .map(
              (item) => SensorModel.fromJson(item),
            )
            .toList()
        : null;
  }

  addValuesToDatabase(SensorModel vsl) async {
    print("DATA ADD: ${vsl.toString()}");
    final db = await database;
    var raw = await db.insert(
      "Sensor",
      vsl.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return raw;
  }

  Future<bool> checkCategoryExits(SensorModel vsl) async {

    print("X: ${vsl.x} Y: ${vsl.y} Z: ${vsl.z}");
    final db = await database;
    var result = await db.query("Sensor", where: "x=? and y=? and z=?", whereArgs: [vsl.x,vsl.y,vsl.z]);

    return result.isNotEmpty ? true : false;
  }
}
