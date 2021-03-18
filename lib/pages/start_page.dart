
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  void initState(){
    super.initState();

    // List directory contents, recursing into sub-directories,
    // but not following symbolic links.
    // if (Platform.isIOS) {
    //   if (audioCache.fixedPlayer != null) {
    //     audioCache.fixedPlayer.startHeadlessService();
    //   }
    //   advancedPlayer.startHeadlessService();
    // }
    Timer(Duration(seconds: 3),() async{
      SharedPreferences prefs=await SharedPreferences.getInstance();
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = Path.join(dir.path, 'my_day_database.db');
      var db = await databaseFactoryIo.openDatabase(dbPath, version: 0);
      // Use the animals store using Map records with int keys
      // var store = intMapStoreFactory.store('activities');
      // await db.transaction((txn) async {
      //   await store.add(txn, {'name': 'fish12'});
      //   await store.add(txn, {'name': 'cat'});
      // });
      // var finder = Finder(
      //     filter: Filter.greaterThan('name', 'cat'),
      //     sortOrders: [SortOrder('name')]);
      // var finder = Finder(
      //     sortOrders: [
      //       SortOrder('type',true)]);
      // var records = await store.find(db, finder: finder);
      // print(records);
      // await store.delete(db, finder: finder);
      // var query = store.query(finder: finder);
      // var subscription = query.onSnapshots(db).listen((snapshots) async{
      //   // snapshots always contains the list of records matching the query
      //   print('fds $snapshots');
      //   // ...
      // });
// ...

// cancel subscription. Important! not doing this might lead to
// memory leaks
//       unawaited(subscription?.cancel());
      // var records = await store.find(db, finder: finder);
      // var results = await store
      //     .stream(db)
      //     .map((snapshot) => Map<String, dynamic>.from(snapshot.value)
      //   ..['id'] = snapshot.key)
      //     .toList();
      // results.forEach((element) {
      //   print('name:${element['name']}');
      // });
      // prefs.setString('myday_start_date','10-02-2021');
      if(prefs.getBool('myday_already_opened')==null){//first time connection TO DO: Uncomment
        prefs.setBool('myday_already_opened',true);
        prefs.setString('myday_config_alert_sound',ConfigDatas.alertSounds['activity-started-female']);
        prefs.setString('myday_config_lang',ConfigDatas.appLangs['english-lang']);
        var now=DateTime.now();
        prefs.setString('myday_start_date','${now.day}-${now.month}-${now.year}');
        Navigator.of(context).popAndPushNamed(
          '/onboarding',
            arguments:{'database':db}
        );
      }else
        Navigator.of(context).pushNamedAndRemoveUntil('/goalremind',(Route<dynamic> route) => false, arguments:{'database':db});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.height*0.25
                ),
              ],
            ),
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}