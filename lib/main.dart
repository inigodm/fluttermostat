import 'dart:io';

import 'package:fluthermostat/site.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.loadData();
  runApp(const MyApp());
}

class Preferences {
  static late String bearer = '';
  static late String userId = '';
  static late String role = '';
  static String baseUrl = Platform.isAndroid
      ? "http://127.0.0.1:8080"
      : "http://127.0.0.1:8080";


  static setBearer(String bearer) async {
    Preferences.bearer = bearer;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("bearer", Preferences.bearer);
  }

  static setUserId(String userId) async {
    Preferences.userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", Preferences.userId);
  }

  static setRole(String role) async {
    Preferences.role = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", Preferences.role);
  }

  static String getBearer() {
    if (Preferences.bearer.isEmpty) {
      loadData();
    }
    return Preferences.bearer;
  }

  static String getUserId() {
    if (Preferences.userId.isEmpty) {
      loadData();
    }
    return Preferences.userId;
  }

  static String getRole() {
    if (Preferences.role.isEmpty) {
      loadData();
    }
    return Preferences.role;
  }

  static Future<String> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    Preferences.bearer = prefs.getString("bearer") ?? "";
    Preferences.userId = prefs.getString("userId") ?? "";
    Preferences.role = prefs.getString("role") ?? "";
    return "ok";
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Preferences.getBearer().isNotEmpty && Preferences.getUserId().isNotEmpty) {
      return MaterialApp(
        title: 'Fluthermostat',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      );
    }
    return MaterialApp(
      title: 'Fluthermostat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Login(title: 'Fluttermostat Login'),
    );
  }
}

