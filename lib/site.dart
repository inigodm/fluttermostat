import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';


class HomePage extends StatefulWidget {
  late String bearer;

  HomePage(String bearer) {
    this.bearer = bearer;
  }

  @override
  _HomePageState createState() => _HomePageState(bearer);
}

class _HomePageState extends State<HomePage> {
  static String baseUrl = Platform.isAndroid
      ? "http://192.168.1.136:8080"
      : "http://localhost:8080";
  late String bearer;
  late int temp;
  final List<Widget> _pages = [];
  int _selectedIndex = 0;
  TextEditingController initTime = TextEditingController();
  TextEditingController endTime = TextEditingController();


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

  _HomePageState(String bearer) {
    this.bearer = bearer;
    this.temp = 22;
    Widget home = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Test text"),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: increase,
              child: Text(
                '+',
                style: TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45),
              ),
            ),
            Text(
                "${temp}",
                style: TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45)),
            TextButton(
              onPressed: decrease,
              child: Text(
                '-',
                style: TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45),
              ),
            ),
          ],
        )
      ],
    );
    Widget schedules = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Expanded(
              child: TextField(
                controller: initTime,
                decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
            children: [Text("Desired temperature"),
              NumberPicker(
              value: 15,
              minValue: 10,
              maxValue: 30,
              onChanged: (value) => setState(() => {}),
            )],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: MultiSelectDialogField(
              title: Text("Select the days in which this task must be enabled"),
              buttonText: Text("Days"),
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

              },
            ),
          ),
      ]
    );
    _pages.add(home);
    _pages.add(schedules);
    _pages.add(Text("Test text"));
  }


  void increase() async {
    final url = Uri.parse("$baseUrl/temperature/increment");
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': this.bearer,
        },
        body: jsonEncode(<String, int> {
          "temperature": 100,
        }));
    if (response.statusCode == 200) {
    } else {
    }
    temp++;
    setState(() {});
  }

  void getDesiredValue() async {
    final url = Uri.parse("$baseUrl/temperature");
    final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': this.bearer,
        });
    if (response.statusCode == 200) {
      print("body ${jsonDecode(response.body)['value']['temp']}");
    } else {
      print("body ${response.toString()}");
      print("body ${response.body}");
    }
    temp++;
    setState(() {});
  }

  void decrease() async {
    final url = Uri.parse("$baseUrl/temperature/decrement");
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': this.bearer,
        },
        body: jsonEncode(<String, int> {
          "temperature": 100,
        }));
    if (response.statusCode == 200) {
      getDesiredValue();
    } else {

    }
    temp--;
    setState(() {});
  }

  void _onItemTapped(int item) {
    setState(() {
      this._selectedIndex = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thermostat'),
        automaticallyImplyLeading: false,
      ),
      // El body tiene que tener el array con el indice seleccionado
      body: Center(child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
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
