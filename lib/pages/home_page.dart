
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timelines/timelines.dart';

class HomePage extends StatefulWidget {
  BuildContext get homePageContext {
    return this.pageContext;
  }
  BuildContext pageContext;

  @override
  _HomePageState createState() => _HomePageState();
}
class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}


class _HomePageState extends State<HomePage> {
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  int activeTab=0;
  bool dayStarted=false;
  List<String> activities = ['Activity 1','Activity 2','Activity 3','Activity 4'];
  List<Item> activitytypes = <Item>[
    const Item('Rest',Icon(Icons.airline_seat_flat,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const Item('Hobby',Icon(Icons.accessible_forward_outlined,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Study',Icon(Icons.menu_book,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Spiritual',Icon(Icons.accessibility_new,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Professional',Icon(Icons.corporate_fare,color:  Color.fromRGBO(51, 102, 255, 1))),
  ];
  Item selectedActivityType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.pageContext=context;//we store the context of this widget
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
                  child: Text(activities.length==index?'Add activity':'8:12'),
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
                            Icons.airline_seat_individual_suite,
                            color: Colors.white
                        ),
                        Text(
                            activities[index],
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
                itemCount: 6,

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
                            'Read Bible jhjgh jhgj hfghfg gfdgdf',
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
                itemCount: 6,

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
                            'Hard working',
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
            SizedBox(height: 40,),
            TimePicker(timeController: timeController),
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
                    return DropdownButton<Item>(
                      hint:  Text("Select type"),
                      value: selectedActivityType,
                      onChanged: (Item Value) {
                        setState(() {
                          selectedActivityType = Value;
                        });
                      },
                      items: activitytypes.map((Item activitytype) {
                        return  DropdownMenuItem<Item>(
                          value: activitytype,
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
              Navigator.pop(context),
              save(variant)
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

  save(variant){
    switch(variant){
      case 'add_emergency':print('TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
      case 'add_activity':print('TIME:${timeController.text} TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
      case 'add_principle':print('TITLE:${titleController.text} DESCRIPTION:${descriptionController.text}');
      break;
    };

  }
}
