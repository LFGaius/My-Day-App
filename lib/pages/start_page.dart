
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),() async{
      SharedPreferences prefs=await SharedPreferences.getInstance();
      if(prefs.getBool('fun_already_opened')==null){//first time connection
        prefs.setBool('fun_already_opened',true);
        Navigator.of(context).popAndPushNamed(
          '/onboarding',
        );
      }else
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                    "assets/logo.png",
                    width: MediaQuery.of(context).size.height*0.25
                ),
              ],
            ),
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}