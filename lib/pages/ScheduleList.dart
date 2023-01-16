import 'package:fluthermostat/Schedule.dart';
import 'package:fluthermostat/pages/SchedulesItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchedulesList extends StatefulWidget {
  String bearer;
  String baseUrl;

  SchedulesList(this.baseUrl, this.bearer);

  @override
  State<StatefulWidget> createState() => _SchedulesList(bearer, baseUrl);

}

class _SchedulesList  extends State<SchedulesList>{
  String bearer;
  String baseUrl;
  List<ScheduleItem> items = [];

  _SchedulesList(this.bearer, this.baseUrl){
   loadSchedules();
  }

  void deleteSchedule(Schedule schedule) async {
    final url = Uri.parse("$baseUrl/schedule/${schedule.id}");
    final response = await http.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        },);
    if (response.statusCode == 200) {
      loadSchedules();
    }
  }

  void loadSchedules() async {
    final url = Uri.parse("$baseUrl/schedules");
    final response = await http.get(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': bearer,
          });
      if (response.statusCode == 200) {
        List results = jsonDecode(response.body)["value"] as List;
        if (results.isNotEmpty) {
          setState(() {
            items = results
                .map((item) =>
                Schedule(
                    item["id"],
                    item["timeFrom"],
                    item["timeTo"],
                    "L",
                    item["active"],
                    item["minTemp"]))
                .map((schedule) =>
                ScheduleItem(schedule, (schedule) => { }, (schedule) => { deleteSchedule(schedule) }))
                .toList();
          });
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: items
    );
  }

}