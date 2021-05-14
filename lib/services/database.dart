import 'dart:collection';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/helper/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserByUsername(String username) async{
   return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }

  getUserByUsernameForSearch(String username) async {
    return await FirebaseFirestore.instance.collection("users").where("searchname",isEqualTo: username).get();
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: userEmail).get();
  }

  getEvents() async{
    return await FirebaseFirestore.instance.collection("events").orderBy("time",descending: true).get();
  }

  getAnnouncements() async{
    return await FirebaseFirestore.instance.collection("announcements").orderBy("time",descending: true).get();
  }

  getWhatsHappening() async{
    return await FirebaseFirestore.instance.collection("whatshappening").orderBy("time",descending: true).get();
  }


  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e){
   print(e.toString());
    });
  }

  uploadPost(postMap) {
    FirebaseFirestore.instance.collection('feed').add(postMap).catchError((e) {
      print(e.toString());
    });
  }

  uploadEvent(postMap) {
    FirebaseFirestore.instance.collection('events').add(postMap).catchError((e) {
      print(e.toString());
    });
  }
  uploadWhats(postMap) {
    FirebaseFirestore.instance.collection('whatshappening').add(postMap).catchError((e) {
      print(e.toString());
    });
  }
  uploadAnnouncement(postMap) {
    FirebaseFirestore.instance.collection('announcements').add(postMap).catchError((e) {
      print(e.toString());
    });
  }


  updatePost(String username) async{
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users").where("name",isEqualTo: username).get();
    String x = docRef.docs[0].id;
    String y = docRef.docs[0].data()["posts"];
    int z = int.parse(y);
    z = z + 1;
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"posts" : "$z"});
  }

  deletePost(String username, String id) async{
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users").where("name",isEqualTo: username).get();
    String x = docRef.docs[0].id;
    String y = docRef.docs[0].data()["posts"];
    int z = int.parse(y);
    z = z - 1;
    FirebaseFirestore.instance.collection('feed').doc(id).delete();
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"posts" : "$z"});
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: userName).get();
        //.snapshots();
  }

  getNoOfPosts(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    List p = docRef.docs[0].data()["ifollowthem"];
    QuerySnapshot doc1;
    int i;
    int j=0;
    if(p.length>0){
      p.add(email);
      for(i=0;i<p.length;i++)
        {
          doc1 = await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: p[i]).get();
          j = j + int.parse(doc1.docs[0].data()["posts"]);
        }
      return j;
    }
    else
      return 0;
  }

  getFollowers(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    List p = docRef.docs[0].data()["ifollowthem"];
    p.add(email);
    return p;
  }

  getUserSpecificFeed(String username) async {
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users")
        .where("name",isEqualTo: username).get();
    String email = docRef.docs[0].data()["email"];
    print(email);
    return await FirebaseFirestore.instance.collection("feed")
        .where("uploader",isEqualTo: email)
        .orderBy("time",descending: true)
        .get();
  }

  getFeed(String username) async {
     QuerySnapshot docRef = await FirebaseFirestore.instance
         .collection("users")
         .where("name",isEqualTo: username).get();
     String email = docRef.docs[0].data()["email"];
     print(email);
     QuerySnapshot snap = await FirebaseFirestore.instance.collection("feed").orderBy("time",descending: true).get();
     List p = docRef.docs[0].data()["ifollowthem"];
     if(p.length>0) {
       // p.add(email);
       // print(p);
       // print(p.length);
       // print(p[0]);
       // print(p[1]);
       // print(snap.docs.length);
       //
       // int i,j;
       // for(i=0;i<p.length;i++)
       //   for(j=0;j<snap.docs.length;j++)
       //     if(snap.docs[j].data()["uploader"] == p[i]) {
       //       print(p[i]);
             return snap;
           //}
             //   return await FirebaseFirestore.instance.collection('feed')
           // .where("uploader",arrayContainsAny: p).get();
     }
     else {
      return await FirebaseFirestore.instance.collection("feed")
          .where("uploader",isEqualTo: email)
          .orderBy("time",descending: true)
          .get();
    }
  }

  String checking(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        return result.data()["name"];
      });
    });
  }

  getUserByUsernameCheck(String username) async{
    int x = username.length;
    // return await FirebaseFirestore.instance.collection("users").
    // where("name",isEqualTo: username[0]).
    // where("name",isEqualTo: username[1]).
    // where("name",isEqualTo: username[2]).
    // get();
    return await FirebaseFirestore.instance.collection("users").
    where("name",isGreaterThanOrEqualTo: username).get();
  }

  bool doesUserExist(String username) {
  FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      print(result.exists);
      print(result.exists.runtimeType);
      return true;
    });
  });
}




