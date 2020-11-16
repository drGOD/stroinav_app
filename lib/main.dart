import 'package:flutter/material.dart';
import 'package:stroinav_app/pages/login_signup_page.dart';
import 'package:stroinav_app/services/NavBar.dart';
import 'package:stroinav_app/services/root_page.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'stroinav_app',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(), //NavBarPage(), //RootPage(auth: new Auth()),
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
