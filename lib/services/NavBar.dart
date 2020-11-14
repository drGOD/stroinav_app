import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:stroinav_app/pages/TimePage.dart';
import 'package:stroinav_app/pages/ProfilePage.dart';
import 'package:stroinav_app/pages/MapPage.dart';
import 'package:stroinav_app/pages/ChatPage.dart';

//import 'package:stroinav_app/services/authentication.dart';

class NavBarPage extends StatefulWidget {
  NavBarPage({Key key, /*this.auth,*/ this.userId, this.onSignedOut})
      : super(key: key);

  //final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  String get count => null;

  @override
  State<StatefulWidget> createState() => new _NavBarPageState(
        userId: userId,
        //auth: auth,
        onSignedOut: onSignedOut,
      );
}

//Статус работы
enum StartStatus { Start, Stop }

class _NavBarPageState extends State<NavBarPage> {
  _NavBarPageState({/*this.auth,*/ this.userId, this.onSignedOut});

  //final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  StartStatus startStatus = StartStatus.Stop;
  String _startStatus = "Stop";

  //смена статуса смены
  void onWorkStatus() {
    setState(() {
      startStatus == StartStatus.Start
          ? {startStatus = StartStatus.Stop, _startStatus = "Stop"}
          : {startStatus = StartStatus.Start, _startStatus = "Start"};
      print('$_startStatus');
      PageProfile(
        onWorkStatus: onWorkStatus,
        startStatus: _startStatus,
      );
    });
  }

  double shw;
  String url;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');
  final Key keyFive = PageStorageKey('pageFive');
  int currentTab = 2;

  PageOne one;
  PageTwo two;
  PageThree four;
  PageProfile three;

  List<Widget> pages;
  Widget currentPage;
  int index = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  Geolocator _geolocator;
  Position _position;

  Timer _everySecond;

  //функция получения координат
  Future<String> getGPS() async {
    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        timeInterval: 30000);
    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _position = position;
      });
    });
    return "Success!";
  }

  @override
  void initState() {
    one = PageOne();
    two = PageTwo();
    three = PageProfile(
      onWorkStatus: onWorkStatus,
      startStatus: _startStatus,
    );
    four = PageThree();

    pages = [one, two, three, four];

    currentPage = three;
    super.initState();

    //геолокация
    getGPS();
    _everySecond = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        startStatus == StartStatus.Start
            ? {
                print(
                    '${_position != null ? _position.latitude.toString() : '0'}'),
                print(
                    '${_position != null ? _position.longitude.toString() : '0'}'),
                postGPSData(
                    '2',
                    '${_position != null ? _position.latitude.toString() : '0'}',
                    '${_position != null ? _position.longitude.toString() : '0'}')
              }
            : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _pageContext(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  //Страница+бар
  Widget _pageContext() {
    return PageStorage(
      child: currentPage == three //fixme убрать одну страницу
          ? currentPage //иссключение верхнего меню
          : Stack(children: [currentPage, _topBar()]),
      bucket: bucket,
    );
  }

  //нижний бар
  Widget _bottomBar() {
    return BottomNavigationBar(
      currentIndex: currentTab,
      onTap: (index) {
        setState(() {
          currentTab = index;
          currentPage = pages[index];
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Чат'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          title: Text("Площадка"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          title: Text('Профиль'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          title: Text('Учет рабочего времени'),
        ),
      ],
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Color(0xFF255781),
      selectedItemColor: Color(0xFB3274ab),
    );
  }

  //верхний бар
  Widget _topBar() {
    return Container(
        height: 80,
        decoration: BoxDecoration(color: Color(0xfffafafa)),
        padding: EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _namePersonal(),
              GestureDetector(
                  onTap: () {
                    //_signOut();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: shw / 4.6,
                    child: Image.asset('image/Logo_100.png', fit: BoxFit.cover),
                  ))
            ]));
  }

  Widget _namePersonal() {
    return new Column(
      children: [
        new Container(
            width: shw / 1.9,
            child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: 'Иванов',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)))),
        new Container(
            width: shw / 1.9,
            child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: 'CCO 3-1',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54)))),
      ],
    );
  }
}

Future postGPSData(String uID, String lat, String lng) async {
  final http.Response response = await http
      .post('http://185.5.54.22:1337/locations', headers: <String, String>{
    'Accept': 'application/json',
  }, body: {
    'uID': '2',
    'location.lat': lat,
    'location.lng': lng
  });
}
