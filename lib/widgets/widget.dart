import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Center(
      child: Text(
        'Campus Connect',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
          color: Colors.white,
        ),
      ),
    ),
    backgroundColor: Color(0xff2a4f98),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Nunito');
}

TextStyle mediumTextFieldStyle() {
  return TextStyle(
    fontFamily: 'Nunito',
    color: Colors.black,
    fontSize: 17.0,
  );
}
