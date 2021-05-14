import 'dart:io';

import 'package:campusconnect/services/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:campusconnect/profile/leftnavpage.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TextEditingController newpasswordTextEditingController =
//     new TextEditingController();
// TextEditingController newconfirmpasswordTextEditingController =
//     new TextEditingController();
// var _poy = ['2020', '2021', '2022', '2023', '2024'];
// var _dept = ['CSE', 'ECE', 'ME', 'AE', 'MP', 'BT'];
// var _club = ['Lanscape', 'IEEE', 'Sports', 'Others'];

class edit extends StatefulWidget {
  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  File _image;
  File _image1;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnap;

  bool dpChange = false;
  bool tpChange = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController newuserNameTextEditingController =
      new TextEditingController();
  TextEditingController newFNameTextEditingController =
      new TextEditingController();
  TextEditingController newLNameTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();
  String selectedBatch = 'Batch';
  String selectedDept = 'Dept';
  String selectedClub = 'Club';

  String userName;
  String batch;
  String Fname;
  String Lname;
  String club;
  String dept;
  String bio;
  bool isLoading = false;

  void initState() {
    getinfo();
    super.initState();
  }

  getinfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  editProfile() async {
    // await databaseMethods.getUserByUsername(Constants.myName).then((
    //     val) {
    //   setState(() {
    //     searchSnapshot = val;
    //   });
    // });
    setState(() {
      isLoading = true;
    });

    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);

    if (formKey.currentState.validate()) {
      print('hello');
      userName = newuserNameTextEditingController.text.isEmpty
          ? "nochange"
          : newuserNameTextEditingController.text;

      Fname = newFNameTextEditingController.text.isEmpty
          ? "nochange"
          : newFNameTextEditingController.text;
      print(Fname);
      Lname = newLNameTextEditingController.text.isEmpty
          ? "nochange"
          : newLNameTextEditingController.text;
      print(Lname);
      batch = selectedBatch == 'Batch' ? "nochange" : selectedBatch;
      dept = selectedDept == 'Dept' ? "nochange" : selectedDept;
      club = selectedClub == 'Club' ? "nochange" : selectedClub;
      bio = bioTextEditingController.text.isEmpty ? "nobio" : bioTextEditingController.text;
      databaseMethods.updateUser(
          Constants.myName, userName, Fname, Lname, batch, dept, club,bio);
      // userName = searchSnapshot.docs[0].data()["name"];
      // batch = searchSnapshot.docs[0].data()["batch"];
      // Fname = searchSnapshot.docs[0].data()["fname"];
      // Lname = searchSnapshot.docs[0].data()["lname"];
      // club = searchSnapshot.docs[0].data()["club"];
      // dept = searchSnapshot.docs[0].data()["dept"];

      // newuserNameTextEditingController.text.isEmpty ? HelperFunctions.saveUserNameSharedPreference(
      //     Constants.myName) : HelperFunctions.saveUserNameSharedPreference(
      //     newuserNameTextEditingController.text);
      //
      // if(newuserNameTextEditingController.text.isNotEmpty)
      // Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    }
  }

  bool doesExist = false;

