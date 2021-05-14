import 'package:campusconnect/helper/authenticate.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/bottombar.dart';
import 'package:campusconnect/views/chatroomscreen.dart';
import 'package:campusconnect/views/home_page.dart';
import 'package:campusconnect/views/signin.dart';
import 'package:campusconnect/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        if (value == null)
          userIsLoggedIn = false;
        else
          userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? BottomBar() : Authenticate(),
    );
  }
}


