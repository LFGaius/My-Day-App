
import 'package:expandable/expandable.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/global_procedures.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:my_day_app/models/goal.dart';
import 'package:my_day_app/models/goal.dart';
import 'package:my_day_app/models/principle.dart';
import 'package:my_day_app/models/taboo.dart';
import 'package:my_day_app/widgets/card_action_list.dart';
import 'package:my_day_app/widgets/tab_bar_view_principles.dart';
import 'package:my_day_app/widgets/tab_bar_view_timeline.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

class BlacklistPage extends StatefulWidget {

  final Database database;


  const BlacklistPage({this.database, Key key}) : super(key: key);

  @override
  BlacklistyPageState createState() => BlacklistyPageState();
}

class BlacklistyPageState extends State<BlacklistPage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  List<Taboo> taboos=[];

  var subscriptionTaboos;
  final ScrollController lvcontroller=ScrollController();

  @override
  void initState() {
    // _controller.addListener(_scrollListener);//the listener for up and down.
    // TODO: implement initState
    super.initState();
    // SharedPreferences.getInstance().then((prefs){
    //   String storiesOpened=prefs.getString('myday_stories_opened')!=null?prefs.getString('myday_stories_opened'):'';
    //   print('${storiesOpened};$widget.date');
    //   if(!storiesOpened.contains(widget.date))
    //     prefs.setString('myday_stories_opened','${storiesOpened};${widget.date}');//to store the dates of stories already opened
    // });

    var store = intMapStoreFactory.store('taboos');
    // print('widget.date '+widget.date);
    // var finder = Finder(
    //     limit: 10,
    //     // filter: Filter.equals('date', '${widget.date}')
    // );
    var query = store.query();
    subscriptionTaboos = query.onSnapshots(widget.database).listen((snapshots) {
      // snapshots always contains the list of records matching the query
      List<Taboo> taboos_temp = snapshots.map((snapshot) {
        var taboo = new Taboo(
            snapshot.key,
            snapshot.value['word']
        );
        return taboo;
      }).toList();
      if(mounted)
        setState(() {
          taboos = taboos_temp;
        });
      else
        taboos = taboos_temp;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    unawaited(subscriptionTaboos?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
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
                    arguments:{'database':widget.database,'startTab':ConfigDatas.storiesTabOrder}
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )
        ),
        backgroundColor: Colors.black87,
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
                padding: const EdgeInsets.only(left:20,right: 20),
                child: Text(
                  'TABOOLIST (${taboos.length})',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Freestyle Script Regular',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height:MediaQuery.of(context).size.height*0.7,
                  // padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      shrinkWrap: true ,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.5,
                        crossAxisCount: 3,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 0.0
                      ),

                      itemCount: taboos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  taboos[index].word,
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                    decorationColor: Colors.black,
                                    fontSize: 40.0,
                                    // fontWeight: FontWeight.bold
                                    fontFamily: 'Freestyle Script Regular',
                                  ),
                                ),
                              ),
                            ),
                            CardActionList(
                              variant: 'taboo',
                              onDelete: () async{
                                var store = intMapStoreFactory.store('taboos');
                                await store.record(taboos[index].id).delete(widget.database);
                              },
                              onEdit: () {
                                _onAlertWithCustomContentPressed(context,'edit',taboos[index]);
                              },
                            ),
                          ],
                        );
                      }
                  ),
                ),
              ),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _onAlertWithCustomContentPressed(context,'create',new Taboo(
                null,
                '',
            ));
          },
          child: Icon(Icons.add,color: Colors.black,),
          backgroundColor: Colors.white,
        ),
      );
  }

  _onAlertWithCustomContentPressed(context,mode,Taboo taboo) {
    TextEditingController tabooWordController = TextEditingController();
    tabooWordController.text = taboo.word;

    Alert(
        context: context,
        style: AlertStyle(
            titleStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize:30,
            )
        ),
        title: mode=='create'?'Add taboo':'Edit taboo',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            TextField(
              controller: tabooWordController,
              minLines: 1,
              maxLines: null,
              readOnly: false,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Word',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: ()  async=>{
              await saveTaboo(
                new Taboo(
                  taboo?.id,
                  tabooWordController.text
                )
              ),
              Navigator.pop(context)
            },
            color: Colors.black,
            width: 100,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
            ),
          )
        ]).show();
  }



  saveTaboo(Taboo taboo) async {
    var store = intMapStoreFactory.store('taboos');
    if(taboo.id==null)
      await widget.database.transaction((txn) async {
        print(taboo.id);
        print('ttt ${taboo.id}');
        await store.add(txn, {
          'word': taboo.word
        });
      });
    else
      await widget.database.transaction((txn) async {
        print(taboo.id);
        print('ttt ${taboo.id}');
        await store.record(taboo.id).update(txn, {
          'word': taboo.word
        });
      });
  }

}
