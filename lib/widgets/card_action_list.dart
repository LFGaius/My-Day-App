
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CardActionList extends StatelessWidget {
  final Function onDelete;
  final Function onView;
  final Function onEdit;
  final Function onSwitchFavorite;
  final Function onSwitchAccomplished;
  final String variant;
  final int isFavorite;
  final bool isAccomplished;


  const CardActionList({Key key, this.onDelete, this.onView, this.variant, this.onEdit, this.isFavorite, this.onSwitchFavorite, this.isAccomplished, this.onSwitchAccomplished}) : super(key: key);
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
          onPressed: () {
            onDelete();
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

  @override
  Widget build(BuildContext context) {
    return variant=='goal'?
      Column(
        children: [
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:Colors.black.withOpacity(0.4
                        ),
                        offset: Offset(0,5),
                        blurRadius: 6
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(
                Icons.edit_rounded,
                size: 18,
                color: ConfigDatas.appBlueColor,
              ),
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              _onConfirmDeleteAction(context,'Are you sure you want to delete this element?');
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:Colors.black.withOpacity(0.4),
                        offset: Offset(0,5),
                        blurRadius: 6
                    )
                  ],
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(
                Icons.delete,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: onSwitchFavorite,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:Colors.black.withOpacity(0.4
                        ),
                        offset: Offset(0,5),
                        blurRadius: 6
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(
                isFavorite==1?Icons.favorite:Icons.favorite_border,
                size: 18,
                color: ConfigDatas.appBlueColor,
              ),
            ),
          ),
        ],
      ):
      Row(
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
            onTap: onSwitchAccomplished,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: isAccomplished?Colors.green:Colors.black54,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(
                Icons.check,
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

}