import 'package:flutter/material.dart';

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

        ),
      ),
    );
  }
}
