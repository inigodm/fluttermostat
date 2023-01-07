import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                style: TextStyle(color: Colors.black, fontSize: 45),
              ),
            ),
            Text(
                "${temp}",
                style: TextStyle(color: Colors.black, fontSize: 45)),
            TextButton(
              onPressed: decrease,
              child: Text(
                '-',
                style: TextStyle(color: Colors.black, fontSize: 45),
              ),
            ),
          ],
        )
      ],
    );
    Widget graph = Text("Test text");
    _pages.add(home);
    _pages.add(graph);
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
