import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stroinav_app/pages/login_signup_page.dart';
import 'package:stroinav_app/services/authentication.dart';
import 'package:connectivity/connectivity.dart';
import 'package:stroinav_app/services/Something.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

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
  String _userId = "";
  String _dogovor = "";
  double shw;

  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _dogovor = user.displayName;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result);
      if (result != ConnectivityResult.none) {
        print('Интернет есть');
        widget.auth.getCurrentUser().then((user) {
          setState(() {
            if (user != null) {
              _userId = user?.uid;
              _dogovor = user.displayName;
            }
            authStatus = user?.uid == null
                ? AuthStatus.NOT_LOGGED_IN
                : AuthStatus.LOGGED_IN;
          });
        });
      } else {
        authStatus = AuthStatus.NO_INTERNET;
      }
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _dogovor = user.displayName;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _dogovor = '';
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
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new TemproryPage(
            userId: _dogovor,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
