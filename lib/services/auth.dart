import 'package:firebase_auth/firebase_auth.dart';
import 'package:campusconnect/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final googeSignIn = GoogleSignIn();
  //
  // Future<bool> googleSignIn() async {
  //   GoogleSignInAccount googleSignInAccount = await googeSignIn.signIn();
  //   if(googleSignInAccount != null) {
  //     GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken
  //     );
  //
  //     UserCredential result = await _auth.signInWithCredential(credential);
  //     User user = await _auth.currentUser;
  //     print(user.uid);
  //   }
  //
  //
  //   return Future.value(true);
  // }

  Userr _userFromFirebaseUser(User user) {
    return user !=null ? Userr(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email,String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      if(firebaseUser.emailVerified)
      return _userFromFirebaseUser(firebaseUser);
      else {
        print("not verified");
        return "notv";
      }

    }
    catch(e){
    print(e.toString());
    print("wrong pw");
    return "nop";
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User firebaseUser = result.user;
     await firebaseUser.sendEmailVerification();
      return _userFromFirebaseUser(firebaseUser);
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try{

      //User user = await _auth.currentUser;

      // if(user.providerData[1].providerId == 'google.com') {
      //   await googeSignIn.disconnect();
      // }
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
    }
  }


}

