//import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:stroinav_app/services/NavBar.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP, EMPTY }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  FormMode _loginMode = FormMode.EMPTY;
  var _jwt;
  bool _isIos;
  bool _isLoading;

  double shw;

  Future postLogin(String _email, String _password) async {
    final http.Response response = await http
        .post('http://185.5.54.22:1337/auth/local/', headers: <String, String>{
      'Accept': 'application/json',
    }, body: {
      'identifier': _email,
      'password': _password,
    });
    print(jsonDecode(response.body)['jwt']);
    _jwt = jsonDecode(response.body)['jwt'];
    return _jwt;
  }

  _launchURL() async {
    var url = 'https://career.ruc.su/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        await postLogin(_email, _password);
        if (_jwt.length > 0 && _jwt != null) {
          print('login');
          widget.onSignedIn();
        }
        /*if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          _dataOfStudent =
              'dogovor=$_dogovor&filial=$selectedFilial&group=$selectedGroup';
          userId = await widget.auth.signUp(_email, _dataOfStudent, _password);
          print('Signed in: $userId');
        }*/
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.message;
          } else
            _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeloginMode() {
    _errorMessage = "";
    setState(() {
      _loginMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    shw = MediaQuery.of(context).size.width;
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            _showBodyAll(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF255781)),
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showBodyAll() {
    return new ListView(shrinkWrap: true, reverse: false, children: <Widget>[
      _showLogoBody(),
      _showBody(),
    ]);
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: Center(
            child: _loginMode == FormMode.EMPTY
                ? new Column(
                    children: <Widget>[
                      _showPrimaryButton(),
                      //_showSupportButton(),
                    ],
                  )
                : new Column(
                    children: <Widget>[
                      _showEmailInput(),
                      _showPasswordInput(),
                      _showRulesButton(),
                      _showPrimaryButton(),
                      _showSecondaryButton(),
                      _showErrorMessage(),
                    ],
                  ),
          ),
        ));
  }

  Widget _showLogoBody() {
    return new Container(
      width: 10000.0,
      //color: Color(0xFF304FFE),
      child: _showLogo(),
    );
  }

  Widget _showErrorMessage() {
    if (/*_errorMessage.length > 0 &&*/ _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Color(0xFF255781),
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: _formMode == FormMode.LOGIN
            ? EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 70.0)
            : EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
        child: CircleAvatar(
          backgroundColor: Color(0x000000000),
          radius: 100.0,
          child: Image.asset('image/Logo_100.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: _formMode == FormMode.LOGIN
          ? const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0)
          : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Email не может быть пустым' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Пароль',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Пароль не может быть пустым' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Создать аккаунт',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('У меня есть аккаунт. Войти',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: _formMode == FormMode.LOGIN
            ? EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0)
            : EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
          width: 350.0,
          height: 40.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Color(0xFF255781),
              disabledColor: Color(0xFF1b3e5c),
              child: _loginMode == FormMode.EMPTY
                  ? new Text('Войти в личный кабинет',
                      style: new TextStyle(fontSize: 20.0, color: Colors.white))
                  : _formMode == FormMode.LOGIN
                      ? new Text('Войти',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white))
                      : new Text('Создать аккаунт',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
              onPressed: _loginMode == FormMode.EMPTY
                  ? _changeloginMode
                  : _formMode == FormMode.LOGIN
                      ? _validateAndSubmit
                      : null),
        ));
  }

  Widget _showRulesButton() {
    return _formMode == FormMode.LOGIN
        ? new Container()
        : new FlatButton(
            child: Text(
                'Я ознакомлен с правилами, политикой конфиденциальности и принимаю их условия',
                textAlign: TextAlign.center,
                style:
                    new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w100)),
            onPressed: () {
              _launchURL();
            },
          );
  }
}
