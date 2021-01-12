
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CardActionList extends StatelessWidget {
  final Function onDelete;
  final Function onView;


  const CardActionList({Key key, this.onDelete, this.onView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onView,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: ConfigDatas.appBlueColor,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(
              Icons.list,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _onConfirmDeleteAction(context,'Are you sure you want to delete this element?');
          },
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Icon(
              Icons.delete,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _onConfirmDeleteAction(context,message) {
    Alert(
      context: context,
      style: AlertStyle(
          titleStyle: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 30
          )
      ),
      type: AlertType.warning,
      title: "Warning",
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async{
            await onDelete();
            Navigator.pop(context);
          },
          color: Colors.redAccent
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: ConfigDatas.appBlueColor,
        )
      ],
    ).show();
  }

}