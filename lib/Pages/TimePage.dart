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

  double shw;
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 45, 10, 5),
                  child: new Column(children: [
                    Container(
                      height: shw / 1.2,
                      width: shw / 1.3,
                      child: Image.asset(
                        'image/Diagramm.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF448ec9),
                                  child: Icon(Icons.directions_walk,
                                      color: Colors.black54),
                                  radius: shw / 20,
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('67/100',
                                          style: TextStyle(
                                            color: Color(0xFF255781),
                                            fontSize: shw / 23,
                                          )),
                                      Text('эффективность',
                                          style: TextStyle(
                                            color: Color(0xFF255781),
                                            fontSize: shw / 28,
                                          )),
                                    ]),
                              ]),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF52cc8d),
                                  child:
                                      Icon(Icons.shop, color: Colors.black54),
                                  radius: shw / 20,
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('63/100',
                                          style: TextStyle(
                                            color: Color(0xFF255781),
                                            fontSize: shw / 23,
                                          )),
                                      Text('безопасность',
                                          style: TextStyle(
                                            color: Color(0xFF255781),
                                            fontSize: shw / 28,
                                          )),
                                    ]),
                              ]),
                        ]),
                    SizedBox(height: 15),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: new Column(children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('ЧТ',
                                          style: TextStyle(
                                            color: Color(0xFF255781),
                                            fontSize: shw / 23,
                                          )),
                                      CircleAvatar(
                                        backgroundColor: Color(0xFF255781),
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
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          'Установки опалубки 2 этажа,3 корпуса',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: shw / 25,
                                          )),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('8:30-14:00',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 25,
                                                )),
                                            SizedBox(width: shw / 3),
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
                                            SizedBox(width: shw / 4),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            fontSize: shw / 25,
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
                                            SizedBox(width: shw / 3),
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
                                            SizedBox(width: shw / 4),
                                            Icon(Icons.beenhere),
                                          ])
                                    ]),
                              ]),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.add_a_photo),
                                    Text('Отчёт о',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: shw / 25,
                                        )),
                                    Text('выполнении работ',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: shw / 25,
                                        )),
                                  ],
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.notification_important),
                                      Text('Проблема',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: shw / 25,
                                          )),
                                    ])
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
