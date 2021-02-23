import 'package:flutter/material.dart';
import 'package:my_day_app/configs/config_datas.dart';
import 'package:my_day_app/models/emergency.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sembast/sembast.dart';

class PopupFunctions{
  static onAlertWithCustomContentPressed(context,mode,{Emergency emergency,database}) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    titleController.text = emergency?.title;
    descriptionController.text = emergency?.description;
    Alert(
        context: context,
        style: AlertStyle(
            titleStyle: TextStyle(
              color: ConfigDatas.appBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: mode!='view'?30:0,
            )
        ),
        title: mode!='view'?(mode=='create'?'Add emergency':'Edit emergency'):'',
        closeIcon: Icon(Icons.close_outlined,color: ConfigDatas.appBlueColor),
        content: Column(
          children: <Widget>[
            if(mode=='view') GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onAlertWithCustomContentPressed(context,'edit',emergency: emergency,database: database);
              },
              child: Container(
                width: 80,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: ConfigDatas.appBlueColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit,color: Colors.white),
                    Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextField(
              controller: titleController,
              readOnly: mode=='view',
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              minLines: 4,
              maxLines: null,
              readOnly: mode=='view',
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
        buttons: [
          if(mode!='view') DialogButton(
            onPressed: () async{
              DateTime _now=DateTime.now();
              await saveEmergency(new Emergency(
                  emergency?.id,
                  titleController.text,
                  descriptionController.text,
                  emergency.isAccomplished,
                  '${_now.day}-${_now.month}-${_now.year}'
              ),database);
              Navigator.pop(context);
            },
            color: ConfigDatas.appBlueColor,
            width: 100,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
            ),
          )
        ]).show();
  }

  static saveEmergency(Emergency emergency,database) async {
    var store = intMapStoreFactory.store('emergencies');
    if(emergency.id==null)
      await database.transaction((txn) async {
        print(emergency.id);
        print('ttt ${emergency.id}');
        await store.add(txn, {
          'title': emergency.title,
          'description': emergency.description,
          'isAccomplished':false,
          'date': emergency.date
        });
      });
    else
      await database.transaction((txn) async {
        print(emergency.id);
        print('ttt ${emergency.id}');
        await store.record(emergency.id).update(txn, {
          'title': emergency.title,
          'description': emergency.description,
          'isAccomplished':emergency.isAccomplished,
          'date': emergency.date
        });
      });
  }
}