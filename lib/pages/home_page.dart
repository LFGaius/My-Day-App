
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  int activeTab=0;
  bool dayStarted=false;
  List<String> activities = ['Activity 1','Activity 2','Activity 3','Activity 4'];
  List<Item> users = <Item>[
    const Item('Rest',Icon(Icons.airline_seat_flat,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const Item('Hobby',Icon(Icons.accessible_forward_outlined,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Study',Icon(Icons.menu_book,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Spiritual',Icon(Icons.accessibility_new,color:  Color.fromRGBO(51, 102, 255, 1))),
    const Item('Professional',Icon(Icons.corporate_fare,color:  Color.fromRGBO(51, 102, 255, 1))),
  ];
  Item selectedUser;
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
                  onTap: ()=>_onAlertWithCustomContentPressed(context),
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
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        style: AlertStyle(
          titleStyle: TextStyle(
            color: ConfigDatas.appBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: 30
          )
        ),
        title: "New Activity",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              minLines: 4,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 40,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    'Type',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.black54
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<Item>(
                      hint:  Text("Select type"),
                      value: selectedUser,
                      onChanged: (Item Value) {
                        setState(() {
                          selectedUser = Value;
                        });
                      },
                      items: users.map((Item user) {
                        return  DropdownMenuItem<Item>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              user.icon,
                              SizedBox(width: 10,),
                              Text(
                                user.name,
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
            onPressed: () => Navigator.pop(context),
            color: ConfigDatas.appBlueColor,
            width: 100,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
            ),
          )
        ]).show();
  }



}
