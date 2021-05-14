import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/bottombar.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/home_page.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campusconnect/views/chatroomscreen.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleUsername extends StatefulWidget {
  @override
  _GoogleUsernameState createState() => _GoogleUsernameState();
}

class _GoogleUsernameState extends State<GoogleUsername> {

  QuerySnapshot searchSnap;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextEditingController = new TextEditingController();

  bool doesExist = false;

  checking<bool>(String val)  {
    databaseMethods.getUserByUsername(val).then((
        value) {
      setState(() {
        print(value);
        searchSnap = value;
      });
    });
    print(searchSnap.size);
    if(searchSnap.size == 1)
      setState(() {
        doesExist = true;
      });
    else
      setState(() {
        doesExist = false;
      });
    print(doesExist);
    return doesExist;
  }

submitUsername() {
  if(formKey.currentState.validate()) {
    Navigator.pop(context, userNameTextEditingController.text);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          SizedBox(
          height: 30,
          ),
          Form(
          key: formKey,
          child: Column(
          children: [
          TextFormField(
          onChanged:  checking,
          validator: (val) => checking(val) || val.isEmpty || val.length < 2
          ? 'Please provide valid username' : null,
          controller: userNameTextEditingController,
          style: simpleTextFieldStyle(),
          decoration: InputDecoration(
          errorText: doesExist ? 'Username in use' : null,
          labelText: "Enter Username",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(),
          ),
          //fillColor: Colors.green
          ),
          ),
          GestureDetector(
            onTap: submitUsername,
            child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20.0,),
            decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [
            Colors.blueAccent,
            Colors.blue,
            ]
            ),
            borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
            'Proceed',
            style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Nunito'),
            ),
            ),
          ),
          ],
          ),
          ),
          ],
          ),
          ),
        ),
      ),
    );
  }
}
