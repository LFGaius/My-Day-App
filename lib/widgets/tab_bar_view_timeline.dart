
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/main.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class TabBarViewTimeline extends StatefulWidget {

  final Database database;

  const TabBarViewTimeline({Key key, this.database}) : super(key: key);

  @override
  _TabBarViewTimelineState createState() => _TabBarViewTimelineState();
}

class _TabBarViewTimelineState extends State<TabBarViewTimeline> {
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Activity> activities=[];
  List<ActivityTypeItem> activitytypes = <ActivityTypeItem>[
    const ActivityTypeItem('Other',Icon(Icons.wysiwyg_sharp,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Rest',Icon(Icons.airline_seat_flat,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Hobby',Icon(Icons.accessible_forward_outlined,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Study',Icon(Icons.menu_book,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Spiritual',Icon(Icons.accessibility_new,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Professional',Icon(Icons.corporate_fare,color:  Color.fromRGBO(51, 102, 255, 1))),
  ];
  String selectedActivityType;
  bool isAccomplished=false;
  var subscription;
  String timesCHain;//Use to concatenate all the activities times

  @override
  void initState(){
    super.initState();
    tz.initializeTimeZones();
    DateTime current = DateTime.now();
    Stream timer = Stream.periodic( Duration(seconds: 1), (i){
      var now='${DateTime.now().hour}:${DateTime.now().minute}';
      if(timesCHain.contains(now)){
        if(mounted)
          setState(() {
            timesCHain=timesCHain.replaceFirst(now,'');
          });
        else
          timesCHain=timesCHain.replaceFirst(now,'');
      }
      current = current.add(Duration(seconds: 15));
      return current;
    });

    timer.listen((data)=> {});
    var store = intMapStoreFactory.store('activities');
    var finder = Finder(
        filter: Filter.equals('date', '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'),
        sortOrders: [SortOrder('time',true)]
    );
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      var temp='';
      List<Activity> activities_temp = snapshots.where((e) => e.value['date']=='${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}').map((snapshot) {
        temp+=';'+snapshot.value['time'];
        var act = new Activity(
            snapshot.key,
            snapshot.value['title'],
            snapshot.value['description'],
            snapshot.value['type'],
            snapshot.value['time'],
            snapshot.value['date'],
            snapshot.value['duration'],
            snapshot.value['isAccomplished']
        );
        return act;
      }).toList();
      if(mounted)
        setState(() {
          activities = activities_temp;
          timesCHain=temp;
        });
      else {
        activities = activities_temp;
        timesCHain = temp;
      }
    });
  }

  @override
  void dispose() {
    unawaited(subscription?.cancel());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.connectedFromStyle(
        contentsAlign: ContentsAlign.alternating,
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              activities.length==index?'Add activity':activities[index].time,
            // style: TextStyle(
            //   fontFamily: 'Freestyle Script Regular',
            //   fontSize: 25
            // ),
          ),
        ),

        contentsBuilder: (context, index) => activities.length==index?GestureDetector(
          onTap: ()=>_onAlertWithCustomContentPressed(context,'create',activity:new Activity(
              null,
              '',
              '',
              'Other',
              '00:00',
              'dd-mm-yy',
              '00:00',
              false
          )),
          child: Card(
            color: ConfigDatas.appBlueColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ):Card(
          color: Colors.orangeAccent,
          child: Container(
            width: MediaQuery.of(context).size.width*0.3,
            // height: 90,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CardActionList(
                  onDelete: () async{
                    var notifId=activities[index].id;
                    var store = intMapStoreFactory.store('activities');
                    await store.record(activities[index].id).delete(widget.database);
                    cancelNotification(notifId);
                  },
                  onSwitchAccomplished: () async{
                    print('isAccomplished ${activities[index].isAccomplished}');
                    var store = intMapStoreFactory.store('activities');
                    await widget.database.transaction((txn) async {
                      await store.record(activities[index].id).update(txn, {
                        'isAccomplished': !activities[index].isAccomplished
                      });
                    });
                  },
                  isAccomplished: activities[index].isAccomplished
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    Icon(
                        getIcon(activities[index].type),
                        color: Colors.white
                    ),
                    Text(
                      activities[index].title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_sharp,
                          size: 12,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        SizedBox(width:3),
                        Text(
                          activities[index].duration,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7)
                          ),
                        ),
                      ],
                    ),
                  ]
                )

              ],
            ),
          ),
        ),
        connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
        indicatorStyleBuilder: (context, index) {
          if(activities.length>index){
            DateTime now=DateTime.now();
            var timeSplited=activities[index].time.split(':');
            DateTime activityTime=new DateTime(now.year,now.month,now.day,int.parse(timeSplited[0]),int.parse(timeSplited[1]));

            if(now.isAfter(activityTime))
              return IndicatorStyle.dot;
            else
              return IndicatorStyle.outlined;
          }else
            return IndicatorStyle.outlined;
        },
        itemCount: activities.length+1,
      ),
    );
  }

    _onAlertWithCustomContentPressed(context,mode,{Activity activity}){
      if(activity!=null) {
        titleController.text = activity.title;
        descriptionController.text = activity.description;
        timeController.text=activity.time;
        durationController.text=activity.duration;
        selectedActivityType=activity.type;
        isAccomplished=activity.isAccomplished;
      }
      Alert(
          context: context,
          style: AlertStyle(
              titleStyle: TextStyle(
                  color: ConfigDatas.appBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: mode!='view'?30:0,
              )
          ),
          title: mode!='view'?(mode=='create'?'Add activity':'Edit activity'):'',
          closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
          content: Column(
            children: <Widget>[
              if(mode=='view') GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _onAlertWithCustomContentPressed(context,'edit',activity: activity);
                },
                child: Container(
                  width: 80,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: ConfigDatas.appBlueColor,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit,color: Colors.white),
                      Text(
                        'Edit',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextField(
                controller: titleController,
                readOnly: mode=='view',
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                minLines: 4,
                maxLines: null,
                readOnly: mode=='view',
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 40),
              TimePicker(label:'Start time',readOnly: mode=='view',timeController: timeController),
              SizedBox(height: 40),
              TimePicker(label:'Duration',readOnly: mode=='view',timeController: durationController),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        color: Colors.black54
                    ),
                  ),

                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButton<String>(

                        hint:  Text("Select type"),
                        value: selectedActivityType,
                        onChanged: (String value) {
                          if(mode!='view')
                          setState(() {
                            print('----------$value---------');
                            selectedActivityType = value;
                          });
                        },
                        items: activitytypes.map((ActivityTypeItem activitytype) {
                          return  DropdownMenuItem<String>(
                            value: activitytype.name,
                            child: Row(
                              children: <Widget>[
                                activitytype.icon,
                                SizedBox(width: 10,),
                                Text(
                                  activitytype.name,
                                  style:  TextStyle(color: Colors.black),
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
          buttons: [
            if(mode!='view') DialogButton(
              onPressed: ()  async{
                var now=DateTime.now();
                tz.TZDateTime _now=tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second);
                var targetDt=tz.TZDateTime.local(now.year,now.month,now.day,int.parse(timeController.text.split(':')[0]),int.parse(timeController.text.split(':')[1]));
                print('now: ${now} targetDt: ${targetDt}');
                if(_now.isBefore(targetDt)){
                  List<String> dSplited=durationController.text.split(':');
                  var _hours=int.parse(dSplited[0]);
                  var _minutes=int.parse(dSplited[1]);
                  var endTime=_now.add(Duration(hours: _hours,minutes: _minutes));
                  if((_hours+_minutes)>0 && endTime.isBefore(DateTime(now.year,now.month,now.day,23,59,59))) {
                    int activityId = await saveActivity(new Activity(
                        activity?.id,
                        titleController.text,
                        descriptionController.text,
                        selectedActivityType,
                        timeController.text,
                        '${_now.day}-${_now.month}-${_now.year}',
                        durationController.text,
                        isAccomplished
                    ));
                    int secondsToSchedule = ((targetDt.millisecondsSinceEpoch -
                        _now.millisecondsSinceEpoch) / 1000).toInt();
                    scheduleAlarm(activityId, activity.time,
                        secondsToSchedule == 0 ? 1 : secondsToSchedule,
                        titleController.text);
                    Navigator.pop(context);
                  }else
                    Fluttertoast.showToast(
                        msg: "Invalid duration! Please enter a duration greater than 0 and less than the remaining time in the day",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                }else{
                  Fluttertoast.showToast(
                      msg: "Time passed! Please enter a future time",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
              color: ConfigDatas.appBlueColor,
              width: 100,
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
              ),
            )
          ]).show();
    }

  cancelNotification(int notificationId) async{
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  void scheduleAlarm(int id,String time,int secondsToSchedule,String activityTitle) async {
    print('wait $secondsToSchedule');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'logo',
      // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
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
        id, 'Activity started', activityTitle,
      tz.TZDateTime.local(now.year,now.month,now.day,now.hour,now.minute,now.second).add(-offset).add(Duration(seconds: secondsToSchedule)),//with -offset, we avoid the effect of the offset because in background, the offset is added(conversion to UTC) and compared to the local time(Weird package behavior)
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime
    );
  }

    dynamic getIcon(type){
      switch(type){
        case 'Other': return Icons.wysiwyg_sharp;
        break;
        case 'Rest': return Icons.airline_seat_flat;
        break;
        case 'Hobby': return Icons.accessible_forward_outlined;
        break;
        case 'Study': return Icons.menu_book;
        break;
        case 'Spiritual': return Icons.accessibility_new;
        break;
        case 'Professional': return Icons.corporate_fare;
        break;
      }
    }

    Future<int> saveActivity(Activity activity) async {
      var store = intMapStoreFactory.store('activities');
      int activityId;
      if (activity.id == null){
        await widget.database.transaction((txn) async {
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
        await widget.database.transaction((txn) async {
          await store.record(activity.id).update(txn, {
            'title': activity.title,
            'description': activity.description,
            'type': activity.type,
            'time': activity.date,
            'duration': activity.duration,
            'isAccomplished': activity.isAccomplished
          });
        });
      }
      return activityId;
    }
      // var
}