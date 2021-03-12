import 'package:flutter/material.dart';


class TimePicker extends StatefulWidget {
  final TextEditingController timeController;
  final bool readOnly;
  final String label;

  const TimePicker({Key key, this.timeController, this.readOnly, this.label}) : super(key: key);
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String _setTime;

  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },

      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = _hour.padLeft(2, '0') + ':' + _minute.padLeft(2, '0');
      widget.timeController.text = _time;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){//The code inside will be executed after build to avoid issue of setState executed before widget built
      if(widget.timeController.text==null) widget.timeController.text = '06:00';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.label,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.caption
              ),
              InkWell(
                onTap: () {
                  if(!widget.readOnly) _selectTime(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                    onSaved: (String val) {
                      _setTime = val;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: widget.timeController,
                    decoration: InputDecoration(
                        disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}