import 'dart:io';

import 'package:fluthermostat/pages/GraphPage.dart';
import 'package:fluthermostat/pages/SchedulesPage.dart';
import 'package:fluthermostat/pages/Thermostat.dart';
import 'package:flutter/material.dart';

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

  _HomePageState(this.bearer);

  void _onItemTapped(int item) {
    setState(() {
      _selectedIndex = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages.clear();
    _pages.add(Thermostat(baseUrl, bearer));
    _pages.add(SchedulesPage(baseUrl, bearer));
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
