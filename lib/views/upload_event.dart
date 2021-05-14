import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadEvent extends StatefulWidget {
  @override
  _UploadEventState createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snap;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController =
  new TextEditingController();
  TextEditingController bodyTextEditingController = new TextEditingController();
  TextEditingController linkTextEditingController = new TextEditingController();

  String imageurl = "";
  File _image;
  bool imagePresent = false;
  bool isLoading = false;

  post(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState.validate()) {
      // if(databaseMethods.doesUserExist(userNameTextEditingController.text) == null) {
      Map<String, dynamic> postMap = {
        "title": titleTextEditingController.text,
        "body": bodyTextEditingController.text,
        "link": linkTextEditingController.text.isEmpty ? "" : linkTextEditingController.text,
        "uploader": snap.docs[0].data()["email"],
        "time": DateTime.now().millisecondsSinceEpoch,
        "image":imageurl,
      };
      databaseMethods.uploadEvent(postMap);
      Navigator.pop(context);
      //databaseMethods.updatePost(Constants.myName);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => BottomBar()));
    }
  }

  myuser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      snap = val;
    });
  }

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print("image taken");
      print("Image Path $_image");
      imagePresent = true;
      print(imagePresent);
    });
  }

  uploadPic(BuildContext context) async {

    String fileName = basename(_image.path);
    //initiateSearch();
    //String useremail = searchSnap.docs[0].data()["email"];
    String filenamenew = titleTextEditingController.text;
    String date = DateTime.now().toString();
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('events/$filenamenew+$date');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //var storage = FirebaseStorage.instance.ref();
    TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() {
      setState(() async {
        print("Event pic uploaded");
        //storage.child('gs://campconnectchat.appspot.com/users/$useremail').getDownloadURL().then((value) {
        final ref = FirebaseStorage.instance.ref('events/$filenamenew+$date');
        var url = await ref.getDownloadURL();
        print(url);
        imageurl = url;
        //String id = searchSnap.docs[0].id;
        //print(value);
        // FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(id)
        //     .update({"displaypic": url});
        //});
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text('Profile picture uploaded'),
        // ));
        imagePresent = true;
        // if(tpChange) await uploadPic1(context);
        // else
          //Navigator.pop(context);
        post(context);
      });
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
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => BottomBar()));
              },
            ),
            title: Center(
              child: const Text(
                'New Event',
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
                onPressed: () {
                  print(imagePresent);
                  setState(() {
                    imagePresent = true;
                  });
                  getImage();
                },
              ),
            ],
            backgroundColor: const Color(0xff2a4f98)),
        body: isLoading && formKey.currentState.validate()
            ? Container(
          child: Center(child: SpinKitRing(
            color: Colors.blue.shade500,
            size: 50.0,
          )),
        )
            :
        SingleChildScrollView(
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
                        _image != null ? Container(
                          width: double.infinity,
                          height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                    // _image != null
                                    //     ?
                                    //Image.file(_image,fit: BoxFit.fill,)
                                    FileImage(File(_image.path)),
                                    //    : currenttp(),
                                    fit: BoxFit.cover),
                            ),
                        ) : Container(),
                        _image != null ? SizedBox(
                          height: 40.0,
                          width: 1000.0,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ) : Container(),
                        TextFormField(
                          validator: (val) {
                            return val.isEmpty
                                ? 'Please provide a valid Event Title'
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
                                  ? 'Please provide a valid Event body'
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
                          controller: linkTextEditingController,
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontSize: 20),
                          decoration: new InputDecoration(
                            labelText: "Link",
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
                              child: const Text('Upload Event',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Nunito')),
                              onPressed: () async{
                                if(imagePresent && formKey.currentState.validate()) await uploadPic(context);
                                post(context);
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
