import 'package:fluthermostat/pages/SchedulesForm.dart';
import 'package:flutter/material.dart';

import 'ScheduleList.dart';

class SchedulesPage extends StatefulWidget {
  String bearer;
  String baseUrl;

  SchedulesPage(this.baseUrl, this.bearer);

  @override
  State<StatefulWidget> createState() => _SchedulesPage(bearer, baseUrl);
}

class _SchedulesPage extends State<SchedulesPage> {
  String bearer;
  String baseUrl;
  late SchedulesForm form;
  late SchedulesList list;

  _SchedulesPage(this.bearer, this.baseUrl){
    form = SchedulesForm(baseUrl, bearer);
    list = SchedulesList(baseUrl, bearer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          form,
          Expanded(
            child: list
          )
        ]
    );
  }
}
