import 'package:flutter/material.dart';

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

  @override
  State<StatefulWidget> createState() => new _NavBarPageState(
        userId: userId,
        //auth: auth,
        onSignedOut: onSignedOut,
      );
}

class _NavBarPageState extends State<NavBarPage> {
  _NavBarPageState({/*this.auth,*/ this.userId, this.onSignedOut});

  //final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  _signOut() async {
    try {
      //await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  List data;
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
  List<Data> dataList;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    one = PageOne(
        /*userId: userId,
      auth: auth,
      onSignedOut: onSignedOut,*/
        );
    two = PageTwo(
        /*userId: userId,
      auth: auth,
      onSignedOut: onSignedOut,*/
        );
    three = PageProfile(
        /*userId: userId,
      auth: auth,
      onSignedOut: onSignedOut,*/
        );
    four = PageThree(
        /*userId: userId,
      auth: auth,
      onSignedOut: onSignedOut,*/
        );

    pages = [one, two, three, four];

    currentPage = three;

    super.initState();
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
                    _signOut();
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

class Data {
  final int id;
  bool expanded;
  final String title;
  Data(this.id, this.expanded, this.title);
}
