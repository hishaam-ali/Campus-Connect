import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatroomscreen.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String roomname;
  final String url;

  ConversationScreen(this.chatRoomId, this.roomname, this.url);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot snap;
  TextEditingController messageController = new TextEditingController();
  String myEmail = "";
  Stream chatMessagesStream;

  ScrollController _scrollController = new ScrollController();

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          controller: _scrollController,
          reverse: true,
          shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data()["message"],
                      snapshot.data.documents[index].data()["sendBy"] ==
                          myEmail,
                      snapshot.data.documents[index].data()["time"]
                  );
                          //Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": myEmail,
        //Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    myUser();
    super.initState();
  }

  myUser() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    myEmail = await HelperFunctions.getUserEmailSharedPreference();
    // databaseMethods.getUserByUsername(Constants.myName).then((value) {
    //   setState(() {
    //       snap = value;
    //   });
    //   myEmail = snap.docs[0].data()["email"];
    //   print(myEmail);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              height: 55.0,
              width: 55.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: CircleAvatar(
                backgroundImage: widget.url == ""
                    ? NetworkImage(
                        "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(widget.url),
                radius: 90.0,
              ),
              // Text("${widget.roomname.substring(0,1).toUpperCase()}",
              //   style: mediumTextFieldStyle(),
              // ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              widget.roomname,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff2a4f98),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("image/school1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 90.0),
                child: ChatMessageList()),
            SizedBox(
              height: 100.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                //color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Nunito'),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Send a message',
                            hintStyle: TextStyle(fontFamily: 'Nunito'),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(50.0),
                              borderSide: new BorderSide(),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                        _scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xff2a4f98),
                            Colors.blueAccent,
                            // Colors.blue[200],
                          ]),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.send_sharp,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final int time;
  MessageTile(this.message, this.isSendByMe,this.time);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(
              left: isSendByMe ? 40.0 : 20.0, right: isSendByMe ? 20.0 : 40.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width,
          alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
                color: isSendByMe ? Colors.blueAccent : Colors.deepOrangeAccent,
                borderRadius: isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23.0),
                        topRight: Radius.circular(23.0),
                        bottomLeft: Radius.circular(23.0),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(23.0),
                        topRight: Radius.circular(23.0),
                        bottomRight: Radius.circular(23.0),
                      )),
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.white, fontSize: 17.0, fontFamily: 'Nunito'),
                ),
                Text(DateTimeFormat.format(DateTime.fromMicrosecondsSinceEpoch(time,isUtc: false), format: DateTimeFormats.american),
                  style: TextStyle(fontSize: 7,color: Colors.white),
                  //textAlign: isSendByMe ? TextAlign.right : TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
