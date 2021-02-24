
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/principle.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';

class TabBarViewPrinciples extends StatefulWidget {

  final Database database;

  const TabBarViewPrinciples({Key key, this.database}) : super(key: key);

  @override
  _TabBarViewPrinciplesState createState() => _TabBarViewPrinciplesState();
}

class _TabBarViewPrinciplesState extends State<TabBarViewPrinciples> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Principle> principles=[];
  var subscription;

  @override
  void initState(){
    super.initState();
    var store = intMapStoreFactory.store('principles');
    var finder = Finder(
        sortOrders: [SortOrder('title',true)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Principle> principles_temp = snapshots.map((snapshot) {
        var emer = new Principle(
            snapshot.key,
            snapshot.value['title'],
            snapshot.value['description']);
        return emer;
      }).toList();
      if(mounted)
        setState(() {
          principles = principles_temp;
        });
      else
        principles = principles_temp;
    });
  }

  @override
  void dispose() {
    unawaited(subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: principles.length+1,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemBuilder: (BuildContext context, int index) {
          print('index: $index');
          return index==0?GestureDetector(
            onTap: ()=>PopupFunctions.onAlertWithCustomContentPressed(context,'create','principle',element:new Principle(
                null,
                '',
                ''
            ),database: widget.database),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color.fromRGBO(255, 153 , 51, 1),Colors.orange]
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
                    colors: [Color.fromRGBO(255, 153 , 51, 1),Colors.orange ]
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardActionList(
                    onDelete: () async{
                      var store = intMapStoreFactory.store('principles');
                      await store.record(principles[index-1].id).delete(widget.database);
                    },
                    onView: () {
                      PopupFunctions.onAlertWithCustomContentPressed(context,'view','principle',element:principles[index-1],database:widget.database);
                    },
                    variant: 'principle',
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
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
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _onAlertWithCustomContentPressed(context,mode,{Principle principle}) {
    if(principle!=null) {
      titleController.text = principle.title;
      descriptionController.text = principle.description;
    }
    Alert(
        context: context,
        style: AlertStyle(
            titleStyle: TextStyle(
              color: ConfigDatas.appBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: mode!='view'?30:0,
            )
        ),
        title: mode!='view'?(mode=='create'?'Add principle':'Edit principle'):'',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            if(mode=='view') GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _onAlertWithCustomContentPressed(context,'edit',principle: principle);
              },
              child: Container(
                width: 80,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ConfigDatas.appBlueColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit,color: Colors.white),
                    Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextField(
              controller: titleController,
              readOnly: mode=='view',
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              minLines: 4,
              maxLines: null,
              readOnly: mode=='view',
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        buttons: [
          if(mode!='view') DialogButton(
            onPressed: ()  async=>{
              await savePrinciple(new Principle(
                  principle?.id,
                  titleController.text,
                  descriptionController.text
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

  savePrinciple(Principle principle) async {
    var store = intMapStoreFactory.store('principles');
    if(principle.id==null)
      await widget.database.transaction((txn) async {
        print(principle.id);
        print('ttt ${principle.id}');
        await store.add(txn, {
          'title': principle.title,
          'description': principle.description
        });
      });
    else
      await widget.database.transaction((txn) async {
        print(principle.id);
        print('ttt ${principle.id}');
        await store.record(principle.id).update(txn, {
          'title': principle.title,
          'description': principle.description
        });
      });
  }
// var
}