  checking<bool>(String val) {
    databaseMethods.getUserByUsernameForSearch(val.toLowerCase()).then((value) {
      setState(() {
        print(value);
        searchSnapshot = value;
      });
    });
    if(searchSnapshot != null) {
      print(searchSnapshot.size);
      if (searchSnapshot.size == 1)
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
    else
      return false;
  }


    // dpChange = false;
    // tpChange = false;

     getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print("hello ji");
        print("Image Path $_image");
        dpChange = true;
        print(dpChange);
      });
    }

     getImage1() async {
      var image1 = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image1 = image1;
        print("hello ji");
        print("Image Path $_image1");
        tpChange = true;
        print(tpChange);
      });
    }

    initiateSearch() {
      databaseMethods.getUserByUsername(Constants.myName).then((val) {
        setState(() {
          if(val!=null)
          searchSnap = val;
        });
      });
    }

    uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      initiateSearch();
      String useremail = searchSnap.docs[0].data()["email"];
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('users/$useremail');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      //var storage = FirebaseStorage.instance.ref();
      TaskSnapshot taskSnapshot =
      await uploadTask.whenComplete(() {
        setState(() async {
          print("Profile picture uploaded");
          //storage.child('gs://campconnectchat.appspot.com/users/$useremail').getDownloadURL().then((value) {
          final ref = FirebaseStorage.instance.ref('users/$useremail');
          var url = await ref.getDownloadURL();
          print(url);
          String id = searchSnap.docs[0].id;
          //print(value);
          FirebaseFirestore.instance
              .collection("users")
              .doc(id)
              .update({"displaypic": url});
          //});
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   content: Text('Profile picture uploaded'),
          // ));
          dpChange = true;
          if(tpChange) await uploadPic1(context);
          else Navigator.pop(context);
        });
      });
    }

    uploadPic1(BuildContext context) async {
      String fileName = basename(_image1.path);
      initiateSearch();
      String useremail = searchSnap.docs[0].data()["email"];
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('users/timeline_$useremail');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image1);
      //var storage = FirebaseStorage.instance.ref();
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        setState(() async {
          print("Timeline picture uploaded");
          //storage.child('gs://campconnectchat.appspot.com/users/$useremail').getDownloadURL().then((value) {
          final ref = FirebaseStorage.instance.ref('users/timeline_$useremail');
          var url = await ref.getDownloadURL();
          print(url);
          String id = searchSnap.docs[0].id;
          //print(value);
          FirebaseFirestore.instance
              .collection("users")
              .doc(id)
              .update({"tpic": url});
          //});
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   content: Text('Profile picture uploaded'),
          // ));
          tpChange = true;
          Navigator.pop(context);
        });
      });
    }


    currentdp() {
      initiateSearch();
      return searchSnap != null ? searchSnap.docs[0].data()["displaypic"] == ""
          ? NetworkImage(
              "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
          : NetworkImage(searchSnap.docs[0].data()["displaypic"])
          : NetworkImage(
          "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png");
    }

    currenttp() {
      initiateSearch();
      return searchSnap != null ? searchSnap.docs[0].data()["tpic"] == ""
          ? NetworkImage(
              "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg")
          : NetworkImage(searchSnap.docs[0].data()["tpic"])
          : NetworkImage(
      "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: new Icon(CupertinoIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              'Edit profile',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                  icon: new Icon(
                    Feather.save,
                    size: 30,
                  ),
                  onPressed: () async{
                    await editProfile();
                    if(dpChange == false && tpChange == false) Navigator.pop(context);
                     print(dpChange);
                     print(tpChange);
                    //dpChange ?
                    if(dpChange) await uploadPic(context);
                    //: null;
                    //tpChange ? await
                    if(tpChange) await uploadPic1(context);
                    //: null;
                    print("updation done");
                    //Navigator.pop(context);
                  }),
            ],
            backgroundColor: const Color(0xff2a4f98)),
        body: isLoading
            ? Container(
          child: Center(child: SpinKitRing(
            color: Colors.blue.shade500,
            size: 50.0,
          )),
        )
            : SingleChildScrollView(
            child: Column(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: _image1 != null
                        ?
                        //Image.file(_image,fit: BoxFit.fill,)
                        FileImage(File(_image1.path))
                        : currenttp(),
                    fit: BoxFit.cover)),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Container(
                alignment: Alignment(0.0, 2.5),
                child: CircleAvatar(
                  backgroundImage: _image != null
                      ?
                      //Image.file(_image,fit: BoxFit.fill,)
                      FileImage(File(_image.path))
                      : currentdp(),
                  radius: 70.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    //dpChange = true;
                    print(dpChange);
                    setState(() {
                      dpChange = true;
                    });
                    getImage();
                    //uploadPic(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  color: Color(0xff2a4f98),
                  child: Ink(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        maxHeight: 60.0,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Edit Profile Photo",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 90),
                RaisedButton(
                  onPressed: () {
                    //tpChange = true;
                    print(tpChange);
                    getImage1();
                    setState(() {
                      tpChange = true;
                    });
                    //uploadPic1(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  color: Color(0xff2a4f98),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 100.0,
                      maxHeight: 60.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Cover Photo",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
          ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       dpChange ? RaisedButton(
              //         onPressed: () async{
              //           if(dpChange) await uploadPic;
              //           //dpChange = true;
              //           // print(dpChange);
              //           // setState(() {
              //           //   dpChange = true;
              //           // });
              //           // getImage();
              //           //uploadPic(context);
              //         },
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(80.0),
              //         ),
              //         color: Color(0xff2a4f98),
              //         child: Ink(
              //           child: Container(
              //             constraints: BoxConstraints(
              //               maxWidth: 100.0,
              //               maxHeight: 60.0,
              //             ),
              //             alignment: Alignment.center,
              //             child: Text(
              //               "Save Profile Photo",
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontFamily: 'Nunito',
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300),
              //             ),
              //           ),
              //         ),
              //       ) : Container(),
              //       SizedBox(width: 90),
              //       tpChange ? RaisedButton(
              //         onPressed: () async{
              //           if(tpChange) await uploadPic1();
              //           //tpChange = true;
              //           // print(tpChange);
              //           // getImage1();
              //           // setState(() {
              //           //   tpChange = true;
              //           // });
              //           //uploadPic1(context);
              //         },
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(80.0),
              //         ),
              //         color: Color(0xff2a4f98),
              //         child: Container(
              //           constraints: BoxConstraints(
              //             maxWidth: 100.0,
              //             maxHeight: 60.0,
              //           ),
              //           alignment: Alignment.center,
              //           child: Text(
              //             "Save Cover Photo",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontFamily: 'Nunito',
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w300),
              //           ),
              //         ),
              //       ) : Container(),
              //     ],
              //   ),
              // ),
          SizedBox(
              height: 20.0,
              width: 1000.0,
              child: Divider(
                color: Colors.black,
              )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: checking,
                          validator: (val) => checking(val) || val.indexOf(" ") >= 0
                              ? 'Please provide valid username'
                              : null,
                          // validator: (val) {
                          //   checking(val);
                          //   int x = 0;
                          //   if(searchSnapshot != null)
                          //     x = searchSnapshot.size;
                          //
                          //   return x == 1
                          //       ? 'Please provide a valid username'
                          //       : null;
                          // },
                          controller: newuserNameTextEditingController,
                          style: TextStyle(fontFamily: 'Nunito'),
                          decoration: new InputDecoration(
                            errorText: doesExist ? 'Username in use' : null,
                            labelText: "Change Username",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                        // SizedBox(
                        //   height: 20.0,
                        //   width: 1000.0,
                        //   child: Divider(
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // TextFormField(
                        //   obscureText: true,
                        //   validator: (val) {
                        //     return val.length > 6
                        //         ? null
                        //         : 'Please provide password 6+ character';
                        //   },
                        //   controller: newpasswordTextEditingController,
                        //   style: TextStyle(fontFamily: 'Nunito'),
                        //   decoration: new InputDecoration(
                        //     labelText: "New Password",
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
                        //   obscureText: true,
                        //   validator: (val) {
                        //     return val.length > 6
                        //         ? null
                        //         : 'Password does not Match';
                        //   },
                        //   controller: newconfirmpasswordTextEditingController,
                        //   style: TextStyle(fontFamily: 'Nunito'),
                        //   decoration: new InputDecoration(
                        //     labelText: "Confirm New Password",
                        //     fillColor: Colors.white,
                        //     border: new OutlineInputBorder(
                        //       borderRadius: new BorderRadius.circular(25.0),
                        //       borderSide: new BorderSide(),
                        //     ),
                        //     //fillColor: Colors.green
                        //   ),
                        // ),
                        SizedBox(
                          height: 20.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        TextFormField(
                          validator: (val) {
                            return
                                // val.isEmpty
                                //   ? 'Please provide a valid First Name'
                                //   :
                                null;
                          },
                          controller: newFNameTextEditingController,
                          style: TextStyle(fontFamily: 'Nunito'),
                          decoration: new InputDecoration(
                            labelText: "Change First Name",
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
                            return
                                // val.isEmpty
                                //   ? 'Please provide a valid Last Name'
                                //   :
                                null;
                          },
                          controller: newLNameTextEditingController,
                          style: TextStyle(fontFamily: 'Nunito'),
                          decoration: new InputDecoration(
                            labelText: "Change Last Name",
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
                        ),
                        Container(
                          child: TextFormField(
                            maxLines: 4,
                            controller: bioTextEditingController,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black,
                                fontSize: 20),
                            decoration: new InputDecoration(
                              hintText: "Add Bio",
                              hintStyle:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 18),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 1000.0,
                          child: Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                        ),

                        Text('Modify Year of Pass-Out :',
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
                        SizedBox(
                          height: 20.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Text('Modify Department :',
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
                  )
                ],
              )),
        ])));
  }
}
