import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PageOne extends StatefulWidget {
  PageOne({Key key, this.userId, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String userId;

  @override
  _PageOneState createState() => _PageOneState(
        userId: userId,
        onSignedOut: onSignedOut,
      );
}

class _PageOneState extends State<PageOne> {
  _PageOneState({this.userId, this.onSignedOut});

  final VoidCallback onSignedOut;
  final String userId;

  double shw;
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body:  new FlutterMap(
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
              ])]),
        ),
      ),
    );
  }
}
