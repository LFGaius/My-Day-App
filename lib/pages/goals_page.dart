
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/principle.dart';
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
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
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
        leading: Icon(
          Icons.arrow_back_ios
        )
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
          Center(
            child:Text(
              'Your Goals',
              style: TextStyle(
                color: ConfigDatas.appBlueColor,
                fontSize: 60,
                fontFamily: 'Freestyle Script Regular',
              ),
            )
          ),
          Container(
            height:MediaQuery.of(context).size.height*0.55,
            // padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                shrinkWrap: true ,
              scrollDirection: Axis.horizontal,
              itemCount: 4,
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
                  child: Center(
                    child: Scrollbar(
                      radius: Radius.circular(10),
                      child: TextField(
                        controller: TextEditingController(text: ' Your Objectives $index'*20),
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
                );
              }
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: ConfigDatas.appDarkBlueColor,
      ),
    );
  }
// var finder = Finder(
//     sortOrders: [SortOrder('title')]);
// var query = store.query(finder: finder);
// var subscription = query.onSnapshots(widget.database).listen((snapshots) {
//   // snapshots always contains the list of records matching the query
//   print('fds $snapshots');
//   // ...
// });
// var finder = Finder(
//     filter: Filter.greaterThan('name', 'cat'),
//     sortOrders: [SortOrder('name')]);

}
