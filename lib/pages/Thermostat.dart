import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Thermostat extends StatefulWidget {
  String bearer;
  String baseUrl;

  Thermostat(this.baseUrl, this.bearer);

  @override
  State<StatefulWidget> createState() => _ThermostatPage(bearer, baseUrl);

}

class _ThermostatPage  extends State<Thermostat>{
  String bearer;
  String baseUrl;
  int temp = 10;
  String roomTemp = "0.00";

  _ThermostatPage(this.bearer, this.baseUrl){
    getDesiredValue();
    getRoomTemperatureValue();
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => getRoomTemperatureValue());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void getDesiredValue() async {
    final url = Uri.parse("$baseUrl/temperature");
    final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        });
    setState(() {
      if (response.statusCode == 200) {
        temp = (jsonDecode(response.body)['value']['temp']/100).round();
      }
    });
  }

  void increase() async {
    final url = Uri.parse("$baseUrl/temperature/increment");
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        },
        body: jsonEncode(<String, int> {
          "temperature": 100,
        }));
    if (response.statusCode == 200) {
      getDesiredValue();
      setState(() {
        temp++;
      });
    }
  }

  void decrease() async {
    final url = Uri.parse("$baseUrl/temperature/decrement");
    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        },
        body: jsonEncode(<String, int> {
          "temperature": 100,
        }));
    if (response.statusCode == 200) {
      getDesiredValue();
      setState(() {
        temp--;
      });
    }
  }

  void getRoomTemperatureValue() async {
    final url = Uri.parse("$baseUrl/room-temperature");
    final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearer,
        });
    setState(() {
      if (response.statusCode == 200) {
        roomTemp = jsonDecode(response.body)['value']['temp'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Temp: ${roomTemp}C",
            style: TextStyle(color: Colors.black, fontFamily: 'Digital'),),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: increase,
              child: const Text(
                '+',
                style: TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45),
              ),
            ),
            Text(
                "$temp",
                key: const Key("textKey"),
                style: const TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45)),
            TextButton(
              onPressed: decrease,
              child: const Text(
                '-',
                style: TextStyle(color: Colors.black, fontFamily: 'Digital', fontSize: 45),
              ),
            ),
          ],
        )
      ],
    );
  }
}