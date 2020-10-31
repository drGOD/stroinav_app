import 'package:flutter/material.dart';
import 'package:stroinav_app/services/authentication.dart';

class PageThree extends StatefulWidget {
  PageThree({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _PageThreeState createState() => _PageThreeState(
        userId: userId,
        auth: auth,
        onSignedOut: onSignedOut,
      );
}

class _PageThreeState extends State<PageThree> {
  _PageThreeState({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
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
          body: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: new Column(children: [
                    Text('Диаграмма',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: shw / 10,
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: new Column(children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('ЧТ',
                                                style: TextStyle(
                                                  color: Color(0xFF255781),
                                                  fontSize: shw / 23,
                                                )),
                                            CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFF255781),
                                              child: Text('15',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: shw / 20,
                                                  )),
                                              radius: shw / 20,
                                            ),
                                            Icon(Icons.notification_important,
                                                color: Colors.amber),
                                          ]),
                                    ]),
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Установки опалубки 2 этажа,3 корпуса',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: shw / 21,
                                          )),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('8:30-14:00',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                            Text('212 УЛБ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                          ]),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Отв: Семенов А.В.',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                            Icon(Icons.beenhere),
                                          ])
                                    ]),
                              ]),
                        ])),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: new Column(children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('ЧТ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: shw / 23,
                                                )),
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Text('15',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: shw / 20,
                                                  )),
                                              radius: shw / 20,
                                            ),
                                            Icon(Icons.notification_important,
                                                color: Colors.white),
                                          ]),
                                    ]),
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Установки опалубки 2 этажа,3 корпуса',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: shw / 21,
                                          )),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('15:00-18:30',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                            Text('205 УЛК',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                          ]),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Отв: Воробьев С.В.',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                            Icon(Icons.beenhere),
                                          ])
                                    ]),
                              ]),
                        ])),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
