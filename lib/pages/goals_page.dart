
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
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

class GoalsPage extends StatefulWidget {

  final Database database;

  const GoalsPage({this.database, Key key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  List<Goal> goals=[];
  var subscription;

  @override
  void initState() {
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
    var store = intMapStoreFactory.store('goals');
    var finder = Finder(
        sortOrders: [SortOrder('isFavorite',false)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Goal> goals_temp = snapshots.map((snapshot) {
        var goal = new Goal(
            snapshot.key,
            snapshot.value['description'],
            snapshot.value['isFavorite']);
        return goal;
      }).toList();
      if(mounted)
        setState(() {
          goals = goals_temp;
        });
      else
        goals = goals_temp;
    });
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
        leading: TextButton(
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
          SizedBox(height: MediaQuery.of(context).size.height*0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.album_outlined,
                size: 40,
                color: ConfigDatas.appDarkBlueColor,
              ),
              Text(
                translator.translate('yourGoals'),
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          Expanded(
            child: Container(
              height:MediaQuery.of(context).size.height*0.726,
              // padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true ,
                scrollDirection: Axis.vertical,
                itemCount: goals.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.width*0.4,
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.1,right:MediaQuery.of(context).size.width*0.1,top: 10,bottom: 20),
                    padding: EdgeInsets.only(left:10),
                    decoration: BoxDecoration(
                     boxShadow: [
                       BoxShadow(
                        color: Colors.black26,
                        blurRadius:8,
                        spreadRadius:1,
                            offset: Offset(4,4)
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [ConfigDatas.appDarkBlueColor,ConfigDatas.appBlueColor],
                          stops: [0.3,0.9],
                        ),
                        color: ConfigDatas.appBlueColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:EdgeInsets.only(top:20),
                          child: CardActionList(
                            variant: 'goal',
                            isFavorite:goals[index].isFavorite,
                            onSwitchFavorite:() async{
                              var store = intMapStoreFactory.store('goals');
                              await widget.database.transaction((txn) async {
                                print(goals[index].id);
                                print('ttt ${goals[index].id}');
                                print('ttt ${goals[index].isFavorite}');
                                await store.record(goals[index].id).update(txn, {
                                  'isFavorite': goals[index].isFavorite==1?0:1
                                });
                              });
                            },
                            onDelete: () async{
                              var store = intMapStoreFactory.store('goals');
                              await store.record(goals[index].id).delete(widget.database);
                            },
                            onEdit: () {
                              PopupFunctions.onAlertWithCustomContentPressed(context,'edit','goal',element:goals[index],database: widget.database);
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          padding:EdgeInsets.all(5),
                          child: Center(
                            child: Scrollbar(
                              radius: Radius.circular(10),
                              child: TextField(
                                controller: TextEditingController(text: goals[index].description),
                                maxLines: null,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText:null,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PopupFunctions.onAlertWithCustomContentPressed(context,'create','goal',element:new Goal(
              null,
              '',
              0
          ),database: widget.database);
        },
        child: Icon(Icons.add),
        backgroundColor: ConfigDatas.appDarkBlueColor,
      ),
    );
  }

}
