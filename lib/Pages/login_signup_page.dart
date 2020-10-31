//import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:stroinav_app/services/authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP, EMPTY }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  _launchURL() async {
    var url = 'https://career.ruc.su/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _email;
  String _password;
  String _dogovor;
  String _dataOfStudent;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  FormMode _loginMode = FormMode.EMPTY;
  bool _isIos;
  bool _isLoading;

  double shw;

  List dataFilials;
  List dataYears;
  List dataGroups;
  List<Filials> _filials;
  String selectedFilial;
  List<Years> _years;
  String selectedYear;
  List<Groups> _groups;
  String selectedGroup;

  Future<List<Filials>> getFilials() async {
    var res = await http.get(Uri.parse("http://api.fucku.tech/getFilials"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(utf8.decode(res.bodyBytes));
      dataFilials = resBody['result']['return']['Filial'];
      _filials = [];
      _filials =
          (dataFilials).map<Filials>((item) => Filials.fromJson(item)).toList();
    });
    return _filials;
  }

  Future<List<Years>> getYears() async {
    var res = await http.get(Uri.parse("http://api.fucku.tech/getEduYears"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(utf8.decode(res.bodyBytes));
      dataYears = resBody['result']['return']['EduYear'];
      _years = [];
      _years = (dataYears).map<Years>((item) => Years.fromJson(item)).toList();
    });
    return _years;
  }

  Future<List<Groups>> getGroups() async {
    var res = await http.get(
        Uri.parse(
            "http://api.fucku.tech/getFilialEduGroups?filial=$selectedFilial&year=$selectedYear"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(utf8.decode(res.bodyBytes));
      dataGroups = resBody['result']['return']['EduGroup'];
      _groups = [];
      _groups =
          (dataGroups).map<Groups>((item) => Groups.fromJson(item)).toList();
    });
    return _groups;
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
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          _dataOfStudent =
              'dogovor=$_dogovor&filial=$selectedFilial&group=$selectedGroup';
          userId = await widget.auth.signUp(_email, _dataOfStudent, _password);
          print('Signed in: $userId');
        }
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
          if (_errorMessage ==
              'There is no user record corresponding to this identifier. The user may have been deleted.') {
            _errorMessage = 'Пользователь не найден.';
          }
          if (_errorMessage ==
              'The password is invalid or the user does not have a password.') {
            _errorMessage = 'Неправильный пароль.';
          }
          if (_errorMessage == 'The email address is badly formatted.') {
            _errorMessage = 'Email имеет не правильный формат.';
          }
          if (_errorMessage ==
              'The password must be 6 characters long or more.') {
            _errorMessage = 'Пароль должен состоять из 6 символов или больше.';
          }
          if (_errorMessage ==
              'The given password is invalid. [ Password should be at least 6 characters ]') {
            _errorMessage = 'Пароль должен состоять из 6 символов или больше.';
          }
          if (_errorMessage ==
              'The email address is already in use by another account.') {
            _errorMessage = 'Email уже зарегестрирован в другом аккаунте.';
          }
          if (_errorMessage ==
              'We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later ]') {
            _errorMessage = 'Слишком много попыток входа.';
          }
          if (_errorMessage ==
              'Network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
            _errorMessage = 'Отсутсвует подключение к интернету.';
          }
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
    this.getFilials();
    this.getYears();
    super.initState();
  }

  void _changeFormToSignUp() {
    this.getFilials();
    this.getYears();
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
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFB92139)),
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
                      _showSupportButton(),
                    ],
                  )
                : new Column(
                    children: <Widget>[
                      _showEmailInput(),
                      _showDogovorInput(),
                      _showPasswordInput(),
                      _showDropDownButtonFilial(),
                      _showDropDownButtonYear(),
                      _showDropDownButtonGroup(),
                      _showRulesButton(),
                      _showPrimaryButton(),
                      _showSecondaryButton(),
                      _showSupportButton(),
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
            color: Color(0xFFB92139),
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
          child: Image.asset('image/Logo.png', fit: BoxFit.cover),
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

  Widget _showDogovorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: _formMode == FormMode.SIGNUP
          ? new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: new InputDecoration(
                  hintText: 'Номер договора',
                  icon: new Icon(
                    Icons.mail,
                    color: Colors.grey,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Номер договора не может быть пустым' : null,
              onSaved: (value) => _dogovor = value,
            )
          : new Container(),
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

  Widget _showSupportButton() {
    return new Padding(
        padding: _loginMode == FormMode.EMPTY
            ? EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)
            : EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
            width: 350.0,
            height: 40.0,
            child: _loginMode == FormMode.EMPTY
                ? new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    hoverColor: Color(0xFFB92139),
                    child: new Text('Посмотреть расписание',
                        style: new TextStyle(
                            fontSize: 20.0, color: Color(0xFFB92139))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chois');
                    })
                : new FlatButton(
                    child: _formMode == FormMode.LOGIN
                        ? new Text('Посмотреть расписание',
                            style: new TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w300))
                        : new Container(),
                    onPressed: () {
                      Navigator.pushNamed(context, '/chois');
                    })));
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
              color: Color(0xFFB92139),
              disabledColor: Color(0xFF820014),
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
                  : _formMode == FormMode.LOGIN || selectedGroup != null
                      ? _validateAndSubmit
                      : null),
        ));
  }

  Widget _showDropDownButtonFilial() {
    return _formMode == FormMode.LOGIN || _years == null || _filials == null
        ? new Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
            child: SizedBox(
                width: shw,
                height: 60.0,
                child: new DropdownButton<String>(
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  hint: new Text("Выберите филиал",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.grey,
                        //  fontSize: 20,
                        // fontWeight: FontWeight.w300
                      )),
                  value: selectedFilial,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedFilial = newValue;
                      selectedGroup = null;
                      _groups = null;
                    });
                    if (selectedYear != null) {
                      getGroups();
                    }
                    print(selectedFilial);
                  },
                  isDense: false,
                  isExpanded: true,
                  items: _filials.map((Filials map) {
                    return new DropdownMenuItem<String>(
                      value: map.filialID,
                      child: new Text(map.filialName,
                          style: TextStyle(
                              color: Colors.black,
                              //   fontSize: 20,
                              fontWeight: FontWeight.normal)),
                    );
                  }).toList(),
                )));
  }

  Widget _showDropDownButtonYear() {
    return _formMode == FormMode.LOGIN || _years == null || _filials == null
        ? new Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
            child: new SizedBox(
              width: shw,
              height: 60.0,
              child: new DropdownButton<String>(
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                hint: new Text("Выберите год начала обучения",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.grey,
                      //   fontSize: 20,
                      //  fontWeight: FontWeight.w300
                    )),
                value: selectedYear,
                onChanged: (String newValue) {
                  setState(() {
                    selectedYear = newValue;
                    selectedGroup = null;
                    _groups = null;
                  });
                  if (selectedFilial != null) {
                    getGroups();
                  }
                  print(selectedYear);
                },
                isDense: false,
                isExpanded: true,
                items: _years.map((Years map) {
                  return new DropdownMenuItem<String>(
                    value: map.yearID,
                    child: new Text(map.yearName,
                        style: TextStyle(
                            color: Colors.black,
                            //  fontSize: 20,
                            fontWeight: FontWeight.normal)),
                  );
                }).toList(),
              ),
            ));
  }

  Widget _showDropDownButtonGroup() {
    return _formMode == FormMode.LOGIN ||
            selectedYear == null ||
            selectedFilial == null ||
            _groups == null
        ? new Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
            child: new SizedBox(
              width: shw,
              height: 60.0,
              child: new DropdownButton<String>(
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                hint: new Text("Выберите группу",
                    style: TextStyle(
                      color: Colors.grey,
                      //   fontSize: 20,
                      //  fontWeight: FontWeight.w300
                    )),
                value: selectedGroup,
                onChanged: (String newValue) {
                  setState(() {
                    selectedGroup = newValue;
                  });
                  print(selectedGroup);
                },
                isDense: false,
                isExpanded: true,
                items: _groups.map((Groups map) {
                  return new DropdownMenuItem<String>(
                    value: map.groupID,
                    child: new Text(map.groupName,
                        style: TextStyle(
                            color: Colors.black,
                            //    fontSize: 20,
                            fontWeight: FontWeight.normal)),
                  );
                }).toList(),
              ),
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

class Filials {
  final String filialID;
  final String filialName;

  Filials({this.filialID, this.filialName});
  factory Filials.fromJson(Map<String, dynamic> json) {
    return new Filials(filialID: json['GUID'], filialName: json['Name']);
  }
}

class Years {
  final String yearID;
  final String yearName;

  Years({this.yearID, this.yearName});
  factory Years.fromJson(Map<String, dynamic> json) {
    return new Years(yearID: json['GUID'], yearName: json['Name']);
  }
}

class Groups {
  final String groupID;
  final String groupName;

  Groups({this.groupID, this.groupName});
  factory Groups.fromJson(Map<String, dynamic> json) {
    return new Groups(groupID: json['GUID'], groupName: json['Name']);
  }
}
