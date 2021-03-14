
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/global_procedures.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/comment.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/goal.dart';
import 'package:my_day_app/models/goal.dart';
import 'package:my_day_app/models/principle.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/tab_bar_view_emergencies.dart';
import 'package:my_day_app/widgets/tab_bar_view_principles.dart';
import 'package:my_day_app/widgets/tab_bar_view_timeline.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

class StoryPage extends StatefulWidget {

  final Database database;
  final String date;


  const StoryPage({this.database, Key key, this.date}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  List<Activity> activities=[];
  List<Comment> comments=[];
  List<Emergency> emergencies=[];
  StreamController<String> streamCommentsController = StreamController.broadcast();
  num numberActivitiesAccomplished=0;
  num numberActivitiesNotAccomplished=0;
  num numberEmergenciesAccomplished=0;
  num numberEmergenciesNotAccomplished=0;
  // num accomplishmentRate=0;
  var subscriptionEmergencies;
  var subscriptionComments;
  var subscriptionActivities;
  final ScrollController lvcontroller=ScrollController();
  get actEmerLength{
    return activities.length+emergencies.length;
  }

  get accomplishmentRate{
    double d=actEmerLength>0?((numberActivitiesAccomplished+numberEmergenciesAccomplished)/actEmerLength)*100:0.0;
    return d.toStringAsFixed(2);
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      String storiesOpened=prefs.getString('myday_stories_opened')!=null?prefs.getString('myday_stories_opened'):'';
      print('${storiesOpened};$widget.date');
      if(!storiesOpened.contains(widget.date))
        prefs.setString('myday_stories_opened','${storiesOpened};${widget.date}');//to store the dates of stories already opened
    });

