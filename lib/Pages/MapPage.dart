import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<List<Marker>> fetchWorkerLocation(http.Client client) async {
  final response = await client.get('http://185.5.54.22:1337/users');
  return compute(parseWorkerLocation, response.body);
}

List<Marker> parseWorkerLocation(String responseBody) {
  final parsed = jsonDecode(responseBody);//.cast<Map<String, dynamic>>();
  /* return parsed
      .map<WorkerLocation>((json) => WorkerLocation.fromJson(json))
      .toList();*/
  return parsed.map<WorkerLocation>((json) {
    return Marker(
        width: 40.0,
        height: 40.0,
        point: new LatLng(55.785811, 37.4491582),
        builder: (ctx) => Container(child: Icon(Icons.accessible_forward)));
  });
}

class WorkerLocation {
  final String username;
  final String lat;
  final String lng;

  WorkerLocation({this.username, this.lat, this.lng});

  factory WorkerLocation.fromJson(Map<String, dynamic> json) {
    return WorkerLocation(
      username: json['username'],
      lat: json['location.lat'],
      lng: json['location.lng'],
    );
  }
}

class PageTwo extends StatefulWidget {
  PageTwo({Key key, this.userId, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _PageTwoState(
    userId: userId,
    onSignedOut: onSignedOut,
  );
}

class _PageTwoState extends State<PageTwo> {
  _PageTwoState({this.userId, this.onSignedOut});

  final VoidCallback onSignedOut;
  final String userId;

  void initState() {
    print(fetchWorkerLocation(http.Client()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _map(),
    );
  }

  Widget _map() {
    return FlutterMap(
        options: new MapOptions(
          center: new LatLng(55.785811, 37.4491582),
          zoom: 13.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate:
              "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png" 
          ),
          new MarkerLayerOptions(markers: [
            new Marker(
                width: 40.0,
                height: 40.0,
                point: new LatLng(55.785811, 37.4491582),
                builder: (ctx) =>
                    Container(child: Icon(Icons.accessible_forward))),
          ])
        ]);
  }
}
