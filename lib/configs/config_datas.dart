import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_day_app/models/activity_type_item.dart';

class ConfigDatas{
  static final Color appBlueColor=Color.fromRGBO(51, 102, 255, 1);
  static final Color appDarkBlueColor=Color.fromRGBO(22, 80, 255, 1);
  static final Color appBlueColorDotDeactivated=Color.fromRGBO(51, 102, 255,0.3);
  static final List<ActivityTypeItem> activitytypes = <ActivityTypeItem>[
    const ActivityTypeItem('Other',Icon(Icons.wysiwyg_sharp,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Rest',Icon(Icons.airline_seat_flat,color:  const Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Hobby',Icon(Icons.accessible_forward_outlined,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Study',Icon(Icons.menu_book,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Spiritual',Icon(Icons.accessibility_new,color:  Color.fromRGBO(51, 102, 255, 1))),
    const ActivityTypeItem('Professional',Icon(Icons.corporate_fare,color:  Color.fromRGBO(51, 102, 255, 1))),
  ];
}