import 'package:flutter/material.dart';

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

  double shw;
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(),
      ),
    );
  }
}
