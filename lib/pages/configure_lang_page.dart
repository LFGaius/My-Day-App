
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

class ConfigureLangPage extends StatefulWidget {
  final Database database;

  ConfigureLangPage({Key key, this.database}) : super(key: key);

  @override
  _ConfigureLangPageState createState() => _ConfigureLangPageState();
}

class _ConfigureLangPageState extends State<ConfigureLangPage> {

  AudioCache audioCache;
  AudioPlayer audioPlayer;
  String _valueSelected;

  playSound({name,format}){
    audioCache.play('sounds/$name.$format');
  }
  @override
  void initState(){
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    if(mounted)
      setState(() {
        _valueSelected=translator.currentLanguage;
      });
    else
      _valueSelected=translator.currentLanguage;

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
                  translator.translate('configureAppLang'),
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
                    translator.translate('ChooseTheLangYouWantForMydayApp')
                ),
              ),
              LabeledRadio(
                label: translator.translate('french'),
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: ConfigDatas.appLangs['french-lang'],
                groupValue: _valueSelected,
                onChanged: (String newValue) async{
                  setState(() {
                    _valueSelected = newValue;
                  });
                  setLang(newValue);
                },
              ),
              LabeledRadio(
                label: translator.translate('english'),
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                value: ConfigDatas.appLangs['english-lang'],
                groupValue: _valueSelected,
                onChanged: (String newValue) async{
                  setState(() {
                    _valueSelected = newValue;
                  });
                  setLang(newValue);
                },
              ),
            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  setLang(lang){
    translator.setNewLanguage(
      context,
      newLanguage: lang,
      remember: true,
      restart: true,
    );
  }

}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key key,
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final String groupValue;
  final String value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<String>(
              groupValue: groupValue,
              value: value,
              onChanged: (String newValue) {
                onChanged(value);
              },
            ),
            Text(
                label,
                style: Theme.of(context).textTheme.caption
            ),
          ],
        ),
      ),
    );
  }
}