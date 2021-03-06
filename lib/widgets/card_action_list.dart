
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/helpers/popup_functions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CardActionList extends StatelessWidget {
  final Function onDelete;
  final Function onView;
  final Function onEdit;
  final Function onSwitchFavorite;
  final Function onSwitchAccomplished;
  final Function onRestore;
  final String variant;
  final int isFavorite;
  final bool isAccomplished;
  final bool restoreHidden;


  const CardActionList({Key key, this.onDelete, this.onView, this.variant, this.onEdit, this.isFavorite, this.onSwitchFavorite, this.isAccomplished, this.onSwitchAccomplished, this.onRestore, this.restoreHidden}) : super(key: key);

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
              PopupFunctions.onConfirmDeleteAction(context,translator.translate('confirmDeleteQuestion'),onDelete);
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
        mainAxisAlignment:(variant!='taboo' && variant!='storycomment')?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
        children: [
          if(variant!='taboo' && variant!='storycomment') GestureDetector(
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
          if(variant=='taboo' || variant=='storycomment') GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: ConfigDatas.appBlueColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(
                Icons.edit,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          if(variant=='taboo' || variant=='storycomment') SizedBox(width: 15),
          if(variant!='principle' && variant!='taboo' && variant!='storycomment')  GestureDetector(
              onTap: (variant!='story')?onSwitchAccomplished:null,
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
          if(variant=='story' && !restoreHidden)
            GestureDetector(
              onTap: onRestore,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Icon(
                    Icons.restore,
                    size: 15,
                    color: Colors.white,
                ),
              ),
            )
          else if(variant!='story') GestureDetector(
            onTap: () {
              PopupFunctions.onConfirmDeleteAction(context,translator.translate('confirmDeleteQuestion'),onDelete);
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