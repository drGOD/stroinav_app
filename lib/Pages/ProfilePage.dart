import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_button/sliding_button.dart';

class PageProfile extends StatefulWidget {
  PageProfile(
      {Key key,
      @required this.startStatus,
      this.onWorkStatus,
      @required this.startStatusSOS,
      this.onSOSStatus})
      : super(key: key);

  final VoidCallback onWorkStatus;
  final String startStatus;
  final VoidCallback onSOSStatus;
  final String startStatusSOS;

  @override
  _PageProfileState createState() => _PageProfileState(
      startStatus: startStatus,
      onWorkStatus: onWorkStatus,
      onSOSStatus: onSOSStatus,
      startStatusSOS: startStatusSOS);
}

enum FormSmena { Start, Stop }

class _PageProfileState extends State<PageProfile> {
  _PageProfileState(
      {@required this.startStatus,
      this.onWorkStatus,
      @required this.startStatusSOS,
      this.onSOSStatus});

  final VoidCallback onWorkStatus;
  String startStatus;
  final VoidCallback onSOSStatus;
  String startStatusSOS;

  _ssSmena() async {
    try {
      widget.onWorkStatus();
    } catch (e) {
      print(e);
    }
  }

  _ssSOS() async {
    try {
      widget.onSOSStatus();
    } catch (e) {
      print(e);
    }
  }

  FormSmena _startSmena = FormSmena.Stop;
  FormSmena _startSos = FormSmena.Stop;

  @override
  void initState() {
    //приведение статуса работы стр к статусу приложения
    startStatus == 'Stop'
        ? _startSmena = FormSmena.Stop
        : _startSmena = FormSmena.Start;
    startStatusSOS == 'Stop'
        ? _startSos = FormSmena.Stop
        : _startSos = FormSmena.Start;
    super.initState();
  }

  //смена статуса работы на странице
  void _changeStart() {
    setState(() {
      _startSmena == FormSmena.Start
          ? _startSmena = FormSmena.Stop
          : _startSmena = FormSmena.Start;
    });
  }

  //смена статуса сос на странице
  void _changeSos() {
    setState(() {
      _startSos == FormSmena.Start
          ? _startSos = FormSmena.Stop
          : _startSos = FormSmena.Start;
    });
  }

  double shw;
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFF255781),
        body: _startSos == FormSmena.Stop ? _normalWindow() : _sosWindow());
  }

  Widget _normalWindow() {
    return ListView(
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
                      _qrBlock(),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                          child: Column(children: [
                            _surnameBlock(),
                            _nameBlock(),
                            _typeNumber(),
                            _groupNumber(),
                            _tabelNumber(),
                            _personalNumber()
                          ]))
                    ],
                  ),
                )),
            SizedBox(
              height: 15,
            ),
            _smenaButton(),
            SizedBox(
              height: 15,
            ),
            _sosButton()
          ]),
        ),
      ],
    );
  }

  //экран сос
  Widget _sosWindow() {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      body: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          60,
          20,
          0,
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          new Text('Сигнал SOS',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(
            height: 15,
          ),
          Icon(Icons.warning, color: Colors.red, size: 200.0),
          SizedBox(
            height: 15,
          ),
          _sosButton()
        ]),
      ),
    );
  }

  Widget _sosButton() {
    return Container(
      color: Color(0xFF255781),
      padding: new EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            _ssSOS();
            _changeSos();
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

  Widget _smenaButton() {
    return Container(
      color: Color(0xFF255781),
      padding: new EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            _ssSmena();
            _changeStart();
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
                          _startSmena == FormSmena.Stop
                              ? 'Начать смену'
                              : 'Закончить смену',
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
        )
      ]),
    );
  }

  Widget _personalNumber() {
    return new Row(
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
                        fontWeight: FontWeight.normal,
                        color: Colors.black54)))),
      ],
    );
  }

  Widget _tabelNumber() {
    return new Row(
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
                        fontWeight: FontWeight.normal,
                        color: Colors.black54)))),
      ],
    );
  }

  Widget _groupNumber() {
    return new Row(
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
                        fontWeight: FontWeight.normal,
                        color: Colors.black54)))),
      ],
    );
  }

  Widget _typeNumber() {
    return new Row(
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
                        fontWeight: FontWeight.normal,
                        color: Colors.black54)))),
      ],
    );
  }

  Widget _nameBlock() {
    return new Row(
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
    );
  }

  Widget _surnameBlock() {
    return new RichText(
        text: TextSpan(
            text: 'Иванов',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF255781))));
  }

  Widget _qrBlock() {
    return new QrImage(
      data: 'Иванов Иван Иванович 182186',
      gapless: true,
      size: shw / 1.5,
    );
  }
}
