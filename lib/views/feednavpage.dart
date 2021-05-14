import 'package:campusconnect/views/announcements.dart';
import 'package:campusconnect/views/upload_announcement.dart';
import 'package:campusconnect/views/upload_event.dart';
import 'package:campusconnect/views/upload_whats.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:campusconnect/views/Events.dart';
import 'package:campusconnect/views/whatshappening.dart';
import 'package:campusconnect/views/announcements.dart';

// final GoogleSignIn gSignIn = GoogleSignIn();

class FeedDrawer extends StatefulWidget {
  @override
  _FeedDrawerState createState() => _FeedDrawerState();
}

class _FeedDrawerState extends State<FeedDrawer> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  bool isLoading = true;
  String userName;
  String tp;
  bool admin = false;
  initSearch() async {
    String mycurrentemail = await HelperFunctions.getUserEmailSharedPreference();
    mycurrentemail == "hishaamali12@gmail.com" || mycurrentemail == "abhirams722@gmail.com" || mycurrentemail == "divnandan159@gmail.com" ? admin = true : admin = false;
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
                        fontSize: 25,
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
                  leading: Icon(MaterialIcons.event),
                  title: Text("Events",
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Events()))
                  },
                ),
                ListTile(
                    leading: Icon(FlutterIcons.star_sli),
                    title: Text("What's Happening",
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                    onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => whats()))
                        }),
                ListTile(
                  leading: Icon(Entypo.megaphone),
                  title: Text('Announcements',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => announcement()))
                  },
                ),
               admin ? Divider(color: Colors.black) : Container(),
               admin ? ListTile(
                  leading: Icon(CupertinoIcons.calendar_badge_plus),
                  title: Text("Upload Event",
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UploadEvent()))
                  },
                ) : Container(),
                admin ? ListTile(
                  leading: Icon(Icons.maps_ugc),
                  title: Text("Upload News",
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UploadWhats()))
                  }
                ) : Container(),
                admin ? ListTile(
                  leading: Icon(Icons.add_alert),
                  title: Text('Upload Announcement',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 20)),
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UploadAnnouncements()))
                  },
                ) : Container(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/cult.png'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
    );
  }
}
