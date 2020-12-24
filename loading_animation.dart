import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.red),
        child: Center(
          child: SpinKitDoubleBounce(
            color: Colors.white,
          ),
        ));
  }
}
