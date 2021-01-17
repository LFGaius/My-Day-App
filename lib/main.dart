import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_day_app/routes/route_builder.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('logo');
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id,String title,String body,String payload) async{}
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
  );

  await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async{
        if(payload!=null){
          print('Notification payload $payload');
        }
      }
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Database db;

  const MyApp({Key key, this.db}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Day',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: MyRouteBuilder.buildRoute
    );
  }
}