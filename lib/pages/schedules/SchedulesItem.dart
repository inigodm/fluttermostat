import 'package:fluthermostat/Schedule.dart';
import 'package:flutter/material.dart';

class ScheduleItem extends StatefulWidget {
  final Schedule schedule;
  final Function(Schedule) loadDataCallback;
  final Function(Schedule) deleteCallback;

  const ScheduleItem(this.schedule, this.loadDataCallback, this.deleteCallback, {super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleItem(schedule, loadDataCallback, deleteCallback);
}

class _ScheduleItem  extends State<ScheduleItem>{
  Schedule schedule;
  Function(Schedule) loadDataCallback;
  Function(Schedule) deleteCallback;
  
  _ScheduleItem(this.schedule, this.loadDataCallback, this.deleteCallback);
  
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Checkbox(value: schedule.active, onChanged: (value) => {}),
          GestureDetector(
            child: Text("Days: ${schedule.weekDays} Temp: ${schedule.desiredTemp} Time: ${schedule.timeFrom}" ),
            onTap: () => { loadDataCallback(schedule) },
          ),
          IconButton(onPressed: () => {deleteCallback(schedule)},
              icon: const Icon(Icons.delete_forever))
        ]
    );
  }
  
}