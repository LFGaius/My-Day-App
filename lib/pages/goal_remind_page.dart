
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

class GoalRemindPage extends StatefulWidget {

  final Database database;

  const GoalRemindPage({this.database, Key key}) : super(key: key);

  @override
  _GoalRemindPageState createState() => _GoalRemindPageState();
}

class _GoalRemindPageState extends State<GoalRemindPage> {
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
        filter: Filter.equals('isFavorite', 1)
    );
    store.find(widget.database, finder: finder).then((snapshots) {
      // snapshots always contains the list of records matching the query
      if(mounted)
        setState(() {
          if(snapshots.length>0)
            goals = snapshots.map((snapshot) {
              var goal = new Goal(
                  snapshot.key,
                  snapshot.value['description'],
                  snapshot.value['isFavorite']);
              return goal;
            }).toList();
          else
            Navigator.of(context).pushNamedAndRemoveUntil('/home',(Route<dynamic> route) => false, arguments:{'database':widget.database});
        });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ConfigDatas.appBlueColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.05),
            // Icon(
            //   Icons.album_outlined,
            //   size: 40,
            //   color: ConfigDatas.appDarkBlueColor,
            // ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,bottom: 30,top: 10),
              child: Text(
                'Always remember your goals',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  // fontFamily: 'Freestyle Script Regular',
                ),
              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height*0.77,
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ConfigDatas.appBlueColor.withOpacity(0.05),
              ),
              child: ListView.builder(
                  shrinkWrap: true ,
                  scrollDirection: Axis.vertical,
                  itemCount: goals.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      margin: EdgeInsets.only(left:40,right: 40,top: 20,bottom: 20),
                      // padding: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius:8,
                                spreadRadius:1,
                                offset: Offset(4,4)
                            )
                          ],
                          // gradient: LinearGradient(
                          //   begin: Alignment.bottomCenter,
                          //   end: Alignment.topCenter,
                          //   colors: [ConfigDatas.appDarkBlueColor,ConfigDatas.appBlueColor],
                          //   stops: [0,1],
                          // ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        padding:EdgeInsets.all(40),
                        child: Center(
                          child: Scrollbar(
                            radius: Radius.circular(10),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: ConfigDatas.appBlueColor,
                                  size: 40,
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: TextEditingController(text: goals[index].description),
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
                      ),
                    );
                  }
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/home',(Route<dynamic> route) => false, arguments:{'database':widget.database});
        },
        child: Icon(Icons.home),
        backgroundColor: Colors.black.withOpacity(0.8),
        
      ),
    );
  }


}
