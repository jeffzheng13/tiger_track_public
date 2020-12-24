import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiger_tracker_v2/MyTrackPage.dart';
import 'package:tiger_tracker_v2/main.dart';
import 'package:tiger_tracker_v2/user.dart';

// ignore: camel_case_types
class wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return either HomeScreen or MyTrackPage
    if (user == null) {
      return HomeScreen();
    } else {
      return MyTrackPage();
    }
  }
}
