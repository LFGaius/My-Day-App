
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/global_procedures.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/principle.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

class TabBarViewStories extends StatefulWidget {

  final Database database;

  const TabBarViewStories({Key key, this.database}) : super(key: key);

  @override
  _TabBarViewStoriesState createState() => _TabBarViewStoriesState();
}

class _TabBarViewStoriesState extends State<TabBarViewStories> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Principle> principles=[];
  List<String> days=[];
  Map<int,Color> weekDaysColorMap={
    1:Colors.red,
    2:Colors.yellow,
    3:Colors.orange,
    4:Colors.black87,
    5:Colors.purple,
    6:Colors.green,
    7:Colors.lightBlueAccent,
  };
  var subscription;
  String storiesOpened;


  generateDays() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    print('myday_start_date ${prefs.getString('myday_start_date')}');
    List<String> startdate=prefs.getString('myday_start_date').split('-');
    print('myday_start_date ${prefs.getString('myday_start_date').split('-')}');
    DateTime dt=DateTime(int.parse(startdate[2]),int.parse(startdate[1]),int.parse(startdate[0]));
    DateTime now=DateTime.now();
    List<String> days_temp=[];
    while(dt.isBefore(DateTime(now.year,now.month,now.day))){
      print('current ${dt}');
      print('dt ${dt.add(Duration(days:1))}');
      days_temp.add('${dt.day}-${dt.month}-${dt.year}');
      dt=dt.add(Duration(days:1));
    }
    print('days ${days}');
    if(mounted)//if the widget is already built
      setState(() {
        days=days_temp;
      });
    else
      days=days_temp;
  }

  @override
  void initState(){
    super.initState();
    generateDays();
    SharedPreferences.getInstance().then((prefs){
      print('storiesOpened $storiesOpened');
      if(mounted)
        setState(() {
          storiesOpened=prefs.getString('myday_stories_opened')!=null?prefs.getString('myday_stories_opened'):'';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        padding: EdgeInsets.only(top:5),
        itemCount: days.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemBuilder: (BuildContext context, int index) {
          print('index: $index');
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/story',(Route<dynamic> route) => false,
              arguments:{
                'database':widget.database,
                'date':days[index]
              });
            },
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: getWeekDayColor(days[index])
                    // gradient: LinearGradient(
                    //     begin: Alignment.bottomCenter,
                    //     end: Alignment.topCenter,
                    //     colors: [Color.fromRGBO(255, 153 , 51, 1),Colors.orange ]
                    // )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // CardActionList(
                        //   onDelete: () async{
                        //     var store = intMapStoreFactory.store('principles');
                        //     await store.record(principles[index].id).delete(widget.database);
                        //   },
                        //   onView: () {
                        //     _onAlertWithCustomContentPressed(context,'view',principle: principles[index]);
                        //   },
                        //   variant: 'principle',
                        // ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                'DAY',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white
                                ),
                              ),
                              Text(
                                GlobalProcedures.getDateWithMoreText(days[index]),//principles[index].title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                if(!storiesOpened.contains(days[index])) Positioned(//not opened indicator
                  top: -5,
                  right: 3,
                  child: Indicator.dot(color: ConfigDatas.appBlueColor,size: 15,)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color getWeekDayColor(String date){
    List<String> date_splited=date.split('-');
    return weekDaysColorMap[DateTime(int.parse(date_splited[2]),int.parse(date_splited[1]),int.parse(date_splited[0])).weekday];
  }

  _onAlertWithCustomContentPressed(context,mode,{Principle principle}) {
    if(principle!=null) {
      titleController.text = principle.title;
      descriptionController.text = principle.description;
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
        title: mode!='view'?(mode=='create'?'Add principle':'Edit principle'):'',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            if(mode=='view') GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _onAlertWithCustomContentPressed(context,'edit',principle: principle);
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
          ],
        ),
        buttons: [
          if(mode!='view') DialogButton(
            onPressed: ()  async=>{
              await savePrinciple(new Principle(
                  principle?.id,
                  titleController.text,
                  descriptionController.text
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

  savePrinciple(Principle principle) async {
    var store = intMapStoreFactory.store('principles');
    if(principle.id==null)
      await widget.database.transaction((txn) async {
        print(principle.id);
        print('ttt ${principle.id}');
        await store.add(txn, {
          'title': principle.title,
          'description': principle.description
        });
      });
    else
      await widget.database.transaction((txn) async {
        print(principle.id);
        print('ttt ${principle.id}');
        await store.record(principle.id).update(txn, {
          'title': principle.title,
          'description': principle.description
        });
      });
  }
// var
}