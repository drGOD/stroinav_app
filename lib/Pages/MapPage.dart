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

  var points = <LatLng>[
    LatLng(55.858030, 37.687791),
    LatLng(55.857974, 37.687857),
    LatLng(55.857686, 37.687268),
    LatLng(55.857651, 37.687310),
    LatLng(55.857564, 37.687134),
    LatLng(55.857489, 37.687223),
    LatLng(55.857377, 37.686968),
    LatLng(55.857006, 37.687696),
    LatLng(55.857075, 37.687870),
    LatLng(55.856972, 37.688035),
    LatLng(55.856999, 37.688087),
    LatLng(55.856477, 37.688879),
    LatLng(55.856431, 37.689398),
    LatLng(55.856081, 37.689925),
    LatLng(55.856124, 37.691205),
    LatLng(55.856562, 37.692372),
    LatLng(55.855691, 37.693728),
    LatLng(55.856378, 37.695226),
    LatLng(55.857012, 37.694293),
    LatLng(55.857715, 37.695463),
    LatLng(55.858183, 37.695016),
    LatLng(55.858437, 37.695567),
    LatLng(55.859514, 37.693742),
    LatLng(55.859430, 37.693563),
    LatLng(55.859600, 37.693300),
    LatLng(55.859623, 37.693358),
    LatLng(55.860237, 37.692153),
    LatLng(55.858030, 37.687791),
  ];

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
                    Container(child: Icon(Icons.directions_walk))),
          ]),
          PolylineLayerOptions(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 5.0,
                  color: Color(0xFF255781),
                )
              ]
          )
        ]);
  }

  Widget _showCircularProgress() {
    return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF255781)),
        ));
  }
}
