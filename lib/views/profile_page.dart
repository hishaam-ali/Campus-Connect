import 'package:auto_size_text/auto_size_text.dart';
import 'package:campusconnect/views/conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:campusconnect/profile/leftnavpage.dart';
import 'package:campusconnect/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:time_formatter/time_formatter.dart';

String username;
void nameIs(String name) {
  username = name;
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  QuerySnapshot snap;

  DatabaseMethods databaseMethods10 = new DatabaseMethods();
  QuerySnapshot searchSnapshot10;

  QuerySnapshot doc1;

  String userName;
  String userEmail;
  String currentEmail;
  String batch;
  String Fname;
  String Lname;
  String club;
  String dept;
  String dp;
  String tp;
  String posts;
  String followers;
  String following;
  String bio;

  bool isLoading = true;
  bool isFollowing = false;

  initSearch() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    //print(Constants.myName);
    await databaseMethods.getUserByUsername(username).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    userName = searchSnapshot.docs[0].data()["name"];
    userEmail = searchSnapshot.docs[0].data()["email"];
    batch = searchSnapshot.docs[0].data()["batch"];
    Fname = searchSnapshot.docs[0].data()["fname"];
    Lname = searchSnapshot.docs[0].data()["lname"];
    club = searchSnapshot.docs[0].data()["club"];
    dept = searchSnapshot.docs[0].data()["dept"];
    dp = searchSnapshot.docs[0].data()["displaypic"];
    tp = searchSnapshot.docs[0].data()["tpic"];
    posts = searchSnapshot.docs[0].data()["posts"];
    followers = searchSnapshot.docs[0].data()["followers"];
    following = searchSnapshot.docs[0].data()["following"];
    bio = searchSnapshot.docs[0].data()["bio"];

    await databaseMethods1.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        snap = val;
      });
    });

    await databaseMethods10.getUserSpecificFeed(username).then((val) {
      setState(() {
        searchSnapshot10 = val;
      });
    });

    currentEmail = snap.docs[0].data()["email"];

    setState(() {
      isLoading = false;
    });
  }

  createChatroomAndStartConversation({String userName,String userEmail1}) {
    //print('${Constants.myName}');
    if (userName != Constants.myName) {

      print(currentEmail);
      print(userEmail1);
      String chatRoomId = getChatRoomId(userEmail1, currentEmail);

      List<String> users = [userEmail1, currentEmail];
      // String chatRoomId = getChatRoomId(userName, Constants.myName);
      //
      // List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                  chatRoomId,
                  userName,
                  // chatRoomId
                  //     .replaceAll("_", "")
                  //     .replaceAll(Constants.myName, ""),
                  dp)));
    } else {
      print('you cannot send msg to yourself');
    }
  }

  FollowValue() async {
    bool value =
        await databaseMethods.isUserFollowing(userEmail, Constants.myName);
    setState(() {
      isFollowing = value;
      //print(isFollowing);
    });
  }

  Widget feedList() {
    return searchSnapshot10 != null
        ? ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchSnapshot10.docs.length,
      //searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        print("hello");
        //if(Followers.contains(searchSnapshot.docs[index].data()["uploader"])) {
        return feedTile(
          searchSnapshot10.docs[index].data()["uploader"],
          searchSnapshot10.docs[index].data()["time"],
          searchSnapshot10.docs[index].data()["body"],
          searchSnapshot10.docs[index].data()["title"],
          searchSnapshot10.docs[index].data()["tag"],
        );
        //}
        return Container();
      },
    )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    initSearch();
    FollowValue();
    return Scaffold(
        //drawer: NavDrawer(),
        appBar: AppBar(
            title: Text(
              username,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xff2a4f98)),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  //NetworkImage("https://picsum.photos/250?image=9")
                                  tp == ""
                                      ? NetworkImage(
                                          "https://upload.wikimedia.org/wikipedia/commons/6/6c/Black_photo.jpg")
                                      : NetworkImage(tp),
                              fit: BoxFit.cover)),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: Container(
                          alignment: Alignment(0.0, 2.5),
                          child: CircleAvatar(
                            backgroundImage: dp == ""
                                ? NetworkImage(
                                    "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                                : NetworkImage(dp),
                            radius: 70.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "$Fname $Lname",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'Nunito',
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    batch != null ? Text(
                      "Batch of $batch",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w300),
                    ) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    dept != null ? Text(
                      "$dept Student at SCTCE",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w300),
                    ) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    bio == "" ? Container() : Container(
                      height: 200,
                      child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 25.0),
                          child: ListTile(
                            leading: Image.asset("image/bio.png"),
                            title: AutoSizeText(
                              bio,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Nunito',
                                fontSize: 20.0,
                              ),
                              maxLines: 12,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    club == null ? Container() : Text(
                      club == null ? "Clubs" : club,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Nunito',
                          color: Colors.black45,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300),
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Posts",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    posts,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    followers,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 22.0,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    following,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            if (username != Constants.myName) {
                              await databaseMethods.toggleFollow(
                                  userEmail, Constants.myName, currentEmail);
                              //if(isFollowing) {
                              setState(() {
                                isFollowing = !isFollowing;
                              });
                            } else
                              print("You cant follow yourself");
                            //}
                            //else {
                            //setState(() {
                            //isFollowing = !isFollowing;
                            //});
                            //}
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.pink, Colors.redAccent]),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: isFollowing
                                ? Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 100.0,
                                      maxHeight: 40.0,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Following",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                          fontSize: 12.0,
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                : Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 100.0,
                                      maxHeight: 40.0,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                          fontSize: 12.0,
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            createChatroomAndStartConversation(
                              userName: username,
                              userEmail1: userEmail,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.pink, Colors.redAccent]),
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 100.0,
                                maxHeight: 40.0,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Message",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 12.0,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 1000.0,
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    feedList(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

class feedTile extends StatefulWidget {
  final String userEmail;
  final int time;
  final String body;
  final String title;
  final String tags;
  feedTile(this.userEmail, this.time, this.body, this.title, this.tags);

  @override
  _feedTileState createState() => _feedTileState();
}

class _feedTileState extends State<feedTile> {
  QuerySnapshot searchSnapshot1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot2;
  DatabaseMethods databaseMethods2 = new DatabaseMethods();

  getUserInfo(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods1.getUserByUserEmail(username).then((value) {
        setState(() {
          if (value != null) searchSnapshot1 = value;
          //chatRoomsStream = value;
          // isLoading = false;
        });
        print(value);
      });
      if (searchSnapshot1 != null)
        return searchSnapshot1.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot1.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  getUserName(String username) {
    if (username == null)
      return null;
    else {
      databaseMethods2.getUserByUserEmail(username).then((value) {
        setState(() {
          if (value != null) searchSnapshot2 = value;
          //chatRoomsStream = value;
          // isLoading = false;
        });
        print(value);
      });
      if (searchSnapshot2 != null)
        return searchSnapshot2.docs[0].data()["name"];
      else
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String dp = getUserInfo(widget.userEmail);
    String name = getUserName(widget.userEmail);

    return SingleChildScrollView(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: dp == ""
                    ? NetworkImage(
                    "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(dp),
                radius: 40.0,
              ),
              title: Text(name),
              subtitle: Text(
                formatTime(widget.time),
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(widget.title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.body,
                    style: TextStyle(color: Colors.black.withOpacity(0.6),
                        fontFamily: 'Nunito'),
                  ),
                ],
              ),
            ),
            widget.tags != "" ? ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                FlatButton(
                  onPressed: () {
                    // Perform some action
                  },
                  child: Text(widget.tags),
                ),
                // FlatButton(
                //   onPressed: () {
                //     // Perform some action
                //   },
                //   child: const Text('ACTION 2'),
                // ),
              ],
            ) : Container(),
            // Image.asset('assets/card-sample-image.jpg'),
          ],
        ),
      ),
    );
  }
}

