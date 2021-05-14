import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:campusconnect/profile/editprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/helper/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

// final GoogleSignIn gSignIn = GoogleSignIn();

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  bool isLoading = true;
  String userName;
  String tp;
  initSearch() async {
    await databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    userName = searchSnapshot.docs[0].data()["name"];
    tp = searchSnapshot.docs[0].data()["tpic"];
    // userEmail = searchSnapshot.docs[0].data()["email"];
    // batch = searchSnapshot.docs[0].data()["batch"];
    // Fname = searchSnapshot.docs[0].data()["fname"];
    // Lname = searchSnapshot.docs[0].data()["lname"];
    // club = searchSnapshot.docs[0].data()["club"];
    // dept = searchSnapshot.docs[0].data()["dept"];

    setState(() {
      isLoading = false;
    });
  }

  // Future<void> signoutFromGoogle() async {
  //
  //   final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
  //   print(gSignIn.currentUser);
  //
  //   //await authMethods.signOut().then((value) {
  //      gSignIn.signOut();
  //     print("sign out successful");
  //     HelperFunctions.saveUserLoggedInSharedPreference(false);
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(
  //             builder: (context) => Authenticate()
  //         )
  //     );
  // }

  @override
  Widget build(BuildContext context) {
    initSearch();
    return Drawer(
      child: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    userName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: tp == ""
                            ? NetworkImage(
                                "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg")
                            : NetworkImage(tp),
                      )),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Notification',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {},
                ),
                ListTile(
                    leading: Icon(Feather.edit),
                    title: Text('Edit Profile',
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                    onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => edit()))
                        }),
                ListTile(
                  leading: Icon(Icons.stars),
                  title: Text('Rate Campus Connect',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text('Send Feedback',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/navpage.png'),
                          fit: BoxFit.cover)),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () {
                    // if(Constants.GoogleLogIn == "yes") {
                    //   //setState(() {
                    //     Constants.GoogleLogIn = "no";
                    //   //});
                    //   await signoutFromGoogle();
                    //   print("logged out successfully");
                    //   //gSignIn.signOut();
                    //   //Future.delayed(const Duration(seconds: 4), () {
                    //   //   HelperFunctions.saveUserLoggedInSharedPreference(false);
                    //   //   Navigator.pushReplacement(context,
                    //   //       MaterialPageRoute(
                    //   //           builder: (context) => Authenticate()
                    //   //       )
                    //   //   );
                    //   // });
                    // }
                    //   else {
                    authMethods.signOut();
                    HelperFunctions.saveUserLoggedInSharedPreference(false);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                ),
              ],
            ),
    );
  }
}