getUserByFilter (String username, String dept,String batch,String club) async {
    if(dept == 'Dept' && batch != 'Batch' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).where("batch",isEqualTo: batch)
          .where("club",isEqualTo: club).get();

      else if(batch == 'Batch' && dept != 'Dept' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username)
          .where("club",isEqualTo: club).where("dept",isEqualTo: dept).get();

        else if(club == 'Club' && dept != 'Dept' && batch != 'Batch')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).where("batch",isEqualTo: batch)
          .where("dept",isEqualTo: dept).get();

        else if (dept =='Dept' && batch == 'Batch' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users")
          .where("name",isGreaterThanOrEqualTo: username)
          .where("club",isEqualTo: club)
          .get();

          else if(dept == 'Dept' && club == 'Club' && batch != 'Batch')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).where("batch",isEqualTo: batch).get();

    else if (batch == 'Batch' && club == 'Club' && dept != 'Dept')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).where("dept",isEqualTo: dept).get();

      else if(dept == 'Dept' && club == 'Club' && batch == 'Batch')
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).get();

          else
      return await FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: username).where("batch",isEqualTo: batch)
      .where("club",isEqualTo: club).where("dept",isEqualTo: dept).get();
}

  getUserByFilter1 (String username, String dept,String batch,String club) async {
    if(dept == 'Dept' && batch != 'Batch' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users").where("batch",isEqualTo: batch)
          .where("club",isEqualTo: club).get();

    else if(batch == 'Batch' && dept != 'Dept' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users")
          .where("club",isEqualTo: club).where("dept",isEqualTo: dept).get();

    else if(club == 'Club' && dept != 'Dept' && batch != 'Batch')
      return await FirebaseFirestore.instance.collection("users").where("batch",isEqualTo: batch)
          .where("dept",isEqualTo: dept).get();

    else if (dept =='Dept' && batch == 'Batch' && club != 'Club')
      return await FirebaseFirestore.instance.collection("users")
          .where("club",isEqualTo: club)
          .get();

    else if(dept == 'Dept' && club == 'Club' && batch != 'Batch')
      return await FirebaseFirestore.instance.collection("users").where("batch",isEqualTo: batch).get();

    else if (batch == 'Batch' && club == 'Club' && dept != 'Dept')
      return await FirebaseFirestore.instance.collection("users").where("dept",isEqualTo: dept).get();

    else if(dept == 'Dept' && club == 'Club' && batch == 'Batch')
      return await FirebaseFirestore.instance.collection("users").get();

    else
      return await FirebaseFirestore.instance.collection("users").where("batch",isEqualTo: batch)
          .where("club",isEqualTo: club).where("dept",isEqualTo: dept).get();
  }

  getUsersOnSearch() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  updateUser(String name,String newUsername,
      String fname,String lname,String batch,
      String dept, String club,String bio) async{
    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("users").where("name",isEqualTo: name).get();
    String x = docRef.docs[0].id;

    if(newUsername != "nochange") {
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"name" : newUsername});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"searchname" : newUsername.toLowerCase()});
      HelperFunctions.saveUserNameSharedPreference(
          newUsername);
      Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    }


    if(fname != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"fname" : fname});

    if(lname != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"lname" : lname});

    if(batch != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"batch" : batch});

    if(dept != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"dept" : dept});

    if(club != "nochange")
    FirebaseFirestore.instance.collection("users").doc(x)
        .update({"club" : club});

    if(bio != "nobio")
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"bio" : bio});

  }

  Future<bool> isUserFollowing(String user,String current) async {

    QuerySnapshot snap;
    snap = await FirebaseFirestore.instance.collection("users")
        .where("name",isEqualTo: current)
        .where("ifollowthem",arrayContains: user).get();
    print(snap.size);
    if(snap.size == 1) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }

  Future toggleFollow(String user,String current,String currentEmail) async {

    QuerySnapshot snap;
    snap = await FirebaseFirestore.instance.collection("users")
        .where("name",isEqualTo: current)
        .where("ifollowthem",arrayContains: user).get();
    //print(snap.size);


    if(snap.size == 1) {
      QuerySnapshot docRef = await FirebaseFirestore.instance
          .collection("users").where("email",isEqualTo: user).get();
      String x = docRef.docs[0].id;
      QuerySnapshot docRef1 = await FirebaseFirestore.instance
          .collection("users").where("name",isEqualTo: current).get();
      String y = docRef1.docs[0].id;

      List p = docRef1.docs[0].data()["ifollowthem"];
      List q = docRef.docs[0].data()["followsme"];

      int m = p.length;
      m = m - 1;
      int n = q.length;
      n = n - 1;

      print(docRef1.docs[0].data()["ifollowthem"]);

      await FirebaseFirestore.instance.collection("users").doc(y)
          .update({"ifollowthem" : FieldValue.arrayRemove([user])});

      await FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followsme" : FieldValue.arrayRemove([currentEmail])});

      FirebaseFirestore.instance.collection("users").doc(y)
          .update({"following" : "$m"});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followers" : "$n"});
    }
    else {

      QuerySnapshot docRef = await FirebaseFirestore.instance
          .collection("users").where("email",isEqualTo: user).get();
      String x = docRef.docs[0].id;
      QuerySnapshot docRef1 = await FirebaseFirestore.instance
          .collection("users").where("name",isEqualTo: current).get();
      String y = docRef1.docs[0].id;

      List p = docRef1.docs[0].data()["ifollowthem"];
      List q = docRef.docs[0].data()["followsme"];

      int m = p.length;
      m = m + 1;
      int n = q.length;
      n = n + 1;

      print(docRef1.docs[0].data()["ifollowthem"]);

      await FirebaseFirestore.instance.collection("users").doc(y)
          .update({"ifollowthem" : FieldValue.arrayUnion([user])});

      await FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followsme" : FieldValue.arrayUnion([currentEmail])});

      FirebaseFirestore.instance.collection("users").doc(y)
          .update({"following" : "$m"});
      FirebaseFirestore.instance.collection("users").doc(x)
          .update({"followers" : "$n"});

      // QuerySnapshot docRef = await FirebaseFirestore.instance
      //     .collection("users").where("name",isEqualTo: user).get();
      // String x = docRef.docs[0].id;
      // QuerySnapshot docRef1 = await FirebaseFirestore.instance
      //     .collection("users").where("name",isEqualTo: current).get();
      // String y = docRef1.docs[0].id;
      //
      // print(docRef.docs[0].data()["mefollow"]);
      // List p = docRef.docs[0].data()["mefollow"];
      // List q = docRef1.docs[0].data()["ufollow"];
      //
      // int m = p.length;
      // m = m + 1;
      // int n = q.length;
      // n = n + 1;
      //
      // await FirebaseFirestore.instance.collection("users").doc(x)
      //     .update({"mefollow" : FieldValue.arrayUnion([current])});
      //
      // await FirebaseFirestore.instance.collection("users").doc(y)
      //     .update({"ufollow" : FieldValue.arrayUnion([user])});
      //
      // FirebaseFirestore.instance.collection("users").doc(x)
      //     .update({"followers" : "$m"});
      // FirebaseFirestore.instance.collection("users").doc(y)
      //     .update({"following" : "$n"});
    }
  }

}


