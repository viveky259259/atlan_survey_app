import 'package:flutter/material.dart';

class SnackBarDelegate {
  static showSnackBar(context, String text, scaffoldKey, {int time}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: new Text(
        text,
        style: TextStyle(color: Color(0xff3700b3)),
      ),
      duration: Duration(milliseconds: (time == null) ? 400 : time),
    ));
  }
}
