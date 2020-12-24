import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tiger_tracker_v2/loading_animation.dart';
import 'package:tiger_tracker_v2/size_config.dart';
import 'package:tiger_tracker_v2/auth.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final _formKey =
      new GlobalKey<FormState>(); //performs validation & creates a form
  bool loading = false;
  String _email = '';
  String _password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: Text("Sign Up"),
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
                      onChanged: (val) {
                        setState(() => _email = val);
                      },
                      validator: (val) =>
                          val.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (val) => _email = val.trim(),
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Password',
                      ),
                      onChanged: (val) {
                        setState(() => _password = val);
                      },
                      validator: (val) =>
                          val.isEmpty ? 'Password can\'t be empty' : null,
                      obscureText: true,
                      onSaved: (val) => _password = val.trim(),
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
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            _email, _password);
                                    if (result == null) {
                                      setState(() {
                                        error = 'Unable to Register.';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: new Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ))),
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

                      onPressed: () => _auth.googleSignIn().whenComplete(
                          () => Navigator.pushNamed(context, '/Login')),
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
