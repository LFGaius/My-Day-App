
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';

class HomePage extends StatefulWidget {
  BuildContext get homePageContext {
    return this.pageContext;
  }
  BuildContext pageContext;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.pageContext=context;//we store the context of this widget
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Text('gfdgdf')

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pushNamed(
          //   '/createpublication',
          // );
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: ConfigDatas.appBlueColor,
      ),
    );
  }
}
