import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

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
  Geolocator _geolocator;
  Position _position;

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    updateLocation();

    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _position = position;
      });
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _map(),
      /*Center(
          _qrBlock(),
          child: Text(
              'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
              ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}')),*/
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
              urlTemplate: "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png"//"https://api.mapbox.com/styles/v1/unbrokenknight/ckhgk4unr0z5g19mw3yy7ctdj/wmts?access_token=pk.eyJ1IjoidW5icm9rZW5rbmlnaHQiLCJhIjoiY2toZ2gxZXBjMHpiMjM1bDZ2aGxxMjFpeCJ9.l_g8F2SX1h-xdlCEATV-ew",
            /*additionalOptions: {
              'accessToken': 'pk.eyJ1IjoidW5icm9rZW5rbmlnaHQiLCJhIjoiY2toZ2gxZXBjMHpiMjM1bDZ2aGxxMjFpeCJ9.l_g8F2SX1h-xdlCEATV-ew',
              'id': 'mapbox.mapbox-streets-v8',
            },*/
          ),
          new MarkerLayerOptions(
              markers: [
                new Marker(
                    width: 40.0,
                    height: 40.0,
                    point: new LatLng(55.785811, 37.4491582),
                    builder: (ctx) => new Container(child: new FlutterLogo()))
              ])]);
  }

}
