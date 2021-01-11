
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/principle.dart';
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
  List<Activity> activities=[]; //= [new Activity('Activity 1', 'Description activity 1','hobby', '0:12'),new Activity('Activity 2', 'Description activity 2','hobby', '0:12'),new Activity('Activity 3', 'Description activity 3','hobby', '0:12'),new Activity('Activity 4', 'Description activity 4','hobby', '0:12')];
  List<Emergency> emergencies = [new Emergency('Emergency 1', 'Description emergency 1'),new Emergency('Emergency 2', 'Description emergency 2'),new Emergency('Emergency 3', 'Description emergency 3'),new Emergency('Emergency 4', 'Description emergency 4')];
  List<Principle> principles = [new Principle('Principle 1', 'Description principle 1'),new Principle('Principle 2', 'Description principle 2'),new Principle('Principle 3', 'Description principle 3'),new Principle('Principle 4', 'Description principle 4')];
  List<ActivityTypeItem> activitytypes = <ActivityTypeItem>[
    const ActivityTypeItem('Rest',Icon(Icons.airline_seat_flat,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Hobby',Icon(Icons.accessible_forward_outlined,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Study',Icon(Icons.menu_book,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Spiritual',Icon(Icons.accessibility_new,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Professional',Icon(Icons.corporate_fare,color:  Color.fromRGBO(51, 102, 255, 1))),
  ];
  String selectedActivityType;
  var subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var store = intMapStoreFactory.store('activities');
    var finder = Finder(
        sortOrders: [SortOrder('time',true)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      print('fds ${snapshots[0].value}');
      setState(() {
        activities=snapshots.map((snapshot) {
          var act=new Activity(
              snapshot.key,
              snapshot.value['title'],
              snapshot.value['description'],
              snapshot.value['type'],
              snapshot.value['time']);
          return act;
        }).toList();
      });

      // ...
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // cancel subscription. Important! not doing this might lead to
    // memory leaks
    unawaited(subscription?.cancel());
    super.dispose();
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
            Timeline.tileBuilder(
              builder: TimelineTileBuilder.connectedFromStyle(
                contentsAlign: ContentsAlign.alternating,
                oppositeContentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(activities.length==index?'Add activity':activities[index].time),
                ),

                contentsBuilder: (context, index) => activities.length==index?GestureDetector(
                  onTap: ()=>_onAlertWithCustomContentPressed(context,'add_activity'),
                  child: Card(
                    color: ConfigDatas.appBlueColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ):Card(
                  color: Colors.orangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                            getIcon(activities[index].type),
                            color: Colors.white
                        ),
                        Text(
                          activities[index].title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
                indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,
                itemCount: activities.length+1,
              ),
            ),
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
      case 'add_activity':title='Add activity';
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
            ),
            if(variant=='add_activity') SizedBox(height: 40,),
            if(variant=='add_activity') TimePicker(timeController: timeController),
            SizedBox(height: 40,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(variant=='add_activity') Text(
                    'Type',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.black54
                  ),
                ),
                if(variant=='add_activity') StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      hint:  Text("Select type"),
                      value: selectedActivityType,
                      onChanged: (String value) {
                        setState(() {
                          print('----------$value---------');
                          selectedActivityType = value;
                        });
                      },
                      items: activitytypes.map((ActivityTypeItem activitytype) {
                        return  DropdownMenuItem<String>(
                          value: activitytype.name,
                          child: Row(
                            children: <Widget>[
                              activitytype.icon,
                              SizedBox(width: 10,),
                              Text(
                                activitytype.name,
                                style:  TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),


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
      case 'add_activity':print('TIME:${timeController.text} TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      saveActivity(new Activity(
        null,
        titleController.text,
        descriptionController.text,
        selectedActivityType,
        timeController.text
      ));
      break;
      case 'add_principle':print('TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
    };

  }

  saveActivity(Activity activity) async{
    var store = intMapStoreFactory.store('activities');
    await widget.database.transaction((txn) async {
      await store.add(txn, {
        'title': activity.title,
        'description': activity.description,
        'type': activity.type,
        'time': activity.time
      });
    });
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
}
