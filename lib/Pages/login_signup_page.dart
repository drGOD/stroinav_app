//import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP, EMPTY }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _fio;
  String _email;
  String _phone;
  String _password;
  String _employerName;
  String _occupation;
  String _errorMessage;

  List dataConstructions;
  List<Constructions> _constructions;
  String selectedConstructions;

  FormMode _formMode = FormMode.LOGIN;
  FormMode _loginMode = FormMode.EMPTY;
  var _jwt;
  bool _isIos;
  bool _isLoading;

  double shw;

  Future<List<Constructions>> getFilials() async {
    final http.Response response = await http.get(
        Uri.parse("https://apistroinav.dic.li/constructions"),
        headers: {"Accept": "application/json"});
    setState(() {
      dataConstructions = json.decode(utf8.decode(response.bodyBytes));
      _constructions = [];
      _constructions = (dataConstructions)
          .map<Constructions>((item) => Constructions.fromJson(item))
          .toList();
    });
    return _constructions;
  }

  Future postLogin(String _email, String _password) async {
    final http.Response response = await http.post(
        'https://apistroinav.dic.li/auth/local/',
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'identifier': _email,
          'password': _password,
        });
    print(jsonDecode(response.body)['jwt']);
    _jwt = jsonDecode(response.body)['jwt'];
    var id = jsonDecode(response.body)['user']['id'];
    var constructionId =
        jsonDecode(response.body)['user']['construction']['id'];
    var box = await Hive.openBox('authBox');
    box.put('jwt', _jwt);
    box.put('id', id);
    box.put('constructionId', constructionId);
    return _jwt;
  }

  Future postSingUP(
      String _fio,
      String _email,
      String _phone,
      String _password,
      String _employerName,
      String _occupation,
      String selectedConstructions) async {
    final http.Response response = await http
        .post('https://apistroinav.dic.li/users/', headers: <String, String>{
      'Accept': 'application/json',
    }, body: {
      'fio': _fio,
      'username': _fio,
      'phone': _phone,
      'employerName': _employerName,
      'occupation': _occupation,
      'construction': selectedConstructions,
      'email': _email,
      'password': _password,
      'confirmed': 'true',
    });
    return jsonDecode(response.body)['id'];
  }

  _launchURL() async {
    var url = 'https://kaluga.iniciativa.app/docs/tos';
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
      try {
        if (_formMode == FormMode.SIGNUP) {
          if (await postSingUP(_fio, _email, _phone, _password, _employerName,
                  _occupation, selectedConstructions) !=
              null) {
            await postLogin(_email, _password);
            if (_jwt.length > 0 && _jwt != null) {
              print('login');
              widget.onSignedIn();
            }
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Не корректные данные';
            });
          }
        } else {
          await postLogin(_email, _password);
          if (_jwt.length > 0 && _jwt != null) {
            print('login');
            widget.onSignedIn();
          }
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;

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
    this.getFilials();
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    this.getFilials();
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
                      _showFIOInput(),
                      _showEmailInput(),
                      _showPhoneInput(),
                      _showPasswordInput(),
                      _showDropDownButtonFilial(),
                      _showEmployerNameInput(),
                      _showOccupationInput(),
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
    if (_formMode != FormMode.SIGNUP) {
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
    } else {
      return new Container(
        height: 50,
      );
    }
  }

  Widget _showFIOInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: _formMode == FormMode.LOGIN
            ? const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0)
            : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'ФИО',
              icon: new Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'ФИО не может быть пустым' : null,
          onSaved: (value) => _fio = value,
        ),
      );
    } else {
      return new Container();
    }
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

  Widget _showPhoneInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Телефон',
              icon: new Icon(
                Icons.phone,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Телефон не может быть пустым' : null,
          onSaved: (value) => _phone = value,
        ),
      );
    } else {
      return new Container();
    }
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

  Widget _showDropDownButtonFilial() {
    return _formMode == FormMode.LOGIN || _constructions == null
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
                  hint: new Text("Выберите объект",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.grey,
                        //  fontSize: 20,
                        // fontWeight: FontWeight.w300
                      )),
                  value: selectedConstructions,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedConstructions = newValue;
                    });
                    print(selectedConstructions);
                  },
                  isDense: false,
                  isExpanded: true,
                  items: _constructions.map((Constructions map) {
                    return new DropdownMenuItem<String>(
                      value: map.id.toString(),
                      child: new Text(map.name,
                          style: TextStyle(
                              color: Colors.black,
                              //   fontSize: 20,
                              fontWeight: FontWeight.normal)),
                    );
                  }).toList(),
                )));
  }

  Widget _showEmployerNameInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: _formMode == FormMode.LOGIN
            ? const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0)
            : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Работодатель',
              icon: new Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Поле не может быть пустым' : null,
          onSaved: (value) => _employerName = value,
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _showOccupationInput() {
    if (_formMode == FormMode.SIGNUP) {
      return Padding(
        padding: _formMode == FormMode.LOGIN
            ? const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0)
            : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Специальность',
              icon: new Icon(
                Icons.person_add,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Поле не может быть пустым' : null,
          onSaved: (value) => _occupation = value,
        ),
      );
    } else {
      return new Container();
    }
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
                  : _validateAndSubmit),
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

class Constructions {
  final int id;
  final String name;
  Constructions({this.id, this.name});
  factory Constructions.fromJson(Map<String, dynamic> json) {
    return new Constructions(
        id: json['id'] as int, name: json['name'] as String);
  }
}
