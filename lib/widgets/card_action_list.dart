
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';

class CardActionList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
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
          onTap: () {},
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