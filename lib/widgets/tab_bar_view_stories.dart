
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
                'date':days[days.length-index-1]
              });
            },
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: getWeekDayColor(days[days.length-index-1])
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 25,
                                color: Colors.white,
                              ),
                              Text(
                                translator.translate('day'),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline2
                              ),
                              Text(
                                GlobalProcedures.getDateWithMoreText(days[days.length-index-1]),//principles[index].title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle1
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                if(!storiesOpened.contains(days[days.length-index-1])) Positioned(//not opened indicator
                  top: -5,
                  right: 0,
                  child: Indicator.dot(color: Colors.red,size: 15,)
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
    return ConfigDatas.weekDaysColorMap[DateTime(int.parse(date_splited[2]),int.parse(date_splited[1]),int.parse(date_splited[0])).weekday];
  }

}