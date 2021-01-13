
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';

class TabBarViewTimeline extends StatefulWidget {

  final Database database;

  const TabBarViewTimeline({Key key, this.database}) : super(key: key);

  @override
  _TabBarViewTimelineState createState() => _TabBarViewTimelineState();
}

class _TabBarViewTimelineState extends State<TabBarViewTimeline> {
  TextEditingController timeController = TextEditingController();
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
  var subscription;

  @override
  void initState(){
    super.initState();
    var store = intMapStoreFactory.store('activities');
    var finder = Finder(
        sortOrders: [SortOrder('time',true)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      setState(() {
        activities = snapshots.map((snapshot) {
          var act = new Activity(
              snapshot.key,
              snapshot.value['title'],
              snapshot.value['description'],
              snapshot.value['type'],
              snapshot.value['time']);
          return act;
        }).toList();
      });
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
          child: Text(activities.length==index?'Add activity':activities[index].time),
        ),

        contentsBuilder: (context, index) => activities.length==index?GestureDetector(
          onTap: ()=>_onAlertWithCustomContentPressed(context,'create',activity:new Activity(
              null,
              '',
              '',
              '',
              '00:00'
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
            height: 90,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CardActionList(
                  onDelete: () async{
                    var store = intMapStoreFactory.store('activities');
                    await store.record(activities[index].id).delete(widget.database);
                  },
                  onView: () {
                    _onAlertWithCustomContentPressed(context,'view',activity: activities[index]);
                  },
                ),
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
                  ]
                )

              ],
            ),
          ),
        ),
        connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
        indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,
        itemCount: activities.length+1,
      ),
    );
  }

    _onAlertWithCustomContentPressed(context,mode,{Activity activity}){
      if(activity!=null) {
        titleController.text = activity.title;
        descriptionController.text = activity.description;
        timeController.text=activity.time;
        selectedActivityType=activity.type;
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
              SizedBox(height: 40,),
              TimePicker(readOnly: mode=='view',timeController: timeController),
              SizedBox(height: 40,),
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
              onPressed: ()  async=>{
                await saveActivity(new Activity(
                  activity?.id,
                  titleController.text,
                  descriptionController.text,
                  selectedActivityType,
                  timeController.text
                )),
                Navigator.pop(context)
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



    dynamic getIcon(type){
      switch(type){
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

    saveActivity(Activity activity) async {
      var store = intMapStoreFactory.store('activities');
      if(activity.id==null)
        await widget.database.transaction((txn) async {
          print(activity.id);
            print('ttt ${activity.id}');
            await store.add(txn, {
              'title': activity.title,
              'description': activity.description,
              'type': activity.type,
              'time': activity.time
            });
        });
      else
        await widget.database.transaction((txn) async {
          print(activity.id);
          print('ttt ${activity.id}');
          await store.record(activity.id).update(txn, {
            'title': activity.title,
            'description': activity.description,
            'type': activity.type,
            'time': activity.time
          });
        });

    }
      // var
}