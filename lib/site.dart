import 'dart:io';

import 'package:fluthermostat/main.dart';
import 'package:fluthermostat/pages/GraphPage.dart';
import 'package:fluthermostat/pages/MapPage.dart';
import 'package:fluthermostat/pages/schedules/SchedulesPage.dart';
import 'package:fluthermostat/pages/Thermostat.dart';
import 'package:fluthermostat/pages/FileUploadService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'location_task.dart';

class HomePage extends StatefulWidget {

  //Constructor
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [];
  int _selectedIndex = 0;

  _HomePageState();

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel',
        channelName: 'Servicio de Rastreo de Ubicación',
        channelDescription: 'Este servicio permite rastrear la ubicación cada 2 segundos',
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(2000),
      ),
      iosNotificationOptions: IOSNotificationOptions(),
    );
    startBackgroundTask();
  }

  void _onItemTapped(int item) {
    setState(() {
      _selectedIndex = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages.clear();
    _pages.add(Thermostat());
    _pages.add(SchedulesPage());
    _pages.add(GraphPage.build());
    _pages.add(FileUploadScreen());
    var buttons = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedules'),
      BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Graphs'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Tickets'),
    ];
    if (Preferences.getRole() == 'ADMIN') {
      _pages.add(MapPage());
      buttons.add(BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thermostat'),
        automaticallyImplyLeading: false,
      ),
      // El body tiene que tener el array con el indice seleccionado
      body: Center(child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: List.unmodifiable(buttons),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
    );
  }
}
