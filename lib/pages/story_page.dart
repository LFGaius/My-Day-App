
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
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
  TextEditingController descriptionController = TextEditingController();
  int isFavorite=0;
  List<Goal> goals=[];
  var subscription;

  @override
  void initState() {
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
    // var store = intMapStoreFactory.store('goals');
    // var finder = Finder(
    //     sortOrders: [SortOrder('isFavorite',false)]);
    // var query = store.query(finder: finder);
    // subscription = query.onSnapshots(widget.database).listen((snapshots) {
    //   // snapshots always contains the list of records matching the query
    //   List<Goal> goals_temp = snapshots.map((snapshot) {
    //     var goal = new Goal(
    //         snapshot.key,
    //         snapshot.value['description'],
    //         snapshot.value['isFavorite']);
    //     return goal;
    //   }).toList();
    //   if(mounted)
    //     setState(() {
    //       goals = goals_temp;
    //     });
    //   else
    //     goals = goals_temp;
    // });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                '02 Jun 2021',
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
                                color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.redAccent),
                            SizedBox(width: 5),
                            Text(
                              '0 activities not accomplished',
                              style: TextStyle(
                                color: ConfigDatas.appBlueColor,
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
                                color: ConfigDatas.appBlueColor,
                                fontSize: 15,
                                // fontFamily: 'Freestyle Script Regular',
                              ),
                            )
                          ],
                        ),
                        SizedBox(height:5 ),
                        Row(
                          children: [
                            Indicator.dot(color: Colors.redAccent),
                            SizedBox(width: 5),
                            Text(
                              '0 emergencies not accomplished',
                              style: TextStyle(
                                color: ConfigDatas.appBlueColor,
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
                Text('container'*500)
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

  _onAlertWithCustomContentPressed(context,mode,Goal goal) {
    isFavorite = goal.isFavorite;
    descriptionController.text = goal.description;

    Alert(
        context: context,
        style: AlertStyle(
            titleStyle: TextStyle(
              color: ConfigDatas.appBlueColor,
              fontWeight: FontWeight.bold,
              fontSize:30,
            )
        ),
        title: mode=='create'?'Create goal':'Edit goal',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            TextField(
              controller: descriptionController,
              minLines: 4,
              maxLines: null,
              readOnly: false,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Goal',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: ()  async=>{
              await saveGoal(new Goal(
                  goal?.id,
                  descriptionController.text,
                  isFavorite
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

}
