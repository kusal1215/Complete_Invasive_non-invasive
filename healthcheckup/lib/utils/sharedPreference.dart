

import 'package:shared_preferences/shared_preferences.dart';


Future setDate(String accessToken) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.setString('date', accessToken);
}

Future<String> getDate() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString('date');
}

void clearSharedPref() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.clear();
}
