
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/global_procedures.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:my_day_app/models/activity.dart';
import 'package:my_day_app/models/activity_type_item.dart';
import 'package:my_day_app/models/comment.dart';
import 'package:my_day_app/models/emergency.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

class SettingsPage extends StatefulWidget {

  final Database database;

  const SettingsPage({this.database, Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            backgroundColor: ConfigDatas.appBlueColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headline2,
                )
              ],
            ),
            centerTitle: true,
            leading: TextButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(
                    '/home',
                    arguments:{'database':widget.database,'startTab':0}
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            )
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  onTap: () {

                  },
                  leading: Icon(
                    Icons.account_box_rounded,
                    color: ConfigDatas.appBlueColor,
                  ),
                  title: Text(
                    'Personal infos',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(
                        '/configurealertsound',
                        arguments:{'database':widget.database}
                    );
                  },
                  leading: Icon(
                    Icons.audiotrack,
                    color: ConfigDatas.appBlueColor,
                  ),
                  title: Text(
                      'Configure alert sound',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  onTap: () {

                  },
                  leading: Icon(
                    Icons.delete_forever_sharp,
                    color: ConfigDatas.appBlueColor,
                  ),
                  title: Text(
                    'Clear all my datas',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  onTap: () {

                  },
                  leading: Icon(
                    Icons.sync,
                    color: ConfigDatas.appBlueColor,
                  ),
                  title: Text(
                    'Sync datas',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ]
            ).toList(),
          ),
        )
      );
  }


}
