
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/principle.dart';
import 'package:my_day_app/widgets/tab_bar_view_timeline.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';

class HomePage extends StatefulWidget {

  final Database database;

  const HomePage({this.database, Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  int activeTab=0;
  bool dayStarted=false;

  List<Emergency> emergencies = [new Emergency('Emergency 1', 'Description emergency 1'),new Emergency('Emergency 2', 'Description emergency 2'),new Emergency('Emergency 3', 'Description emergency 3'),new Emergency('Emergency 4', 'Description emergency 4')];
  List<Principle> principles = [new Principle('Principle 1', 'Description principle 1'),new Principle('Principle 2', 'Description principle 2'),new Principle('Principle 3', 'Description principle 3'),new Principle('Principle 4', 'Description principle 4')];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: ConfigDatas.appBlueColor,
          title: Image.asset(
              'assets/logowhitevariant.png',
            height: 50,
          ),
          centerTitle: true,
          bottom: TabBar(
            onTap: (index) {
              activeTab=index;
              print(index);
            },
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(icon: Icon(Icons.today),text: 'Today',),
              Tab(icon: Icon(Icons.warning_amber_rounded),text: 'Emergencies'),
              Tab(icon: Icon(Icons.rule),text: 'Principles'),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            TabBarViewTimeline(database: widget.database),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: emergencies.length+1,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0
                ),
                itemBuilder: (BuildContext context, int index) {
                  return index==0?GestureDetector(
                    onTap: ()=>_onAlertWithCustomContentPressed(context,'add_emergency'),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color.fromRGBO(255, 102, 51, 1), Color.fromRGBO(255, 153 , 51, 1)]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add_circle,
                              size: 50,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ):Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color.fromRGBO(255, 102, 51, 1), Color.fromRGBO(255, 153 , 51, 1)]
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.warning,
                            size: 35,
                            color: Colors.white,
                          ),
                          Text(
                            emergencies[index-1].title,
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
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: principles.length+1,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0
                ),
                itemBuilder: (BuildContext context, int index) {
                  return index==0?GestureDetector(
                    onTap: ()=>_onAlertWithCustomContentPressed(context,'add_principle'),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Color.fromRGBO(255, 153, 102, 1), Color.fromRGBO(255, 204, 102, 1)]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add_circle,
                              size: 50,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ):Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color.fromRGBO(255, 153, 102, 1), Color.fromRGBO(255, 204, 102, 1)]
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.admin_panel_settings_sharp,
                            size: 35,
                            color: Colors.white,
                          ),
                          Text(
                            principles[index-1].title,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onAlertWithCustomContentPressed(context,variant) {
    String title;
    switch(variant){
      case 'add_emergency':title='Add emergency';
      break;
      case 'add_principle':title='Add principle';
      break;
    }
    Alert(
        context: context,
        style: AlertStyle(
          titleStyle: TextStyle(
            color: ConfigDatas.appBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: 30
          )
        ),
        title: title,
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              save(variant),
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

  save(variant){
    switch(variant){
      case 'add_emergency':print('TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
      case 'add_principle':print('TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
    };
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
