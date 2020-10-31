import 'package:flutter/material.dart';
import 'package:stroinav_app/services/authentication.dart';

class PageOne extends StatefulWidget {
  PageOne({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _PageOneState createState() => _PageOneState(
        userId: userId,
        auth: auth,
        onSignedOut: onSignedOut,
      );
}

class _PageOneState extends State<PageOne> {
  _PageOneState({this.auth, this.userId, this.onSignedOut});

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
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Иванов Иван',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: shw / 18,
                                  )),
                              Text('CO-12-177',
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: shw / 18,
                                  )),
                            ],
                          ),
                        ]),
                  ])),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: new Column(children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://326605.selcdn.ru/03005/iblock/1a2/logo_S_1.png'),
                            radius: shw / 12,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.rss_feed),
                                          Text('Отдел кадров',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: shw / 18,
                                              )),
                                        ]),
                                    Text('18:47',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: shw / 18,
                                        )),
                                  ]),
                              Text('До 23 ноября сотрудники...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: shw / 20,
                                  )),
                            ],
                          ),
                        ]),
                  ])),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: new Column(children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://kbsu.ru/wp-content/uploads/2017/04/atomnaya-elektrostantsiya-20130710_072435.jpg'),
                            radius: shw / 12,
                          ),
                          Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.people),
                                            Text('CO-12-77',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: shw / 18,
                                                )),
                                          ]),
                                      Text('16:01',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: shw / 18,
                                          )),
                                    ]),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Виктор:',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: shw / 18,
                                          )),
                                      Text(
                                        'Завтра заканчиваем...',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: shw / 20,
                                        ),
                                      ),
                                    ])
                              ]),
                        ]),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
