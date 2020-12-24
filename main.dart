import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiger_tracker_v2/Map_Cards.dart';
import 'package:tiger_tracker_v2/MyTrackPage.dart';
import 'package:tiger_tracker_v2/ProfilePage.dart';
import 'package:tiger_tracker_v2/deleted%20files/RTDB_Track.dart';
import 'package:tiger_tracker_v2/SignupPage.dart';
import 'package:tiger_tracker_v2/auth.dart';
import 'package:tiger_tracker_v2/LoginPage.dart';
import 'package:tiger_tracker_v2/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiger_tracker_v2/user.dart';
import 'package:tiger_tracker_v2/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new TigerTrackerApp());
}

class TigerTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(home: wrapper(), routes: <String, WidgetBuilder>{
          '/Login': (context) => LoginPage(),
          '/Signup': (context) => SignupPage(),
          '/MyTrackPage': (context) => MyTrackPage(),
          '/MapCards': (context) => MapCardsPage(),
          //'/ProfilePage': (context) => ProfilePage(),
          '/RTDBTrack': (context) => RTDBTrack(),
          //'/ExpandedMaps': (context) => ExpandedMaps(),
        }));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1],
                colors: [Colors.red, Colors.white]),
          ),
          //margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'tiger_tracker_logo_v2.png',
                width: SizeConfig.blockSizeHorizontal * 100,
                height: SizeConfig.blockSizeVertical * 33,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
              LogInButton(),
              SignUpButton(),
              //TestPageButton(),
              //Page2Button(),
            ],
          )),
    );
  }
}

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 80,
      height: SizeConfig.blockSizeVertical * 7,
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      decoration: myBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Login');
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 40,
                height: SizeConfig.blockSizeVertical * 5,
                child: Center(
                  child: Text(
                    'Log In',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.juliusSansOne(
                      textStyle: TextStyle(
                        fontSize: 30.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      width: SizeConfig.blockSizeHorizontal * 80,
      height: SizeConfig.blockSizeVertical * 7,
      decoration: myBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Signup');
                },
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  height: SizeConfig.blockSizeVertical * 5,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.juliusSansOne(
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

//TODO: Get Rid of Test Page Button Before Final
//(Only used for development purposes)
/*
class TestPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 80,
      height: SizeConfig.blockSizeVertical * 7,
      decoration: myBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/MapCards');
                },
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  height: SizeConfig.blockSizeVertical * 5,
                  child: Center(
                    child: Text(
                      'Test Page Button',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.juliusSansOne(
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
*/
BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.white,
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100.0),
    ),
  );
}