    var store = intMapStoreFactory.store('emergencies');
    print('widget.date '+widget.date);
    var finder = Finder(
      // limit: 10,
      filter: Filter.equals('date', '${widget.date}')
    );
    var query = store.query(finder: finder);
    subscriptionEmergencies = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Emergency> emergencies_temp = snapshots.map((snapshot) {
        if(snapshot.value['isAccomplished']) numberEmergenciesAccomplished++;
        else numberEmergenciesNotAccomplished++;
        var emer = new Emergency(
          snapshot.key,
          snapshot.value['title'],
          snapshot.value['description'],
          snapshot.value['isAccomplished'],
          snapshot.value['date']
        );
        return emer;
      }).toList();
      if(mounted)
        setState(() {
          emergencies = emergencies_temp;
        });
      else
        emergencies = emergencies_temp;
    });

    var storeAct = intMapStoreFactory.store('activities');
    var finderAct = Finder(
        filter: Filter.equals('date', '${widget.date}'),
        sortOrders: [SortOrder('time',true)]
    );
    var queryAct = storeAct.query(finder: finderAct);
    subscriptionActivities = queryAct.onSnapshots(widget.database).listen((snapshots) {
      List<Activity> activities_temp = snapshots.map((snapshot) {
        if(snapshot.value['isAccomplished']) numberActivitiesAccomplished++;
        else numberActivitiesNotAccomplished++;
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

      if (mounted)
        setState(() {
          activities = activities_temp;
        });
      else {
        activities = activities_temp;
      }
    });

    var storeCom = intMapStoreFactory.store('comments');
    var finderCom = Finder(
        filter: Filter.equals('storyDate', '${widget.date}')
    );
    var queryCom = storeCom.query(finder: finderCom);
    subscriptionActivities = queryCom.onSnapshots(widget.database).listen((snapshots) {
      List<Comment> comments_temp = snapshots.map((snapshot) {
        print('snapshot $snapshot');
        var act = new Comment(
            snapshot.key,
            snapshot.value['value'],
            snapshot.value['storyDate']
        );
        return act;
      }).toList();

      if (mounted)
        setState(() {
          comments = comments_temp;
          streamCommentsController.add('comments list updated');
        });
      else {
        comments = comments_temp;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    unawaited(subscriptionEmergencies?.cancel());
    unawaited(subscriptionActivities?.cancel());
    unawaited(subscriptionComments?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: ConfigDatas.appBlueColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/logowhitevariant.png',
                height: 50,
              ),
            ],
          ),
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(
                  '/home',
                  arguments:{'database':widget.database,'startTab':ConfigDatas.storiesTabOrder}
              );
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: MediaQuery.of(context).size.height*0.06,
                color: ConfigDatas.appDarkBlueColor,
              ),
              SizedBox(width: 10),
              Text(
                GlobalProcedures.getDateWithMoreText(widget.date),
                style: TextStyle(
                  color: ConfigDatas.appBlueColor,
                  fontSize: MediaQuery.of(context).size.height*0.07,
                  fontFamily: 'Freestyle Script Regular',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if(double.parse(accomplishmentRate)<50) Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(40)
            ),
            child: Text(
              '😑 BAD PRODUCTIVITY',
              style: Theme.of(context).textTheme.headline2
            ),
          ),
          if(double.parse(accomplishmentRate)>=50 && double.parse(accomplishmentRate)<80) Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(40)
            ),
            child: AutoSizeText(
              '🙂 MEDIUM PRODUCTIVITY',
              style: Theme.of(context).textTheme.headline2
            ),
          ),
          if(double.parse(accomplishmentRate)>=80) Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(40)
            ),
            child: AutoSizeText(
              '😲 AMAZING PRODUCTIVITY',
              style: Theme.of(context).textTheme.headline2
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
                controller:lvcontroller,
              // height:MediaQuery.of(context).size.height*0.79,
              // color: Colors.red,
              // padding: const EdgeInsets.all(8.0),
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      height:30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: ConfigDatas.appBlueColor,
                        borderRadius: BorderRadius.circular(30)
                      ),

                      child: Center(child: Text(
                        'A',
                        style: TextStyle(color: Colors.white),
                      ))
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Indicator.dot(color: Colors.green),
                            SizedBox(width: 5),
                            Text(
                              '${numberActivitiesAccomplished} activities accomplished',
                              style: Theme.of(context).textTheme.bodyText2
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.orange),
                            SizedBox(width: 5),
                            Text(
                              '${numberActivitiesNotAccomplished} activities not accomplished',
                              style: Theme.of(context).textTheme.bodyText2
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        height:30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: ConfigDatas.appBlueColor,
                            borderRadius: BorderRadius.circular(30)
                        ),

                        child: Center(
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        )
                    ),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Indicator.dot(color: Colors.green),
                            SizedBox(width: 5),
                            Text(
                              '${numberEmergenciesAccomplished} emergencies accomplished',
                              style: Theme.of(context).textTheme.bodyText2
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.orange),
                            SizedBox(width: 5),
                            Text(
                              '${numberEmergenciesNotAccomplished} emergencies not accomplished',
                              style: Theme.of(context).textTheme.bodyText2
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    Text(
                      '${accomplishmentRate}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 60
                      ),
                    ),
                    Text(
                      'ACCOMPLISHMENTS',
                      style: Theme.of(context).textTheme.bodyText2
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ExpandablePanel(
                  headerAlignment:  ExpandablePanelHeaderAlignment.center,
                  header: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          height:30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: ConfigDatas.appBlueColor,
                              borderRadius: BorderRadius.circular(30)
                          ),

                          child: Center(child: Text(
                            'A',
                            style: TextStyle(color: Colors.white),
                          ))
                      ),
                      Text(
                        'Activities',
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                    ],
                  ),
                  // collapsed: Text('zerrz', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  expanded: expandedWidget(activities,'activity'),
                  tapHeaderToExpand: true,
                  hasIcon: true,
                ),
                ExpandablePanel(
                  headerAlignment:  ExpandablePanelHeaderAlignment.center,
                  header: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          height:30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: ConfigDatas.appBlueColor,
                              borderRadius: BorderRadius.circular(30)
                          ),

                          child: Center(
                            child: Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          )
                      ),
                      Text(
                        'Emergencies',
                        style: Theme.of(context).textTheme.bodyText2
                      ),
                    ],
                  ),
                  // collapsed: Text('zerrz', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  expanded: expandedWidget(emergencies,'emergency'),
                  tapHeaderToExpand: true,
                  hasIcon: true,
                ),

              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showStoryCommentPopup(context);
        },
        child: Icon(Icons.comment),
        backgroundColor: ConfigDatas.appBlueColor,
      ),
    );
  }

  showStoryCommentPopup(context) {
    Alert(
        context: context,
        style: AlertStyle(
          backgroundColor: ConfigDatas.appBlueColor,
            alertPadding: EdgeInsets.all(5),
            isButtonVisible: false,
            titleStyle: Theme.of(context).textTheme.headline2
        ),
        title: 'Story comments',
        closeIcon: Icon(Icons.close_outlined,color: Colors.white),
        content: Container(
          height: MediaQuery.of(context).size.height*0.7,
          width: MediaQuery.of(context).size.width*0.85,
          padding: EdgeInsets.only(left:20,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [comments.length==0?ConfigDatas.appBlueColor:ConfigDatas.appDarkBlueColor,ConfigDatas.appBlueColor],
              stops: [0,0.7],
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  print('comments $comments');
                  // Navigator.pop(context);
                  PopupFunctions.onAlertWithCustomContentPressed(
                      context, 'create', 'storycomment', element: new Comment(
                      null,
                      '',
                      widget.date
                  ),
                  database: widget.database);
                },
                child: Center(
                  child: Icon(
                    Icons.add_box,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Scrollbar(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      streamCommentsController.stream.listen((messages) => {//we stream on comments list changes because the popup keep on UI the effect when the popup was called
                        print('change'),
                        if(mounted)
                          setState(() {
                            comments=comments;
                          })
                      });
                      return comments.length==0?Center(
                        child: Text(
                          'No Comments',
                          style: Theme.of(context).textTheme.bodyText1
                        ),
                      ):ListView.builder(
                          shrinkWrap: true ,
                          scrollDirection: Axis.vertical,
                          itemCount: comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              // width: MediaQuery.of(context).size.width*0.5,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   begin: Alignment.bottomCenter,
                                //   end: Alignment.topCenter,
                                //   colors: [ConfigDatas.appDarkBlueColor,ConfigDatas.appBlueColor],
                                //   stops: [0,1],
                                // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Column(
                                children: [
                                  CardActionList(
                                      variant:'storycomment',
                                      onEdit: () {
                                        PopupFunctions.onAlertWithCustomContentPressed(context,'edit','storycomment',element: comments[index],database:widget.database);
                                      },
                                      onDelete: () async{
                                        var store = intMapStoreFactory.store('comments');
                                        await store.record(comments[index].id).delete(widget.database);
                                      },
                                  ),
                                  Center(
                                    child: Scrollbar(
                                      radius: Radius.circular(10),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: TextEditingController(text: comments[index].value),
                                            maxLines: null,
                                            readOnly: true,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ConfigDatas.appDarkBlueColor,
                                              fontSize: 40,
                                              // fontWeight: FontWeight.bold,
                                              fontFamily: 'Freestyle Script Regular',
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText:null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
                  )
                ),
              ),
            ],
          ),
        )).show();
  }

  Widget expandedWidget(elements,variant){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NotificationListener<OverscrollNotification>(
            onNotification: (OverscrollNotification value) {
              if (value.overscroll < 0 && lvcontroller.offset + value.overscroll <= 0) {
                if (lvcontroller.offset != 0) lvcontroller.jumpTo(0);
                return true;
              }
              if (lvcontroller.offset + value.overscroll >= lvcontroller.position.maxScrollExtent) {
                if (lvcontroller.offset != lvcontroller.position.maxScrollExtent) lvcontroller.jumpTo(lvcontroller.position.maxScrollExtent);
                return true;
              }
              lvcontroller.jumpTo(lvcontroller.offset + value.overscroll);
              return true;
            },
            child: elements.length==0?Center(
              child: Text(variant=='emergency'?'No Emergencies':'No Activities'),
            ):GridView.builder(
              shrinkWrap: true,
              itemCount: elements.length,

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0
              ),
              itemBuilder: (BuildContext context, int index) {
                print('index: $index');
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors:variant=='emergency'?
                            [Color.fromRGBO(255, 102, 51, 1), Color.fromRGBO(255, 153 , 51, 1)]:
                            [Colors.orangeAccent,Colors.orangeAccent]
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CardActionList(
                          variant:'story',
                          onRestore: () {
                            PopupFunctions.performRestoreProcess(variant,elements[index],widget.database,context,frompopup:false,title:elements[index].title,description:elements[index].description);
                          },
                          onView: () {
                            PopupFunctions.onAlertWithCustomContentPressed(context,'view',variant,element: elements[index],database:widget.database,storyMode:true);
                          },
                          isAccomplished: elements[index].isAccomplished!=null?elements[index].isAccomplished:false,
                          restoreHidden:elements[index].isAccomplished!=null?elements[index].isAccomplished:false,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                variant=='emergency'?Icons.warning:GlobalProcedures.getIcon(elements[index].type),
                                size: 35,
                                color: Colors.white,
                              ),
                              Text(
                                elements[index].title,
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }

}
