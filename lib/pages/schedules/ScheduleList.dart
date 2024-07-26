import 'package:fluthermostat/Schedule.dart';
import 'package:fluthermostat/pages/schedules/SchedulesItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'listener/ScheduleEvent.dart';
import 'listener/SchedulesSubscriber.dart';

class SchedulesList extends StatefulWidget {
  String bearer;
  String baseUrl;
  SchedulesSubscriber subscriber;

  SchedulesList(this.baseUrl, this.bearer, this.subscriber, {super.key});

  @override
  State<StatefulWidget> createState() => _SchedulesList(bearer, baseUrl, subscriber);

}

class _SchedulesList  extends State<SchedulesList>{
  String bearer;
  String baseUrl;
  SchedulesSubscriber subscriber;
  List<ScheduleItem> items = [];

  _SchedulesList(this.bearer, this.baseUrl, this.subscriber){
   loadSchedules();
   subscriber.subscribeToCreation((event) => {
     loadSchedules()
   });
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
        if (jsonDecode(response.body)["value"] == null) {
          return;
        }
        List results = jsonDecode(response.body)["value"] as List;
        if (results.isNotEmpty) {
          setState(() {
            items = results
                .map((item) =>
                Schedule(
                    item["id"],
                    item["timeFrom"],
                    "L",
                    item["active"],
                    item["minTemp"]))
                .map((schedule) =>
                ScheduleItem(schedule,
                        (schedule) => { subscriber.push(ScheduleSelected(schedule)) },
                        (schedule) => { deleteSchedule }))
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