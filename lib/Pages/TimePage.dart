import 'package:flutter/material.dart';

class PageThree extends StatefulWidget {
  PageThree({Key key, this.userId, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String userId;

  @override
  _PageThreeState createState() => _PageThreeState(
        userId: userId,
        onSignedOut: onSignedOut,
      );
}

class _PageThreeState extends State<PageThree> {
  _PageThreeState({this.userId, this.onSignedOut});

  final VoidCallback onSignedOut;
  final String userId;

  var shw;

  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color(0xFF255781),
        body: Stack(children: [
          ListView(children: [
            SizedBox(height: shw / 4.75),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(children: [
                Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints.expand(
                          height: 154,
                          width: 240,
                        ),
                        child: Image.asset('image/Logo_100.png',
                            fit: BoxFit.cover),
                      ),
                      SizedBox(height: shw / 15),
                      Text('Раздел в разработке',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: shw / 15,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: shw / 1.25,
                        height: shw / 15,
                      ),
                      new Icon(
                        Icons.sentiment_dissatisfied,
                        size: shw / 2,
                        color: Colors.black,
                      ),
                      SizedBox(height: shw / 13),
                      Text('Тут пока ничего нет',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: shw / 16,
                          )),
                      SizedBox(height: shw / 10),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ]));
  }
}
