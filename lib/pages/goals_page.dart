
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

class GoalsPage extends StatefulWidget {

  final Database database;

  const GoalsPage({this.database, Key key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
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
    var store = intMapStoreFactory.store('goals');
    var finder = Finder(
        sortOrders: [SortOrder('isFavorite',false)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      if(mounted)
        setState(() {
          goals = snapshots.map((snapshot) {
            var goal = new Goal(
                snapshot.key,
                snapshot.value['description'],
                snapshot.value['isFavorite']);
            return goal;
          }).toList();
        });
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
                'Your Goals',
                style: TextStyle(
                  color: ConfigDatas.appBlueColor,
                  fontSize: 60,
                  fontFamily: 'Freestyle Script Regular',
                ),
              ),
            ],
          ),
          Container(
            height:MediaQuery.of(context).size.height*0.5,
            // padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true ,
              scrollDirection: Axis.horizontal,
              itemCount: goals.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  margin: EdgeInsets.all(20),
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
                            _onAlertWithCustomContentPressed(context,'edit',goals[index]);
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontFamily: 'Freestyle Script Regular',
                              ),
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

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAlertWithCustomContentPressed(context,'create',new Goal(
              null,
              '',
              0
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: ConfigDatas.appDarkBlueColor,
      ),
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
