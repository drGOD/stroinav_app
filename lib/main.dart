import 'package:flutter/material.dart';
import 'package:stroinav_app/Pages/ChatPage.dart';
import 'package:stroinav_app/Pages/MapPage.dart';
import 'package:stroinav_app/Pages/TimePage.dart';
import 'package:stroinav_app/Pages/ProfilePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');
  int currentTab = 0;

  PageOne one;
  PageTwo two;
  PageThree three;
  PageFour four;
  List<Widget> pages;
  Widget currentPage;

  List<Data> dataList;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    one = PageOne(
      key: keyOne,
    );
    two = PageTwo(
      key: keyTwo,
    );
    three = PageThree(
      key: keyThree,
    );
    four = PageFour(
      key: keyFour,
    );

    pages = [one, two, three, four];

    currentPage = one;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFF255781),
        selectedItemColor: Color(0xFB3274ab),
        backgroundColor: Color(0xFB474a48),
        currentIndex: currentTab,
        onTap: (int index) {
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
            icon: Icon(Icons.timer),
            title: Text('Учет рабочего времени'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            title: Text('Профиль'),
          ),
        ],
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}

class Data {
  final int id;
  bool expanded;
  final String title;
  Data(this.id, this.expanded, this.title);
}
