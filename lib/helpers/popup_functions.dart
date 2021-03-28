import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/main.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/goal.dart';
import 'package:my_day_app/models/taboo.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PopupFunctions{
  static Map<String,String> title={
    'create-storycomment':'addcomment',
    'edit-storycomment':'editcomment',
    'create-activity':'addactivity',
    'edit-activity':'editactivity',
    'view-activity':'activitydetails',
    'create-emergency':'addemergency',
    'edit-emergency':'editemergency',
    'view-emergency':'emergencydetails',
    'create-principle':'addprinciple',
    'edit-principle':'editprinciple',
    'view-principle':'principledetails',
    'create-taboo':'addtaboo',
    'edit-taboo':'edittaboo',
    'create-goal':'addgoal',
    'edit-goal':'editgoal'
  };
  static Future<dynamic> onAlertWithCustomContentPressed(context,mode,variant,{element,database,storyMode:false}) {
    TextEditingController commentController = TextEditingController();
    TextEditingController wordController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    String selectedActivityType;
    bool isAccomplished=false;
    int isFavorite=0;
    if(variant=='storycomment')
      commentController.text = element?.value;
    else{
      if(variant!='goal' && variant!='taboo') titleController.text = element?.title;
      if(variant!='taboo') descriptionController.text = element?.description;
      if(variant=='taboo') wordController.text = element?.word;
      if (variant != 'principle' && variant != 'goal' && variant != 'taboo') isAccomplished = element?.isAccomplished;
      if (variant == 'goal') isFavorite = element?.isFavorite;
      if (variant == 'activity') {
        timeController.text = element?.time;
        durationController.text = element?.duration;
        selectedActivityType = element?.type;
      }
    }
    Alert(
        context: context,
        style: AlertStyle(
            alertPadding: EdgeInsets.only(top:30,left: 5,right: 5),
            titleStyle: Theme.of(context).textTheme.headline1
        ),
        title: translator.translate(title['$mode-$variant']),// mode!='view'?(mode=='create'?'Add ${variant=='storycomment'?'comment':variant}':(mode=='edit'?'Edit ${variant=='storycomment'?'comment':variant}':'Restore $variant')):'${variant[0].toUpperCase() + variant.substring(1)} details',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Container(
          height: (variant=='storycomment' || variant=='goal')?200:(variant=='taboo'?100:MediaQuery.of(context).size.height*0.6),
          width: MediaQuery.of(context).size.width*0.7,
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true ,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                if(mode=='view' && (variant=='principle' || ((variant=='activity' || variant=='emergency') && !(element.isAccomplished!=null?element.isAccomplished:false)))) GestureDetector(
                  onTap: () async{
                    if(!storyMode) {
                      Navigator.pop(context);
                      onAlertWithCustomContentPressed(
                          context, 'edit', variant, element: element,
                          database: database);
                    }else {
                      performRestoreProcess(variant,element,database,context,title:titleController.text,description:descriptionController.text);
                      // DateTime _now = DateTime.now();
                      // if (variant == 'emergency') {
                      //   savePrincipleOrEmergencyOrComment({
                      //     'id': element?.id,
                      //     'title': titleController.text,
                      //     'date': '${_now.day}-${_now.month}-${_now.year}',
                      //     'description': descriptionController.text,
                      //     'isAccomplished': element.isAccomplished,
                      //   }, database, 'emergencies', context);
                      //   print('emergency restored');
                      // } else {
                      //   Navigator.pop(context);
                      //   onAlertWithCustomContentPressed(
                      //       context, 'restore', variant, element: element,
                      //       database: database);
                      // }
                    }
                  },
                  child: Container(
                    width: storyMode?190:100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: ConfigDatas.appBlueColor,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(storyMode?Icons.restore:Icons.edit,color: Colors.white),
                        Text(
                          storyMode?translator.translate('restore'):translator.translate('edit'),
                          style: Theme.of(context).textTheme.headline2
                        )
                      ],
                    ),
                  ),
                ),
                if(variant=='storycomment')
                  TextField(
                    controller: commentController,
                    minLines: 4,
                    maxLines: null,
                    readOnly: mode=='view',
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                      // labelText: 'Comment',
                      fillColor: ConfigDatas.appBlueColor.withOpacity(0.5)
                    ),
                  ),
                if(variant=='taboo')
                  TextField(
                    controller: wordController,
                    readOnly: mode=='view',
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                      labelText: translator.translate('word'),
                      // fillColor: ConfigDatas.appBlueColor.withOpacity(0.5)
                    ),
                  ),
                if(variant!='storycomment' && variant!='goal' && variant!='taboo')
                  TextField(
                    controller: titleController,
                    readOnly: mode=='view',
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                      labelText: translator.translate('title'),
                      labelStyle: Theme.of(context).textTheme.caption
                    ),
                  ),
                if(variant!='storycomment' && variant!='taboo')
                  TextField(
                    controller: descriptionController,
                    minLines: 4,
                    maxLines: null,
                    readOnly: mode=='view',
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                      labelText: translator.translate('description'),
                      labelStyle: Theme.of(context).textTheme.caption
                    ),
                  ),
                if(variant=='activity')
                  SizedBox(height: 40),
                if(variant=='activity')
                  TimePicker(label: translator.translate('startTime'),
                      readOnly: mode == 'view',
                      timeController: timeController),
                if(variant=='activity')
                  SizedBox(height: 40),
                if(variant=='activity')
                  TimePicker(label: translator.translate('duration'),
                      readOnly: mode == 'view',
                      timeController: durationController),
                if(variant=='activity')
                  SizedBox(height: 40),
                if(variant=='activity')
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          translator.translate('type'),
                          style: Theme.of(context).textTheme.caption
                        ),

                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return DropdownButton<String>(

                              hint: Text(translator.translate('selectType')),
                              value: selectedActivityType,
                              onChanged: (String value) {
                                if (mode != 'view')
                                  setState(() {
                                    print('----------$value---------');
                                    selectedActivityType = value;
                                  });
                              },
                              items: ConfigDatas.activitytypes.map((
                                  ActivityTypeItem activitytype) {
                                return DropdownMenuItem<String>(
                                  value: activitytype.name,
                                  child: Row(
                                    children: <Widget>[
                                      activitytype.icon,
                                      SizedBox(width: 10,),
                                      Text(
                                        activitytype.name,
                                        style: Theme.of(context).textTheme.headline3,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                  ),

              ],
            ),
          ),
        ),
        buttons: [
          if(mode!='view') DialogButton(
            onPressed: () async{
              if(variant=='emergency')
                savePrincipleOrEmergencyOrComment({
                  'id':element?.id,'title':titleController.text,'date':element.date,
                  'description':descriptionController.text,'isAccomplished':element.isAccomplished,
                },database,'emergencies',context);
             else if(variant=='storycomment')
                savePrincipleOrEmergencyOrComment({
                  'id':element?.id,'value':commentController.text,'storyDate':element.storyDate
                },database,'comments',context);
             else if(variant=='principle')
                  savePrincipleOrEmergencyOrComment({
                    'id':element?.id,'title':titleController.text,
                    'description':descriptionController.text,
                  },database,'principles',context);
             else if(variant=='goal')
                saveGoal(new Goal(
                    element?.id,
                    descriptionController.text,
                    element.isFavorite
                ),database,context);
             else if(variant=='taboo')
                saveTaboo(new Taboo(
                    element?.id,
                    wordController.text
                ),database,context);
             else{
                   DateTime _now = DateTime.now();
                    onSaveActivity({
                      'id':mode=='restore'?null:element?.id,'title':titleController.text,'date':(mode=='restore' || mode=='create')?'${_now.day}-${_now.month}-${_now.year}':element.date,
                      'description':descriptionController.text,'isAccomplished':element.isAccomplished,
                      'time':timeController.text,'duration':durationController.text,'type':selectedActivityType
                    },database,context);
                    // String msg='Activity ${mode=='restore'?'restored':'saved'}';
                    // Fluttertoast.showToast(
                    //    msg: msg,
                    //    toastLength: Toast.LENGTH_SHORT,
                    //    gravity: ToastGravity.CENTER,
                    //    timeInSecForIosWeb: 1,
                    //    backgroundColor: Colors.green,
                    //    textColor: Colors.white,
                    //    fontSize: 16.0
                    // );
              }
            },
            color: ConfigDatas.appBlueColor,
            width: 100,
            child: Text(
              translator.translate('save'),
              style: Theme.of(context).textTheme.button,
            ),
          )
        ]).show();
  }

  static performRestoreProcess(variant,element,database,context,{frompopup:false,title,description}){//externalCall for calls external to this class
    DateTime _now = DateTime.now();
    if (variant == 'emergency') {
      savePrincipleOrEmergencyOrComment({
        'id': null,
        'title': title,
        'date': '${_now.day}-${_now.month}-${_now.year}',
        'description': description,
        'isAccomplished': element.isAccomplished,
      }, database, 'emergencies', context,frompopup:frompopup);
      Fluttertoast.showToast(
         msg: translator.translate('emergencyRestored'),
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.green,
         textColor: Colors.white,
         fontSize: 16.0
      );
    } else {
      if(frompopup) Navigator.pop(context);
      onAlertWithCustomContentPressed(
      context, 'restore', variant, element: element,
      database: database);
    }
  }

  static onSaveActivity(activity,database,context) async{
    var now=DateTime.now();
    tz.TZDateTime _now=tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second);
    var targetDt=tz.TZDateTime.local(now.year,now.month,now.day,int.parse(activity['time'].split(':')[0]),int.parse(activity['time'].split(':')[1]));
    print('now: ${now} targetDt: ${targetDt}');
    if(_now.isBefore(targetDt)){
      List<String> dSplited=activity['duration'].split(':');
      var _hours=int.parse(dSplited[0]);
      var _minutes=int.parse(dSplited[1]);
      var endTime=_now.add(Duration(hours: _hours,minutes: _minutes));
      if(/*(_hours+_minutes)>0 && */endTime.isBefore(DateTime(now.year,now.month,now.day,23,59,59))) {
        int activityId = await saveActivity(new Activity(
            activity['id'],
            activity['title'],
            activity['description'],
            activity['type'],
            activity['time'],
            activity['date'],
            activity['duration'],
            activity['isAccomplished']
        ),database);
        print('saved date: '+ activity['date']);
        int secondsToSchedule = ((targetDt.millisecondsSinceEpoch - _now.millisecondsSinceEpoch) / 1000).toInt();
        scheduleAlarm(activityId, activity['time'],
            secondsToSchedule == 0 ? 1 : secondsToSchedule,
            activity['title']
        );
        Navigator.pop(context);
      }else
        Fluttertoast.showToast(
            msg: translator.translate('errorMsgInvalidDuration'),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0
        );
    }else{
      Fluttertoast.showToast(
          msg: translator.translate('errorMsgInvalidTime'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  static void scheduleAlarm(int id,String time,int secondsToSchedule,String activityTitle) async {
    SharedPreferences prefs=await SharedPreferences.getInstance(); print('wait ${prefs.getString('myday_config_alert_sound')}');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif$id',
      'alarm_notif$id',
      'Channel for Alarm notification',
      icon: 'logo',
      sound: RawResourceAndroidNotificationSound(prefs.getString('myday_config_alert_sound')),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
      enableVibration: true,
      importance: Importance.max,
      playSound: true,
      visibility: NotificationVisibility.public,
      channelShowBadge: true,

      // fullScreenIntent: true
    );

    // var iOSPlatformChannelSpecifics = IOSNotificationDetails(
    //     // sound: 'a_long_cold_sting.wav',
    //     presentAlert: true,
    //     presentBadge: true,
    //     // presentSound: true
    // );
    var platformChannelSpecifics = NotificationDetails(
      android:androidPlatformChannelSpecifics,
      // iOS:iOSPlatformChannelSpecifics
    );
    var now=DateTime.now();
    var offset=now.timeZoneOffset;
    print('schedule ${tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second)} ${tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second).add(Duration(seconds: secondsToSchedule))}');
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, translator.translate('activityStarted'), activityTitle,
        tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second).add(-offset).add(Duration(seconds: secondsToSchedule)),//with -offset, we avoid the effect of the offset because in background, the offset is added(conversion to UTC) and compared to the local time(Weird package behavior)
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  static Future<int> saveActivity(Activity activity,database) async {
    var store = intMapStoreFactory.store('activities');
    int activityId;
    print('date: ${activity.date} activity.id: ${activity.id}');
    if (activity.id == null){
      await database.transaction((txn) async {
        print(activity.id);
        print('ttt ${activity.id}');
        activityId=await store.add(txn, {
          'title': activity.title,
          'description': activity.description,
          'type': activity.type,
          'time': activity.time,
          'date': activity.date,
          'duration': activity.duration,
          'isAccomplished': activity.isAccomplished
        });
      });
    }else {
      activityId=activity.id;
      await database.transaction((txn) async {
        await store.record(activity.id).update(txn, {
          'title': activity.title,
          'description': activity.description,
          'type': activity.type,
          'time': activity.time,
          'date': activity.date,
          'duration': activity.duration,
          'isAccomplished': activity.isAccomplished!=null?activity.isAccomplished:false
        });
      });
    }
    return activityId;
  }

  static savePrincipleOrEmergencyOrComment(element,database,variant,context,{frompopup:true}) async {
    DateTime _now=DateTime.now();
    var store = intMapStoreFactory.store(variant);
    if(element['id']==null)
      await database.transaction((txn) async {
        print(element['id']);
        print('ttt ${element['id']}');
        await store.add(txn, {
          if(variant=='comments') 'value':element['value'],
          if(variant=='comments') 'storyDate':element['storyDate'],
          if(variant!='comments') 'title': element['title'],
          if(variant!='comments') 'description': element['description'],
          if(variant=='emergencies') 'isAccomplished':false,
          if(variant=='emergencies') 'date': '${_now.day}-${_now.month}-${_now.year}'
        });
      });
    else
      await database.transaction((txn) async {
        print(element['id']);
        print('ttt ${element['id']}');
        await store.record(element['id']).update(txn, {
          if(variant=='comments') 'value':element['value'],
          if(variant=='comments') 'storyDate':element['storyDate'],
          if(variant!='comments') 'title': element['title'],
          if(variant!='comments') 'description': element['description'],
          if(variant=='emergencies') 'isAccomplished':element['isAccomplished']!=null?element['isAccomplished']:false,
          if(variant=='emergencies') 'date': element['date']
        });
      });
    Fluttertoast.showToast(
        msg: 'Saved',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
    if(frompopup) Navigator.pop(context);
  }

  static saveGoal(Goal goal,database,context) async {
    var store = intMapStoreFactory.store('goals');
    if(goal.id==null)
      await database.transaction((txn) async {
        print(goal.id);
        print('ttt ${goal.id}');
        await store.add(txn, {
          'isFavorite': goal.isFavorite,
          'description': goal.description
        });
      });
    else
      await database.transaction((txn) async {
        print(goal.id);
        print('ttt ${goal.id}');
        await store.record(goal.id).update(txn, {
          'isFavorite': goal.isFavorite,
          'description': goal.description
        });
      });

    Fluttertoast.showToast(
        msg: 'Saved',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }

  static saveTaboo(Taboo taboo,database,context) async {
    var store = intMapStoreFactory.store('taboos');
    if(taboo.id==null)
      await database.transaction((txn) async {
        print(taboo.id);
        print('ttt ${taboo.id}');
        await store.add(txn, {
          'word': taboo.word
        });
      });
    else
      await database.transaction((txn) async {
        print(taboo.id);
        print('ttt ${taboo.id}');
        await store.record(taboo.id).update(txn, {
          'word': taboo.word
        });
      });

    Navigator.pop(context);
  }
}