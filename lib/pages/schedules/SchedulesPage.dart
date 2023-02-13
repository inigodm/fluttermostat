import 'package:flutter/material.dart';

import 'ScheduleList.dart';
import 'SchedulesForm.dart';
import 'listener/SchedulesSubscriber.dart';

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
  SchedulesSubscriber subscriber= SchedulesSubscriber();

  _SchedulesPage(this.bearer, this.baseUrl){
    form = SchedulesForm(baseUrl, bearer, subscriber);
    list = SchedulesList(baseUrl, bearer, subscriber);
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
