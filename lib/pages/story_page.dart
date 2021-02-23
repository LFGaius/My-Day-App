
import 'package:expandable/expandable.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/global_procedures.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
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
  List<Emergency> emergencies=[];
  var subscriptionEmergencies;
  var subscriptionActivities;
  final ScrollController lvcontroller=ScrollController();

  @override
  void initState() {
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
    var store = intMapStoreFactory.store('emergencies');
    var finder = Finder(
        filter: Filter.equals('date', '${widget.date}')
    );
    var query = store.query(finder: finder);
    subscriptionEmergencies = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Emergency> emergencies_temp = snapshots.map((snapshot) {
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    unawaited(subscriptionEmergencies?.cancel());
    unawaited(subscriptionActivities?.cancel());
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
          leading: FlatButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(
                  '/home',
                  arguments:{'database':widget.database}
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
                              '2 activities accomplished',
                              style: TextStyle(
                                // color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.orange),
                            SizedBox(width: 5),
                            Text(
                              '0 activities not accomplished',
                              style: TextStyle(
                                // color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
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
                              '2 emergencies accomplished',
                              style: TextStyle(
                                // color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.orange),
                            SizedBox(width: 5),
                            Text(
                              '0 emergencies not accomplished',
                              style: TextStyle(
                                // color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
                            )
                          ],
                        ),
                      ],
                    )
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
                        style: TextStyle(
                          color: ConfigDatas.appBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  // collapsed: Text('zerrz', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  expanded: expandedWidget(emergencies,'activity'),
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
                        style: TextStyle(
                          color: ConfigDatas.appBlueColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _onAlertWithCustomContentPressed(context,'create',new Goal(
      //         null,
      //         '',
      //         0
      //     ));
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: ConfigDatas.appDarkBlueColor,
      // ),
    );
  }

  // _onAlertWithCustomContentPressed(context,mode,Goal goal) {
  //   isFavorite = goal.isFavorite;
  //   descriptionController.text = goal.description;
  //
  //   Alert(
  //       context: context,
  //       style: AlertStyle(
  //           titleStyle: TextStyle(
  //             color: ConfigDatas.appBlueColor,
  //             fontWeight: FontWeight.bold,
  //             fontSize:30,
  //           )
  //       ),
  //       title: mode=='create'?'Create goal':'Edit goal',
  //       closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
  //       content: Column(
  //         children: <Widget>[
  //           TextField(
  //             controller: descriptionController,
  //             minLines: 4,
  //             maxLines: null,
  //             readOnly: false,
  //             keyboardType: TextInputType.multiline,
  //             decoration: InputDecoration(
  //               labelText: 'Goal',
  //             ),
  //           ),
  //         ],
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: ()  async=>{
  //             await saveGoal(new Goal(
  //                 goal?.id,
  //                 descriptionController.text,
  //                 isFavorite
  //             )),
  //             Navigator.pop(context)
  //           },
  //           color: ConfigDatas.appBlueColor,
  //           width: 100,
  //           child: Text(
  //             "Save",
  //             style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
  //           ),
  //         )
  //       ]).show();
  // }



  saveGoal(Goal goal) async {
    var store = intMapStoreFactory.store('goals');
    if(goal.id==null)
      await widget.database.transaction((txn) async {
        print(goal.id);
        print('ttt ${goal.id}');
        await store.add(txn, {
          'isFavorite': goal.isFavorite,
          'description': goal.description
        });
      });
    else
      await widget.database.transaction((txn) async {
        print(goal.id);
        print('ttt ${goal.id}');
        await store.record(goal.id).update(txn, {
          'isFavorite': goal.isFavorite,
          'description': goal.description
        });
      });
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
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 10,//elements.length,

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

                          },
                          onView: () {
                            PopupFunctions.onAlertWithCustomContentPressed(context,'view',emergency: elements[index],database:widget.database);
                          },
                          isAccomplished: true,//elements[index].isAccomplished
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                variant=='emergency'?Icons.warning:Icons.wysiwyg_sharp/*GlobalProcedures.getIcon(elements[index].type)*/,
                                size: 35,
                                color: Colors.white,
                              ),
                              Text(
                                'test',//elements[index-1].title,
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
