import 'dart:convert';

import 'package:fluthermostat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MapPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  List<Point> points = List.empty();
  List<Marker> _markers = [];
  _MapPage(){
  }

  @override
  void initState() {
    super.initState();
    obtainLastLocationFor(Preferences.userId);
  }



  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Mapa de OpenStreetMap')),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(37.4228, -122.0860), // Ajusta las coordenadas según tus necesidades
            zoom: 1.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _markers,
            ),
          ],
        ),
      );
  }

  void getMarkers() {
    final markers = points.map((point) => {
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(point.latitude, point.longitude), // Inserta aquí tu latitud y longitud
        builder: (ctx) => Container(
        child: Icon(Icons.location_on, color: Colors.red, size: 40),
        ))
    }).toList(growable: false);
    // Actualiza el estado
    setState(() {
      _markers = markers.cast<Marker>();
    });
  }

  void obtainLastLocationFor(String userID) async {
    final url = Uri.parse("${Preferences.baseUrl}/geolocation");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Preferences.bearer,
        },
        body: jsonEncode(<String, List<Map<String, String>>> {
          "filters": [{"field": "user_id", "option": " = ", "value": userID}],
        }));
    setState(() {
      if (response.statusCode == 200) {
        List<Map<String, String>> res = jsonDecode(response.body);
        res.map((it) => {
          Point(
              it["userId"]!,
              double.parse(it["latitude"]!),
              double.parse(it["longitude"]!),
              "username")
        }).toList();
      }
    });
    getMarkers();
  }
}

class Point {
  String userId = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String username = "";

  Point(this.userId, this.latitude, this.longitude, this.username);

}
