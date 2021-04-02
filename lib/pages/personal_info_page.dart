
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfoPage extends StatefulWidget {
  final Database database;

  PersonalInfoPage({Key key, this.database}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ConfigDatas.appBlueColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  translator.translate('personalInfos'),
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            centerTitle: true,
            leading: TextButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(
                    '/settings',
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
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    ''
                ),
              ),
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}