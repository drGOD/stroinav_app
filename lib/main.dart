import 'package:flutter/material.dart';

import 'package:stroinav_app/services/NavBar.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'stroinav_app',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new NavBarPage(), //RootPage(auth: new Auth()),
        routes: {
          '/Something': (BuildContext context) => NavBarPage(),
        });
  }
}

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {'/': (BuildContext context) => MainScreen()}));
}
