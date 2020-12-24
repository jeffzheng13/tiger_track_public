import 'package:flutter/material.dart';
import 'package:tiger_tracker_v2/auth.dart';
import 'package:tiger_tracker_v2/loading_animation.dart';
import 'package:tiger_tracker_v2/size_config.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

// underscore makes state private (cannot be seen from main)
class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _email = '';
  String _password = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: Text("Log In"),
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 1],
            colors: [Colors.red, Colors.white],
          )),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              Image.asset(
                'stemlogo.png',
                alignment: Alignment.topCenter,
                height: SizeConfig.blockSizeVertical * 45,
              ),
              new Form(
                  key: _formKey,
                  child: new Column(children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextFormField(
                      decoration: new InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter a valid email' : null,
                      onChanged: (val) {
                        setState(() => _email = val.trim());
                      },
                      //onSaved: (val) => _email = val.trim(),
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Password can\'t be empty' : null,
                      onChanged: (val) {
                        setState(() => _password = val.trim());
                      },
                      obscureText: true,
                      //onSaved: (val) => _password = val.trim(),
                    ),
                    Text(
                      error,
                      style: TextStyle(fontSize: 13.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    loading
                        ? Loading()
                        : new ButtonTheme(
                            minWidth: SizeConfig.blockSizeHorizontal * 75,
                            //padding: EdgeInsets.only(bottom: 10.0),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.red,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .signInWithEmailAndPassword(
                                            _email, _password)
                                        .whenComplete(() =>
                                            Navigator.of(context)
                                                .pushNamed('/MyTrackPage'));
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'The email or password is incorrect. Please try again.';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: new Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                )),
                          ),
                  ])),
              new Column(
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text('- OR -')),
                  new Container(
                      child: ButtonTheme(
                    minWidth: SizeConfig.blockSizeHorizontal * 75,
                    child: SignInButton(
                      Buttons.Google,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () => _auth.googleSignIn().whenComplete(() =>
                          Navigator.of(context).pushNamed('/MyTrackPage')),
                      //darkMode: true,
                      //borderRadius: 10.0,
                    ),
                  ))
                ],
              ),
            ],
          ),
        ));
  }
}
