import 'package:campusconnect/helper/authenticate.dart';
import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/conversation_screen.dart';
import 'package:campusconnect/views/search.dart';
import 'package:campusconnect/views/signin.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:campusconnect/services/database.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods data = new DatabaseMethods();
  bool noChats = false;

  Stream chatRoomsStream;
  String myEmail;
  QuerySnapshot searchSnapshot;
  QuerySnapshot searchSnapshot1;
  QuerySnapshot searchSnapshot2;
  QuerySnapshot snap1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();

  Widget chatRoomList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(searchSnapshot.docs.length);
              print(searchSnapshot.docs[index]
                  .data()["chatroomid"]
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(myEmail, ""));
              int i = 0;
              while (i < searchSnapshot.docs.length) {
                print(searchSnapshot.docs.length);
                i++;
                print(i);
                return ChatRoomsTile(
                    searchSnapshot.docs[index]
                            .data()["chatroomid"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(myEmail, ""),
                    // searchUser(searchSnapshot.docs[i]
                    //             .data()["chatroomid"]
                    //             .toString()
                    //             .replaceAll("_", "")
                    //             .replaceAll(myEmail, "")),
                    searchSnapshot.docs[index].data()["chatroomid"],
                    initiateSearch(searchSnapshot.docs[i-1]
                      .data()["chatroomid"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(myEmail, ""))
                    );
                // return ChatRoomsTile(
                //     searchSnapshot.docs[index]
                //         .data()["chatroomid"]
                //         .toString()
                //         .replaceAll("_", "")
                //         .replaceAll(Constants.myName, ""),
                //     searchSnapshot.docs[index].data()["chatroomid"],
                //     initiateSearch(searchSnapshot.docs[i - 1]
                //         .data()["chatroomid"]
                //         .toString()
                //         .replaceAll("_", "")
                //         .replaceAll(Constants.myName, "")));
              }
              return null;
            },
          )
        : Container();
  }

  // initiateSearch() {
  //   databaseMethods.getUserByFilter(searchTextEditingController.text,selectedDept,selectedBatch,selectedClub).then((
  //       val) {
  //     setState(() {
  //       searchSnapshot = val;
  //     });
  //   });
  // }



  String initiateSearch(String userName) {
    if (userName == null)
      return "";
    else {
      databaseMethods1.getUserByUserEmail(userName).then((val) {
        setState(() {
          if (val != null) searchSnapshot1 = val;
          //print(val);
          //isLoading = false;
        });
      });
      if (searchSnapshot1 != null)
        return searchSnapshot1.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot1.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  //
  // Widget chatRoomList() {
  //   return Expanded(
  //     child: StreamBuilder(
  //       stream: chatRoomsStream,
  //       builder: (context, snapshot) {
  //         //if(snapshot.data == null) return CircularProgressIndicator();
  //         return snapshot.hasData ? ListView.builder(
  //             itemCount: snapshot.data.documents.length,
  //             itemBuilder: (context, index) {
  //               // print(snapshot.data.documents[index].data()["chatroomid"]
  //               //     .toString().replaceAll("_", "")
  //               //     .replaceAll(Constants.myName, ""));
  //               return ChatRoomsTile(
  //                 snapshot.data.documents[index].data()["chatroomid"]
  //                     .toString().replaceAll("_", "")
  //                     .replaceAll(Constants.myName, ""),
  //                   snapshot.data.documents[index].data()["chatroomid"],
  //                 ""
  //
  //                 // initiateSearch(snapshot.data.documents[index].data()["chatroomid"]
  //                 //     .toString().replaceAll("_", "")
  //                 //     .replaceAll(Constants.myName, ""))
  //               );
  //             }
  //         ) : Container();
  //       },
  //     ),
  //   );
  // }
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  bool isLoading = true;

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
    print(myEmail);

    // data.getUserByUsername(Constants.myName).then((value) {
    //   setState(() {
    //     snap1 = value;
    //   });
    //   myEmail = snap1.docs[0].data()["email"];
    // });

    databaseMethods.getChatRooms(myEmail).then((value) {
      setState(() {
        if (value != null) searchSnapshot = value;
        //chatRoomsStream = value;
        // isLoading = false;
        searchSnapshot.docs.length == 0 ? noChats = true : noChats = false;
        isLoading = false;
      });
      print(value);
      print(searchSnapshot.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'Messaging',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     authMethods.signOut();
            //     HelperFunctions.saveUserLoggedInSharedPreference(false);
            //     Navigator.pushReplacement(context,
            //     MaterialPageRoute(
            //         builder: (context) => Authenticate()
            //     )
            //     );
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 10.0),
            //     child: Icon(Icons.exit_to_app),
            //   ),
            // )
          ],
          backgroundColor: const Color(0xff2a4f98)),
      body:
          //isLoading ? Container(
          //child: Center(child: CircularProgressIndicator()),
          //) :
          Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width - 20.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    Padding(padding: EdgeInsets.only(left: 15.0)),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1.0,
              width: 150.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            child: Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
          ),
          // searchSnapshot == null ? Text('Start a new chat', style: TextStyle(color: Colors.black,fontSize: 30.0),) :
          //DelayedDisplay(
          //delay: Duration(seconds: 1),
          //child:
          isLoading
              ? Expanded(
                child: Container(
            child: Center(child: CircularProgressIndicator()),
          ),
              ) :
          noChats ? Expanded(child: Container(child: Center(child: Text('You have no chats',style: TextStyle(fontFamily: 'Nunito'),)),)) : Expanded(child: chatRoomList()),
          //),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(
      //             builder: (context) => SearchScreen()
      //         ));
      //   },
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.blue,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white54,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.home_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.chat_bubble_mdi),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.upload_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.heart_ant),
      //       title: Text(''),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(FlutterIcons.user_ant),
      //       title: Text(''),
      //     ),
      //   ],
      // ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String url;

  ChatRoomsTile(this.userName, this.chatRoomId, this.url);

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  QuerySnapshot searchSnapshot2;
  DatabaseMethods databaseMethods2 = new DatabaseMethods();
  QuerySnapshot snap10;
  DatabaseMethods data10 = new DatabaseMethods();

  String initiateSearch1(String userName) {
    if (userName == null)
      return null;
    else {
      databaseMethods2.getUserByUserEmail(userName).then((val) {
        setState(() {
          if (val != null) searchSnapshot2 = val;
          //print(val);
          //isLoading = false;
        });
      });
      if (searchSnapshot2 != null)
        return searchSnapshot2.docs[0].data()["displaypic"] == ""
            ? ""
            : searchSnapshot2.docs[0].data()["displaypic"];
      else
        return "";
    }
  }

  String searchUser(String userEmail) {
    if(userEmail == null)
      return null;
    else {
      data10.getUserByUserEmail(userEmail).then((val) {
        setState(() {
          if(val != null)
            snap10 = val;
        });
      });
      if(snap10 != null)
        return snap10.docs[0].data()["name"];
      else
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userName);
    String url1 = initiateSearch1(widget.userName);
    String chatName = searchUser(widget.userName);
    //String url = initiateSearch(userName);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                      widget.chatRoomId,
                      chatName,
                      //widget.url
                      url1)));
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                height: 50.0,
                width: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: CircleAvatar(
                  backgroundImage: url1 == ""
                      ? NetworkImage(
                          "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                      : NetworkImage(url1),
                  radius: 70.0,
                ),
                // Text("${userName.substring(0,1).toUpperCase()}",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 25.0,
                //   ),
                // ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                chatName,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
