import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stroinav_app/pages/login_signup_page.dart';

List<Marker> parseWorkerLocation(String responseBody) {
  final parsed = jsonDecode(responseBody); //.cast<Map<String, dynamic>>();
  /* return parsed
      .map<WorkerLocation>((json) => WorkerLocation.fromJson(json))
      .toList();*/
  /*return parsed.map<WorkerLocation>((json) {
    return Marker(
        width: 40.0,
        height: 40.0,
        point: new LatLng(55.785811, 37.4491582),
        builder: (ctx) => Container(child: Icon(Icons.accessible_forward)));
  });*/
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

enum ConnectMod { TEST, OK, ERR }

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

  double _lat;
  double _lng;

  double _latC;
  double _lngC;

  ConnectMod _connectMode = ConnectMod.TEST;

  Future/*<List<Marker>>*/ fetchWorkerLocation(http.Client client) async {
    final response = await client.get('http://185.5.54.22:1337/users');
    _lat = jsonDecode(response.body)[0]['position']['location']['lat'];
    _lng = jsonDecode(response.body)[0]['position']['location']['lng'];
    _latC = jsonDecode(response.body)[0]['construction']['center']['lat'];
    _lngC = jsonDecode(response.body)[0]['construction']['center']['lng'];
    print('lat ${jsonDecode(response.body)[0]['position']['location']['lat']}');
    setState(() {
      _connectMode = ConnectMod.OK;
    });
    //return compute(parseWorkerLocation, response.body);
    return {_lat, _lng};
  }

  void initState() {
    fetchWorkerLocation(http.Client());
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        fetchWorkerLocation(http.Client());
      });
    });
    //print(fetchWorkerLocation(http.Client()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _connectMode == ConnectMod.OK
            ? _map(_lat, _lng)
            : _showCircularProgress());
  }

  Widget _map(double lat, double lng) {
    return FlutterMap(
        options: new MapOptions(
          center: new LatLng(_latC, _lngC),
          zoom: 15.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png"),
          new MarkerLayerOptions(markers: [
            new Marker(
                width: 40.0,
                height: 40.0,
                point: new LatLng(lat, lng),
                builder: (ctx) =>
                    Container(child: Icon(Icons.accessible_forward))),
          ])
        ]);
  }

  Widget _showCircularProgress() {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF255781)),
    ));
  }
}
