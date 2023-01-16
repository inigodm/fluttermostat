import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;

class SchedulesForm extends StatefulWidget {
  String bearer;
  String baseUrl;

  SchedulesForm(this.baseUrl, this.bearer);

  @override
  State<StatefulWidget> createState() => _SchedulesForm(bearer, baseUrl);

}

class _SchedulesForm  extends State<SchedulesForm>{
  String bearer;
  String baseUrl;

  TextEditingController initTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  int desiredTemp = 15;
  List<String> weekDays = [];
  late bool active = true;

  _SchedulesForm(this.bearer, this.baseUrl);

  Future displayTimePicker(BuildContext context, TextEditingController control) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );

    if (time != null) {
      setState(() {
        control.text = "${time.hour}:${time.minute}";
      });
    }
  }

  void sendSchedule() async {
    final url = Uri.parse("$baseUrl/schedule");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        },
        body: jsonEncode( {
          "dateFrom": "2022-01-02",
          "dateTo": "2022-03-02",
          "timeFrom": initTime.text,
          "timeTo": endTime.text,
          "active": active,
          "minTemp": desiredTemp,
          "weekDays": weekDays
        }));
    if (response.statusCode == 200) {
      print("OK response");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Expanded(
                child: TextField(
                  controller: initTime,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start time',
                      hintText: 'Select start time'
                  ),
                  onTap: () => displayTimePicker(context, initTime),
                ),
              )]
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Expanded(
                child: TextField(
                  controller: endTime,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'End time',
                      hintText: 'Select end time'
                  ),
                  onTap: () => displayTimePicker(context, endTime),
                ),
              )]
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [const Text("Desired temperature"),
              NumberPicker(
                value: desiredTemp,
                minValue: 10,
                maxValue: 30,
                onChanged: (value) => setState(() => {
                  desiredTemp = value
                }),
              )],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: MultiSelectDialogField(
              title: const Text("Select the days in which this task must be enabled"),
              buttonText: const Text("Days"),
              items: [MultiSelectItem("L", "Monday"),
                MultiSelectItem("M", "Tuesday"),
                MultiSelectItem("X", "Thursday"),
                MultiSelectItem("J", "Wednesday"),
                MultiSelectItem("V", "Friday"),
                MultiSelectItem("S", "Saturday"),
                MultiSelectItem("D", "Sunday"),
              ],
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                weekDays = values;
              },
            ),
          ),
          CheckboxListTile(
            title: Text("Active"),
            value: active,
            onChanged: (newValue) {
              setState(() {
                active = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: sendSchedule,
              child: const Text(
                'Accept',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ]
    );
  }

}