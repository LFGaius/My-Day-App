
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
import 'package:my_day_app/widgets/tab_bar_view_stories.dart';
import 'package:my_day_app/widgets/tab_bar_view_timeline.dart';
import 'package:my_day_app/widgets/time_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';
import 'package:timelines/timelines.dart';

class HomePage extends StatefulWidget {

  final Database database;
  final int startTab;

  const HomePage({this.database, Key key, this.startTab}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();
  int activeTab;
  @override
  void initState() {
    // TODO: implement initState
    activeTab=widget.startTab!=null?widget.startTab:0;
    print('activeTab  $activeTab');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: activeTab,
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
              Tab(icon: Icon(Icons.history_edu_sharp),text: 'Stories'),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            TabBarViewTimeline(database: widget.database),
            TabBarViewEmergencies(database: widget.database),
            TabBarViewPrinciples(database: widget.database),
            TabBarViewStories(database: widget.database),
          ],
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              bottom: 80,
              right: 0,
              child: FloatingActionButton(
                heroTag: 'blacklist',
                backgroundColor:Colors.black87,
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                      '/blacklist',
                      arguments:{'database':widget.database}
                  );
                },
                child: Icon(
                    Icons.list,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              child: FloatingActionButton(
                heroTag: 'goals',
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                      '/goals',
                      arguments:{'database':widget.database}
                  );
                },
                child: Icon(Icons.album_outlined),
                backgroundColor: Colors.blue.withOpacity(0.8),
              )
            )
          ],
        )
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
