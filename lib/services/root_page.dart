import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stroinav_app/services/NavBar.dart';
import 'package:stroinav_app/pages/login_signup_page.dart';

class RootPage extends StatefulWidget {
  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NO_INTERNET,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  //AuthStatus authStatus = AuthStatus.LOGGED_IN;
  String _userId = "";
  String _dogovor = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _counter;
  SharedPreferences prefs;

  Future<void> _incrementCounter(String status) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _counter = prefs.setString("counter", status).then((bool success) {
        return status;
      });
    });
  }

  double shw = 200;
  var s;

  Future someMethod() async {
    s = await _prefs.then((prefs) {
      s = prefs.getString('counter');
      print(prefs.getString('counter'));
      return prefs.getString('counter');
    });
  }

  someMethod2() async {}

  void initState() {
    super.initState();

    someMethod();

    print(s);
    if (_counter == 'LoggedIn') {
      print('LoggedIn');
      authStatus = AuthStatus.LOGGED_IN;
    } else {
      print('fixme ');
      authStatus = AuthStatus.NOT_LOGGED_IN;
    }

    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result);
      if (result != ConnectivityResult.none) {
        print('Интернет есть');
      } else {
        authStatus = AuthStatus.NO_INTERNET;
      }
    });
  }

  void _onLoggedIn() {
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      _incrementCounter('LoggedIn');
      print(_counter);
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _incrementCounter('LoggedOut');
    });
  }

  Widget _buildWaitingScreen() {
    shw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _noInternet() {
    return Scaffold(
      body: Column(children: [
        Center(
          child: Column(
            children: [
              SizedBox(height: shw / 1.75),
              Text('Нет подключения к',
                  style: TextStyle(
                      color: Color(0xFFB92139),
                      fontSize: shw / 15,
                      fontWeight: FontWeight.bold)),
              Text('Интернету',
                  style: TextStyle(
                      color: Color(0xFFB92139),
                      fontSize: shw / 15,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              new Icon(
                Icons.signal_cellular_off,
                size: shw / 4,
                color: Color(0xFFB92139),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NO_INTERNET:
        return _noInternet();
        break;
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        return new NavBarPage(
          //userId: _dogovor,
          onSignedOut: _onSignedOut,
        );
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
