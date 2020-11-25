import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stroinav_app/pages/login_signup_page.dart';
import 'package:hive/hive.dart';

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
  final Set<Polygon> _polygons = {};

  var _lat;
  var _lng;

  var _latC;
  var _lngC;

  var _statusLocate = true;

  var _polygonPoints;

  ConnectMod _connectMode = ConnectMod.TEST;

  Future/*<List<Marker>>*/ fetchWorkerLocation(http.Client client) async {
    var box = await Hive.openBox('authBox');
    final response = await client
        .get('http://185.5.54.22:1337/users?id=${box.get('id')}', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${box.get('jwt')}',
    });

    _lat = jsonDecode(response.body)[0]['position']['location']['lat'];
    _lng = jsonDecode(response.body)[0]['position']['location']['lng'];
    _latC = jsonDecode(response.body)[0]['construction']['center']['lat'];
    _lngC = jsonDecode(response.body)[0]['construction']['center']['lng'];
    _getListOfLatLong(jsonDecode(response.body)[0]['construction']['polygon']);
    setState(() {
      _connectMode = ConnectMod.OK;
    });
    //return compute(parseWorkerLocation, response.body);
    return {_lat, _lng};
  }

  void initState() {
    fetchWorkerLocation(http.Client());
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (_checkIfValidMarker(LatLng(_lat, _lng), _polygonPoints)) {
        setState(() {
          _statusLocate = true;
          print('true');
        });
      } else {
        setState(() {
          _statusLocate = false;
          print('false');
        });
      }
      setState(() {
        fetchWorkerLocation(http.Client());
      });
    });
    //print(fetchWorkerLocation(http.Client()));
    super.initState();
  }

  List<LatLng> _getListOfLatLong(polygonData) {
    List<LatLng> list = [];
    polygonData.forEach((element) {
      var point = element as Map<String, dynamic>;
      list.add(LatLng(point['lat'], point['lng']));
    });
    list.add(list[0]); // Костыль для того чтобы полигон был законченным
    _polygonPoints = list;
    return list;
  }

  bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }
    return ((intersectCount % 2) == 1);
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false;
    }

    double m = (aY - bY) / (aX - bX);
    double bee = (-aX) * m + aY;
    double x = (pY - bee) / m;
    return x > pX;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _connectMode == ConnectMod.OK
            ? _map(_lat, _lng)
            : _showCircularProgress());
  }

  Widget _map(double lat, double lng) {
    return Stack(
      children: [
        FlutterMap(
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
              PolylineLayerOptions(polylines: [
                Polyline(
                  points: _polygonPoints,
                  strokeWidth: 5.0,
                  color: Color(0xFF255781),
                )
              ])
            ]),
        !_statusLocate
            ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.5, 0.8],
              colors: [
                Color(0x40db324d),
                Color(0x70cf2440),
                Color(0x60b92139),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.black87, size: 120.0),
              Text('Предупреждение! Вы покинули стройплощадку будучи на смене!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  )),
          ],),
              )
            : Container()
      ],
    );
  }

  Widget _showCircularProgress() {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF255781)),
    ));
  }
}
