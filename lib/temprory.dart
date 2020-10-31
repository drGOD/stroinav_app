import 'package:flutter/material.dart';
import 'package:stroinav_app/services/authentication.dart';

class TemproryPage extends StatefulWidget {
  TemproryPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('$this.userId'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: Center(
          child: Column(
        children: [
          RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/R');
              },
              child: Text('Открыть окно просмотра проектов')),
          RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Something');
              },
              child: Text('Тестирую ботомбары')),
        ],
      )),
    );
  }
}
