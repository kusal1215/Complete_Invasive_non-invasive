
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:healthcheckup/providers/data_provider.dart';
import 'package:healthcheckup/providers/non_invasive_provider.dart';
import 'package:healthcheckup/tabs/invasive_tab.dart';
import 'package:healthcheckup/tabs/non_invasive_tab.dart';
import 'package:healthcheckup/utils/sharedPreference.dart';
import 'package:provider/src/provider.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class HomePage extends StatefulWidget {
  FirebaseApp app;
  HomePage(this.app);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime startDate = new DateTime.now();

  DatabaseReference _databaseReference;
  UserCredential userCredential;
  FirebaseDatabase database;

  NonInvasiveProvider _nonInvasiveProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = FirebaseDatabase(app: widget.app);

    updateData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    requestpermission();
  }
  void updateData() async {

    bool permissionsGiven = await requestPermissionForDataType();
    print("PERMISSION: $permissionsGiven");
    if(!permissionsGiven){
      await requestPermissionForDataType();
    }
    if (permissionsGiven) {

      userCredential = await FirebaseAuth.instance.signInAnonymously();

      print("UID: ${userCredential.user.uid}");
      if (userCredential != null) {

        _nonInvasiveProvider = context.read<NonInvasiveProvider>();
        _nonInvasiveProvider.initializeProvider(widget.app);
        _nonInvasiveProvider. getData();
        // _nonInvasiveProvider.bindBackgroundIsolate();
        _nonInvasiveProvider.updateValues();



        String uId = userCredential.user.uid;
        _databaseReference =  database.reference().child('GoogleFitData').child(uId);

        context.read<DataProvider>().deletePreviousData(_databaseReference);

        String prevDate = await getDate();

        if (prevDate == null) {
          setDate(DateTime(startDate.year, startDate.month, startDate.day, 00, 00, 00).toString());
          context.read<DataProvider>().addToDatabase(-1, _databaseReference,-1);
        } else {
          final date2 = DateTime.now();
          final difference = date2.difference(DateTime.parse(prevDate)).inDays;

          if(difference > 0 && difference <15){
            setDate(DateTime.now().toString());
            context.read<DataProvider>().addToDatabase(0, _databaseReference,difference);
          }else if(difference>=15){
            setDate(DateTime.now().toString());
            context.read<DataProvider>().addToDatabase(0, _databaseReference,1);
          }else{
            context.read<DataProvider>().getDataFromFirebase(_databaseReference);
          }

        }
      }
    }
  }

  void requestpermission()async{
    Map<Permission, PermissionState> permission = await PermissionsPlugin
        .requestPermissions([
      Permission.READ_EXTERNAL_STORAGE,
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.BODY_SENSORS,

    ]);

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black38,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: PreferredSize(
                preferredSize: Size.fromHeight(5),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      tabs: [
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Invasive"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Non - Invasive"),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            body: TabBarView(children: [
              InvasiveTab(widget.app),
              NonInvasiveTab(widget.app),
            ]),
          ),
        ));
  }
}


Future<bool> requestPermissionForDataType() async {

  try {
    final responses = await FitKit.hasPermissions([
      DataType.HEART_RATE,
      DataType.SLEEP,
    ]);

    if (!responses) {
      final value = await FitKit.requestPermissions([
        DataType.HEART_RATE,
        DataType.SLEEP,
      ]);

      return value;
    } else {
      return true;
    }
  } on UnsupportedException catch (e) {
    // thrown in case e.dataType is unsupported
    print(e);
    return false;
  }
}

