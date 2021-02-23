
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';

class TabBarViewEmergencies extends StatefulWidget {

  final Database database;

  const TabBarViewEmergencies({Key key, this.database}) : super(key: key);

  @override
  _TabBarViewEmergenciesState createState() => _TabBarViewEmergenciesState();
}

class _TabBarViewEmergenciesState extends State<TabBarViewEmergencies> {

  List<Emergency> emergencies=[];
  var subscription;

  @override
  void initState(){
    super.initState();
    var store = intMapStoreFactory.store('emergencies');
    var finder = Finder(
        sortOrders: [SortOrder('title',true)]);
    var query = store.query(finder: finder);
    subscription = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Emergency> emergencies_temp = snapshots.map((snapshot) {
        var emer = new Emergency(
            snapshot.key,
            snapshot.value['title'],
            snapshot.value['description'],
            snapshot.value['isAccomplished'],
            snapshot.value['date']
        );
        return emer;
      }).toList();
      if(mounted)
        setState(() {
          emergencies = emergencies_temp;
        });
      else
        emergencies = emergencies_temp;
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
        itemCount: emergencies.length+1,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemBuilder: (BuildContext context, int index) {
          print('index: $index');
          return index==0?GestureDetector(
            onTap: ()=>PopupFunctions.onAlertWithCustomContentPressed(context,'create',emergency:new Emergency(
                null,
                '',
                '',
                false,
                'dd-mm-yy'
            ),database:widget.database),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardActionList(
                    onDelete: () async{
                      var store = intMapStoreFactory.store('emergencies');
                      await store.record(emergencies[index-1].id).delete(widget.database);
                    },
                    onSwitchAccomplished: () async{
                      print('isAccomplished ${emergencies[index-1].isAccomplished}');
                      var store = intMapStoreFactory.store('emergencies');
                      await widget.database.transaction((txn) async {
                        await store.record(emergencies[index-1].id).update(txn, {
                          'isAccomplished': !emergencies[index-1].isAccomplished
                        });
                      });
                    },
                    onView: () {
                      PopupFunctions.onAlertWithCustomContentPressed(context,'view',emergency: emergencies[index-1],database:widget.database);
                    },
                    isAccomplished: emergencies[index-1].isAccomplished
                  ),
                  Expanded(
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
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
// var
}