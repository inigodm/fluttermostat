import 'dart:convert';
import 'dart:io';

import 'package:fluthermostat/pages/GraphPage.dart';
import 'package:fluthermostat/pages/Thermostat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';


class HomePage extends StatefulWidget {
  late String bearer;

  //Constructor
  HomePage(this.bearer, {super.key});

  @override
  _HomePageState createState() => _HomePageState(bearer);
}

class _HomePageState extends State<HomePage> {
  static String baseUrl = Platform.isAndroid
      ? "http://192.168.1.136:8080"
      : "http://localhost:8080";
  late String bearer;
  final List<Widget> _pages = [];
  int _selectedIndex = 0;
  TextEditingController initTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  int desiredTemp = 15;
  List<String> weekDays = [];
  late bool active = true;

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

  _HomePageState(this.bearer) {
    getDesiredValue();
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

  void _onItemTapped(int item) {
    setState(() {
      _selectedIndex = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget schedules = Column(
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
    _pages.clear();
    _pages.add(Thermostat(baseUrl, bearer));
    _pages.add(schedules);
    _pages.add(GraphPage.build());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermostat'),
        automaticallyImplyLeading: false,
      ),
      // El body tiene que tener el array con el indice seleccionado
      body: Center(child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Schedules',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_rounded),
              label: 'Graphs',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
    );
  }
}
