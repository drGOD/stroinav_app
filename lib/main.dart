import 'package:flutter/material.dart';

import 'services/authentication.dart';
import 'pages/root_page.dart';
import 'package:stroinav_app/pages/TimePage.dart';
import 'package:stroinav_app/services/Something.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'stroinav_app',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()),
        routes: {
          '/Something': (BuildContext context) => TemproryPage(),
          '/R': (BuildContext context) => PageThree(),
        });
  }
}

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {'/': (BuildContext context) => MainScreen()}));
}
