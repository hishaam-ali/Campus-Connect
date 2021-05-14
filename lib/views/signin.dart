import 'package:campusconnect/helper/authenticate.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/bottombar.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/google_username.dart';
import 'package:campusconnect/views/home_page.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campusconnect/views/forgot_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'chatroomscreen.dart';

// final GoogleSignIn gSignIn = GoogleSignIn();
// final usersReference = FirebaseFirestore.instance.collection("users");

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool epCorrect = true;
  bool isVerified = true;
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
        // print('${snapshotUserInfo.docs[0].data()["name"]} this is sparta');
      });
      //TODO function to get user Details

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        //if(val != null)
        if (val != "notv" && val != "nop" && val != null) {
          setState(() {
            epCorrect = true;
            isVerified = true;
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomBar()));
        } else {
          print("wrong email/passsword");
          if (val == "notv")
            setState(() {
              isVerified = false;
              epCorrect = true;
            });
          else if (val == "nop") {
            setState(() {
              epCorrect = false;
              isVerified = true;
            });
          }
        }
      });
    }
  }

  // void initState() {
  //   super.initState();
  //
  //   gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
  //     print("hello");
  //
  //     controlSignIn(gSigninAccount);
  //   },
  //   onError: (gError) {
  //     print("Error Message : " + gError);
  //   }
  //   );
  //
  //   gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
  //     print("yo");
  //     controlSignIn(gSignInAccount);
  //   }).catchError((gError) {
  //     print("Error Message : " + gError);
  //   });
  // }
  //
  // bool isSignedIn = false;
  // controlSignIn(GoogleSignInAccount signInAccount)  async {
  //
  //   if(signInAccount != null) {
  //     setState(() {
  //       isSignedIn = true;
  //     });
  //     print('hi');
  //     await saveUserInfoToFirestore();
  //
  //   }
  //   else {
  //     setState(() {
  //       isSignedIn = false;
  //     });
  //     // print('bye');
  //     // HelperFunctions.saveUserLoggedInSharedPreference(false);
  //     //
  //     // Constants.GoogleLogIn = "no";
  //     // Navigator.pushReplacement(context,
  //     //     MaterialPageRoute(
  //     //         builder: (context) => Authenticate()
  //     //     ));
  //   }
  // }
  //
  // saveUserInfoToFirestore() async {
  //   final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
  //   print(gSignIn.currentUser);
  //   DocumentSnapshot documentSnapshot = await usersReference.doc(gCurrentUser.id).get();
  //
  //   if(!documentSnapshot.exists) {
  //    final username =  await Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleUsername()));
  //
  //     usersReference.doc(gCurrentUser.id).set({
  //
  //       "name": username,
  //       "fname": gCurrentUser.displayName,
  //       "lname":"",
  //       "url" : gCurrentUser.photoUrl,
  //       "email": gCurrentUser.email,
  //       "batch": null,
  //       "dept": null,
  //       "club": null,
  //     });
  //     Constants.myName = username;
  //    // HelperFunctions.saveUserEmailSharedPreference(
  //    //     gCurrentUser.email);
  //
  //    // Navigator.pushReplacement(context,
  //    //     MaterialPageRoute(
  //    //         builder: (context) => BottomBar()
  //    //     ));
  //   }
  //   databaseMethods.getUserByUserEmail(gCurrentUser.email).then((val) {
  //     snapshotUserInfo = val;
  //     HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()["name"]);
  //     // print('${snapshotUserInfo.docs[0].data()["name"]} this is sparta');
  //   });
  //
  // }
  //
  //
  // googleSign() async{
  //  try{
  //    await gSignIn.signIn();
  //    setState(() {
  //      isSignedIn = true;
  //    });
  //    print("signed in with google");
  //    print(Constants.GoogleLogIn);
  //    if(Constants.GoogleLogIn == "no") {
  //   Constants.GoogleLogIn = "yes";
  //   HelperFunctions.saveUserLoggedInSharedPreference(true);
  //   Navigator.pushReplacement(context,
  //   MaterialPageRoute(
  //   builder: (context) => BottomBar()
  //   ));
  //   }
  //
  //  }
  //  catch(e) {
  //    print(e);
  //  }
  //
  //   //  print("signed in with google");
  //  // Constants.GoogleLogIn = "yes";
  //  //  await gSignIn.signIn();
  //  //  HelperFunctions.saveUserLoggedInSharedPreference(true);
  //  //
  //  //  Navigator.pushReplacement(context,
  //  //      MaterialPageRoute(
  //  //          builder: (context) => BottomBar()
  //  //      ));
  // }
  //
  // logoutGoogleUser() {
  //   gSignIn.signOut();
  //   setState(() {
  //     isSignedIn = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset("image/cult1.png"),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
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
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 1000.0,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.length > 0 ? null : 'Wrong password';
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: InputDecoration(
                          labelText: "Password",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 1000.0,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                epCorrect == false
                    ? Text(
                        "Email / Password is wrong or doesn't exist!",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.red,
                          fontSize: 17.0,
                        ),
                      )
                    : Container(),
                epCorrect == false
                    ? SizedBox(
                        height: 8.0,
                      )
                    : Container(),
                isVerified == false
                    ? Text(
                        "Email hasn't been verified!",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.red,
                          fontSize: 17.0,
                        ),
                      )
                    : Container(),
                isVerified == false
                    ? SizedBox(
                        height: 8.0,
                      )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
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
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Nunito',
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   width: MediaQuery.of(context).size.width,
                //   padding: EdgeInsets.symmetric(vertical: 20.0,),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(30.0),
                //   ),
                //   child: Text(
                //     'Sign In with Google',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 17.0,
                //     ),
                //   ),
                // ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   child: new RaisedButton(
                //       padding:
                //       EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
                //       color: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //       ),
                //       onPressed: () {
                //       //  googleSign();
                //       },
                //       child: new Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           new Image.asset(
                //             'image/google.png',
                //             height: 48.0,
                //           ),
                //           new Container(
                //               padding: EdgeInsets.only(left: 10.0, right: 10.0),
                //               child: new Text(
                //                 "Sign in with Google",
                //                 style: TextStyle(
                //                     color: Colors.black,
                //                     fontFamily: 'Nunito',
                //                     fontWeight: FontWeight.bold),
                //               )),
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontSize: 18, fontFamily: 'Nunito'),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
