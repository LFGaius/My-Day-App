import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/routes/route_builder.dart';
import 'package:sembast/sembast.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
final  MethodChannel platform =MethodChannel('myday.app/channel');

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  // String timeZoneName;
  // try {
  //   timeZoneName = await platform.invokeMethod('getTimeZoneName');
  // } on PlatformException catch(e){}

  print('timeZoneName1 ${tz.TZDateTime.local(2021,1,27,22,40)}');
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
}

// void _requestPermissions() {
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       IOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       MacOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // _requestPermissions();
  await _configureLocalTimeZone();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings(
      'logo'
  );
  // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  //   onDidReceiveLocalNotification: (int id,String title,String body,String payload) async{}
  // );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS
  );

  await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async{
        if(payload!=null){
          print('Notification payload $payload');
        }
      }
  );

  // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //   'alarm_notif',
  //   'alarm_notif',
  //   'Channel for Alarm notification',
  //   icon: 'logo',
  //   // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
  //   largeIcon: DrawableResourceAndroidBitmap('logo'),
  // );

  // var iOSPlatformChannelSpecifics = IOSNotificationDetails(
  //   // sound: 'a_long_cold_sting.wav',
  //   presentAlert: true,
  //   presentBadge: true,
  //   // presentSound: true
  // );
  // var platformChannelSpecifics = NotificationDetails(
  //     android:androidPlatformChannelSpecifics,
  //     iOS:iOSPlatformChannelSpecifics
  // );

  // var controller = ScheduleController([
  //   Schedule(
  //
  //     timeOutRunOnce: true,
  //     timing: [7.5],
  //     readFn: () async{},
  //     writeFn: (_) {},
  //     callback: () async{
  //       debugPrint('schedule----');
  //       await flutterLocalNotificationsPlugin.show(0, 'Activity started', 'gfdgdfg', platformChannelSpecifics);
  //     },
  //   ),
  // ]);
  // controller.run();
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
        // theme: ThemeData(
        //   // Use the old theme but apply the following three changes
        //     textTheme: Theme.of(context).textTheme.apply(
        //         fontFamily: 'Freestyle Script Regular',
        //         )),

        theme: ThemeData(
          fontFamily: 'APril Flowers',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline1: TextStyle(
              color: ConfigDatas.appBlueColor,
              fontSize: 35,
              // fontWeight: FontWeight.w900,
              fontFamily: 'HEy Comic',
            ),
            headline2: TextStyle(
              color: Colors.white,
              fontSize: 30,
              // fontWeight: FontWeight.w900,
              fontFamily: 'HEy Comic',
            ),
            headline5: TextStyle(
              color: Colors.white,
              fontSize: 25,
              // fontWeight: FontWeight.w900,
              fontFamily: 'HEy Comic',
            ),
            subtitle1: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w400),
            bodyText1: TextStyle(color: Colors.white,fontSize: 40),
            bodyText2: TextStyle(fontSize: 27,fontWeight: FontWeight.w500),
            headline3: TextStyle(fontSize: 27,color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w900),
            headline4: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),
            button: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),
            caption: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: MyRouteBuilder.buildRoute
    );
  }
}