import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PageFour extends StatefulWidget {
  PageFour({Key key, this.userId, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String userId;

  @override
  _PageFourState createState() => _PageFourState(
        userId: userId,
        onSignedOut: onSignedOut,
      );
}

enum FormMode { Start, Stop }

class _PageFourState extends State<PageFour> {
  _PageFourState({this.userId, this.onSignedOut});

  final VoidCallback onSignedOut;
  final String userId;
  FormMode _start = FormMode.Start;

  void _changeStart() {
    setState(() {
      _start == FormMode.Start
          ? _start = FormMode.Stop
          : _start = FormMode.Start;
    });
  }

  double shw;
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF255781),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(children: [
                Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          QrImage(
                            data: 'Иванов Иван Иванович 182186',
                            gapless: true,
                            size: shw / 1.5,
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                              child: Column(children: [
                                RichText(
                                    text: TextSpan(
                                        text: 'Иванов',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF255781)))),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                        child: RichText(
                                            textAlign: TextAlign.center,
                                            // overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: "Иван Иванович",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black)))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                            text: "Класс: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.clip,
                                            text: TextSpan(
                                                text: 'CO',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54)))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                            text: "Отряд: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.clip,
                                            text: TextSpan(
                                                text: '12',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54)))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                            text: "Табель: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: '177',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54)))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                            text: "Личный номер: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    Expanded(
                                        child: RichText(
                                            overflow: TextOverflow.fade,
                                            text: TextSpan(
                                                text: '182186',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54)))),
                                  ],
                                ),
                              ]))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Color(0xFF255781),
                  padding: new EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        _changeStart();
                        print(_start);
                      },
                      child: new Container(
                        padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        child: new Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: new EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 10.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF255781),
                                    borderRadius: BorderRadius.all(
                                      const Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Container(
                                      padding: new EdgeInsets.all(2.0),
                                      color: Color(0xFF255781),
                                      child: _smenaButton()),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 15,
                ),
                _sosButton()
              ]),
            ),
          ],
        ));
  }

  Widget _smenaButton() {
    return new Text(
      _start == FormMode.Start ? 'Начать смену' : 'Закончить смену',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _sosButton() {
    return Container(
      color: Color(0xFF255781),
      padding: new EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
      child: Column(children: [
        GestureDetector(
          onTap: () {},
          child: new Container(
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                const Radius.circular(20.0),
              ),
            ),
            child: new Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF255781),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                      child: Container(
                        padding: new EdgeInsets.all(2.0),
                        color: Color(0xFF255781),
                        child: new Text(
                          'SOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
