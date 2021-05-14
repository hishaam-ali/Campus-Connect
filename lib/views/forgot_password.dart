import 'package:campusconnect/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  String tempw = "";

  respw() {
    if (formKey.currentState.validate()) {
      authMethods.resetPass(emailTextEditingController.text).then((val) {
        Navigator.pop(context);
        //   else
        //     print("email/password is wrong");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2a4f98),
        title: Text(
          'Reset password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset("image/cult1.png"),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : 'Please provide valid email';
                        },
                        controller: emailTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: InputDecoration(
                          labelText: "Enter your email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        // decoration: InputDecoration(
                        //   hintText: 'Enter your email',
                        //   hintStyle: TextStyle(
                        //     color: Colors.black,
                        //   ),
                        //   border: new OutlineInputBorder(
                        //     borderRadius: new BorderRadius.circular(25.0),
                        //     borderSide: new BorderSide(),
                        //   ),
                        //   // focusedBorder: UnderlineInputBorder(
                        //   //     borderSide: BorderSide(color: Colors.black)),
                        //   // enabledBorder: UnderlineInputBorder(
                        //   //     borderSide: BorderSide(color: Colors.black)),
                        // ),
                      ),
                      // TextFormField(
                      //   obscureText: true,
                      //   validator: (val) {
                      //     tempw = val;
                      //     return val.length > 6 ? null : 'Please provide password 6+ character';
                      //   },
                      //
                      //   style: simpleTextFieldStyle(),
                      //   decoration: textFieldInputDecoration('new password'),
                      // ),
                      // TextFormField(
                      //   obscureText: true,
                      //   validator: (val) {
                      //     return val == tempw ? null : 'Please enter same password as above';
                      //   },
                      //   controller: passwordTextEditingController,
                      //   style: simpleTextFieldStyle(),
                      //   decoration: textFieldInputDecoration('re-enter password'),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                GestureDetector(
                  onTap: () {
                    respw();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff2a4f98),
                        Colors.blue[800],
                        Colors.blue
                      ]),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          color: Colors.white),
                    ),
                  ),
                  // child: Container(
                  //   alignment: Alignment.center,
                  //   width: MediaQuery.of(context).size.width,
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 20.0,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(colors: [
                  //       Colors.blueAccent,
                  //       Colors.blue,
                  //     ]),
                  //     borderRadius: BorderRadius.circular(30.0),
                  //   ),
                  //   child: Text(
                  //     'Submit',
                  //     style: mediumTextFieldStyle(),
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Go to sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontFamily: 'Nunito',
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
