import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:campusconnect/helper/authenticate.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/bottombar.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/home_page.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campusconnect/helper/constants.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snap;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController =
      new TextEditingController();
  TextEditingController bodyTextEditingController = new TextEditingController();
  TextEditingController tagTextEditingController = new TextEditingController();

  post() {
    if (formKey.currentState.validate()) {
      // if(databaseMethods.doesUserExist(userNameTextEditingController.text) == null) {
      Map<String, dynamic> postMap = {
        "title": titleTextEditingController.text,
        "body": bodyTextEditingController.text,
        "tag": tagTextEditingController.text.isEmpty ? "" : tagTextEditingController.text,
        "uploader": snap.docs[0].data()["email"],
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.uploadPost(postMap);
      databaseMethods.updatePost(Constants.myName);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBar()));
    }
  }

  myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    myuser();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: new Icon(Entypo.cross, size: 35),
              tooltip: 'Back to Home',
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => BottomBar()));
              },
            ),
            title: Center(
              child: const Text(
                'New Post',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: new Icon(
                  MaterialIcons.add_a_photo,
                  size: 35,
                ),
                tooltip: 'Post',
                onPressed: () {},
              ),
            ],
            backgroundColor: const Color(0xff2a4f98)),
        body: SingleChildScrollView(
            child: Container(
                //height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Form(
                      key: formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          height: 40.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        TextFormField(
                          validator: (val) {
                            return val.isEmpty
                                ? 'Please provide a valid Post Title'
                                : null;
                          },
                          controller: titleTextEditingController,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontSize: 20),
                          decoration: new InputDecoration(
                            labelText: "Title",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            validator: (val) {
                              return val.isEmpty
                                  ? 'Please provide a valid Post Body'
                                  : null;
                            },
                            maxLines: 12,
                            controller: bodyTextEditingController,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black,
                                fontSize: 20),
                            decoration: new InputDecoration(
                              hintText: "Body",
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
                          height: 40.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          // validator: (val) {
                          //   return val.isEmpty
                          //       ? 'Please provide a valid Tag'
                          //       : null;
                          // },
                          controller: tagTextEditingController,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontSize: 20),
                          decoration: new InputDecoration(
                            labelText: "Tags",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        ButtonTheme(
                            minWidth: 200.0,
                            height: 50.0,
                            child: RaisedButton(
                              child: const Text('Upload Post',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Nunito')),
                              onPressed: () {
                                post();
                              },
                              color: Color(0xff2a4f98),
                              disabledColor:
                                  Colors.blue, //remove when onPressed is used
                              textColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              splashColor: Colors.blue,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        )
                      ]),
                    )))));
  }
}
