import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:stroinav_app/pages/TimePage.dart';
import 'package:stroinav_app/pages/ProfilePage.dart';
import 'package:stroinav_app/pages/MapPage.dart';
import 'package:stroinav_app/pages/ChatPage.dart';
import 'package:hive/hive.dart';

//Выгрузка на сервер
Future postGPSData(String lat, String lng) async {
  var box = await Hive.openBox('authBox');
  final http.Response response = await http
      .post('https://apistroinav.dic.li/locations', headers: <String, String>{
    'Accept': 'application/json',
    'Authorization': 'Bearer ${box.get('jwt')}',
  }, body: {
    'uID': box.get('id').toString(),
    'location.lat': lat,
    'location.lng': lng
  });
}

Future postGPSDataSOS(String lat, String lng, String type) async {
  var box = await Hive.openBox('authBox');
  final http.Response response = await http
      .post('https://apistroinav.dic.li/sos', headers: <String, String>{
    'Accept': 'application/json',
    'Authorization': 'Bearer ${box.get('jwt')}',
  }, body: {
    'uID': box.get('id').toString(),
    'location.lat': lat,
    'location.lng': lng,
    'type': type,
    'constructionId': box.get('constructionId').toString()
  });
}

Future postStatus(String work, String sos) async {
  var box = await Hive.openBox('authBox');
  final http.Response response = await http.put(
      'https://apistroinav.dic.li/users/${box.get('id').toString()}',
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.get('jwt')}',
      },
      body: {
        'working': work,
        'accident': sos
      });
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key key, this.userId, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String userId;

  String get count => null;

  @override
  State<StatefulWidget> createState() => new _NavBarPageState(
        userId: userId,
        onSignedOut: onSignedOut,
      );
}

//Статус работы
enum StartStatus { Start, Stop }

class _NavBarPageState extends State<NavBarPage> {
  _NavBarPageState({this.userId, this.onSignedOut});

  final VoidCallback onSignedOut;
  final String userId;

  StartStatus startStatus = StartStatus.Stop;
  StartStatus startStatusSOS = StartStatus.Stop;

  String _startStatus;
  String _startStatusSOS;
  bool _isLoading = true;

  var box;

  initStatus() async {
    box = await Hive.openBox('authBox');
    setState(() {
      _startStatus = box.get('startStatus');
      if (_startStatus == 'Start') {
        startStatus = StartStatus.Start;
        print('startStatus == Start');
      } else {
        startStatus = StartStatus.Stop;
        print('startStatus == Stop');
      }
      _startStatusSOS = box.get('startStatusSOS');
      if (_startStatusSOS == 'Start') {
        startStatusSOS = StartStatus.Start;
        print('sos Status == Start');
      } else {
        startStatusSOS = StartStatus.Stop;
        print('sos Status == Stop');
      }
    });
    initStatePage();
    _isLoading = false;
  }

  //смена статуса смены
  void onWorkStatus() {
    setState(() {
      startStatus == StartStatus.Start
          ? {
              startStatus = StartStatus.Stop,
              _startStatus = "Stop",
              box.put('startStatus', "Stop"),
              postStatus("false", "false")
            }
          : {
              startStatus = StartStatus.Start,
              _startStatus = "Start",
              box.put('startStatus', "Start"),
              postStatus('true', "false")
            };
      print('$_startStatus work');
      initStatePage();
      return currentPage = pages[2];
    });
  }

  void onSOSStatus() {
    setState(() {
      startStatusSOS == StartStatus.Start
          ? {
              startStatusSOS = StartStatus.Stop,
              _startStatusSOS = "Stop",
              box.put('startStatusSOS', "Stop"),
              print('$_position'),
              postGPSDataSOS(
                  '${_position != null ? _position.latitude.toString() : '0'}',
                  '${_position != null ? _position.longitude.toString() : '0'}',
                  '1'),
              postStatus(
                  box.get('startStatus') == 'Start' ? 'true' : "false", "false")
            }
          : {
              startStatusSOS = StartStatus.Start,
              _startStatusSOS = "Start",
              box.put('startStatusSOS', "Start"),
              print('$_position'),
              postGPSDataSOS(
                  '${_position != null ? _position.latitude.toString() : '0'}',
                  '${_position != null ? _position.longitude.toString() : '0'}',
                  '3'),
              postStatus(
                  box.get('startStatus') == 'Start' ? 'true' : "false", 'true')
            };
      print('$_startStatusSOS sos');
      initStatePage();
      return currentPage = pages[2];
    });
  }

  //функция получения координат fixme убрать постоянное сканирование
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

  void initStatePage() {
    one = PageOne();
    two = PageTwo();
    three = new PageProfile(
      onWorkStatus: onWorkStatus,
      startStatus: _startStatus,
      onSOSStatus: onSOSStatus,
      startStatusSOS: _startStatusSOS,
    );
    four = PageThree();
    currentPage = three;
    pages = [one, two, three, four];
  }

  @override
  void initState() {
    initStatus();
    //initStatePage();
    //initStatus();
    super.initState();

    //геолокация
    getGPS();
    _everySecond = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        startStatus == StartStatus.Start || startStatusSOS == StartStatus.Start
            ? postGPSData(
                '${_position != null ? _position.latitude.toString() : '0'}',
                '${_position != null ? _position.longitude.toString() : '0'}')
            : null;
      });
    });
  }

//отображение
  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    if (_isLoading == true) {
      return _showCircularProgress();
    } else {
      return Scaffold(
        body: _pageContext(),
        bottomNavigationBar: _bottomBar(),
      );
    }
  }

  //Страница+бар
  Widget _pageContext() {
    return new PageStorage(
      child: currentPage == three //fixme убрать одну страницу
          ? currentPage
          //иссключение верхнего меню
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
                    onSignedOut();
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

  Widget _showCircularProgress() {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF255781)),
    ));
  }
}
