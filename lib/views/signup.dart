import 'package:campusconnect/helper/authenticate.dart';
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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  QuerySnapshot searchSnap;
  QuerySnapshot snap;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  //TextEditingController batchTextEditingController = new TextEditingController();
  //TextEditingController deptTextEditingController = new TextEditingController();
  TextEditingController clubTextEditingController = new TextEditingController();
  TextEditingController FNameTextEditingController =
      new TextEditingController();
  TextEditingController LNameTextEditingController =
      new TextEditingController();
  //var _poy = ['Batch','2020', '2021', '2022', '2023', '2024'];
  //var _dept = ['Dept','CSE', 'ECE', 'ME', 'MA', 'MP', 'BT'];
  //var _club = ['Club','LanScape','Film Club','IEDC','IEEE','Team Meckartans','Vykon Vektor','NSS','LnD','Team Roborex'];
  String selectedBatch = 'Batch';
  String selectedDept = 'Dept';
  String selectedClub = 'Club';

  signMeUp() {
    if (formKey.currentState.validate()) {
      // if(databaseMethods.doesUserExist(userNameTextEditingController.text) == null) {
      List<String> FollowsMe = [];
      List<String> IFollowThem = [];

      Map<String, dynamic> userInfoMap = {
        "name": userNameTextEditingController.text,
        "fname": FNameTextEditingController.text,
        "lname": LNameTextEditingController.text,
        "email": emailTextEditingController.text,
        "batch": selectedBatch == 'Batch' ? null : selectedBatch,
        "dept": selectedDept == 'Dept'
            ? null
            : selectedDept, //deptTextEditingController.text,
        "club": selectedClub == 'Club'
            ? null
            : selectedClub, // clubTextEditingController == null ? "null" : clubTextEditingController.text
        "displaypic": "",
        "tpic": "",
        "followers": "0",
        "following": "0",
        "posts": "0",
        "followsme": FollowsMe,
        "ifollowthem": IFollowThem,
        "bio":"",
        "searchname":userNameTextEditingController.text.toLowerCase(),
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        // print('${val.uid}');

        databaseMethods.uploadUserInfo(userInfoMap);
        //HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      });
    }

    //   else
    //     {
    //       print("username exists");
    //     }
    // }
    // else
    //   print("sign up failed");
  }

  bool doesExist = false;
  bool emailExist = false;

  checking<bool>(String val) {
    databaseMethods.getUserByUsernameForSearch(val.toLowerCase()).then((value) {
      setState(() {
        print(value);
        searchSnap = value;
      });
    });
    print(searchSnap.size);
    if (searchSnap.size == 1)
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

  checkingEmail<bool>(String val) {
    databaseMethods1.getUserByUserEmail(val).then((value) {
      setState(() {
        print(value);
        snap = value;
      });
    });
    print(snap.size);
    if (snap.size == 1)
      setState(() {
        emailExist = true;
      });
    else
      setState(() {
        emailExist = false;
      });
    print(emailExist);
    return emailExist;
  }

  // void _handleChange(String val) {
  //   Future.delayed(Duration(seconds: 2)).then(() {
  //     setState(() {
  //       doesExist = true;
  //     });
  //     print(doesExist);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                //height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset("image/cult1.png"),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty
                                    ? 'Please provide a valid First Name'
                                    : null;
                              },
                              controller: FNameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: new InputDecoration(
                                labelText: "Enter First Name",
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
                              validator: (val) {
                                return val.isEmpty
                                    ? 'Please provide a valid Last Name'
                                    : null;
                              },
                              controller: LNameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: new InputDecoration(
                                labelText: "Enter Last Name",
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
                                height: 2,
                                color: Colors.white,
                              ),
                            ),
                            TextFormField(
                              onChanged: checking,
                              // validator: (val){
                              //   checking(val);
                              //   //print(searchSnap.size);
                              //   int x = 0;
                              //   if(searchSnap != null)
                              //     x = searchSnap.size;
                              //   print(x);
                              //   // Future.delayed(const Duration(milliseconds: 500), () {
                              //   //   print(searchSnap.size);
                              //   // });
                              //     //print(searchSnapshot.docs[0].data()["name"]);
                              //   return val.isEmpty || val.length < 2 ||  x == 1 ? 'Please provide a valid username' : null;
                              // },
                              validator: (val) => val.isEmpty || val.indexOf(" ") >= 0
                                  ? 'Please provide valid username'
                                  : checking(val)
                                      ? 'Username already exists'
                                      : null,
                              controller: userNameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: InputDecoration(
                                //errorText: doesExist ? 'Username in use' : null,
                                labelText: "Enter Username",
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
                              onChanged: checkingEmail,
                              validator: (val) =>
                                  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? checkingEmail(val) == false
                                          ? null
                                          : 'Email is already in use'
                                      : 'Please provide valid email',
                              controller: emailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: InputDecoration(
                                //errorText: emailExist ? 'Email in use' : null,
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
                                return val.length >= 6
                                    ? null
                                    : 'Please provide password with atleast 6 characters';
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
                            // TextFormField(
                            //   validator: (val) {
                            //     return val.isEmpty
                            //         ? 'Please provide a valid First Name'
                            //         : null;
                            //   },
                            //   controller: FNameTextEditingController,
                            //   style: simpleTextFieldStyle(),
                            //   decoration: new InputDecoration(
                            //     labelText: "Enter First Name",
                            //     fillColor: Colors.white,
                            //     border: new OutlineInputBorder(
                            //       borderRadius: new BorderRadius.circular(25.0),
                            //       borderSide: new BorderSide(),
                            //     ),
                            //     //fillColor: Colors.green
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 20.0,
                            //   width: 1000.0,
                            //   child: Divider(
                            //     color: Colors.white,
                            //   ),
                            // ),
                            // TextFormField(
                            //   validator: (val) {
                            //     return val.isEmpty
                            //         ? 'Please provide a valid Last Name'
                            //         : null;
                            //   },
                            //   controller: LNameTextEditingController,
                            //   style: simpleTextFieldStyle(),
                            //   decoration: new InputDecoration(
                            //     labelText: "Enter Last Name",
                            //     fillColor: Colors.white,
                            //     border: new OutlineInputBorder(
                            //       borderRadius: new BorderRadius.circular(25.0),
                            //       borderSide: new BorderSide(),
                            //     ),
                            //     //fillColor: Colors.green
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 20.0,
                            //   width: 1000.0,
                            //   child: Divider(
                            //     height: 2,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            Text('Select Year of Pass-Out :',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Nunito')),
                            DropdownButton<String>(
                              value: selectedBatch,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 16,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.blue,
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('2020'),
                                  value: '2020',
                                ),
                                DropdownMenuItem(
                                  child: Text('2021'),
                                  value: '2021',
                                ),
                                DropdownMenuItem(
                                  child: Text('2022'),
                                  value: '2022',
                                ),
                                DropdownMenuItem(
                                  child: Text('2023'),
                                  value: '2023',
                                ),
                                DropdownMenuItem(
                                  child: Text('2024'),
                                  value: '2024',
                                ),
                                DropdownMenuItem(
                                  child: Text('---Batch---'),
                                  value: 'Batch',
                                ),
                              ],
                              // _poy.map((String dropDownStringItem) {
                              //   return DropdownMenuItem<String>(
                              //     child: Text(dropDownStringItem),
                              //   );
                              // }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  selectedBatch = newValueSelected;
                                });
                              },
                            ),
                            // TextFormField(
                            //   validator: (val) {
                            //     return val.isEmpty || val.length >4 ? 'Please provide valid batch' : null;
                            //   },
                            //   controller: batchTextEditingController,
                            //   style: simpleTextFieldStyle(),
                            //   decoration: textFieldInputDecoration('batch'),
                            // ),
                            SizedBox(
                              height: 20.0,
                              width: 1000.0,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),

                            // TextFormField(
                            //   validator: (val) {
                            //     return val.isEmpty || val.length > 4 ? 'Please provide valid department' : null;
                            //   },
                            //   controller: deptTextEditingController,
                            //   style: simpleTextFieldStyle(),
                            //   decoration: textFieldInputDecoration('department'),
                            // ),

                            Text('Select Department :',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Nunito')),
                            DropdownButton<String>(
                              value: selectedDept,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 16,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.blue,
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('CSE'),
                                  value: 'CSE',
                                ),
                                DropdownMenuItem(
                                  child: Text('ECE'),
                                  value: 'ECE',
                                ),
                                DropdownMenuItem(
                                  child: Text('ME'),
                                  value: 'ME',
                                ),
                                DropdownMenuItem(
                                  child: Text('MA'),
                                  value: 'MA',
                                ),
                                DropdownMenuItem(
                                  child: Text('MP'),
                                  value: 'MP',
                                ),
                                DropdownMenuItem(
                                  child: Text('BT'),
                                  value: 'BT',
                                ),
                                DropdownMenuItem(
                                  child: Text('---Dept---'),
                                  value: 'Dept',
                                ),
                              ],
                              // _dept.map((String dropDownStringItem) {
                              //   return DropdownMenuItem<String>(
                              //     child: Text(dropDownStringItem),
                              //   );
                              // }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  selectedDept = newValueSelected;
                                });
                              },
                            ),
                            // TextFormField(
                            //   controller: clubTextEditingController,
                            //   style: simpleTextFieldStyle(),
                            //   decoration: textFieldInputDecoration('club (if any)'),
                            // ),
                            SizedBox(
                              height: 20.0,
                              width: 1000.0,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            Text('Select Club :',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Nunito')),
                            DropdownButton<String>(
                              value: selectedClub,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 16,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.blue,
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('LanScape'),
                                  value: 'LanScape',
                                ),
                                DropdownMenuItem(
                                  child: Text('Film Club'),
                                  value: 'Film Club',
                                ),
                                DropdownMenuItem(
                                  child: Text('IEEE'),
                                  value: 'IEEE',
                                ),
                                DropdownMenuItem(
                                  child: Text('IEDC'),
                                  value: 'IEDC',
                                ),
                                DropdownMenuItem(
                                  child: Text('ASME'),
                                  value: 'ASME',
                                ),
                                DropdownMenuItem(
                                  child: Text('SAE'),
                                  value: 'SAE',
                                ),
                                DropdownMenuItem(
                                  child: Text('CEST'),
                                  value: 'CEST',
                                ),
                                DropdownMenuItem(
                                  child: Text('Team Meckartans'),
                                  value: 'Team Meckartans',
                                ),
                                DropdownMenuItem(
                                  child: Text('Team Roborex'),
                                  value: 'Team Roborex',
                                ),
                                DropdownMenuItem(
                                  child: Text('LnD'),
                                  value: 'LnD',
                                ),
                                DropdownMenuItem(
                                  child: Text('---Club---'),
                                  value: 'Club',
                                ),
                              ],

                              // _club.map((String dropDownStringItem) {
                              //   return DropdownMenuItem<String>(
                              //     child: Text(dropDownStringItem),
                              //   );
                              // }).toList(),
                              onChanged: (newValueSelected) {
                                setState(() {
                                  selectedClub = newValueSelected;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                        ),
                        child: Center(
                          child: Text(
                            "Please verify your email id after signing up",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.red,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO
                          signMeUp();
                          // Future.delayed(const Duration(milliseconds: 500), () {
                          //   signMeUp();
                          // });
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
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito'),
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
                      //     'Sign Up with Google',
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 17.0,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Nunito'),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Sign in now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.0,
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
