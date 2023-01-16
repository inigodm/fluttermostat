import 'package:fluthermostat/pages/SchedulesForm.dart';
import 'package:flutter/material.dart';

class SchedulesPage extends StatefulWidget {
  String bearer;
  String baseUrl;

  SchedulesPage(this.baseUrl, this.bearer);

  @override
  State<StatefulWidget> createState() => _SchedulesForm(bearer, baseUrl);
}

class _SchedulesForm extends State<SchedulesPage> {
  String bearer;
  String baseUrl;

  _SchedulesForm(this.bearer, this.baseUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SchedulesForm(baseUrl, bearer),
        ]
    );
  }
}
